//
//  LogInTextField.swift
//  LogInTextField
//
//  Created by Nato Egnatashvili on 30.08.21.
//

import UIKit

public class LogInTextField: UIView , UITextFieldDelegate{
    
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
        lbl.font = Resourcebook.Font.captionBig
        return lbl
    }()
    
    private var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .gray
        textField.borderStyle = .roundedRect
        return textField
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
        textField.isSecureTextEntry = model.textType == .secury
    }
    
    public func getTextFieldText() -> String {
        textField.text ?? ""
    }
    
    public func emptyTextField() {
        textField.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LogInTextField {
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
        self.verticalStack.addArrangedSubview(titleLbl)
        self.verticalStack.addArrangedSubview(textField)
        textField.left(toView: self, constant: 8)
        textField.right(toView: self, constant: 8)
    }
    
}

