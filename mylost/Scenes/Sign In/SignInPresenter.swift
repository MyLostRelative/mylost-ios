//
//  SignInPresenter.swift
//  SignInPresenter
//
//  Created by Nato Egnatashvili on 30.08.21.
//

import UIKit
import Core
import Components

protocol SignInPresenter {
    func viewDidLoad()
    func attach(view: SignInView)
}

class SignInPresenterImpl: SignInPresenter {
    enum PageType {
        case signIn
        case registration
    }
    
    private weak var view: SignInView?
    private var tableViewDataSource: ListViewDataSource?
    private let modelConfigurator: SignInModelConfigurator = SignInModelConfiguratorImpl()
    private let router: SignInRouter
    private let loginGateway: LoginGateway
    private let registrationGateway: RegistrationGateway
    private let userDefaultManager = UserDefaultManagerImpl()
    
    init(router: SignInRouter,
         loginGateway: LoginGateway,
         registrationGateway: RegistrationGateway) {
        self.router = router
        self.loginGateway = loginGateway
        self.registrationGateway = registrationGateway
    }
    
    func attach(view: SignInView) {
        self.view = view
    }
    
    func viewDidLoad() {
        configureDataSource()
        constructDataSource()
    }
    
    private func callLogin(params: [String: Any]) {
        self.view?.startLoading()
        loginGateway.postLogin(params: params) {[weak self] result in
            switch result {
            case .success(let response):
                guard let token = response.access_token else { return }
                self?.tokenSuccesfullyFetched(token: token)
                
            case .failure(let error):
                self?.view?.stopLoading()
                if let error = error as? LocalError {
                    self?.view?.displayBanner(type: .negative,
                                              title: "მოხდა შეცდომა",
                                              description: error.desc)
                } else {
                    self?.view?.displayBanner(type: .negative,
                                              title: "მოხდა შეცდომა",
                                              description: "სცადეთ მოგვიანებით")
                }
                
            }
        }
    }
    
    private func callRegister(params: [String: Any]) {
        registrationGateway.postRegistration(params: params) {[weak self] result in
            switch result {
            case .success(let response):
                guard let token = response.access_token else { return }
                self?.tokenSuccesfullyFetched(token: token)
                
            case .failure(let error):
                self?.view?.displayBanner(type: .negative,
                                          title: "მოხდა შეცდომა",
                                          description: "დაფიქსირდა შეცდომა , სცადეთ მოგვიანებით.")
                print(error)
            }
        }
    }
    
    private func tokenSuccesfullyFetched(token: String) {
        DispatchQueue.main.async {
            self.userDefaultManager.saveKeyName(key: "token", value: token)
            self.view?.stopLoading()
            self.router.changeToUser()
        }
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
                    ShadowCardTableCell.self
                ])
        }
    }
    
    private func constructDataSource() {
            DispatchQueue.main.async {
                self.tableViewDataSource?.reload(
                    with: [self.signInCaseSections()]
                )
            }
    }
    
    private func pageDescriptionRow() -> ListRow <PageDescriptionTableCell> {
        ListRow(model: PageDescriptionTableCell.Model(imageType: (image: Resourcebook.Image.Icons24.systemSearch.template,
                                                                  tint: Resourcebook.Color.Positive.solid300.uiColor),
                                                      title: "My Lost",
                                                      description: "გაიარეთ რეგისტრაცია ან დალოგინდით"),
                height: UITableView.automaticDimension)
    }
    
    private func textField(with model: LoginTextFieldTableCell.Model) -> ListRow <LoginTextFieldTableCell> {
        ListRow(model: model, height: UITableView.automaticDimension)
    }
    
    private func shadowCardRow() -> ListRow<ShadowCardTableCell> {
        ListRow(model: .init(image: Resourcebook.Image.Icons24.systemInfoFill.image,
                             title: "ვიზიტის დაჯავშნა",
                             description: "ფიზიკურ პირთან კონსულტაცია"),
                height: UITableView.automaticDimension)
    }
    
    private func button(with model: RoundedButtonTableCell.ViewModel) -> ListRow<RoundedButtonTableCell> {
        ListRow(model: model,
                height: UITableView.automaticDimension)
    }
    
    private func clickableLabel(with model: TiTleButtonTableCell.ViewModel) -> ListRow<TiTleButtonTableCell> {
        ListRow(model: model,
    height: UITableView.automaticDimension)
    }
}

// MARK: Sign Up Section
extension SignInPresenterImpl {
    private func signInCaseSections() -> ListSection {
        var nameField: LoginTextFieldTableCell?
        var passwordField: LoginTextFieldTableCell?
        let usernameModel = modelConfigurator.getTextFieldModel(with: .usernameTextField(ontap: { newNameField in
            nameField = newNameField
        }))
        let passwordModel = modelConfigurator.getTextFieldModel(with: .passwordTextField(ontap: { newpasswordField in
            passwordField = newpasswordField
        }))
        
        let loginButton = modelConfigurator.getButtoModel(with: .login(onTap: { _ in
            self.callLogin(params: ["username": nameField?.getText() ?? "",
                                    "password": passwordField?.getText() ?? ""])
        }))
        
        let loginClickableLabelModel = modelConfigurator.getClickableLabelModel(with: .login(onTap: { _ in
            self.router.move2Registration()
        }))
        return ListSection.init(
            id: "",
            rows: [
                self.shadowCardRow(),
                self.pageDescriptionRow(),
                self.textField(with: usernameModel),
                self.textField(with: passwordModel),
                self.button(with: loginButton),
                self.clickableLabel(with: loginClickableLabelModel)] )
    }
}
