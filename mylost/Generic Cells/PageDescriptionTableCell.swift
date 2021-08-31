//
//  PageDescriptionTableCell.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/27/21.
//

import UIKit

public class PageDescriptionTableCell: ListRowCell {
    public typealias Model = PageDescription.ViewModel
    
    private let pageDescription: PageDescription = {
        let r = PageDescription()
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
        pageDescription.configure(with: model)
    }
    
    private func styleUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        pageDescription.roundCorners(with: .constant(radius: 10))
    }
    
    private func setUpConstraints() {
        self.contentView.addSubview(pageDescription)
        pageDescription.stretchLayout(with: 8, to: self.contentView)
    }
}
