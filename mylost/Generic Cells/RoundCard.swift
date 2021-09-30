//
//  RoundCard.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/25/21.
//

import UIKit

public class RoundCard: ListRowCell {
    public typealias Model = RoundedTitleAndDescription.ViewModel
    
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
        setUp()
    }

    public func configure(with model: Model) {
        cardBottom.configure(with: model)
    }
    
    private func styleUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        cardBottom.roundCorners(with: .constant(radius: 10), with: .round)
    }

    private func setUp() {
        self.contentView.addSubview(cardBottom)
        cardBottom.stretchLayout(with: 16, to: self.contentView)
    }
}


extension RoundCard: ConfigurableTableCell {
    public func configure(with model: TableCellModel) {
        if let model = model as? CellModel {
            cardBottom.configure(with: model.roundModel)
        }
    }
    
    
}

extension RoundCard {
    struct CellModel: TableCellModel{
        var nibIdentifier: String = "RoundCard"
        var height: Double = Double(UITableView.automaticDimension)
        var roundModel: RoundedTitleAndDescription.ViewModel
        
        public init(roundModel: RoundedTitleAndDescription.ViewModel) {
            self.roundModel = roundModel
        }
    }
}
