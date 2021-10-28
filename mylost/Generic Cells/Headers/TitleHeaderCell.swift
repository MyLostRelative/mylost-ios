//
//  TitleHeaderCell.swift
//  mylost
//
//  Created by Nato Egnatashvili on 27.10.21.
//

import UIKit

public class TitleHeaderCell: ListHeaderFooter{
    public typealias Model = ViewModel
    lazy var label: UILabel = {
        let label = UILabel.init()
        label.font = Resourcebook.Font.headline3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        styleUI()
        addRowItemToContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func styleUI() {
        let backgroundView = UIView(frame: .zero)
        self.backgroundView = backgroundView
        self.contentView.backgroundColor = Resourcebook.Color.Invert.Background.canvas.uiColor
        self.backgroundColor = .clear
        self.label.roundCorners(with: .constant(radius: 40))
    }
    
    private func addRowItemToContentView() {
        contentView.addSubview(label)
        setUpRowItemConstraints()
    }
   
    private func setUpRowItemConstraints() {
        label.top(toView: contentView, constant: 5)
        label.bottom(toView: contentView, constant: 5)
        label.right(toView: contentView)
        label.left(toView: contentView, constant: 20)
    }
    
    public func configure(with model: Model) {
        label.text = model.title
    }
    
}

extension TitleHeaderCell {
    public struct ViewModel {
        let title: String
    }
}
