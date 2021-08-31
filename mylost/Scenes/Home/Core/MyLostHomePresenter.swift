//  
//  MyLostHomePresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import UIKit

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
                    PickerViewCell.self
                ],
                reusableViews: [
                ])
        }
    }
    
    private func constructDataSource() {
        let stateDependent =  self.isLoading ? animationState() :
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
        [textFieldSections()]
    }
    
    private func emptyState() -> [ListSection]{
        [emptyStatementsSection(), cardSections()]
    }
    
    private func errorState() -> [ListSection]{
        [errorStatementsSection()]
    }
}

//MARK: Sections
extension MyLostHomePresenterImpl {
    private func cardSections() -> ListSection {
        let roundCardModels = self.statements.map({ modelBuilder.getCardModel(with: $0)})
        let roundCardRows = roundCardModels.map({self.roundCard(model: $0)})
        return ListSection(
            id: "",
            rows: roundCardRows)
    }
    
    private func textFieldSections() -> ListSection {
        ListSection(
            id: "",
            rows:  [pickerRow(), pickerRowCity(), pickerRowAge()])
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
    private func textfield() -> ListRow <RoundedTextFieldTableCell>{
        ListRow(model: modelBuilder.getPostModel(tap: { (_) in
            print("Post this")
        }),
                height: UITableView.automaticDimension,
                tapClosure: {_,_ in
            self.router.move2UserDetails()
        })
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
    
    private func pickerRow() -> ListRow <PickerViewCell>{
        ListRow(
            model: PickerViewCell.ViewModel(title: "სქესი", pickerData: [["მდედრობითი", "მამრობითი"]]),
            height: UITableView.automaticDimension)
    }
    
    private func pickerRowCity() -> ListRow <PickerViewCell>{
        ListRow(
            model: PickerViewCell.ViewModel(title: "ქალაქი", pickerData: [["თბილისი", "ბათუმი", "ქუთაისი"]]),
            height: UITableView.automaticDimension)
    }
    
    private func pickerRowAge() -> ListRow <PickerViewCell>{
        ListRow(
            model: PickerViewCell.ViewModel(title: "ასაკი", pickerData: [["20 - დან", "21 - დან", "22 -დან"],
                                                                                   ["20 - მდე", "21 - მდე", "22 -მდე"]]),
            height: UITableView.automaticDimension)
    }
}
