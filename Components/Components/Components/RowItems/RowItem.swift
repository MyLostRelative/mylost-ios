//
//  RowItem.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import UIKit

public class RowItem: UIView {
    
    private var horizontalStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 4
        view.axis = .horizontal
        view.alignment = .fill
        
        return view
    }()
    
    private var icon: UIImageView = {
        let imgView = UIImageView()
        imgView.height(equalTo: 20)
        imgView.width(equalTo: 20)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = Resourcebook.Color.Information.solid300.uiColor
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = Resourcebook.Font.captionBig
        return lbl
    }()
    
    private var descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = Resourcebook.Font.captionBig
        lbl.numberOfLines = 0
        return lbl
    }()
    
    public init(with model: ViewModel? = nil ) {
        super.init(frame: .zero)
        styleUI()
        setUp()
        guard let model = model else { return }
        configure(with: model)
    }
    
    public func configure(with model: ViewModel) {
        if let title = model.title {
            titleLbl.text = title + ": "
        }
        descriptionLbl.text = model.description
        icon.image = model.icon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RowItem {
    private func styleUI() {
        self.backgroundColor = .white
    }
    
    private func setUp() {
        setUpVerticalStack()
        setUpTitleAndDescription()
    }
    
    private func setUpVerticalStack() {
        self.addSubview(horizontalStack)
        horizontalStack.stretchLayout(with: 8, to: self)
    }
    
    private func setUpTitleAndDescription() {
        self.horizontalStack.addArrangedSubview(icon)
        self.horizontalStack.addArrangedSubview(titleLbl)
        self.horizontalStack.addArrangedSubview(descriptionLbl)
    }
    
}
