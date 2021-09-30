//
//  RevealAnimator.swift
//  mylost
//
//  Created by Nato Egnatashvili on 11.09.21.
//

import UIKit

class RevealAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    let animationDuration = 2.0
    var operation: UINavigationController.Operation = .push
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey:
         .from) as! MyLostHomeController
        let toVC = transitionContext.viewController(forKey:
         .to) as! FilterDetailsViewController
        transitionContext.containerView.addSubview(toVC.view)
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.toValue = NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeTranslation(0.0, -10.0, 0.0),CATransform3DMakeScale(150.0, 150.0, 1.0)))
        
        animation.duration = animationDuration
        animation.delegate = self
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name:
                                                            CAMediaTimingFunctionName.easeIn)
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        print("ended")
    }

}
