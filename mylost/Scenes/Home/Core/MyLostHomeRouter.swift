//  
//  MyLostHomeRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import UIKit
import Hero

protocol MyLostHomeRouter {
    func move2UserDetails(guestUserID: Int, guestImgUrl: String?)
    func move2Filter(delegate: FilterDetailsPresenterDelegate)
    func move2H()
}

class MyLostHomeRouterImpl: MyLostHomeRouter {
    
    private weak var controller: MyLostHomeController?
    
    init(_ controller: MyLostHomeController?) {
        self.controller = controller
    }
    
    func move2UserDetails(guestUserID: Int, guestImgUrl: String?) {
        guard let vc = DIAssembly(uiAssemblies: [ContactDetailsAssembly(guestUserID: guestUserID,
                                                                        guestImgUrl: guestImgUrl)],
                                  networkAssemblies: [UserInfoetworkAssembly()])
            .resolver
                .resolve(ContactDetailsViewController.self) else { return }
        
       self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func move2Filter(delegate: FilterDetailsPresenterDelegate) {
        move2Fav()
//        guard let vc = DIAssembly(uiAssemblies: [FilterDetailsAssembly(delegate: delegate)],
//                                  networkAssemblies: [])
//            .resolver
//                .resolve(FilterDetailsViewController.self) else { return }
//        self.controller?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func move2Fav() {
        guard let vc = DIAssembly(uiAssemblies: [FavouriteStatementsAssembly()],
                                  networkAssemblies: [])
            .resolver
                .resolve(FavouriteStatementsController.self) else { return }
        
       self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func move2H() {
        let otherPaymentConfigure = MyLostHomeConfiguratorImpl()
        let otherProductsVC = MyLostHomeController()
        otherPaymentConfigure.configure(otherProductsVC )
        self.controller?.navigationController?.pushViewController(otherProductsVC, animated: true)
    }
}
