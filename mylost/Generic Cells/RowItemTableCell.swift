//
//  RowItemTableCell.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import UIKit

public class RowItemTableCell: ListRowCell {
    public typealias Model = RowItem.ViewModel
    
    private let rowItem: RowItem = {
        let b = RowItem()
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
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
        rowItem.configure(with: model)
    }
    
    private func styleUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    private func setUpConstraints() {
        self.contentView.addSubview(rowItem)
        rowItem.stretchLayout(with: 4, to: self.contentView)
    }
}

