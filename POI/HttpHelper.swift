import Foundation

class HTTPHelper {
    
    internal static  let BaseUrl = "http://t21services.herokuapp.com/points"
    
    static func getList() -> PointsOfInterestListResponse  {
    
        var request = createRequest(url: BaseUrl)
        var data = process(request)
        return CreateInstanceOf<PointsOfInterestListResponse>().from(data!)
    }
    
    static func getDetails(id: String) ->  PointOfInterestResponse {
    
        var url = "\(BaseUrl)/\(id)"
        var request = createRequest(url: url)
        var data = process(request)
        return CreateInstanceOf<PointOfInterestResponse>().from(data!)
    }
    
    internal static func createRequest(#url: String) -> NSMutableURLRequest {
        
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "GET"
        request.timeoutInterval = 60
        
        return request
    }
    
    internal static func process(request: NSMutableURLRequest) -> NSData? {
        
        var response: NSURLResponse?
        var error: NSError? = nil
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        if error == nil {
            
            if let httpResponse = response as? NSHTTPURLResponse {
                
                switch httpResponse.statusCode {
                    
                case 200:
                    return data
                    
                default:
                    return nil
                }
            }
        }
        
        return nil
    }
}


protocol Mappable {
    
    init(dictionary: NSDictionary)
}

struct CreateInstanceOf<T:Mappable> {
    
    func from(json: NSData) -> T {
        
        let dictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
        return T(dictionary: dictionary)
    }
}




