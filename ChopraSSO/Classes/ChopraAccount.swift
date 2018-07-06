import SwiftyJSON

public class ChopraAccount {
    
    init(json: JSON) {
        self.id = json["id"].string
        self.firstName = json["firstName"].string
        self.lastName = json["lastName"].string
        self.birthDate = json["birthDate"].string
        self.email = json["email"].string
        self.gender = json["gender"].string
        self.profileImage = json["profileImage"].string
    }
    
    public var id: String?
    public var firstName: String?
    public var lastName: String?
    public var birthDate: String?
    public var email: String?
    public var gender: String?
    public var profileImage: String?
}
