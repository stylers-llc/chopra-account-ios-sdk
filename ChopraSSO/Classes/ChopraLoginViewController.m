//
//  ChopraLoginViewController.m
//  SSOTestApplication
//
//  Created by Stylers on 2016. 01. 26..
//  Copyright © 2016. Stylers. All rights reserved.
//

#import "ChopraLoginViewController.h"
#import "NSData+Base64.h"
#import "BBAES.h"
#import "RTSerializer.h"
#import "CryptLib.h"
#import <CommonCrypto/CommonCrypto.h>

@interface ChopraLoginViewController ()
{
    void (^_completionHandler)(NSString* userId, NSString* ssoToken);
    void (^_complete)(ChopraAccount* chopraAccount);
}

@end

@implementation ChopraLoginViewController

NSString* baseUrl;
NSString* apiUrl;
NSString* clientKey;
NSString* apiKey;
NSString* platform;
NSString* nameSpace;
NSString* clientSecret;
NSString* socialToken;
NSString* socialId;
int socialType;
NSString* userId;
NSString* userToken;
UIWebView *webView;
UIImageView *closeButton;
UIActivityIndicatorView *activityIndicator;
UIView *contentView;

-(void) setLoginBaseUrl:(NSString*)_baseUrl apiUrl:(NSString*)_apiUrl apiKey:(NSString*)_apiKey clientKey:(NSString*)_clientKey platform:(NSString*)_platform
              nameSpace:(NSString*)_nameSpace clientSecret:(NSString*)_clientSecret{
    
    baseUrl = _baseUrl;
    apiUrl = _apiUrl;
    apiKey = _apiKey;
    clientKey = _clientKey;
    platform = _platform;
    nameSpace = _nameSpace;
    clientSecret = _clientSecret;
    
}


- (void) showSocialLoginViewFrom:(UIViewController*)rootViewController socialToken:(NSString*)_socialToken
                       socialId:(NSString*)_socialId socialType:(int) _socialType withHandler:(void(^)(NSString*,NSString*))handler {
    
    socialToken = _socialToken;
    socialId = _socialId;
    socialType = _socialType;
    
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [rootViewController presentViewController:self animated:YES completion: nil];
    _completionHandler = [handler copy];
    
}

