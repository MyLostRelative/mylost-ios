//
//  Button With Line.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import UIKit

public class ButtonWithLine: UIView {
    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    var button: LoaclButton = {
        let btn = LoaclButton()
        btn.titleLabel?.font = Resourcebook.Font.body1
        btn.setTitleColor(Resourcebook.Color.Invert.Component.solid500.uiColor, for: .normal)
        btn.backgroundColor = Resourcebook.Color.Invert.Component.tr5.uiColor
        btn.setLocalButtonTitle()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.roundCorners(with: .constant(radius: 5))
        return btn
    }()
    
    var separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Resourcebook.Color.Invert.Component.solid500.uiColor
        view.height(equalTo: 1)
        return view
    }()
    
    private var onTap: ((ButtonWithLine) -> ())?
    
    
    public init(with model: ViewModel? = nil) {
        super.init(frame: .zero)
        setup()
        guard let model = model else {
            return
        }
        configure(with: model)
    }
    
    public func configure(with model: ViewModel) {
        
        button.setTitle(model.title, for: .normal)
        separatorLine.width(equalTo: button.frame.width)
        self.onTap = model.onTap
        button.addAction(.init(handler: { (_) in
            model.onTap?(self)
        }), for: .touchUpInside)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ButtonWithLine {
    private func setup() {
        setUpStackView()
        setUpSubviews()
    }
    
    private func setUpStackView() {
        self.addSubview(stackView)
        
        stackView.stretchLayout(to: self)
    }
    
    private func setUpSubviews() {
        self.stackView.addArrangedSubview(self.button)
        //self.stackView.addArrangedSubview(separatorLine)
        
    }
}
