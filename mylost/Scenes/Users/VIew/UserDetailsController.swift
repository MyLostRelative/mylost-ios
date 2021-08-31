//
//  UserDetailsController.swift
//  UserDetailsController
//
//  Created by Nato Egnatashvili on 14.08.21.
//

import UIKit
import RxSwift
import RxCocoa

class UserDetailsController: UIViewController {
    fileprivate let bag = DisposeBag()
    var user: UserDetailModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user?.isFavorite.accept(true)
    }
}
