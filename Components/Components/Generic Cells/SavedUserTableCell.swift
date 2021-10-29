//
//  SavedUserTableCell\.swift
//  mylost
//
//  Created by Nato Egnatashvili on 02.09.21.
//

import UIKit

public class SavedUserTableCell: ListRowCell {
    public typealias Model = SavedUserCard.ViewModel
    
    private let savedUserCard: SavedUserCard = {
        let b = SavedUserCard()
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private var onTap: ((RoundedButtonTableCell) -> ())?
    
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
        savedUserCard.configure(with: model)
    }
    
    private func styleUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    private func setUpConstraints() {
        self.contentView.addSubview(savedUserCard)
        savedUserCard.top(toView: self.contentView, constant: 10)
        savedUserCard.bottom(toView: self.contentView, constant: 5)
        savedUserCard.left(toView: self.contentView, constant: 10)
    }
}

