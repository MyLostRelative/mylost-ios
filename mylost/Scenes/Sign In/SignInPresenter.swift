//
//  SignInPresenter.swift
//  SignInPresenter
//
//  Created by Nato Egnatashvili on 30.08.21.
//

import UIKit

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
    private var pageType: PageType = .signIn
    private let router: SignInRouter
    private let loginGateway: LoginGateway
    private let userDefaultManager = UserDefaultManager()
    
    init(router: SignInRouter, loginGateway: LoginGateway) {
        self.router = router
        self.loginGateway = loginGateway
    }
    
    func attach(view: SignInView) {
        self.view = view
    }
    
    func viewDidLoad() {
        configureDataSource()
        constructDataSource()
    }
    
    private func callLogin(params: [String: Any]) {
        loginGateway.postLogin(params: params) {[weak self] result in
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
                    RoundedButtonTableCell.self
                ])
        }
    }
    
    private func constructDataSource() {
        switch pageType {
        case .signIn:
            DispatchQueue.main.async {
                self.tableViewDataSource?.reload(
                    with: [self.signInCaseSections()]
                )
            }
        case .registration:
            DispatchQueue.main.async {
                self.tableViewDataSource?.reload(
                    with: [self.registrationCaseSections()]
                )
            }
        }
    }
    
    private func pageDescriptionRow() -> ListRow <PageDescriptionTableCell>  {
        ListRow(model: PageDescriptionTableCell.Model(imageType: (image: Resourcebook.Image.Icons24.systemSearch.template,
                                                                  tint: Resourcebook.Color.Positive.solid300.uiColor),
                                                      title: "My Lost",
                                                      description: "გაიარეთ რეგისტრაცია ან დალოგინდით"),
                height: UITableView.automaticDimension)
    }
    
    private func pageDescriptionRowRegistration() -> ListRow <PageDescriptionTableCell>  {
        ListRow(model: PageDescriptionTableCell.Model(imageType: (image: Resourcebook.Image.Icons24.generalLoginHistory.template,
                                                                  tint: Resourcebook.Color.Positive.solid300.uiColor),
                                                      title: "Registration",
                                                      description: nil),
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
}

//MARK: Sign Up Section
extension SignInPresenterImpl {
    private func signInCaseSections() -> ListSection{
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
            self.pageType = .registration
            nameField = nil
            passwordField = nil
            self.constructDataSource()
        }))
        return ListSection.init(
            id: "",
            rows: [
                self.pageDescriptionRow(),
                self.textField(with: usernameModel),
                self.textField(with: passwordModel),
                self.button(with: loginButton),
                self.clickableLabel(with: loginClickableLabelModel)] )
    }
}

//MARK: TextField Models
extension SignInPresenterImpl{
    private func getRegistrationModels() -> [LoginTextFieldTableCell.Model] {
        let nameModel = modelConfigurator.getTextFieldModel(with: .name(ontap: { field in
            field.emptyTextField()
        }))
        let surnameModel = modelConfigurator.getTextFieldModel(with: .surname(ontap: { field in
            field.emptyTextField()
        }))
        
        let mobileModel = modelConfigurator.getTextFieldModel(with: .mobileTextField(ontap: { field in
            field.emptyTextField()
        }))
        
        let email = modelConfigurator.getTextFieldModel(with: .mailTextField(ontap: { field in
            field.emptyTextField()
        }))
        
        let age = modelConfigurator.getTextFieldModel(with: .ageTextField(ontap: { field in
            field.emptyTextField()
        }))
        
        let usernameModel = modelConfigurator.getTextFieldModel(with: .usernameTextField(ontap: { field in
            field.emptyTextField()
        }))
        let passwordModel = modelConfigurator.getTextFieldModel(with: .passwordTextField(ontap: { field in
            field.emptyTextField()
        }))
        return [nameModel, surnameModel, mobileModel, email, age, usernameModel, passwordModel]
    }
    
}

//MARK: Registration Section
extension SignInPresenterImpl {
    private func registrationCaseSections() -> ListSection{
        let registrationButton = modelConfigurator.getButtoModel(with: .registration(onTap: { _ in
            print("click registration")
        }))
        let textFieldModels: [ListSection.Row] = getRegistrationModels().map({textField(with: $0)})
        let registrationClickableLabelModel = modelConfigurator.getClickableLabelModel(with: .registration(onTap: { _ in
            self.pageType = .signIn
            self.constructDataSource()
        }))
        
        return ListSection.init(
            id: "",
            rows: [self.pageDescriptionRowRegistration()] + textFieldModels + [
                self.button(with: registrationButton),
                self.clickableLabel(with: registrationClickableLabelModel)] )
    }
}
