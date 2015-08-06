import Foundation
import UIKit

class PointOfViewShortDetailCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceInfoLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var visitedImage: UIImageView!
    
    let darkGray =  UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
    let lightGray =  UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
    
    func setupUIDefaults(){
        
        self.titleLabel.font = DefaultFonts.set(FontWeight.bold, size: 18)
        self.distanceInfoLabel.font = DefaultFonts.set(FontWeight.regular, size: 12)
        self.distanceLabel.font = DefaultFonts.set(FontWeight.regular, size: 12)

        self.titleLabel.textColor = darkGray
        self.distanceInfoLabel.textColor = lightGray
        self.distanceLabel.textColor = lightGray
    }
}