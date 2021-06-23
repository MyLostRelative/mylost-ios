//
//  HeaderWithDetails.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/22/21.
//

import UIKit

public class HeaderWithDetails: UIView {
    private var mainStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 8
        view.alignment = .center
        view.layer.borderColor = Resourcebook.Color.Invert.Background.canvas.cgColor
        view.roundCorners(with: .constant(radius: 10), with: .roundTop)
        view.backgroundColor = .white
        return view
    }()
    
    private var verticalStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 4
        view.axis = .vertical
        return view
    }()
    
    private var icon: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.roundCorners(with: .circle)
        img.height(equalTo: 32)
        img.width(equalTo: 32)
        return img
    }()
    
    private var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = Resourcebook.Font.caption1
        return lbl
    }()
    
    private var descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = Resourcebook.Font.body1
        return lbl
    }()
    
    public init(with model: ViewModel? = nil ) {
        super.init(frame: .zero)
        setUp()
        guard let model = model else { return }
        configure(with: model)
    }
    
    public func configure(with model: ViewModel){
        icon.image = model.icon
        titleLbl.text = model.title
        descriptionLbl.text = model.description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension HeaderWithDetails {
    private func setUp() {
        setUpStackView()
        setUpMainStackSubviews()
        setUpTitleAndDescription()
    }
    
    private func setUpStackView() {
        self.addSubview(mainStackView)
        
        mainStackView.stretchLayout(to: self)
    }
    
    private func setUpMainStackSubviews() {
        self.mainStackView.addArrangedSubview(icon)
        icon.left(toView: self.mainStackView, constant: 4)
        
        self.mainStackView.addArrangedSubview(verticalStack)
        verticalStack.top(toView: self, constant: 16)
        verticalStack.bottom(toView: self, constant: 16)
    }
    
    private func setUpTitleAndDescription() {
        self.verticalStack.addArrangedSubview(titleLbl)
        self.verticalStack.addArrangedSubview(descriptionLbl)
    }
    
}
