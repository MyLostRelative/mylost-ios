//
//  BannerDisplay.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/23/21.
//

import UIKit

extension UIViewController {
    func displayBanner(banner: BannerComponent.ViewModel) {
        let bannerComp = BannerComponent(with: banner)
        bannerComp.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bannerComp)
        
        bannerComp.top(toView: self.view )
        bannerComp.left(toView: self.view, constant: 16)
        bannerComp.right(toView: self.view, constant: 16)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            bannerComp.removeFromSuperview()
        }

    }
}
