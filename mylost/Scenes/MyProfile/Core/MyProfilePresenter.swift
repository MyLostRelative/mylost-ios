//
//  MyProfilePresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 01.09.21.
//

import UIKit
import Core
import Components

protocol MyProfilePresenterDelegate: AnyObject {
    func MyProfilePresenterUpdate(_ presenter: PostCreatePresenterImpl)
}

protocol MyProfilePresenter {
    func viewDidLoad()
    func attach(view: MyProfileView)
}

class MyProfilePresenterImpl: MyProfilePresenter {
    
    private weak var view: MyProfileView?
    private var tableViewDataSource: ListViewDataSource?
    private let router: MyProfileRouter
    private let userID: Int
    private let bearerToken: String
    private let userInfoGateway: UserInfoGateway
    private let userInfoBearerGateway: UserInfoBearerGateway
    
    private let statementGateway: StatementGateway
    private var isLoading: Bool = true
    private var statementLoading: Bool = false
    private var fetchFailed: Bool = false {
        didSet {
            self.constructDataSource()
        }
    }
    private var statements: [Statement] = []
    private var userInfo: UserInfo?
    
    
    init(router: MyProfileRouter,
         userID: Int,
         bearerToken: String,
         userInfoGateway: UserInfoGateway,
         userInfoBearerGateway: UserInfoBearerGateway,
         statementGateway: StatementGateway) {
        self.router = router
        self.userID = userID
        self.bearerToken = bearerToken
        self.userInfoGateway = userInfoGateway
        self.userInfoBearerGateway = userInfoBearerGateway
        self.statementGateway = statementGateway
    }
    
    func attach(view: MyProfileView) {
        self.view = view
    }
    
    func viewDidLoad() {
        getUserInfo()
        configureDataSource()
        constructDataSource()
    }
    
    private func configureDataSource() {
        self.view.unwrap { v in
            tableViewDataSource = ListViewDataSource.init(
                tableView: v.tableView,
                withClasses: [
                    LoginTextFieldTableCell.self,
                    PageDescriptionTableCell.self,
                    TiTleButtonTableCell.self,
                    RoundedButtonTableCell.self,
                    SavedUserTableCell.self,
                    RoundedTextFieldTableCell.self,
                    CardAnimationTableCell.self,
                    TitleAndDescriptionCardTableCell.self
                ])
        }
    }
    
    private func constructDataSource() {
        let stateDependent = self.isLoading ?  [self.cardAnimation()] :
            (self.statementLoading ? self.statementAnimationState() : self.statementLoadedState() )
        DispatchQueue.main.async {
            self.tableViewDataSource?.reload(
                with: stateDependent
            )
        }
    }
}

// MARK: Service
extension MyProfilePresenterImpl {
    private func getUserInfo() {
        userInfoBearerGateway.getUser(bearerToken: self.bearerToken){ [weak self] response in
            self?.isLoading = false
            switch response {
            case .success(let resp):
                DispatchQueue.main.async {
                    self?.userInfo = resp.getUserInfo()
                    self?.statementLoading = true
                    self?.fetchStatements()
                    self?.constructDataSource()
                }
                
            case .failure(_):
                self?.fetchFailed = true
            }
        }
    }
    
    private func fetchStatements() {
        statementGateway.getStatementListByUser(userID: userInfo?.id ?? self.userID) { [weak self] response  in
                self?.statementLoading = false
                switch response {
                case .success(let resp):
                    DispatchQueue.main.async {
                        self?.statements = resp
                        self?.constructDataSource()
                    }
                    
                case .failure(_):
                    self?.view?.displayBanner(type: .negative,
                                              title: "მოხდა შეცდომა",
                                              description: "თქვენი განცხადება ვერ ჩაიტვირთა")
                }
            }
        }
}

// MARK: Section
extension MyProfilePresenterImpl {
    private func cardsSection() -> ListSection{
        return ListSection.init(
            id: "",
            rows: [self.userCardRow(), 
                   self.clickableLabel(with: .init(title: "პოსტის შექმნა",
                                                   colorStyle: .positive,
                                                   onTap: { _ in
                                                    self.router.move2CreatePost(userID: self.userInfo?.id ??  self.userID,
                                                                                myProfileDelegate: self)
                                                   }))] )
    }
    
    private func statementAnimationState() -> [ListSection] {
        [cardsSection(), cardAnimation()]
    }
    
    private func statementLoadedState() -> [ListSection] {
        [cardsSection(), statementSection()]
    }
    
    private func statementSection() -> ListSection {
        let statementRows = statements.map({statementRow(statement: $0)})
        return ListSection(id: "",
                    rows: statementRows)
        
    }
    
    private func cardAnimation() -> ListSection {
        ListSection(id: "", rows: [cardAnimationRow(), cardAnimationRow()])
    }

    private func errorStatementsSection() -> ListSection {
        ListSection(
            id: "",
            rows:  [errorPageDescriptionRow()])
    }
}

// MARK: ROWS
extension MyProfilePresenterImpl {
    private func userCardRow() -> ListRow <SavedUserTableCell> {
        guard let firstName = userInfo?.firstName,
              let lastName = userInfo?.lastName,
              let username = userInfo?.username else {
            return ListRow(model: .init(avatar: Resourcebook.Image.Icons24.generalUserRetailFill.template,
                                        username: "",
                                        age: "",
                                        buttonTitle: "პროფილი", onTap: nil) ,
                   height: UITableView.automaticDimension)
        }
        return ListRow(model: .init(avatar: Resourcebook.Image.Icons24.generalUserRetailFill.template,
                             username: firstName + " " + lastName,
                             age: username,
                             buttonTitle: "პროფილი") { _ in
            guard let userInfo = self.userInfo else { return }
            self.router.move2ProfileDetails(userInfo: userInfo)
            
        },
        height: UITableView.automaticDimension)
    }
    
    private func textField(with model: LoginTextFieldTableCell.Model) -> ListRow <LoginTextFieldTableCell> {
        ListRow(model: model, height: UITableView.automaticDimension)
    }
    
    private func button(with model: RoundedButtonTableCell.ViewModel) -> ListRow<RoundedButtonTableCell> {
        ListRow(model: model,
                height: UITableView.automaticDimension)
    }
    
    private func clickableLabel(with model: TiTleButtonTableCell.ViewModel) -> ListRow<TiTleButtonTableCell> {
        ListRow(model: model,
                height: UITableView.automaticDimension)
    }
    
    private func cardAnimationRow() -> ListRow <CardAnimationTableCell> {
        ListRow(
            model: "",
            height: UITableView.automaticDimension)
    }
    
    private func errorPageDescriptionRow() -> ListRow <PageDescriptionWithButtonTableCell> {
        ListRow(
            model: MyLostHomePresenterImpl.ModelBuilder().getErrorPgaeDescription(tap: { (_) in
                self.isLoading = true
                self.fetchFailed = false
            }),
            height: UITableView.automaticDimension)
    }
    
    private func statementRow(statement: Statement) -> ListRow <TitleAndDescriptionCardTableCell> {
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
                            description: nil,
                        rightIcon: nil),
                       cardModel: .init(title: "",
                                        description: statement.statementDescription)),
            
            height: UITableView.automaticDimension,
            tapClosure: {_,_,_  in
                print("dw")
            })
    }
}

extension MyProfilePresenterImpl: MyProfilePresenterDelegate {
    func MyProfilePresenterUpdate(_ presenter: PostCreatePresenterImpl) {
        self.statementLoading = true
        self.fetchStatements()
    }
    
}
