//
//  PageDescription.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/27/21.
//

import UIKit

public class PageDescription: UIView {
    
    private var verticalStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 4
        view.axis = .vertical
        view.alignment = .center
        
        return view
    }()
    
    private var icon: UIImageView = {
        let img = UIImageView()
        img.height(equalTo: 100)
        img.width(equalTo: 100)
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
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
        icon.image = model.imageType.image
        icon.tintColor = model.imageType.tint
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageDescription {
    private func styleUI() {
        self.backgroundColor = .white
    }
    
    private func setUp() {
        setUpVerticalStack()
        setUpTitleAndDescription()
    }
    
    private func setUpVerticalStack() {
        self.addSubview(verticalStack)
        verticalStack.stretchLayout(with: 8, to: self)
        
    }
    
    private func setUpTitleAndDescription() {
        self.verticalStack.addArrangedSubview(icon)
        
        self.verticalStack.addArrangedSubview(titleLbl)
        self.verticalStack.addArrangedSubview(descriptionLbl)
    }
    
}