- (void) showEmailLoginViewFrom:(UIViewController*)rootViewController withHandler:(void(^)(NSString*,NSString*))handler {
    
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;

    [rootViewController presentViewController:self animated:YES completion: nil];
    _completionHandler = [handler copy];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    contentView = [[UIView alloc] init];
    [contentView setFrame:CGRectMake(self.view.frame.origin.x+15, self.view.frame.origin.y +35, self.view.frame.size.width-30, self.view.frame.size.height-50)];
    [contentView setBackgroundColor: [UIColor whiteColor]];
    [self.view addSubview:contentView];
    
    webView = [[UIWebView alloc] init];
    [webView setFrame:CGRectMake(self.view.frame.origin.x+15, self.view.frame.origin.y +35, self.view.frame.size.width-30, self.view.frame.size.height-50)];
    webView.scrollView.bounces = NO;
    [self.view addSubview:webView];
    
    closeButton = [[UIImageView alloc]initWithImage:[self loadImageFromResourceBundle:@"icon_default.png"] highlightedImage:[self loadImageFromResourceBundle:@"icon_pressed.png"]];
    closeButton.frame = CGRectMake(self.view.frame.origin.x+5, self.view.frame.origin.y +25, 30, 30);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeButtonTouch:)];
    [closeButton addGestureRecognizer:singleTap];
    [closeButton setMultipleTouchEnabled:YES];
    [closeButton setUserInteractionEnabled:YES];
    
    [self.view addSubview:closeButton];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setHidesWhenStopped:YES];
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    [webView setHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.2]];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect oldFrame = activityIndicator.frame;
    
    oldFrame.origin.x = (self.view.frame.size.width - 50.0f) / 2.0f;
    oldFrame.origin.y = (self.view.frame.size.height - 50.0f) / 2.0f;
    
    [activityIndicator setFrame:oldFrame];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == closeButton)
    {
        closeButton.image = [self loadImageFromResourceBundle:@"icon_pressed.png"];
    }
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == closeButton)
    {
        closeButton.image = [self loadImageFromResourceBundle:@"icon_default.png"];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSString *url=baseUrl;
    if (socialToken!=nil && socialToken.length>0){
        url =[url stringByAppendingString:@"/social/tokenauth?client_key="];
    } else {
        url =[url stringByAppendingString:@"/tokenauth?client_key="];
    }
    url = [url stringByAppendingString:clientKey];
    url = [url stringByAppendingString:@"&platform_type="];
    url = [url stringByAppendingString:platform];
    url = [url stringByAppendingString:@"&namespace="];
    url = [url stringByAppendingString:nameSpace];
    
    if (socialToken!=nil && socialToken.length>0) {
        url = [url stringByAppendingString:@"&social_id="];
        url = [url stringByAppendingString:socialId];
        url = [url stringByAppendingString:@"&social_token="];
        url = [url stringByAppendingString:[self encryptSocialToken:socialToken]];
        url = [url stringByAppendingString:@"&social_type="];
        
        if (socialType == 1) {
            url = [url stringByAppendingString:@"facebook"];
        } else {
            url = [url stringByAppendingString:@"google"];
        }
        
    }
    
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webView loadRequest:nsrequest];
    [webView setDelegate:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)closeButtonTouch:(UIButton*)sender {
    _completionHandler(nil, nil);
    _completionHandler = nil;
    closeButton.image = [self loadImageFromResourceBundle:@"icon_default.png"];
    [webView stopLoading];
    webView.delegate = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [webView setHidden:NO];
    [activityIndicator stopAnimating];
    
    NSString *currentURL = webView.request.URL.query;
    
    if ([currentURL containsString:@"sso_code"] && _completionHandler) {
        
        NSString *url = [currentURL stringByReplacingOccurrencesOfString:@"#" withString:@"&"];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (NSString *param in [url componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [params setObject:[elts objectAtIndex:1] forKey:[elts firstObject]];
        }
        
        NSString *ssoCode = [[params objectForKey:@"sso_code"] stringByRemovingPercentEncoding];

        NSData *decodedData = [NSData base64DataFromString2:ssoCode];
        
        NSString *base64Decoded = [[NSString alloc] initWithData:decodedData encoding:[NSString defaultCStringEncoding]];
        base64Decoded = [base64Decoded stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSData *data = [base64Decoded dataUsingEncoding:NSASCIIStringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];

        NSData* keyData = [clientSecret dataUsingEncoding:NSUTF8StringEncoding];
        
        NSString *decryptedMessage = [[[json objectForKey:@"value"]description] bb_AESDecryptedStringForIV:nil key:keyData];
       decryptedMessage = [@"a:2:{s:4:" stringByAppendingString:decryptedMessage];
        
        RTSerializer * serializer = [[RTSerializer alloc] init];
        id object = [serializer deserialize: decryptedMessage];
        userId = [object objectForKey:@"u_id"];
        userToken = [object objectForKey:@"api_token"];
        
        _completionHandler(userId,userToken);
        _completionHandler = nil;
        
        [webView stopLoading];
        webView.delegate = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

- (NSString*) encryptSocialToken:(NSString*)token{
    
    RTSerializer *serializer = [[RTSerializer alloc] init];
    NSString* serializedString = @"";
    serializedString = [serializer serialize:token inString:serializedString];

    NSString *ivString = [self randomStringWithLength:16];
    NSData *iv =[ivString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64EncodedIV= [iv base64EncodedStringWithOptions:0];
    
    StringEncryption *strencryption = [[StringEncryption alloc] init];
    NSData *encryptedTokenData = [strencryption encrypt:[serializedString dataUsingEncoding:NSUTF8StringEncoding]  key:clientSecret iv:ivString];
    NSString *encryptedTokenString = [encryptedTokenData base64EncodedStringWithOptions:0];
    
    NSString *base64EncodedIvAndValue = [base64EncodedIV stringByAppendingString:encryptedTokenString];
    
    NSString* macString = [self getHashEncription:clientSecret andData:base64EncodedIvAndValue];
    NSDictionary *dictionary = @{@"iv"    : base64EncodedIV,
                                 @"value" : encryptedTokenString,
                                 @"mac"   : macString};
    
    NSData   *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSData *nsdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    return base64Encoded;
    
}

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
-(NSString *) randomStringWithLength: (int) len {
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    return randomString;
}


- (NSString*)encodeStringTo64:(NSString*)fromString
{
    NSData *plainData = [fromString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String;
    if ([plainData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64String = [plainData base64EncodedStringWithOptions:kNilOptions];
    } else {
        base64String = [plainData base64EncodedStringWithOptions:0];
    }
    return base64String;
}


- (NSString *)getHashEncription:(NSString *)key andData:(NSString *)data{
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    
    return output;
    
}


- (void) getChopraAccountByUserKey:(NSString*)_ssoToken withHandler:(void(^)(ChopraAccount*))handler{
    
    if (!_ssoToken) {
        handler(nil);
        return;
    }
    
    _complete = [handler copy];
    [self sendJSONRequestByUserToken:_ssoToken];
}

- (void) sendJSONRequestByUserToken:(NSString*)_usertoken{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[apiUrl stringByAppendingString:@"/auth"]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:apiKey forHTTPHeaderField:@"X-SSO-ApiKey"];
    [request setValue:clientKey forHTTPHeaderField:@"X-SSO-ClientKey"];
    [request setValue:[@"Bearer " stringByAppendingString:_usertoken] forHTTPHeaderField:@"Authorization"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"requestReply: %@", requestReply);
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        ChopraAccount *chopraAccount;
        if ([json objectForKey:@"error"]) {
             chopraAccount = NULL;
        } else {
             chopraAccount = [[ChopraAccount alloc] initFromJson:json];
        }
        
        _complete(chopraAccount);
        _complete = nil;
        
    }] resume];
}

- (void) logout:(NSString*)_ssoToken{

    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[apiUrl stringByAppendingString:@"/auth"]]];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:apiKey forHTTPHeaderField:@"X-SSO-ApiKey"];
    [request setValue:clientKey forHTTPHeaderField:@"X-SSO-ClientKey"];
    [request setValue:[@"Bearer " stringByAppendingString:_ssoToken] forHTTPHeaderField:@"Authorization"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"Logout response: %@", requestReply);
        
        
    }] resume];
}

+ (NSBundle *) getResourcesBundle
{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"ChopraSSO" withExtension:@"bundle"]];
    return bundle;
}

- (UIImage *) loadImageFromResourceBundle:(NSString *)imageName
{
    NSBundle *bundle = [ChopraLoginViewController getResourcesBundle];
    NSString *imageFileName = [NSString stringWithFormat:@"%@.png",imageName];
    UIImage *image = [UIImage imageNamed:imageFileName inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
