//
//  TwoInputTableCell.swift
//  mylost
//
//  Created by Nato Egnatashvili on 27.10.21.
//

import MaterialComponents.MaterialTextControls_OutlinedTextFields

public protocol TwoInputTableCellDelegate: AnyObject {
    func TwoInputTableCellDelegate(_ cell: TwoInputTableCell,
                                   firstText: String,
                                   secondText: String)
}

public class TwoInputTableCell: ListRowCell {
    public typealias Model = ViewModel
    
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = " - "
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var roundedTextField: MDCOutlinedTextField = {
        let r = MDCOutlinedTextField()
        r.delegate = self
        r.keyboardType = .numberPad
        r.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        r.translatesAutoresizingMaskIntoConstraints = false
        return r
    }()
    
    private lazy var roundedTextFieldTwo: MDCOutlinedTextField = {
        let r = MDCOutlinedTextField()
        r.delegate = self
        r.keyboardType = .numberPad
        r.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        r.translatesAutoresizingMaskIntoConstraints = false
        return r
    }()
    private weak var delegate: TwoInputTableCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        styleUI()
        setUpConstraints()
    }
    
    private func styleUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    private func setUpConstraints() {
        self.contentView.addSubview(stackView)
        stackView.addArrangedSubview(roundedTextField)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(roundedTextFieldTwo)
        self.contentView.addSubview(stackView)
        stackView.left(toView: contentView, constant: 60)
        stackView.right(toView: contentView, constant: 60)
        stackView.top(toView: contentView, constant: 16)
        stackView.bottom(toView: contentView, constant: 16)
    }
}

extension TwoInputTableCell {
    
    public func configure(with model: Model) {
        self.delegate = model.delegate
        roundedTextField.label.text = model.firstInputPlaceHolder
        roundedTextField.placeholder = model.firstInputPlaceHolder
        roundedTextField.sizeToFit()
        
        roundedTextFieldTwo.label.text = model.secondInputPlaceHolder
        roundedTextFieldTwo.placeholder = model.secondInputPlaceHolder
        roundedTextFieldTwo.sizeToFit()
    }
    
}

extension TwoInputTableCell: UITextFieldDelegate {

    @objc func textFieldDidChange(textField: UITextField) {
        delegate?.TwoInputTableCellDelegate(self,
                                            firstText: roundedTextField.text ?? "",
                                            secondText: roundedTextFieldTwo.text ?? "")
    }
}
