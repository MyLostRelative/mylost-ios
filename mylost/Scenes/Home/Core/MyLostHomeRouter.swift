//  
//  MyLostHomeRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import RxRelay
import Core

protocol MyLostHomeRouter {
    func move2UserDetails(guestUserID: Int, guestImgUrl: String?)
    func move2Filter(delegate: FilterDetailsPresenterDelegate)
    func move2Fav(favouriteStatements: BehaviorRelay<[Statement]>)
    func attach(controller: MyLostHomeController)
}

class MyLostHomeRouterImpl: MyLostHomeRouter {
    
    private weak var controller: MyLostHomeController?
    
    func attach(controller: MyLostHomeController) {
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
        guard let vc = DIAssembly(uiAssemblies: [FilterDetailsAssembly(delegate: delegate)],
                                  networkAssemblies: [])
            .resolver
                .resolve(FilterDetailsViewController.self) else { return }
        self.controller?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func move2Fav(favouriteStatements: BehaviorRelay<[Statement]>) {
        guard let vc = DIAssembly(
                uiAssemblies: [FavouriteStatementsAssembly(favouriteStatements: favouriteStatements)],
                                  networkAssemblies: [])
            .resolver
                .resolve(FavouriteStatementsController.self) else { return }
        
       self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func move2Fav(adapter: StatementsAndBlogsAdapter) {
//        guard let vc = DIAssembly(
//                uiAssemblies: [FavouriteStatementsAssembly(favouriteStatements: favouriteStatements)],
//                                  networkAssemblies: [])
//            .resolver
//                .resolve(FavouriteStatementsController.self) else { return }
//        
//       self.controller?.navigationController?.pushViewController(vc, animated: true)
//    }
}
