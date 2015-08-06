import Foundation
import MapKit

extension String {

    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        
        let coordenates =  split(self) { $0 == ","}
        
        let location = CLLocationCoordinate2D(
            latitude: (coordenates[0] as NSString).doubleValue,
            longitude: (coordenates[1] as NSString).doubleValue
        )
        
        return location
    }
    
    
    func toCLLocation() -> CLLocation {
        
        let coordenates =  split(self) { $0 == ","}
        
        let location = CLLocation(
            latitude: (coordenates[0] as NSString).doubleValue,
            longitude: (coordenates[1] as NSString).doubleValue
        )
        
        return location
    }
}

extension Double {

    func humanizeKmFromMeters() -> String {
        
        var km = self/1000
        var formated = NSString(format: "%.2f", km) as String
        return "\(formated) Km"
    }
}
	
// measure between 2 coordintates
infix operator |=> { associativity left precedence 140 }

func |=> (left:CLLocation, rigth: CLLocation) -> Double {
    
    var distance = left.distanceFromLocation(rigth)
    return distance
}