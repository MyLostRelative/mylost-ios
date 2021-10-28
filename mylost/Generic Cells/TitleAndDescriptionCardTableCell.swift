//
//  TitleAndDescriptionCardTableCell.swift.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/22/21.
//

import UIKit

public class TitleAndDescriptionCardTableCell: ListRowCell {
    public typealias Model = ViewModel
    
    private let stack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let header: HeaderWithDetails = {
        let r = HeaderWithDetails()
        r.translatesAutoresizingMaskIntoConstraints = false
        return r
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Resourcebook.Color.Invert.Background.canvas.uiColor
        view.height(equalTo: 1)
        return view
    }()
    
    private let cardBottom: RoundedTitleAndDescription = {
        let r = RoundedTitleAndDescription()
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
        header.configure(with: model.headerModel)
        cardBottom.configure(with: model.cardModel)
    }
    
    public func getIcon() -> UIImageView {
        header.getIcon()
    }
    
    private func styleUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    private func setUpConstraints() {
        setUpStack()
        setUpStackSubviews()
    }
    
    private func setUpStack() {
        self.contentView.addSubview(stack)
        stack.stretchLayout(with: 8, to: self.contentView)
    }
    
    private func setUpStackSubviews() {
        self.stack.addArrangedSubview(header)
        self.stack.addArrangedSubview(separatorLine)
        self.stack.addArrangedSubview(cardBottom)
    }
    
}

extension TitleAndDescriptionCardTableCell {
    public struct ViewModel {
        let headerModel: HeaderWithDetails.ViewModel
        let cardModel: RoundedTitleAndDescription.ViewModel
        
    }
}

extension TitleAndDescriptionCardTableCell: ConfigurableTableCell {
    public func configure(with model: TableCellModel) {
        if let model = model as? CellModel {
            header.configure(with: model.headerModel)
            cardBottom.configure(with: model.cardModel)
        }
    }
}

extension TitleAndDescriptionCardTableCell {
    struct CellModel: TableCellModel {
        var nibIdentifier: String = "TitleAndDescriptionCardTableCell"
        var height: Double = Double(UITableView.automaticDimension)
        let headerModel: HeaderWithDetails.ViewModel
        let cardModel: RoundedTitleAndDescription.ViewModel
        
        public init(headerModel: HeaderWithDetails.ViewModel,
                    cardModel: RoundedTitleAndDescription.ViewModel) {
            self.headerModel = headerModel
            self.cardModel = cardModel
        }
    }
}
