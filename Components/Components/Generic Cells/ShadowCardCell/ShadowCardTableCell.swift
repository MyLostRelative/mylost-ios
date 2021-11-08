//
//  ShadowCardTableCell.swift
//  Components
//
//  Created by Nato Egnatashvili on 08.11.21.
//

import UIKit

public class ShadowCardTableCell: ListRowCell {
    public typealias Model = ShadowCard.ViewModel
    
    private let shadowCard: ShadowCard = {
        let r = ShadowCard()
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
        shadowCard.configure(with: model)
    }
    
    private func styleUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    private func setUpConstraints() {
        self.contentView.addSubview(shadowCard)
        shadowCard.stretchLayout(with: 8, to: self.contentView)
    }
}

extension ShadowCardTableCell: ConfigurableTableCell {
    public func configure(with model: TableCellModel) {
        if let model = model as? CellModel {
            shadowCard.configure(with: model.shadowCardModel)
        }
    }
}

extension ShadowCardTableCell {
    struct CellModel: TableCellModel {
        var nibIdentifier: String = "ShadowCardTableCell"
        var height: Double = Double(UITableView.automaticDimension)
        var shadowCardModel: ShadowCard.ViewModel
        
        public init(shadowCardModel: ShadowCard.ViewModel) {
            self.shadowCardModel = shadowCardModel
        }
    }
}
