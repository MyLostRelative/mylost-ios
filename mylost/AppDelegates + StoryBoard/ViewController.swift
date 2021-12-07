//
//  ViewController.swift
//  mylost
//
//  Created by Nato Egnatashvili on 5/14/21.
//

import UIKit
import Components

class ViewController: UIViewController {
    private lazy var imgView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.width(equalTo: 100)
        img.height(equalTo: 100)
        img.image = Resourcebook.Image.Icons24.systemSearch.image
        return img
    }()
    
    private let lbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Welcome to My Lost"
        lbl.font = .systemFont(ofSize: 18, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func viewDidLoad() {
        //self.view.addSubview(imgView)
        self.view.addSubview(lbl)
        //imgView.centerVertically(to: self.view)
        lbl.centerHorizontally(to: self.view)
        self.lbl.center.y -= self.view.bounds.width
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
//        UIView.animate(withDuration: 0.5, delay: 0,  options: [.transitionCurlUp]) {
//            self.imgView.center.x += self.view.bounds.width/2 - 50
//        } completion: { _ in
//            print("animacia morcha")
//        }

        UIView.animate(withDuration: 0.5, delay: 0.5,  options: [.curveLinear]) {
            self.lbl.center.x = self.view.bounds.width/2
            self.lbl.center.y = self.view.bounds.height/2 - 100
        } completion: { _ in
            
            let childController = ProductContainer.init(nibName: "ProductContainer", bundle: nil)
            self.addChild(childController)
            childController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            self.view.addSubview(childController.view)
            childController.didMove(toParent: self)
            //self.navigationController?.pushViewController(ProductContainer(), animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      //  self.imgView.center.x -= self.view.bounds.width
        self.lbl.center.y -= self.view.bounds.width
        let balloon = CALayer()
        //balloon.contents = #imageLiteral(resourceName: "balloon").cgImage
        balloon.contents = Resourcebook.Image.Icons24.systemSearch.template.cgImage
        balloon.frame = CGRect(x: -50.0, y: 0.0, width: 50.0, height: 50.0)
        self.view.layer.addSublayer(balloon)
        let flight = CAKeyframeAnimation(keyPath: "position")
        flight.duration = 5
        flight.values = [
            CGPoint(x: -50.0, y: 0.0),
            CGPoint(x: view.frame.width , y: self.view.center.y),
            CGPoint(x: -50.0, y: self.view.center.y + 100)
        ].map { NSValue(cgPoint: $0) }
        flight.keyTimes = [0.0, 0.5, 1.0]
        
        balloon.add(flight, forKey: nil)
        balloon.position = CGPoint(x: -50.0, y: self.view.center.y)
    }
}
