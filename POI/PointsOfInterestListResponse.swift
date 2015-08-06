import Foundation

class PointOfInterestShortDetailsDto {
    
    var Id: String
    var Title: String
    var Geocoordinates: String
    
    required init(dictionary: NSDictionary) {
        
        self.Id = dictionary["id"] as! String
        self.Title = dictionary["title"] as! String
        self.Geocoordinates = dictionary["geocoordinates"] as! String
    }
}

class PointsOfInterestListResponse : Mappable {
    
    var Results = [PointOfInterestShortDetailsDto]()
    
    required init(dictionary: NSDictionary) {
        
        var results = dictionary["list"] as! NSArray
        
        for dataObject: AnyObject in results {
            
            if let data = dataObject as? NSDictionary {
                var item = PointOfInterestShortDetailsDto(dictionary: data)
                self.Results.append(item)
            }
        }
    }
}
