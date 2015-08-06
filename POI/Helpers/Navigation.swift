import UIKit
import Foundation


// Segue to detail view
class CustomSegue: UIStoryboardSegue {
    
    override func perform() {
        
        let toViewController: UIViewController = self.destinationViewController as! UIViewController
        let fromViewController: UIViewController = self.sourceViewController as! UIViewController
        
        let containerView: UIView? = fromViewController.view.superview
        let screenBounds: CGRect = UIScreen.mainScreen().bounds
        
        let finalToFrame: CGRect = screenBounds
        let finalFromFrame: CGRect = CGRectOffset(finalToFrame, -screenBounds.size.width, 0)
        
        toViewController.view.frame = CGRectOffset(finalToFrame, screenBounds.size.width, 0)
        containerView?.addSubview(toViewController.view)
        
        UIView.animateWithDuration(0.2, animations: {
            
            toViewController.view.frame = finalToFrame
            fromViewController.view.frame = finalFromFrame
            
            }, completion: {
                finished in
                let fromVC: UIViewController = self.sourceViewController as! UIViewController
                let toVC: UIViewController = self.destinationViewController as! UIViewController
                fromVC.presentViewController(toVC, animated: false, completion: nil)
        })
    }
}

// Dismiss segue to keep listing position 
class DismissSegue: UIStoryboardSegue {
    
    override func perform(){
        
        let fromViewController: UIViewController = self.sourceViewController as! UIViewController
        let slideInFromLeftTransition = CATransition()
        
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromLeft
        slideInFromLeftTransition.duration = 0.2
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        slideInFromLeftTransition.fillMode = kCAFillModeBoth
        
        fromViewController.view.window?.layer.addAnimation(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
        fromViewController.dismissViewControllerAnimated(false,completion: nil)
    }
}
