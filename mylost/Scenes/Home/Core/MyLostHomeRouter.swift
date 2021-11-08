//  
//  MyLostHomeRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import RxRelay
import Core
import Components

protocol MyLostHomeRouter {
    func move2UserDetails(guestUserID: Int, guestImgUrl: String?)
    func move2Filter(delegate: FilterDetailsPresenterDelegate)
    func move2Fav(favouriteStatements: BehaviorRelay<[Statement]>)
    func attach(controller: MyLostHomeController)
    func dispayDialog(model: DialogComponent.ViewModel)
    func dismissPresentedView()
}

class MyLostHomeRouterImpl: MyLostHomeRouter {
    
    private weak var controller: MyLostHomeController?
    private var presentedView: UIViewController?
    
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
        let v = ChatViewController()
        
        self.controller?.navigationController?.pushViewController(v, animated: true)
        return 
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
    
    func dispayDialog(model: DialogComponent.ViewModel) {
        let comp = DialogComponent.init(model: model)
        presentedView = comp
        self.controller?.present(comp, animated: true, completion: nil)
    }
    
    func dismissPresentedView() {
        presentedView?.dismiss(animated: true, completion: nil)
    }
}
