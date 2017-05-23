//
//  LoaderView.swift
//  VideoAnalytics

//

import UIKit

public enum LoaderViewType: Int {
    case white = 0 , black
}

class LoaderView: UIView {
    
    fileprivate var indicatorView:UIImageView!
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    // use this to show loader on middle of each screen
    convenience init (viewFrame: CGRect) {
        self.init(frame : viewFrame)
        addLoader()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func addLoader() {
        
        self.backgroundColor = UIColor.clear
        
        indicatorView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        
        indicatorView.center = self.center
        
        self.addSubview(indicatorView)
        
    }
    
    func startAnimating(_ loaderType:LoaderViewType = .white) {
        
        if loaderType == .white {
            indicatorView.image = UIImage(named: "ic_loader")
        } else {
            indicatorView.image = UIImage(named: "ic_loading_white_bg")
        }
        
        indicatorView!.startRotating()
    }
    
    func stopAnimating() {
        indicatorView!.stopRotating()
    }
}

extension UIView {
    
    //Start Rotating view
    func startRotating(_ duration: Double = 1) {
        
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            
            animate.fromValue = 0.0
            animate.toValue = Float(Double.pi * 2.0)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    
    //Stop rotating view
    func stopRotating() {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
    
}
