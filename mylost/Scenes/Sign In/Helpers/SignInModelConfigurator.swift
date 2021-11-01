//
//  SignInModelConfigurator.swift
//  SignInModelConfigurator
//
//  Created by Nato Egnatashvili on 30.08.21.
//

import Foundation
import Components

protocol SignInModelConfigurator {
    func getTextFieldModel(with type: SignInModelConfiguratorImpl.SignInTextFieldModelType) -> LoginTextFieldTableCell.Model
    func getButtoModel(with type: SignInModelConfiguratorImpl.SignInButtonModelType) -> RoundedButtonTableCell.Model
    func getClickableLabelModel(with type: SignInModelConfiguratorImpl.SignInClickableTextModelType) -> TiTleButtonTableCell.Model
}

class SignInModelConfiguratorImpl:  SignInModelConfigurator{
    
    enum SignInTextFieldModelType {
        case name(ontap: ((LoginTextFieldTableCell) -> ())?)
        case surname(ontap: ((LoginTextFieldTableCell) -> ())?)
        case usernameTextField(ontap: ((LoginTextFieldTableCell) -> ())?)
        case passwordTextField(ontap: ((LoginTextFieldTableCell) -> ())?)
        case mailTextField(ontap: ((LoginTextFieldTableCell) -> ())?)
        case mobileTextField(ontap: ((LoginTextFieldTableCell) -> ())?)
        case ageTextField(ontap: ((LoginTextFieldTableCell) -> ())?)
    }
    
    enum SignInButtonModelType {
        case login(onTap: ((RoundedButtonTableCell) -> ())?)
        case registration(onTap: ((RoundedButtonTableCell) -> ())?)
    }
    
    enum SignInClickableTextModelType {
        case login(onTap: ((TiTleButtonTableCell) -> ())?)
        case registration(onTap: ((TiTleButtonTableCell) -> ())?)
    }
    
    func getTextFieldModel(with type: SignInTextFieldModelType) -> LoginTextFieldTableCell.Model{
        switch type {
        case .name(let ontap):
            return LoginTextFieldTableCell.Model.init(title: "სახელი",
                                               onTap: ontap)
        case .surname(let ontap):
            return LoginTextFieldTableCell.Model.init(title: "გვარი",
                                               onTap: ontap)
        case .usernameTextField(let ontap):
            return LoginTextFieldTableCell.Model.init(title: "Username",
                                               onTap: ontap)
        case .passwordTextField(let ontap):
            return LoginTextFieldTableCell.Model.init(title: "Password",
                                               textType: .secury,
                                               onTap: ontap)
        case .mailTextField(let ontap):
            return LoginTextFieldTableCell.Model.init(title: "მეილი",
                                               onTap: ontap)
        case .mobileTextField(let ontap):
            return LoginTextFieldTableCell.Model.init(title: "საკონტაქტო ნომერი",
                                               onTap: ontap)
        case .ageTextField(let ontap):
            return LoginTextFieldTableCell.Model.init(title: "ასაკი",
                                               onTap: ontap)
        }
    }
    
    func getButtoModel(with type: SignInButtonModelType) -> RoundedButtonTableCell.Model {
        switch type {
        case .login(let onTap):
            return RoundedButtonTableCell.Model(title: "Log In", onTap: onTap)
        case .registration(let onTap):
            return RoundedButtonTableCell.Model(title: "Registration", onTap: onTap)
        }
    }
    
    func getClickableLabelModel(with type: SignInClickableTextModelType) -> TiTleButtonTableCell.Model {
        switch type {
        case .login(let onTap):
            return TiTleButtonTableCell.Model(title: "გაიარე რეგისტრაცია", onTap: onTap)
        case .registration(let onTap):
            return TiTleButtonTableCell.Model(title: "შესვლაზე დაბრუნება", onTap: onTap)
        }
    }
}
