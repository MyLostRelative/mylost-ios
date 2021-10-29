//
//  TransitionManager.swift
//  mylost
//
//  Created by Nato Egnatashvili on 11.09.21.
//

import UIKit
import Components

final class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from) as? MyLostHomeController, // 1
            let toViewController = transitionContext.viewController(forKey: .to) as? ContactDetailsViewController, // 2
        let albumCell = fromViewController.currentCell as? TitleAndDescriptionCardTableCell
        else {
            return
        }
        
        let detailHeaderView = toViewController.headerView
        let homeImageView = albumCell.getIcon()
        
        let containerView = transitionContext.containerView // 6
        let snapshotContentView = UIView()
        snapshotContentView.frame = CGRect(x: homeImageView.frame.minX,
                                           y: homeImageView.frame.minY,
                                           width: homeImageView.frame.width,
                                           height: homeImageView.frame.height)
        snapshotContentView.layer.cornerRadius = homeImageView.layer.cornerRadius
        
        let snapshotImageView = UIImageView()
        snapshotImageView.layer.cornerRadius = homeImageView.layer.cornerRadius
        snapshotImageView.layer.masksToBounds = true
        snapshotImageView.image = homeImageView.image
        snapshotImageView.frame = CGRect(x: homeImageView.frame.minX,
                                         y: homeImageView.frame.minY,
                                         width: homeImageView.frame.width,
                                         height: homeImageView.frame.height)
        snapshotContentView.addSubview(snapshotImageView)
        containerView.addSubview(toViewController.view) // 7
        containerView.addSubview(snapshotContentView)

        toViewController.view.isHidden = true // 8
        homeImageView.isHidden = true
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn) {
            snapshotContentView.frame = containerView.convert(toViewController.view.frame, from: toViewController.view)
            snapshotImageView.frame = containerView.convert(detailHeaderView.frame, from: detailHeaderView)
            snapshotImageView.layer.masksToBounds = true
            snapshotImageView.layer.cornerRadius = detailHeaderView.layer.cornerRadius
            
        }

        animator.addCompletion { position in
            toViewController.view.isHidden = false
            snapshotImageView.removeFromSuperview()
            snapshotContentView.removeFromSuperview()
            homeImageView.isHidden = false
            transitionContext.completeTransition(position == .end)
        }

        animator.startAnimation()
    }
    
}
