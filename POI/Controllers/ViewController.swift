import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterView: UIView!

    // Btns
    
    @IBOutlet weak var nearMeBtn: UIButton!
    @IBOutlet weak var favoritsBtn: UIButton!
    @IBOutlet weak var visitedBtn: UIButton!
    
    var results = [PointOfInterestShortDetailsDto]()
    var filteredResults = [PointOfInterestShortDetailsDto]()
    var isFiltering = false
    var here: CLLocation? = nil
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        fetchData()
        bindDelegates()
        setupUIDefaults()
    }

    func setupUIDefaults(){
    
        let btnsFonts = FontsLibrary.set(FontWeight.regular, size: 12)
        self.view.backgroundColor = ColorsLibrary.darkRed
        searchBar.barTintColor = ColorsLibrary.darkRed

        nearMeBtn.titleLabel?.font = btnsFonts
        favoritsBtn.titleLabel?.font = btnsFonts
        visitedBtn.titleLabel?.font = btnsFonts
        
        nearMeBtn.setTitleColor(ColorsLibrary.darkGray, forState: UIControlState.Normal)
        favoritsBtn.setTitleColor(ColorsLibrary.darkGray, forState: UIControlState.Normal)
        visitedBtn.setTitleColor(ColorsLibrary.darkGray, forState: UIControlState.Normal)
        
        
        let attributesDictionary = [NSForegroundColorAttributeName: ColorsLibrary.darkGray]
        var textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        
        textFieldInsideSearchBar!.font = FontsLibrary.set(FontWeight.regular, size: 14)
    
        textFieldInsideSearchBar!.attributedPlaceholder = NSAttributedString(string: "Barcelona point of interest finder" , attributes: attributesDictionary)
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
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            
            // tiny hack to force keyboard to disapear when clear is tapped
            let timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("disapearKeyboard"), userInfo: nil, repeats: false)
        }
    }
    
    func disapearKeyboard() {
    
        searchBar.resignFirstResponder()
        isFiltering = false
        tableView.reloadData()
        self.view.endEditing(true)
    }
    
    // Search bar funcs
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {

        isFiltering = true
        self.view.endEditing(true)
        filteredResults = results.filter{ (elem: PointOfInterestShortDetailsDto) -> Bool in
            
            // For sake of simpilicity convert both to lower case to compare
            let lowerCaseTitle = elem.Title.lowercaseString as NSString
            return lowerCaseTitle.containsString(self.searchBar.text.lowercaseString)
        }
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
        
        filteredResults = results.sorted {
        
            (self.here! |=>  $0.Geocoordinates.toCLLocation()) < (self.here! |=>  $1.Geocoordinates.toCLLocation())
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
        cell.favoriteImage.alpha = ManagePreferences.isFavorite(pointOfInterest.Id) ? 0.5 : 0
        
        cell.setupUIDefaults()
        
        // hack to prevent separator to disappear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        
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
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
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
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        })

        markAsVisited.backgroundColor = ColorsLibrary.darkRed
        addToFavorites.backgroundColor = ColorsLibrary.darkGray
        
        return [addToFavorites, markAsVisited]
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        SessionVars.detailId = isFiltering ? filteredResults[indexPath.row].Id : results[indexPath.row].Id
        performSegueWithIdentifier("goToDetailsSegue", sender: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var dataSource = isFiltering ? filteredResults : results
        
        if dataSource.count == 0 {
            
            var noResultsView = NSBundle.mainBundle().loadNibNamed("NoResults", owner: self, options: nil)
            tableView.backgroundView = noResultsView[0] as? UIView
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            
            return 0
        }
        else {
            
            self.tableView.backgroundView = nil
        }

        
        return dataSource.count
    }
    
    // Location funcs
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        here = manager.location
        tableView.reloadData()
        
        // only do this once, when the app is loaded
        manager.stopUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
    
        super.didReceiveMemoryWarning()
    }
}