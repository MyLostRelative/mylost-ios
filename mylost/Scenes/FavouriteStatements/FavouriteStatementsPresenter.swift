//  
//  FavouriteStatementsPresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 27.09.21.
//

import Foundation

protocol FavouriteStatementsView: AnyObject {
}

protocol FavouriteStatementsPresenter {
    func attach(view: FavouriteStatementsView) 
    func viewDidLoad()
}

class FavouriteStatementsPresenterImpl: FavouriteStatementsPresenter {
    
    private weak var view: FavouriteStatementsView?
    private let router: FavouriteStatementsRouter
    
    init(router: FavouriteStatementsRouter) {
        self.router = router
    }
    
    func viewDidLoad() {
    }
    
    func attach(view: FavouriteStatementsView) {
        self.view = view
    }
}
