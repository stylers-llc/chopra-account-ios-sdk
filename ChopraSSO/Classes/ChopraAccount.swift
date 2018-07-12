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
    
    public init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        self.lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        self.birthDate = aDecoder.decodeObject(forKey: "birthDate") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        self.gender = aDecoder.decodeObject(forKey: "gender") as? String
        self.profileImage = aDecoder.decodeObject(forKey: "profileImage") as? String
    }
    
    public var id: String?
    public var firstName: String?
    public var lastName: String?
    public var birthDate: String?
    public var email: String?
    public var gender: String?
    public var profileImage: String?
}
