//  
//  RegistrationPresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 22.10.21.
//

import Foundation
import Core
import Components

protocol RegistrationPresenter {
    func viewDidLoad()
    func attach(view: RegistrationView)
}

class RegistrationPresenterImpl: RegistrationPresenter {
    
    private var view: RegistrationView?
    private var router: RegistrationRouter
    private var modelsFactory: RegistrationModelsFactory
    private var tableViewDataSource: ListViewDataSource?
    private let registrationGateway: RegistrationGateway
    private let userDefaultManager: UserDefaultManager
    
    var params = ["username": "",
                  "password": "",
                  "firstName": "",
                  "lastName": "",
                  "email": "",
                  "mobileNumber": ""]
    init(router: RegistrationRouter,
         modelsFactory: RegistrationModelsFactory,
         registrationGateway: RegistrationGateway,
         userDefaultManager: UserDefaultManager) {
        self.router = router
        self.modelsFactory = modelsFactory
        self.registrationGateway = registrationGateway
        self.userDefaultManager = userDefaultManager
    }
    
    func attach(view: RegistrationView ) {
        self.view = view
    }
    
    func viewDidLoad() {
        configureDataSource()
        constructDataSource()
    }
    
}

extension RegistrationPresenterImpl {
    private func configureDataSource() {
        self.view.unwrap { v in
            tableViewDataSource = ListViewDataSource.init(
                tableView: v.tableView,
                withClasses: [
                    MaterialInputFieldTableCell.self,
                    RoundedButtonTableCell.self
                ])
        }
    }
    
    private func constructDataSource() {
        self.tableViewDataSource?.reload(
            with: [modelsFactory.getRoundedTextSection(delegate: self),
                   modelsFactory.getRoundedButtonSection(onTap: { [weak self] _ in
                       self?.registrationTap()
                   })]
        )
    }
    
    private func registrationTap() {
        if !(params["username"]?.isEmpty ?? true) &&
            !(params["password"]?.isEmpty ?? true) &&
            !(params["email"]?.isEmpty ?? true) &&
            !(params["firstName"]?.isEmpty ?? true) &&
            !(params["lastName"]?.isEmpty ?? true) &&
            !(params["mobileNumber"]?.isEmpty ?? true) {
            callRegister(params: params)
        } else {
            self.view?.displayBanner(type: .negative,
                                     title: "დაფიქსირდა შეცდომა",
                                     description: "გთხოვთ შეავსოთ ყველა საჭირო ველი")
        }
        print(params)
    }
}
// MARK: - Service Call
extension RegistrationPresenterImpl {
    private func callRegister(params: [String: Any]) {
        self.view?.startLoading()
        registrationGateway.postRegistration(params: params) {[weak self] result in
            
            switch result {
            case .success(let response):
                self?.view?.stopLoading()
                guard let token = response.access_token else { return }
                self?.tokenSuccesfullyFetched(token: token)
                
            case .failure(let error):
                self?.view?.stopLoading()
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
}

// MARK: - Delegate
extension RegistrationPresenterImpl: MaterialInputFieldTableCellDelegate {
    func MaterialInputFieldTableCellDelegate(_ cell: MaterialInputFieldTableCell,
                                             changeText: String,
                                             with inputType: MaterialInputFieldTableCell.InputType) {
        switch inputType {
        case .username:
            params["username"] = changeText
        case .password:
            params["password"] = changeText
        case .mail:
            params["email"] = changeText
        case .name:
            params["firstName"] = changeText
        case .surname:
            params["lastName"] = changeText
        case .mobileNumber:
            params["mobileNumber"] = changeText
        }
    }
}
