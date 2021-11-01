//
//  LoginTextFieldTableCell.swift
//  LoginTextFieldTableCell
//
//  Created by Nato Egnatashvili on 30.08.21.
//

import UIKit
public class LoginTextFieldTableCell: ListRowCell {
    public typealias Model = LogInTextField.ViewModel
    
    private let roundedTextField: LogInTextField = {
        let r = LogInTextField()
        r.translatesAutoresizingMaskIntoConstraints = false
        return r
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        styleUI()
        setUpConstraints()
    }

    public func configure(with model: Model) {
        roundedTextField.configure(with: model)
        model.onTap?(self)
    }
    
    public func getText()-> String? {
        roundedTextField.getTextFieldText()
    }
    
    public func emptyTextField() {
        roundedTextField.emptyTextField()
    }
    
    private func styleUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    private func setUpConstraints() {
        self.contentView.addSubview(roundedTextField)
        roundedTextField.top(toView: self.contentView)
        roundedTextField.bottom(toView: self.contentView)
        roundedTextField.right(toView: self.contentView, constant: 8)
        roundedTextField.left(toView: self.contentView, constant: 8)
    }
}
