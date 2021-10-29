//
//  MaterialInputFieldTableCell.swift
//  mylost
//
//  Created by Nato Egnatashvili on 22.10.21.
//

import MaterialComponents.MaterialTextControls_OutlinedTextFields

public protocol MaterialInputFieldTableCellDelegate: AnyObject {
    func MaterialInputFieldTableCellDelegate(_ cell: MaterialInputFieldTableCell,
                                             changeText: String,
                                             with inputType: MaterialInputFieldTableCell.InputType)
}

public class MaterialInputFieldTableCell: ListRowCell {
    public typealias Model = ViewModel
    
    private lazy var roundedTextField: MDCOutlinedTextField = {
        let r = MDCOutlinedTextField()
        r.delegate = self
        
        r.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        r.translatesAutoresizingMaskIntoConstraints = false
        return r
    }()
    
    private var inputType: InputType = .username
    private weak var delegate: MaterialInputFieldTableCellDelegate?
    
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
        self.contentView.addSubview(roundedTextField)
        roundedTextField.stretchLayout(with: 16, to: self.contentView)
    }
}

extension MaterialInputFieldTableCell {
    
    public func configure(with model: Model) {
        configureRoundedTextFIeld(with: model)
        self.inputType = model.inputType
        self.delegate = model.delegate
        if model.inputType == .password {passcodeCase() }
    }
    
    private func configureRoundedTextFIeld(with model: Model) {
        roundedTextField.label.text = model.title
        roundedTextField.placeholder = model.placeHolder
        roundedTextField.sizeToFit()
    }
    
    private func passcodeCase() {
        roundedTextField.trailingView = getEyeButton()
        roundedTextField.trailingViewMode = .whileEditing
        roundedTextField.isSecureTextEntry = true
    }
    
    private func getEyeButton() -> UIButton {
        let imageOn = Resourcebook.Image.Icons24.systemLockOffFill.image
        let imageOff = Resourcebook.Image.Icons24.systemLockOnFill.image
        var btn: UIButton = UIButton()
        btn = UIButton(type: .contactAdd, primaryAction: .init(handler: { _ in
            btn.setImage(self.roundedTextField.isSecureTextEntry ? imageOn : imageOff, for: .normal)
            self.roundedTextField.isSecureTextEntry = !self.roundedTextField.isSecureTextEntry
            
        }))
        btn.setImage(self.roundedTextField.isSecureTextEntry ? imageOn : imageOff, for: .normal)
        btn.height(equalTo: 40)
        btn.width(equalTo: 40)
        return btn
    }
    
}

extension MaterialInputFieldTableCell: UITextFieldDelegate {

    @objc func textFieldDidChange(textField: UITextField) {
        delegate?.MaterialInputFieldTableCellDelegate(self,
                                                      changeText: textField.text ?? "",
                                                      with: self.inputType)
    }
}
