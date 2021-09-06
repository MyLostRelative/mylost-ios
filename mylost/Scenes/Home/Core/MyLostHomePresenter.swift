//  
//  MyLostHomePresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import UIKit
import SDWebImage

protocol MyLostHomeView: AnyObject {
    var tableView: UITableView {get}
    func displayBanner(type: Bannertype, title: String, description: String)
}

protocol MyLostHomePresenter {
    func viewDidLoad()
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
    private let manager: PickerDataManager = PickerDataManagerImpl()
    
    init(view: MyLostHomeView, statementsGateway: StatementGateway, router: MyLostHomeRouter) {
        self.view = view
        self.statementsGateway = statementsGateway
        self.router = router
    }
    
    func viewDidLoad() {
        fetchStatementList()
        configureDataSource()
        constructDataSource()
    }
    
    private func retry() {
        self.isLoading = true
        self.statementsFetchFailed = false
        self.constructDataSource()
        self.fetchStatementList()
    }
}

//MARK: Services
extension MyLostHomePresenterImpl {
    private func fetchStatementList() {
        self.statementsGateway.getStatementList { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false
            switch result{
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
        self.constructDataSource()
    }
    
    private func statementsFetchFailed(_ error: Error) {
        self.statementsFetchFailed = true
        self.view?.displayBanner(type: .negative, title: "ოპერაცია წარმატებით შესრულდა",
                                  description: error.localizedDescription)
        self.constructDataSource()
    }
}

//MARK: Configure and Construct
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
                    RoundButtonTableCell.self
                ],
                reusableViews: [
                ])
        }
    }
    
    private func constructDataSource() {
        let stateDependent =  self.isLoading ? animationState() :
            self.filterState ? filtersLoadedState() :
            self.statementsFetchFailed ? errorState() :
            self.statements.isEmpty ? emptyState() :
            cardLoadedState()
            
        DispatchQueue.main.async {
            self.tableViewDataSource?.reload(
                with: stateDependent
            )
        }
    }
  
}

//MARK: States
extension MyLostHomePresenterImpl {
    private func animationState()-> [ListSection] {
        [ListSection(
            id: "",
            rows: [self.cardAnimation(), self.cardAnimation(),  self.cardAnimation()] )]
    }
    
    private func cardLoadedState() -> [ListSection]{
        [filterLabelSection(), cardSections() ]
    }
    
    private func filtersLoadedState() -> [ListSection] {
        [filterSection()]
    }
    
    private func emptyState() -> [ListSection]{
        [emptyStatementsSection()]
    }
    
    private func errorState() -> [ListSection]{
        [errorStatementsSection()]
    }
}

//MARK: Sections
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
                                                self.filterState = true
                                                self.constructDataSource()
                                               })),
                    ] )
    }
    
    private func filterSection() -> ListSection {
        ListSection(
            id: "",
            rows:  [clickableLabel(with: .init(title: "უკან დაბრუნება",
                                               onTap: { _ in
                                                self.filterState = false
                                                self.constructDataSource()
                                               })),
                    pickerRow(type: .relativeType),
                    pickerRow(type: .sexType),
                    pickerRow(type: .age),
                    pickerRow(type: .bloodType),
                    pickerRow(type: .city),
                    buttonRow()])
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

//MARK: Rows
extension MyLostHomePresenterImpl {
    
    private func roudCards() -> ListSection{
        let rows = self.statements.map({roundCard(model: .init(title: $0.statementTitle,
                                                    description: $0.statementDescription))})
        return ListSection(
            id: "",
            rows:  rows)
    }
    
    
    private func roundCard(model: RoundedTitleAndDescription.ViewModel) -> ListRow <RoundCard>{
        ListRow(
            model: model,
            height: UITableView.automaticDimension)
    }
    
    private func cardAnimation() -> ListRow <CardAnimationTableCell>{
        ListRow(
            model: "",
            height: UITableView.automaticDimension)
    }
    
    
    private func emptyPageDescriptionRow() -> ListRow <PageDescriptionTableCell>{
        ListRow(
            model: modelBuilder.getEmptyPageDescription,
            height: UITableView.automaticDimension)
    }
    
    
    private func errorPageDescriptionRow() -> ListRow <PageDescriptionWithButtonTableCell>{
        ListRow(
            model: modelBuilder.getErrorPgaeDescription(tap: { (_) in
                self.retry()
            }),
            height: UITableView.automaticDimension)
    }
    
    private func pickerRow(type: PickerDataManagerImpl.PickerType) -> ListRow <PickerViewCell> {
        ListRow(
            model: PickerViewCell.ViewModel(title: type.title,
                                            pickerData: type.vectorData,
                                            onTap:  {
                                                pickers in
                                                self.manager.addPickerTypeToDict(type: type, data: pickers)
                                            }),
            height: UITableView.automaticDimension)
    }
    
    private func buttonRow( ) -> ListRow <RoundButtonTableCell> {
        ListRow(
            model: .init(title: "გაფილტვრა", onTap: { _ in
                print("")
            }),
            height: UITableView.automaticDimension)
    }
    
    private func clickableLabel(with model: TiTleButtonTableCell.ViewModel) -> ListRow<TiTleButtonTableCell> {
        ListRow(model: model,
                height: UITableView.automaticDimension)
    }
    
    private func statementRow(statement: Statement) -> ListRow <TitleAndDescriptionCardTableCell>{
        return ListRow(
            model: TitleAndDescriptionCardTableCell
                .Model(headerModel:
                        HeaderWithDetailsCell.Model(
                            icon: .withURL(url: URL(string: statement.imageUrl ?? "")),
                            title: "განცხადება: " + statement.statementTitle,
                            info1: "სისხლის ჯგუფი: " + (statement.bloodType?.rawValue ?? "უცნობია"),
                            info2: "სქესი: " + (statement.gender?.rawValue ?? "უცნობია"),
                            info3: "ნათესაობის ტიპი: " + (statement.relationType?.rawValue ?? "უცნობია"),
                            info4: "ქალაქი: " + (statement.city ?? "უცნობია"),
                            description: nil),
                       cardModel: .init(title: "",
                                        description: statement.statementDescription)),
            
            height: UITableView.automaticDimension,
            tapClosure: {row,_ in
                self.router.move2UserDetails(guestUserID: self.statements[row].userID)
                print(self.statements[row].userID)
            })
    }
}
