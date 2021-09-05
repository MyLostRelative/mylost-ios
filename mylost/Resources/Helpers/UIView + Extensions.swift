//
//  UIView + Extensions.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/19/21.
//


import UIKit

public class Helper {
    ///Deprecated, will be removed  soon.
    ///Please migrate to another API
    @available(*, deprecated, message: "This will be removed in v2.0. please refactor acordingly")
    static func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
}

public extension UIView {
    
    // MARK: Safe UIView anchors
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return self.topAnchor
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leftAnchor
        }
        return self.leftAnchor
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.rightAnchor
        }
        return self.rightAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }
        return self.bottomAnchor
    }
    
    // MARK: Constraint helper methods
    func left(toView view: UIView, constant value: CGFloat = 0) {
        self.leftAnchor.constraint(equalTo: view.safeLeftAnchor, constant: value).isActive = true
    }
    func leftNotSafe(toView view: UIView, constant value: CGFloat = 0) {
        self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: value).isActive = true
    }
    func relativeLeft(toView view: UIView, constant value: CGFloat) {
        self.leftAnchor.constraint(equalTo: view.safeRightAnchor, constant: value).isActive = true
    }
    func right(toView view: UIView, constant value: CGFloat = 0) {
        self.rightAnchor.constraint(equalTo: view.safeRightAnchor, constant: -value).isActive = true
    }
    func right(toView view: UIView, greaterThanOrEqualToConstant value: CGFloat) {
        self.rightAnchor.constraint(greaterThanOrEqualTo: view.safeRightAnchor, constant: -value).isActive = true
    }

    func rightNotSafe(toView view: UIView, constant value: CGFloat = 0) {
        self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -value).isActive = true
    }
    
    func relativeRight(toView view: UIView, constant value: CGFloat) {
        self.rightAnchor.constraint(equalTo: view.safeLeftAnchor, constant: value).isActive = true
    }
    func top(toView view: UIView, constant value: CGFloat = 0) {
        self.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: value).isActive = true
    }
    @discardableResult
    func bottom(toView view: UIView, constant value: CGFloat = 0) -> NSLayoutConstraint {
        let cconstant = self.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -value)
        cconstant.isActive = true
        return cconstant
    }
    func topNotSafe(toView view: UIView, constant value: CGFloat = 0) {
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: value).isActive = true
    }
    func bottomNotSafe(toView view: UIView, constant value: CGFloat = 0) {
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -value).isActive = true
    }
    func relativeBottom(toView view: UIView, constant value: CGFloat = 0) {
        self.bottomAnchor.constraint(equalTo: view.safeTopAnchor, constant: -value).isActive = true
    }
    func relativeTop(toView view: UIView, constant value: CGFloat = 0) {
        self.topAnchor.constraint(equalTo: view.safeBottomAnchor, constant: value).isActive = true
    }
    func width(equalTo dimension: NSLayoutDimension) {
        self.widthAnchor.constraint(equalTo: dimension).isActive = true
    }
    func width(equalTo dimension: NSLayoutDimension, constant value: CGFloat) {
        self.widthAnchor.constraint(equalTo: dimension, constant: value).isActive = true
    }
    func height(to dimension: NSLayoutDimension, multiplier: CGFloat = 0) {
        self.heightAnchor.constraint(equalTo: dimension, multiplier: multiplier).isActive = true
    }
    func height(equalTo constant: CGFloat) {
        self.heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    func height(greaterThanOrEqualToConstant constant: CGFloat) {
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
    }
    func width(equalTo constant: CGFloat) {
        self.widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    func width(lessThanOrEqualTo dimension: NSLayoutDimension, multiplier: CGFloat = 1) {
        self.widthAnchor.constraint(lessThanOrEqualTo: dimension, multiplier: multiplier).isActive = true
    }
    func width(lessThanOrEqualTo constant: CGFloat) {
        self.widthAnchor.constraint(lessThanOrEqualToConstant: constant).isActive = true
    }
    func centerVertically(to view: UIView) {
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    func centerHorizontally(to view: UIView) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func stretchLayout(with constant: CGFloat, to view: UIView) {
        self.top(toView: view, constant: constant)
        self.left(toView: view, constant: constant)
        self.right(toView: view, constant: constant)
        self.bottom(toView: view, constant: constant)
    }
    
    func stretchLayout(to view: UIView) {
        self.top(toView: view)
        self.left(toView: view)
        self.right(toView: view)
        self.bottom(toView: view)
    }
}



extension UIView {
    func roundCorners(with type: RadiusType) {
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        switch type {
        case .circle:
            return self.layer.cornerRadius = self.layer.frame.height / 2
        case .constant(let radius):
            return
                self.layer.cornerRadius = radius
        }
    }
    
    func roundCorners(with radiusType: RadiusType, with roundedType:  RoundedType) {
        
        switch roundedType {
        case .round:
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        case .roundBottom:
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        case .roundTop:
            self.layer.maskedCorners = [.layerMinXMinYCorner,  .layerMaxXMinYCorner]
        }
        
        switch radiusType {
        case .circle:
            return self.layer.cornerRadius = self.layer.frame.height / 2
        case .constant(let radius):
            return
                self.layer.cornerRadius = radius
        }
    }
}

enum RadiusType {
    case circle
    case constant(radius: CGFloat)
}

enum RoundedType {
    case roundTop
    case roundBottom
    case round
}

public extension Optional where Wrapped: Any {
    func unwrap(_ block: (_ it: Wrapped) -> () ) {
        guard let obj = self else {
            return
        }
        block(obj)
    }
}

extension String {
    var convertedDate: String? {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "MMM d , yyyy , h:mm a"
            dateFormatter.locale = tempLocale // reset the locale
            return  dateFormatter.string(from: date)
        }
        return nil
    }
}
