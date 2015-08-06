import UIKit
import MapKit
import MessageUI

class DetailsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
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
        
        navigationBar.tintColor = ColorsLibrary.darkRed
        navigationBar.barTintColor = ColorsLibrary.darkRed
        
        statusBarWrapperView.backgroundColor = ColorsLibrary.darkRed
        
        navigationBar.titleTextAttributes = [NSFontAttributeName: FontsLibrary.set(FontWeight.regular, size: 16),
            NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        directionsInfoLabel.font = FontsLibrary.set(FontWeight.regular, size: 12)
        directionsInfoLabel.alpha = 0.6
        
        titleLabel.font = FontsLibrary.set(FontWeight.bold, size: 18)
        descriptionTextView.font = FontsLibrary.set(FontWeight.regular, size: 16)
        descriptionTextView.textColor = ColorsLibrary.darkGray
        descriptionTextView.setContentOffset(CGPointZero, animated: false)
        descriptionTextView.backgroundColor = UIColor.clearColor()
    }
    
    func fetchData(){
        
        details = HTTPHelper.getDetails( SessionVars.detailId!)
        
        titleLabel.text = details!.Title
        
        descriptionTextView.text = details!.Description
        descriptionTextView.scrollRangeToVisible(NSRange(location:0, length:0))
        
        directionsInfoLabel.text = details!.Transport
        
        buildMap(details!.Geocoordinates.toCLLocationCoordinate2D())
    }
    
    @IBAction func emailBtnClickEventHandler(sender: AnyObject) {

        var picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setSubject("Need more info")
        picker.setToRecipients([details!.Email!])
        picker.setMessageBody("", isHTML: true)
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func telephoneBtnClickEventHandler(sender: AnyObject) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://9809088798")!)
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
    }
}
