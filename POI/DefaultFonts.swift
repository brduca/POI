import Foundation
import UIKit

class DefaultFonts {

  static func set(weight: FontWeight, size: Int) -> UIFont {
    
        return UIFont(name: weight.rawValue, size:CGFloat(size))!
    }
}

public enum FontWeight : String {

    case regular = "LibreBaskerville-Regular"
    case italic = "LibreBaskerville-Italic"
    case bold = "LibreBaskerville-Bold"
}