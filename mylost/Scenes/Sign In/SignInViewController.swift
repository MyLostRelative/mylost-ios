//
//  SignInViewController.swift
//  SignInViewController
//
//  Created by Nato Egnatashvili on 30.08.21.
//

import UIKit
import LifetimeTracker
import MaterialComponents.MaterialActivityIndicator
import Components

protocol SignInView: AnyObject {
    var tableView: UITableView {get}
    func displayBanner(type: Bannertype, title: String, description: String)
    func startLoading()
    func stopLoading()
}

class SignInViewController: UIViewController, LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "VC")
    }
    
    var presenter: SignInPresenter?
    
    internal  var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .white
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        return table
    }()
    
    private lazy var activityIndicator: MDCActivityIndicator = {
        let activityIndicator = MDCActivityIndicator()
        activityIndicator.sizeToFit()
        activityIndicator.cycleColors = [.black]
        return activityIndicator
    }()
    
    private lazy var ActivityIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var blurView: UIView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackLifetime()
        setUpTableView()
        setUpActivityIndicator()
        self.presenter?.viewDidLoad()
    }
    
    private func setUpTableView() {
        self.view.addSubview(tableView)
        tableView.top(toView: self.view)
        tableView.right(toView: self.view)
        tableView.bottom(toView: self.view)
        tableView.left(toView: self.view)
        self.view.backgroundColor = .white
        
    }
    
    private func setUpActivityIndicator() {
        self.tableView.addSubview(blurView)
        blurView.isHidden = true
        tableView.addSubview(ActivityIndicatorView)
        ActivityIndicatorView.left(toView: tableView, constant: self.view.frame.width/2 - activityIndicator.frame.width/2)
        ActivityIndicatorView.top(toView: tableView, constant: self.view.frame.height/2 - activityIndicator.frame.height/2)
        
        ActivityIndicatorView.addSubview(activityIndicator)
    }
}

extension SignInViewController: SignInView {
    func displayBanner(type: Bannertype, title: String, description: String) {
        DispatchQueue.main.async {
            self.displayBanner(banner: .init(type: type, title: title, description: description))
        }
    }
    
    func startLoading() {
        DispatchQueue.main.async { self.blurView.isHidden = false }
        self.activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        DispatchQueue.main.async { self.blurView.isHidden = true }
        self.activityIndicator.stopAnimating()
    }
}
