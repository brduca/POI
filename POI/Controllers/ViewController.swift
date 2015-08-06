import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterView: UIView!

    var results = [PointOfInterestShortDetailsDto]()
    var filteredResults = [PointOfInterestShortDetailsDto]()
    var isFiltering = false
    var here: CLLocation? = nil
    
    let darkRed =  UIColor(red: 112/255, green: 48/255, blue: 48/255, alpha: 1)
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        fetchData()
        bindDelegates()
        setupUIDefaults()
    }

    func setupUIDefaults(){
    
        self.view.backgroundColor = darkRed
        searchBar.barTintColor = darkRed
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
    }
    
    func bindDelegates(){
    
        searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func fetchData(){
        
        results = HTTPHelper.getList().Results
        tableView.reloadData()
    }
    
    // Search bar funcs
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        isFiltering = true
        filteredResults = results.filter{ (elem: PointOfInterestShortDetailsDto) -> Bool in return  (elem.Title as NSString).containsString(searchBar.text) }
        self.view.endEditing(true)
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }

    @IBAction func filterByLocationBtnClickEventHandler(sender: AnyObject) {
        
        filteredResults = results.filter{(pointOfInterest: PointOfInterestShortDetailsDto) -> Bool in
        
            let destination = pointOfInterest.Geocoordinates.toCLLocation()
            let distance = self.here! |=> destination

            return true
        }
        
        isFiltering = true
        tableView.reloadData()
    }
    
    @IBAction func filterByFavoritesBtnClickEventHandler(sender: AnyObject) {
        
        filteredResults = results.filter{(pointOfInterest: PointOfInterestShortDetailsDto) -> Bool in
            
            return ManagePreferences.isFavorite(pointOfInterest.Id)
        }
        
        isFiltering = true
        tableView.reloadData()
    }
    
    @IBAction func filterByVisitedBtnClickEventHandler(sender: AnyObject) {
        
        filteredResults = results.filter{(pointOfInterest: PointOfInterestShortDetailsDto) -> Bool in
            
            return ManagePreferences.isVisited(pointOfInterest.Id)
        }
        
        isFiltering = true
        tableView.reloadData()
    }
    
    // table view funcs
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PointOfViewShortDetailCell

        let pointOfInterest = isFiltering ? filteredResults[indexPath.row] : results[indexPath.row]
        
        cell.titleLabel.text = pointOfInterest.Title
        
        if here != nil {
        
            let destination = pointOfInterest.Geocoordinates.toCLLocation()
            let distance = here! |=> destination
            
            cell.distanceInfoLabel.text = distance.humanizeKmFromMeters()
        }
        
        cell.visitedImage.alpha = ManagePreferences.isVisited(pointOfInterest.Id) ? 0.5 : 0
        cell.favoriteImage.alpha = ManagePreferences.isFavorite(pointOfInterest.Id)
 ? 0.5 : 0
        
        cell.setupUIDefaults()
        
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        let id = results[indexPath.row].Id
        
        let isVisited = ManagePreferences.isVisited(id)
        let vistitedTitle = isVisited ? "Remove visited" : "Visited!"
        
        let isFavorite = ManagePreferences.isFavorite(id)
        let favoriteTitle = isFavorite ? "Remove favorite" : "Favorit!"
        
        var markAsVisited = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: vistitedTitle, handler: {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            if isVisited
            {
                ManagePreferences.removeFromVisited(id)
            
            } else {
                
                ManagePreferences.addToVisited(id)
            }
            
            tableView.setEditing(false, animated: true)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        })

        var addToFavorites = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: favoriteTitle, handler: {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            if isFavorite
            {
                
                ManagePreferences.removeFromFavorite(id)
                
            } else {
                
                ManagePreferences.addToFavorite(id)
            }
            
            tableView.setEditing(false, animated: true)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        })

        markAsVisited.backgroundColor = UIColor.blueColor()
        addToFavorites.backgroundColor = UIColor.brownColor()
        
        return [addToFavorites, markAsVisited]
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        SessionVars.detailId = isFiltering ? filteredResults[indexPath.row].Id : results[indexPath.row].Id
        performSegueWithIdentifier("goToDetailsSegue", sender: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isFiltering ? filteredResults.count : results.count
    }
    
    // Location funcs
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        here = manager.location
    }
    
    override func didReceiveMemoryWarning() {
    
        super.didReceiveMemoryWarning()
    }
}