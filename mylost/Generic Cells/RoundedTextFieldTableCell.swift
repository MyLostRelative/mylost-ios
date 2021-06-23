//
//  RoundedTextFieldTableCell.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import UIKit

public class RoundedTextFieldTableCell: ListRowCell {
    public typealias Model = RoundedTextField.ViewModel
    
    private let roundedTextField: RoundedTextField = {
        let r = RoundedTextField()
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
    }
    
    private func styleUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    private func setUpConstraints() {
        self.contentView.addSubview(roundedTextField)
        roundedTextField.left(toView: self.contentView, constant: 16)
        roundedTextField.right(toView: self.contentView, constant: 16)
        roundedTextField.top(toView: self.contentView)
        roundedTextField.bottom(toView: self.contentView)
    }
}

