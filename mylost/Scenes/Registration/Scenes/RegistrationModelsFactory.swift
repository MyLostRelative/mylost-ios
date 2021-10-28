//
//  RegistrationModelsFactory.swift
//  mylost
//
//  Created by Nato Egnatashvili on 22.10.21.
//

import UIKit

protocol RegistrationModelsFactory {
    func getRoundedTextSection(delegate: MaterialInputFieldTableCellDelegate?) -> ListSection
    func getRoundedButtonSection(onTap: ((RoundedButtonTableCell) -> Void)?) -> ListSection
}

class RegistrationModelsFactoryImpl: RegistrationModelsFactory {
    
   func getRoundedTextSection(delegate: MaterialInputFieldTableCellDelegate?) -> ListSection {
        return ListSection(
            id: "",
            rows: [textFieldRow(inputType: .username,
                                delegate: delegate),
                   textFieldRow(inputType: .password,
                                       delegate: delegate),
                   textFieldRow(inputType: .name,
                                       delegate: delegate),
                   textFieldRow(inputType: .surname,
                                       delegate: delegate),
                   textFieldRow(inputType: .mail,
                                       delegate: delegate),
                   textFieldRow(inputType: .mobileNumber,
                                       delegate: delegate)] )
    }
    
    func getRoundedButtonSection(onTap: ((RoundedButtonTableCell) -> Void)?) -> ListSection {
         return ListSection(
             id: "Button",
             rows: [butttonRow(onTap: onTap)] )
     }
    
}

// MARK: - Rows
extension RegistrationModelsFactoryImpl {
    private func textFieldRow(
        inputType: MaterialInputFieldTableCell.InputType,
        delegate: MaterialInputFieldTableCellDelegate?) -> ListRow <MaterialInputFieldTableCell> {
            ListRow(model: .init(title: inputType.title,
                                 placeHolder: inputType.placeHolder,
                             inputType: inputType,
                             delegate: delegate),
                height: UITableView.automaticDimension)
    }
    
    private func butttonRow(onTap: ((RoundedButtonTableCell) -> Void)?) -> ListRow <RoundedButtonTableCell> {
        ListRow(model: .init(title: "რეგისტრაცია",
                             onTap: onTap),
                height: UITableView.automaticDimension)
    }
}
