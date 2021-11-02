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
    var currentCell: UITableViewCell? {get set}
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
    private let modelBuilder = ModelBuilder()
    private var isLoading = true
    private var statementsFetchFailed = false
    private var filterState = false
    private let isAuthorized = UserDefaultManagerImpl().getValue(key: "token") != nil
    private var currentCell: UITableViewCell? {
        didSet {
            self.view?.currentCell = currentCell
        }
    }
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
                ],
                reusableViews: [
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
    
}

// MARK: States
extension MyLostHomePresenterImpl {
    private func animationState() -> [ListSection] {
        [ListSection(
            id: "",
            rows: [self.cardAnimation(), self.cardAnimation(),  self.cardAnimation()] )]
    }
    
    private func cardLoadedState() -> [ListSection] {
        [ favouriteLabelSection(), filterLabelSection(), cardSections() ]
    }
    
    private func emptyState() -> [ListSection] {
        [emptyStatementsSection()]
    }
    
    private func errorState() -> [ListSection] {
        [errorStatementsSection()]
    }
    
    private func filterNotFoundState() -> [ListSection] {
        [removeFilterLabelSection(), emptyStatementsSection()]
    }
}

// MARK: Sections
extension MyLostHomePresenterImpl {
    private func cardSections() -> ListSection {
        let cardRows = self.statements.map({statementRow(statement: $0)})
        return ListSection(
            id: "",
            rows: cardRows)
    }
    
    private func filterLabelSection() -> ListSection {
        ListSection(
            id: "",
            rows:  [clickableLabel(with: .init(title: "ფილტრის გამოყენება",
                                               onTap: { _ in
                                                self.router.move2Filter(delegate: self)
                                               })), SearchTextFieldRow()] )
    }
    
    private func favouriteLabelSection() -> ListSection {
        ListSection(
            id: "",
            rows:  [clickableLabel(with: .init(title: "ფავორიტების სია",
                                               onTap: { _ in
                                                   self.router.move2Fav(favouriteStatements: self.statementsAndBlogsAdapter.favouriteStatements )
                                               }))
            ] )
    }
    
    private func removeFilterLabelSection() -> ListSection {
        ListSection(
            id: "",
            rows:  [clickableLabel(with: .init(title: "ფიტლრების წაშლა",
                                               onTap: { _ in
                                                   self.filterState = false
                                                   self.fetchStatementList()
                                               }))
            ] )
    }
    
    private func emptyStatementsSection() -> ListSection {
        ListSection(
            id: "",
            rows:  [emptyPageDescriptionRow()])
    }
    
    private func errorStatementsSection() -> ListSection {
        ListSection(
            id: "",
            rows:  [errorPageDescriptionRow()])
    }
}

// MARK: Rows
extension MyLostHomePresenterImpl {
    
    private func roudCards() -> ListSection {
        let rows = self.statements.map({roundCard(model: .init(title: $0.statementTitle,
                                                               description: $0.statementDescription))})
        return ListSection(
            id: "",
            rows:  rows)
    }
    
    private func roundCard(model: RoundedTitleAndDescription.ViewModel) -> ListRow <RoundCard> {
        ListRow(
            model: model,
            height: UITableView.automaticDimension)
    }
    
    private func cardAnimation() -> ListRow <CardAnimationTableCell> {
        ListRow(
            model: "",
            height: UITableView.automaticDimension)
    }
    
    private func emptyPageDescriptionRow() -> ListRow <PageDescriptionTableCell> {
        ListRow(
            model: modelBuilder.getEmptyPageDescription,
            height: UITableView.automaticDimension)
    }
        
    private func errorPageDescriptionRow() -> ListRow <PageDescriptionWithButtonTableCell> {
        ListRow(
            model: modelBuilder.getErrorPgaeDescription(tap: { (_) in
                self.retry()
            }),
            height: UITableView.automaticDimension)
    }
    
    private func clickableLabel(with model: TiTleButtonTableCell.ViewModel) -> ListRow<TiTleButtonTableCell> {
        ListRow(model: model,
                height: UITableView.automaticDimension)
    }
    
    // FAKE SERVICE
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
    
    private func statementRow(statement: Statement) -> ListRow <TitleAndDescriptionCardTableCell> {
        let isFav = self.statementsAndBlogsAdapter.favouriteStatements.value.filter({ $0 == statement }).first != nil
        return ListRow(
            model: TitleAndDescriptionCardTableCell
                .Model(headerModel:
                        HeaderWithDetailsCell.Model(
                            icon: .withURL(url: URL(string: statement.imageUrl ?? "")),
                            title: "განცხადება: " + statement.statementTitle,
                            info1: "სისხლის ჯგუფი: " + (statement.bloodType?.rawValue ?? "უცნობია"),
                            info2: "სქესი: " + (statement.gender?.value ?? "უცნობია"),
                            info3: "ნათესაობის ტიპი: " + (statement.relationType?.value ?? "უცნობია"),
                            info4: "ქალაქი: " + (statement.city ?? "უცნობია"),
                            description: nil,
                            rightIcon: .init(rightIconIsActive: isFav,
                                             rightIconActive: Resourcebook.Image.Icons24.systemStarFill.image,
                                             rightIconDissable: Resourcebook.Image.Icons24.systemStarOutline.image,
                                             rightIconHide: false,
                                             onTap: { _ in
                                                 self.isAuthorized ? self.setFavourtie(becomeFavourite: !isFav,
                                                                                       statement: statement) :
                                                 self.setFavourtie(becomeFavourite: !isFav,
                                                                                       statement: statement)
                                             })),
                       cardModel: .init(title: "",
                                        description: statement.statementDescription)),
            
            height: UITableView.automaticDimension,
            tapClosure: {row,_ ,cell in
                self.router.move2UserDetails(guestUserID: self.statements[row].userID, guestImgUrl: self.statements[row].imageUrl)
                print(self.statements[row].userID)
                self.currentCell = cell
            })
    }
    
    private func SearchTextFieldRow() -> ListRow <SearchTextField> {
        return ListRow(model: .init(title: "ძიება", onTapSearch: { search in
            self.fetchStatementList(statement: StatementSearchEntity.getWithQuery(query: search))
            self.constructDataSource()
        }) , height: UITableView.automaticDimension )
    }
}

extension MyLostHomePresenterImpl: FilterDetailsPresenterDelegate {
    func FilterDetailsPresenterDelegate(with: StatementSearchEntity) {
        self.isLoading = true
        self.filterState = true
        self.constructDataSource()
        self.fetchStatementList(statement: with)
    }
}
