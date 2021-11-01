//
//  RoundedTitleAndDescription.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/22/21.
//

import UIKit

public class RoundedTitleAndDescription: UIView {
    
    private var verticalStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 4
        view.axis = .vertical
        view.alignment = .leading
        
        return view
    }()
    
    private var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = Resourcebook.Font.caption1
        return lbl
    }()
    
    private var icon: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.roundCorners(with: .circle)
        img.height(equalTo: 100)
        img.width(equalTo: 100)
        return img
    }()
    
    private var descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = Resourcebook.Font.body1
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
        icon.isHidden = model.icon == nil
        icon.image = model.icon
        descriptionLbl.text = model.description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RoundedTitleAndDescription {
    private func styleUI() {
        self.roundCorners(with: .constant(radius: 10), with: .roundBottom)
        self.backgroundColor = .white
    }
    
    private func setUp() {
        setUpVerticalStack()
        setUpTitleAndDescription()
    }
    
    private func setUpVerticalStack() {
        self.addSubview(verticalStack)
        verticalStack.top(toView: self, constant: 8)
        verticalStack.left(toView: self)
        verticalStack.right(toView: self)
        verticalStack.bottom(toView: self, constant: 8)
        
    }
    
    private func setUpTitleAndDescription() {
        self.verticalStack.addArrangedSubview(titleLbl)
        titleLbl.left(toView: verticalStack, constant: 16)
        self.verticalStack.addArrangedSubview(icon)
        icon.left(toView: verticalStack, constant: 6)
        self.verticalStack.addArrangedSubview(descriptionLbl)
        descriptionLbl.left(toView: verticalStack, constant: 8)
    }
    
}
