import Foundation
import UIKit

class FontsLibrary {

  static func set(weight: FontWeight, size: Int) -> UIFont {
    
        return UIFont(name: weight.rawValue, size:CGFloat(size))!
    }
}

class ColorsLibrary {
    
    static let darkGray =  UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
    static let lightGray =  UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
    static let darkRed =  UIColor(red: 112/255, green: 48/255, blue: 48/255, alpha: 1)
    
    static let oliveGreen = UIColor(red: 112/255, green: 48/255, blue: 48/255, alpha: 1)
}

public enum FontWeight : String {

    case regular = "LibreBaskerville-Regular"
    case italic = "LibreBaskerville-Italic"
    case bold = "LibreBaskerville-Bold"
}