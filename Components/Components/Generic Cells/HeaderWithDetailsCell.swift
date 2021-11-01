//
//  HeaderWithDetailsCell.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/22/21.
//

import UIKit

public class HeaderWithDetailsCell: ListRowCell {
    public typealias Model = HeaderWithDetails.ViewModel
    
    private let roundedTextField: HeaderWithDetails = {
        let r = HeaderWithDetails()
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
        roundedTextField.stretchLayout(with: 8, to: self.contentView)
    }
}
