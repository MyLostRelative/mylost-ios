//
//  UserProfile.swift
//  mylost
//
//  Created by Nato Egnatashvili on 02.09.21.
//

import UIKit

public protocol SavedUserCardDelegate: AnyObject {
    func savedUserCardDidTapButton(_ sender: SavedUserCard)
}

public class SavedUserCard: UIView {
    
    // MARK: Internal Components
    
    private let mainStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        return stackView
    }()
    
    private let firstStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.alignment = .top
        return stackView
    }()
    
    private let userAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.width(equalTo: Constants.Avatar.size.width)
        imageView.height(equalTo: Constants.Avatar.size.height)
        imageView.tintColor = Resourcebook.Color.Information.solid100.uiColor
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Constants.Title.textColor
        label.font = Constants.Title.font
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Constants.Username.textColor
        label.font = Constants.Username.font
        return label
    }()
    
    private let textContainerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = Resourcebook.Color.Information.tr100.uiColor
        button.roundCorners(with: .constant(radius: 10))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = Resourcebook.Font.caption2
        button.height(equalTo: 20)
        button.width(equalTo: 20)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    private var onTap: ((SavedUserCard) ->())?
    
    public var buttonTitle: String? {
        didSet {
            button.setImage(Resourcebook.Image.Icons24.systemInfoOutline.image.withTintColor(Resourcebook.Color.Information.tr300.uiColor), for: .normal)
        }
    }
    
    public init(with model: ViewModel? = nil) {
        super.init(frame: .zero)
        setup()
        guard let model = model else { return }
        configure(with: model)
    }
    
    public func configure(with model: ViewModel) {
        userAvatar.image = model.avatar
        ageLabel.text = model.age
        usernameLabel.text = model.username
        buttonTitle = model.buttonTitle
        self.onTap = model.onTap
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: UIView Lifecycle
extension SavedUserCard {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        userAvatar.roundCorners(with: .circle)
    }
    
}

// MARK: Setup
extension SavedUserCard {
    
    private func setup() {
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(mainStack)
        mainStack.stretchLayout(to: self)
        mainStack.addArrangedSubview(firstStack)
        mainStack.addArrangedSubview(textContainerStack)
        
        firstStack.addArrangedSubview(button)
        firstStack.addArrangedSubview(userAvatar)
        
        textContainerStack.addArrangedSubview(usernameLabel)
        textContainerStack.addArrangedSubview(ageLabel)
    }
    
    private func setupConstraints() {
        button.left(toView: self, constant: 5)
        self.mainStack.roundCorners(with: .constant(radius: 15))
        self.mainStack.backgroundColor = Resourcebook.Color.Invert.Component.tr5 .uiColor
        
    }
    
}

// MARK: Touch events
extension SavedUserCard {
    
    @objc
    private func didTapButton() {
        self.onTap?(self)
    }
    
}


