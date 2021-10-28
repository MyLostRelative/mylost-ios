//
//  SearchTextField.swift
//  mylost
//
//  Created by Nato Egnatashvili on 06.09.21.
//


import UIKit

public class SearchTextField: ListRowCell {
    public typealias Model = SearchTextField.ViewModel
    
    private var onTapSearch: ((String) -> ())?
    
    private let horizontal: UIStackView = {
        let b = UIStackView()
        
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let searchField: UITextField = {
        let b = UITextField()
        b.borderStyle = .roundedRect
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let button: UIButton = {
        let b = UIButton()
        b.height(equalTo: 40)
       // b.width(equalTo: 40)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
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
    public func configure(with model: Model) {
        button.backgroundColor = Resourcebook.Color.Positive.solid100.uiColor
        button.roundCorners(with: .constant(radius: 10))
        button.setTitle(model.title, for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        self.onTapSearch = model.onTapSearch
    }
    
    private func styleUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    private func setUpConstraints() {
        self.contentView.addSubview(horizontal)
        horizontal.stretchLayout(with: 5, to: self.contentView)
        horizontal.addArrangedSubview(searchField)
        horizontal.addArrangedSubview(button)
    }
    
    @objc func didTap() {
        let search = searchField.text ?? ""
        searchField.text = ""
        self.onTapSearch?(search)
    }
}

extension SearchTextField {
    public struct ViewModel {
        let title: String
        let onTapSearch: ((String) -> Void)?
    }
}
