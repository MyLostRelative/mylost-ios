//
//  Table Extensions.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/19/21.
//

import Foundation
import UIKit

public protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

public protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    public static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

extension UITableViewCell: ReusableView {
    
}

extension UITableViewHeaderFooterView: ReusableView {
    
}

extension UICollectionViewCell: ReusableView {
    
}

public extension UITableView {
    
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func register<T: UITableViewCell>(_: T.Type) where T:NibLoadableView {
        let bundle = Bundle.init(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
}

extension UITableView {
  
    func registerCell(reusable: Reusable.Type) {
       register(reusable, forCellReuseIdentifier: reusable.reuseID)
    }
    
    func registerNibCell(reusable: Reusable.Type) {
        register(UINib.init(
                 nibName: reusable.reuseID, bundle: nil),
                 forHeaderFooterViewReuseIdentifier: reusable.reuseID)
    }
    
    func registerFooterHeader(reusable:  Reusable.Type) {
        register(reusable, forHeaderFooterViewReuseIdentifier: reusable.reuseID)
    }
    
    func registerNibFooterHeader(reusable:  Reusable.Type) {
        register(UINib.init(nibName: reusable.reuseID, bundle: nil), forHeaderFooterViewReuseIdentifier: reusable.reuseID)
    }
}

extension UITableView {
    func dequeueCell<T>(at indexPath: IndexPath)  -> T where  T: UITableViewCell {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("Unexpected ReusableCell Type for reuseID \(T.reuseID)")
        }
        return cell
    }
    
    func dequeueView<T>() -> T where  T: UITableViewHeaderFooterView {
        
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: T.reuseID) as? T else {
            fatalError("Unexpected ReusableView Type for reuseID \(T.reuseID)")
        }
        return cell
    }
}


extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        
        register(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: NSIndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
}


