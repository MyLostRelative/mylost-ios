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
    
    func attach(view: SignInView) {
        self.view = view
    }
    
    func viewDidLoad() {
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
        ListRow(model: PageDescriptionTableCell.Model(imageType: (image: Resourcebook.Image.Icons24.channelPaybox.template,
                                                                  tint: Resourcebook.Color.Positive.solid300.uiColor),
                                                      title: "My Lost",
                                                      description: "გაიარეთ რეგისტრაცია ან დალოგინდით"),
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
        let usernameModel = modelConfigurator.getTextFieldModel(with: .usernameTextField(ontap: { _ in
            print("username")
        }))
        let passwordModel = modelConfigurator.getTextFieldModel(with: .passwordTextField(ontap: { _ in
            print("password")
        }))
        
        let loginButton = modelConfigurator.getButtoModel(with: .login(onTap: { _ in
            print("დალოგინება")
        }))
        
        let loginClickableLabelModel = modelConfigurator.getClickableLabelModel(with: .login(onTap: { _ in
            self.pageType = .registration
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
        let usernameModel = modelConfigurator.getTextFieldModel(with: .usernameTextField(ontap: { _ in
            print("username")
        }))
        let passwordModel = modelConfigurator.getTextFieldModel(with: .passwordTextField(ontap: { _ in
            print("password")
        }))
        
        let age = modelConfigurator.getTextFieldModel(with: .ageTextField(ontap: { _ in
            print("password")
        }))
        
        let email = modelConfigurator.getTextFieldModel(with: .mailTextField(ontap: { _ in
            print("password")
        }))
        
        let registrationButton = modelConfigurator.getButtoModel(with: .registration(onTap: { _ in
            print("click registration")
        }))
        
        let registrationClickableLabelModel = modelConfigurator.getClickableLabelModel(with: .registration(onTap: { _ in
            self.pageType = .signIn
            self.constructDataSource()
        }))
        
        return ListSection.init(
            id: "",
            rows: [
                self.textField(with: usernameModel),
                self.textField(with: passwordModel),
                self.textField(with: age),
                self.textField(with: email),
                self.button(with: registrationButton),
                self.clickableLabel(with: registrationClickableLabelModel)] )
    }
}
