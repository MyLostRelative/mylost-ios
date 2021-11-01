//  
//  FavouriteStatementsPresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 27.09.21.
//

import RxSwift
import RxRelay
import Core
import Components

protocol FavouriteStatementsView: AnyObject {
    var viewModel: FavouriteViewModel { get }
}

protocol FavouriteStatementsPresenter {
    func attach(view: FavouriteStatementsView)
    func viewDidLoad()
}

class FavouriteStatementsPresenterImpl: FavouriteStatementsPresenter {
    
    private weak var view: FavouriteStatementsView?
    private let router: FavouriteStatementsRouter
    let favouriteStatements: BehaviorRelay<[Statement]>
    
    init(router: FavouriteStatementsRouter,
         favouriteStatements: BehaviorRelay<[Statement]>) {
        self.router = router
        self.favouriteStatements = favouriteStatements
    }
    
    func viewDidLoad() {
        getModels()
    }
    
    func getModels() {
        let models = favouriteStatements.value.map({ getTitleAndDescription(statement: $0) })
        self.view?.viewModel.subscribeWithItems(subItems: models)
    }
    
    // FAKE SERVICE
    private func removeFromFavs(
        success: Bool = true,
        statement: Statement) {
            if success {
                let removedFav = self.favouriteStatements.value.filter( { $0 != statement})
                self.favouriteStatements.accept(removedFav)
                self.getModels()
            } else {
                // print()
            }
        }
    
    func getTitleAndDescription(statement: Statement) ->  TitleAndDescriptionCardTableCell.CellModel {
        return TitleAndDescriptionCardTableCell.CellModel(headerModel:
                                                            HeaderWithDetailsCell.Model(
                                                                icon: .withURL(url: URL(string: statement.imageUrl ?? "")),
                                                                title: "განცხადება: " + statement.statementTitle,
                                                                info1: "სისხლის ჯგუფი: " + (statement.bloodType?.rawValue ?? "უცნობია"),
                                                                info2: "სქესი: " + (statement.gender?.value ?? "უცნობია"),
                                                                info3: "ნათესაობის ტიპი: " + (statement.relationType?.value ?? "უცნობია"),
                                                                info4: "ქალაქი: " + (statement.city ?? "უცნობია"),
                                                                description: nil,
                                                                rightIcon: .init(rightIconIsActive: true,
                                                                                 rightIconActive: Resourcebook.Image.Icons24.systemStarFill.image,
                                                                                 rightIconDissable: Resourcebook.Image.Icons24.systemStarOutline.image,
                                                                                 rightIconHide: false,
                                                                                 onTap: { _ in
                                                                                     self.removeFromFavs( statement: statement)
                                                                                 })),
                                                          cardModel: .init(title: "",
                                                                           description: statement.statementDescription))
    }
    
    func attach(view: FavouriteStatementsView) {
        self.view = view
    }
}
