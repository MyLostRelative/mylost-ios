//
//  ShadowCard.swift
//  Components
//
//  Created by Nato Egnatashvili on 08.11.21.
//

import UIKit

public class ShadowCard: UIView {
    
    private var horizontalStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 10
        view.alignment = .leading
        return view
    }()
    
    private var verticalStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 4
        view.axis = .vertical
        view.alignment = .leading
        
        return view
    }()
    
    private var icon: UIImageView = {
        let img = UIImageView()
        img.height(equalTo: 40)
        img.width(equalTo: 40)
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Resourcebook.Color.Black.tr50.uiColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.width(equalTo: 1)
        view.height(equalTo: 41)
        return view
    }()
    
    private var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = Resourcebook.Font.captionBig
        return lbl
    }()
    
    private var descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = Resourcebook.Font.caption2
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
    
    public func configure(with model: ViewModel){
        titleLbl.text = model.title
        descriptionLbl.text = model.description
        icon.image = model.image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ShadowCard {
    private func styleUI() {
        self.backgroundColor = .white
        self.roundCorners(with: .constant(radius: 10))
        self.layer.shadowColor = Resourcebook.Color.Black.tr50.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        //self.layer.shadowRadius = 1
    }
    
    private func setUp() {
        setUpHorizontalStack()
        setUpTitleAndDescription()
        setUpIconAndTitles()
    }
    
    private func setUpHorizontalStack() {
        self.addSubview(horizontalStack)
        horizontalStack.stretchLayout(with: 8, to: self)
        
    }
    
    private func setUpIconAndTitles() {
        self.horizontalStack.addArrangedSubview(icon)
        self.horizontalStack.addArrangedSubview(separatorView)
        self.horizontalStack.addArrangedSubview(verticalStack)
    }
    
    private func setUpTitleAndDescription() {
        self.verticalStack.addArrangedSubview(titleLbl)
        self.verticalStack.addArrangedSubview(descriptionLbl)
    }
    
}
