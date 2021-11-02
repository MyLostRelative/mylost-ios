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
        stackView.alignment = .center
        stackView.spacing = 10
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
    
    private var onTap: ((SavedUserCard) ->())?
    
    public init(with model: ViewModel? = nil) {
        super.init(frame: .zero)
        setup()
        guard let model = model else { return }
        configure(with: model)
    }
    
    public func configure(with model: ViewModel) {
        userAvatar.image = model.avatar
        ageLabel.text = model.description
        usernameLabel.text = model.username
        self.onTap = model.onTap
        addGesture()
    }
    
    private func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
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
        setUpUI()
    }
    
    private func setUpMainStackViewConstraint() {
        addSubview(mainStack)
        mainStack.left(toView: self, constant: 30)
        mainStack.right(toView: self, constant: 30)
        mainStack.top(toView: self)
        mainStack.bottom(toView: self)
    }
    
    private func addArrangedSubviews() {
        mainStack.addArrangedSubview(firstStack)
        mainStack.addArrangedSubview(textContainerStack)
        
        firstStack.addArrangedSubview(userAvatar)
        
        textContainerStack.addArrangedSubview(usernameLabel)
        textContainerStack.addArrangedSubview(ageLabel)
    }
    
    private func addSubviews() {
        setUpMainStackViewConstraint()
        addArrangedSubviews()
    }
    
    private func setUpUI() {
        self.roundCorners(with: .constant(radius: 15))
        self.backgroundColor = Resourcebook.Color.Invert.Component.tr5 .uiColor
        
    }
    
}

// MARK: Touch events
extension SavedUserCard: UIGestureRecognizerDelegate {
    
    @objc
    private func didTapButton() {
        self.onTap?(self)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.onTap?(self)
      }
    
}


