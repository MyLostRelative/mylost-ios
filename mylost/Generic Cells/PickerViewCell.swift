//
//  PickerViewCell.swift
//  mylost
//
//  Created by Nato Egnatashvili on 31.08.21.
//


import UIKit

public class PickerViewCell: ListRowCell {
    public typealias Model = PickerViewCell.ViewModel
    var pickerData: [[String]] = [[]]
    
    private let containerView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .vertical
        stack.roundCorners(with: .constant(radius: 20))
        stack.height(equalTo: 100)
        stack.backgroundColor = Resourcebook.Color.Information.solid50.uiColor
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.height(equalTo: 30)
        label.font = Resourcebook.Font.headline2
        label.textColor = Resourcebook.Color.Invert.Background.canvas.uiColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let picker: UIPickerView = {
        let b = UIPickerView()
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private var onTap: (([String])-> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        self.picker.delegate = self
        self.picker.dataSource = self
        styleUI()
        setUpConstraints()
    }
    public func configure(with model: Model) {
        label.text = model.title
        pickerData = model.pickerData
        onTap = model.onTap
    }
    
    private func styleUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    private func setUpConstraints() {
        self.contentView.addSubview(containerView)
        containerView.top(toView: self.contentView, constant: 6)
        containerView.bottom(toView: self.contentView, constant: 6)
        containerView.right(toView: self.contentView, constant: 36)
        containerView.left(toView: self.contentView, constant: 36)
        
        containerView.addArrangedSubview(label)
        containerView.addArrangedSubview(picker)
    }
}

extension PickerViewCell:  UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerData.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerData[component].count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        pickerData[component][row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let result = pickerData.enumerated().map({ pickerData[$0.offset][pickerView.selectedRow(inComponent: $0.offset)]})
        self.onTap?(result)
    }
}
    
extension PickerViewCell {
    public struct ViewModel {
        let title: String
        let pickerData: [[String]]
        let onTap: (([String])-> ())?
    }
}

