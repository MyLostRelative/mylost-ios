//
//  RoundedTextField.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import UIKit

public class RoundedTextField: UIView  {
    private lazy var textField: UITextView  = {
        let field = UITextView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textColor = Resourcebook.Color.Invert.Component.solid500.uiColor
        field.layer.borderColor = Resourcebook.Color.Invert.Background.canvas.cgColor
        field.layer.borderWidth = 3
        field.roundCorners(with: .constant(radius: 5))
        field.clipsToBounds = true
        field.delegate = self
        field.height(equalTo: 80)
        field.font = Resourcebook.Font.body1
        textViewDidChange(field)
        return field
    }()
    let messageTextViewMaxHeight: CGFloat = 80
    
    
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 5
        return stack
    }()
    
    private var button: ButtonWithLine = {
        let btn = ButtonWithLine()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(with model: ViewModel? = nil) {
        super.init(frame: .zero)
        setUp()
        guard let model = model else { return }
        configure(with: model)
    }

    public func configure(with model: ViewModel) {
        self.textField.text = model.placeHolderText
        self.button.configure(with: .init(title: model.title, onTap: { (_) in
            model.onTap?(self)
        }))
    }
    
    public func getText() -> String? {
        return self.textField.text
    }

}

extension RoundedTextField {
    private func setUp () {
        setUpStackView()
        setUpTextView()
        setUpButton()
    }
    
    private func setUpStackView() {
        self.addSubview(stackView)
        stackView.stretchLayout(to: self)
    }
    
    private func setUpTextView() {
        stackView.addArrangedSubview(textField)
        textField.left(toView: stackView)
        textField.right(toView: stackView)
    }
    
    private func setUpButton() {
        
        stackView.addArrangedSubview(button)
        button.left(toView: stackView, constant: 2)
    }
}

extension RoundedTextField: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height >= self.messageTextViewMaxHeight{
            textView.isScrollEnabled = true
        } else {
            textView.frame.size.height = textView.contentSize.height
            textView.isScrollEnabled = false
        }
    }
}
