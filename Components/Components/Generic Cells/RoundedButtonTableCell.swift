//
//  RoundedButtonTableCell.swift
//  RoundedButtonTableCell
//
//  Created by Nato Egnatashvili on 30.08.21.
//

import UIKit

public class RoundedButtonTableCell: ListRowCell {
    public typealias Model = RoundedButtonTableCell.ViewModel
    
    private let roundedButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.height(equalTo: 35)
        b.roundCorners(with: .constant(radius: 15))
        b.backgroundColor = Resourcebook.Color.Information.solid100.uiColor
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
        onTap = model.onTap
        roundedButton.setTitle(model.title, for: .normal)
        roundedButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    private func styleUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    private func setUpConstraints() {
        self.contentView.addSubview(roundedButton)
        roundedButton.top(toView: self.contentView, constant: 6)
        roundedButton.bottom(toView: self.contentView, constant: 6)
        roundedButton.right(toView: self.contentView, constant: 36)
        roundedButton.left(toView: self.contentView, constant: 36)
    }
    
    @objc private func didTap() {
        self.onTap?(self)
    }
}
    
extension RoundedButtonTableCell {
    public struct ViewModel {
        public init(title: String?, onTap: ((RoundedButtonTableCell) -> ())?) {
            self.title = title
            self.onTap = onTap
        }
        
        let title: String?
        let onTap: ((RoundedButtonTableCell) -> ())?
    }
}
