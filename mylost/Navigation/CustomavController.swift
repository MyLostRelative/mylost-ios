//
//  CustomavController.swift
//  mylost
//
//  Created by Nato Egnatashvili on 12.09.21.
//

import UIKit

open class CustomNavController: UINavigationController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        addBarDecoration()
    }
    
    public func set() {
        navigationBar.backgroundColor = Resourcebook.Color.Invert.Background.canvas.uiColor
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func addBarDecoration() {
        navigationBar.barTintColor = UIColor(white: 1, alpha: 0)
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        set()
    }
}

extension CustomNavController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let customNav = viewController as? customNavigatable {
            viewController.navigationItem.titleView = NavBarTitle.init(with: customNav.navTiTle)
        }
        
        if (viewController.navigationController?.viewControllers.count ?? 0) > 1 {
            let button = UIButton.init(type: .custom)
            button.addTarget(nil, action: #selector(pop), for: .touchUpInside)
            
            let image = Resourcebook.Image.Icons24.systemClose.template
            image.withTintColor(.black)
            button.setImage(image, for: .normal)
            button.imageView?.tintColor = .black
            let button2 = UIBarButtonItem(customView: button)
            viewController.navigationItem.leftBarButtonItem = button2
        }

    }
    
    @objc func pop() {
        self.viewControllers.last?.navigationController?.popViewController(animated: true)
    }
}

