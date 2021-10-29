//
//  PageDescriptionWithButtonTableCell.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/27/21.
//

import UIKit

public class PageDescriptionWithButtonTableCell: ListRowCell {
    public typealias Model = ViewModel
    
    private let stack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pageDescription: PageDescription = {
        let r = PageDescription()
        r.translatesAutoresizingMaskIntoConstraints = false
        return r
    }()
    
    private var button: ButtonWithLine = {
        let btn = ButtonWithLine()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
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
        pageDescription.configure(with: model.pageDescriptionModel)
        button.configure(with: model.buttonModel)
    }
    
    private func styleUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        stack.backgroundColor = .white
        stack.roundCorners(with: .constant(radius: 10))
    }
    
    private func setUpConstraints() {
        self.contentView.addSubview(stack)
        stack.stretchLayout(with: 8, to: self.contentView)
        
        stack.addArrangedSubview(pageDescription)
        stack.addArrangedSubview(button)
    }
}

extension PageDescriptionWithButtonTableCell{
    public struct ViewModel {
        public init(pageDescriptionModel: PageDescription.ViewModel, buttonModel: ButtonWithLine.ViewModel) {
            self.pageDescriptionModel = pageDescriptionModel
            self.buttonModel = buttonModel
        }
        
        let pageDescriptionModel: PageDescription.ViewModel
        let buttonModel: ButtonWithLine.ViewModel
    }
}
