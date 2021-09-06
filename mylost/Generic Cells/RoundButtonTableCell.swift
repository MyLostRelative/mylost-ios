//
//  RoundButtonTableCell.swift
//  mylost
//
//  Created by Nato Egnatashvili on 06.09.21.
//

import UIKit

public class RoundButtonTableCell: ListRowCell {
    public typealias Model = RoundButtonTableCell.ViewModel
    
    private var onTap: ((RoundButtonTableCell) -> ())?
    private let button: UIButton = {
        let b = UIButton()
        b.height(equalTo: 40)
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
        button.backgroundColor = Resourcebook.Color.Positive.solid100.uiColor
        button.roundCorners(with: .constant(radius: 10))
        button.setTitle(model.title, for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        self.onTap = model.onTap
    }
    
    private func styleUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    private func setUpConstraints() {
        self.contentView.addSubview(button)
        button.stretchLayout(with: 16, to: self.contentView)
    }
    
    @objc func didTap() {
        self.onTap?(self)
    }
}

extension RoundButtonTableCell {
    public struct ViewModel {
        let title: String
        let onTap: ((RoundButtonTableCell) -> ())?
    }
}
