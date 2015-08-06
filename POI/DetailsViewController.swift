import UIKit
import MapKit

class DetailsViewController: UIViewController {
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directionsInfoLabel: UILabel!
    
    // TextView
    @IBOutlet weak var descriptionTextView: UITextView!

    // Map
    @IBOutlet weak var mapView: MKMapView!
    
    // Naviagtion bar
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    // View
    @IBOutlet weak var statusBarWrapperView: UIView!
    
    
    let darkRed =  UIColor(red: 112/255, green: 48/255, blue: 48/255, alpha: 1)
    let darkGray =  UIColor(red: 47/255, green: 52/255, blue: 59/255, alpha: 1)
    
    var details : PointOfInterestResponse? = nil
    let span = MKCoordinateSpanMake(0.005, 0.005)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        fetchData()
        setupUIDefaults()
        bindSwipe()
    }
    
    func bindSwipe() {
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.Right:
                
                performSegueWithIdentifier("back", sender: nil)
                
            default:
                break
            }
        }
    }

    
    func setupUIDefaults(){
        
        navigationBar.tintColor = darkRed
        navigationBar.barTintColor = darkRed
        
        statusBarWrapperView.backgroundColor = darkRed
        
        navigationBar.titleTextAttributes = [NSFontAttributeName: DefaultFonts.set(FontWeight.regular, size: 16),
            NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        directionsInfoLabel.font = DefaultFonts.set(FontWeight.regular, size: 12)
        directionsInfoLabel.alpha = 0.6
        
        titleLabel.font = DefaultFonts.set(FontWeight.bold, size: 18)
        descriptionTextView.font = DefaultFonts.set(FontWeight.regular, size: 16)
        descriptionTextView.textColor = darkGray
        descriptionTextView.setContentOffset(CGPointZero, animated: false)
        descriptionTextView.backgroundColor = UIColor.clearColor()
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        var barButtonAppearace = UIBarButtonItem.appearance()
        
        barButtonAppearace.setTitleTextAttributes([NSFontAttributeName: DefaultFonts.set(FontWeight.regular, size: 16)], forState: UIControlState.Normal)
        
        barButtonAppearace.tintColor = UIColor.whiteColor()

    }
    
    func fetchData(){
    
        details = HTTPHelper.getDetails( SessionVars.detailId!)
       
       titleLabel.text = details!.Title
        
        descriptionTextView.text = details!.Description
        descriptionTextView.scrollRangeToVisible(NSRange(location:0, length:0))
    
        directionsInfoLabel.text = details!.Transport
        
        buildMap(details!.Geocoordinates.toCLLocationCoordinate2D())
    }
    
    @IBAction func launchMapsBtnClickEventHandler(sender: AnyObject) {
        
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        var placemark = MKPlacemark(coordinate: details!.Geocoordinates.toCLLocationCoordinate2D(), addressDictionary: nil)
        var mapItem = MKMapItem(placemark: placemark)

        mapItem.name = details!.Address
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
    func buildMap(location : CLLocationCoordinate2D){
        
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = details!.Title
        annotation.subtitle = details!.Address
        mapView.addAnnotation(annotation)
     //   mapView.selectAnnotation(annotation, animated: true)
    }
}
