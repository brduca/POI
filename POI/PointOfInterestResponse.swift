import Foundation

class PointOfInterestResponse: Mappable {
    
    var Id: String
    var Title: String
    var Address: String
    var Transport: String
    var Email: String?
    var Geocoordinates: String
    var Description: String
    var Phone: String
    
    required init(dictionary: NSDictionary) {
    
        self.Id = dictionary["id"] as! String
        self.Title = dictionary["title"] as! String
        self.Address = dictionary["address"] as! String
        self.Transport = dictionary["transport"] as! String
        self.Email = dictionary["email"] as? String
        self.Geocoordinates = dictionary["geocoordinates"] as! String
        self.Description = dictionary["description"] as! String
        self.Phone = dictionary["phone"] as! String
    }
}
