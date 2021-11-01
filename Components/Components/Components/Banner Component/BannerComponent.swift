//
//  BannerComponent.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/23/21.
//

import UIKit

public class BannerComponent: UIView  {
    
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 5
        return stack
    }()
    
    private var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = Resourcebook.Font.body1
        return lbl
    }()
    
    private var descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = Resourcebook.Font.caption1
        lbl.numberOfLines = 0
        return lbl
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(with model: ViewModel? = nil) {
        super.init(frame: .zero)
        setUp()
        styleUI()
        guard let model = model else { return }
        configure(with: model)
    }

    public func configure(with model: ViewModel) {
        titleLbl.text = model.title
        descriptionLbl.text = model.description
        self.backgroundColor = model.type.background
    }

}

extension BannerComponent {
    private func styleUI() {
        self.roundCorners(with: .constant(radius: 10), with: .round)
    }

    private func setUp () {
        setUpStackView()
        setUpButton()
    }
    
    private func setUpStackView() {
        self.addSubview(stackView)
        stackView.stretchLayout(with: 16, to: self)
    }
    
    private func setUpButton() {
        
        stackView.addArrangedSubview(titleLbl)
        titleLbl.left(toView: stackView, constant: 2)
        
        stackView.addArrangedSubview(descriptionLbl)
        descriptionLbl.left(toView: stackView, constant: 2)
    }
}
