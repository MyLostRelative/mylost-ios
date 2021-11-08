//  
//  MyLostHomePresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa
import Core
import Components

protocol MyLostHomeView: AnyObject {
    var tableView: UITableView {get}
    func displayBanner(type: Bannertype, title: String, description: String)
}

protocol MyLostHomePresenter {
    func viewDidLoad()
    func viewWillAppear()
    func attach(view: MyLostHomeView)
}

class MyLostHomePresenterImpl: MyLostHomePresenter {
    
    private weak var view: MyLostHomeView?
    private var router: MyLostHomeRouter
    private var tableViewDataSource: ListViewDataSource?
    private let statementsGateway: StatementGateway
    private var statements: [Statement] = []
    private let modelsFactory: MyLostHomeFactory  = MyLostHomeFactoryImpl()
    private var isLoading = true
    private var statementsFetchFailed = false
    private var filterState = false
    private let isAuthorized = UserDefaultManagerImpl().getValue(key: "token") != nil
    let favouriteStatements: BehaviorRelay<[Statement]> = BehaviorRelay(value: [])
    private let manager: PickerDataManager = PickerDataManagerImpl()
    private let statementsAndBlogsAdapter: StatementsAndBlogsAdapter
    
    init(statementsGateway: StatementGateway,
         router: MyLostHomeRouter,
         statementsAndBlogsAdapter: StatementsAndBlogsAdapter) {
        self.statementsGateway = statementsGateway
        self.router = router
        self.statementsAndBlogsAdapter = statementsAndBlogsAdapter
    }
    
    func attach(view: MyLostHomeView) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchStatementList()
        configureDataSource()
    }
    
    func viewWillAppear() {
        constructDataSource()
    }
    
    private func retry() {
        self.isLoading = true
        self.statementsFetchFailed = false
        self.constructDataSource()
        self.fetchStatementList()
    }
    
    private func fetchFavourites() {
        statementsAndBlogsAdapter.favouriteStatements.accept(statements.filter({$0.isFavourite ?? false}))
    }
}

// MARK: Services
extension MyLostHomePresenterImpl {
    private func fetchStatementList(statement: StatementSearchEntity = .default) {
        self.statementsGateway.getStatementList(statement: statement) { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let statements):
                self.statementsFetchSuccess(statements)
            case .failure(let err):
                self.statementsFetchFailed(err)
            }
        }
    }
    
    private func statementsFetchSuccess(_ statements: [Statement]) {
        self.statementsFetchFailed = false
        self.statements = statements
        fetchFavourites()
        self.constructDataSource()
    }
    
    private func statementsFetchFailed(_ error: Error) {
        self.statementsFetchFailed = true
        self.view?.displayBanner(type: .negative, title: "ოპერაცია წარმატებით შესრულდა",
                                 description: error.localizedDescription)
        self.constructDataSource()
    }
}

// MARK: Configure and Construct
extension MyLostHomePresenterImpl {
    private func configureDataSource() {
        self.view.unwrap { v in
            tableViewDataSource = ListViewDataSource.init(
                tableView: v.tableView,
                withClasses: [
                    RoundedTextFieldTableCell.self,
                    HeaderWithDetailsCell.self,
                    TitleAndDescriptionCardTableCell.self,
                    CardAnimationTableCell.self,
                    RoundCard.self,
                    PageDescriptionTableCell.self,
                    PageDescriptionWithButtonTableCell.self,
                    PickerViewCell.self,
                    TiTleButtonTableCell.self,
                    RoundButtonTableCell.self,
                    SearchTextField.self
                ])
            tableViewDataSource?.needAnimation = true
        }
    }
    
    private func constructDataSource() {
        let stateDependent =  self.isLoading ? animationState() :
            self.statementsFetchFailed ? errorState() :
            self.filterState ? filterNotFoundState() :
            self.statements.isEmpty ? emptyState() :
            cardLoadedState()
        
        DispatchQueue.main.async {
            self.tableViewDataSource?.reload(
                with: stateDependent
            )
        }
    }
    
