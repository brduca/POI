import Foundation
import UIKit

class PointOfViewShortDetailCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceInfoLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var visitedImage: UIImageView!
    
    // Setup initial cell styles
    func setupUIDefaults(){
        
        self.titleLabel.font = FontsLibrary.set(FontWeight.bold, size: 18)
        self.distanceInfoLabel.font = FontsLibrary.set(FontWeight.regular, size: 12)
        self.distanceLabel.font = FontsLibrary.set(FontWeight.regular, size: 12)

        self.titleLabel.textColor = ColorsLibrary.darkGray
        self.distanceInfoLabel.textColor = ColorsLibrary.lightGray
        self.distanceLabel.textColor = ColorsLibrary.lightGray
    }
}