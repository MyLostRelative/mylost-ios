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
    private let registrationGateway: RegistrationGateway
    private let userDefaultManager = UserDefaultManager()
    
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


//MARK: Registration Section
extension SignInPresenterImpl {
    private func registrationCaseSections() -> ListSection{
        var nameField: LoginTextFieldTableCell?
        var surnameField: LoginTextFieldTableCell?
        var emailField: LoginTextFieldTableCell?
        var mobileField: LoginTextFieldTableCell?
        var usernameField: LoginTextFieldTableCell?
        var passwordField: LoginTextFieldTableCell?
        
        let nameModel = modelConfigurator.getTextFieldModel(with: .name(ontap: { field in
            field.emptyTextField()
            nameField = field
        }))
        let surnameModel = modelConfigurator.getTextFieldModel(with: .surname(ontap: { field in
            field.emptyTextField()
            surnameField = field
        }))
        
        let email = modelConfigurator.getTextFieldModel(with: .mailTextField(ontap: { field in
            field.emptyTextField()
            emailField = field
        }))
        
        let mobile = modelConfigurator.getTextFieldModel(with: .mobileTextField(ontap: { field in
            field.emptyTextField()
            mobileField = field
        }))
        
        let usernameModel = modelConfigurator.getTextFieldModel(with: .usernameTextField(ontap: { field in
            field.emptyTextField()
            usernameField = field
        }))
        let passwordModel = modelConfigurator.getTextFieldModel(with: .passwordTextField(ontap: { field in
            field.emptyTextField()
            passwordField = field
        }))
        
        let registrationButton = modelConfigurator.getButtoModel(with: .registration(onTap: { _ in
            self.registrationClicked(username: usernameField?.getText() ,
                                    password: passwordField?.getText() ,
                                    firstName: nameField?.getText(),
                                    lastName: surnameField?.getText(),
                                    email:emailField?.getText(),
                                    mobile: mobileField?.getText())
        }))
        let textFieldModels: [ListSection.Row] = [textField(with: nameModel) ,
                                                  textField(with: surnameModel),
                                                  textField(with: email),
                                                  textField(with: mobile),
                                                  textField(with: usernameModel),
                                                  textField(with: passwordModel)]
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
    
    private func registrationClicked(username: String? ,
                                     password: String? ,
                                     firstName: String? ,
                                     lastName: String? ,
                                     email: String? ,
                                     mobile: String?) {
        if let usernamew = username,
           let passwordw = password,
           let firstNamew = firstName,
           let lastNamew = lastName,
           let emailw = email,
           let mobilew = mobile {
            let params = ["username": usernamew,
                                        "password": passwordw,
                                        "firstName": firstNamew,
                                        "lastName": lastNamew,
                                        "email": emailw,
                                        "mobileNumber": mobilew]
            callRegister(params: params)
        }else {
            self.view?.displayBanner(type: .negative,
                                     title: "დაფიქსირდა შეცდომა",
                                     description: "გთხოვთ შეავსოთ ყველა საჭირო ველი")
        }
    }
}