    private func setFavourtie(success: Bool = true,
                              becomeFavourite: Bool,
                              statement: Statement) {
        if success {
            if becomeFavourite {
                self.statementsAndBlogsAdapter.favouriteStatements.accept(self.statementsAndBlogsAdapter.favouriteStatements.value  + [statement])
            } else {
                let removedFav = self.statementsAndBlogsAdapter.favouriteStatements.value.filter({$0 != statement})
                self.statementsAndBlogsAdapter.favouriteStatements.accept(removedFav)
                
            }
            constructDataSource()
        } else {
            
        }
    }
    
    private func notAuthorizedState() {
        self.view?.displayBanner(type: .informative,
                                 title: "თქვენ არ ხართ დალოგინებული",
                                 description: "დალოგინდით ა გაიარეთ რეგისტრაცია , რათა შეძლოთ გგანცხადების გაფავორიტება")
    }
    
}

// MARK: - States
extension MyLostHomePresenterImpl {
    private func animationState() -> [ListSection] {
        [modelsFactory.animationSection()]
    }
    
    private func cardLoadedState() -> [ListSection] {
        [ favouriteLabelSection(), filterLabelSection(), cardSections() ]
    }
    
    private func emptyState() -> [ListSection] {
        [modelsFactory.emptyStatementsSection()]
    }
    
    private func errorState() -> [ListSection] {
        [modelsFactory.errorStatementsSection { _ in
            self.retry()
        }]
    }
    
    private func filterNotFoundState() -> [ListSection] {
        [removeFilterLabelSection(), modelsFactory.emptyStatementsSection()]
    }
}

// MARK: Sections
extension MyLostHomePresenterImpl {
    private func cardSections() -> ListSection {
        let statementWithTips = self.statements.map { statement -> StatementWithTaps in
            let isFavourite = self.statementsAndBlogsAdapter
                .favouriteStatements
                .value
                .filter({ $0 == statement }).first != nil
            
            return StatementWithTaps(statement: statement,
                              isFavourite: isFavourite) { _ in
                let favModel = self.modelsFactory.favouriteDialogModel(isFavourite: !isFavourite,
                    primaryTap: {[weak self] _ in
                    self?.router.dismissPresentedView()
                    self?.setFavourtie(becomeFavourite: !isFavourite,
                                                          statement: statement)
                }, secondaryTap: {[weak self] _ in
                    self?.router.dismissPresentedView()
                })
                self.router.dispayDialog(model: favModel)
                
//                                                 self.isAuthorized ? self.setFavourtie(becomeFavourite: !isFavourite,
//                                                                                       statement: statement) :
//                                                 self.setFavourtie(becomeFavourite: !isFavourite,
//                                                                                       statement: statement)
            } rowTap: { row, _, _ in
                self.router.move2UserDetails(guestUserID: self.statements[row].userID,
                                             guestImgUrl: self.statements[row].imageUrl)
            }

        }
        return modelsFactory.cardSections(statements: statementWithTips)
    }
    
    private func filterLabelSection() -> ListSection {
        modelsFactory.filterLabelSection { _ in
            self.router.move2Filter(delegate: self)
        } onTapSearch: { search in
            self.fetchStatementList(statement: StatementSearchEntity.getWithQuery(query: search))
            self.constructDataSource()
        }
    }
    
    private func favouriteLabelSection() -> ListSection {
        modelsFactory.favouriteLabelSection { _ in
            self.router.move2Fav(favouriteStatements: self.statementsAndBlogsAdapter.favouriteStatements )
        }
    }
    
    private func removeFilterLabelSection() -> ListSection {
        modelsFactory.removeFilterLabelSection { _ in
            self.filterState = false
            self.fetchStatementList()
        }
    }
}

// MARK: - Delegates
extension MyLostHomePresenterImpl: FilterDetailsPresenterDelegate {
    func FilterDetailsPresenterDelegate(with: StatementSearchEntity) {
        self.isLoading = true
        self.filterState = true
        self.constructDataSource()
        self.fetchStatementList(statement: with)
    }
}
