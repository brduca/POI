import Foundation
import MapKit

extension String {

    // Parse a string into CLLocationCoordinate2D
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        
        let coordenates =  split(self) { $0 == ","}
        
        let location = CLLocationCoordinate2D(
            latitude: (coordenates[0] as NSString).doubleValue,
            longitude: (coordenates[1] as NSString).doubleValue
        )
        
        return location
    }
    
    // Parse a string into CLLocation
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

    // Transform a distance in meters into Km
    // with 2 point precision and
    // adds the km sign
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