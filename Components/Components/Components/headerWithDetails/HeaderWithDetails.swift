//
//  HeaderWithDetails.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/22/21.
//

import UIKit
import SDWebImage

public class HeaderWithDetails: UIView {
    private var mainStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 8
        view.alignment = .center
        view.layer.borderColor = Resourcebook.Color.Invert.Background.canvas.cgColor
        view.roundCorners(with: .constant(radius: 10), with: .roundTop)
        view.backgroundColor = .white
        return view
    }()
    
    private var verticalStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 4
        view.axis = .vertical
        return view
    }()
    
    private var icon: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 25
        img.layer.masksToBounds = true
        img.height(equalTo: 50)
        img.width(equalTo: 50)
        return img
    }()
    
    private var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = Resourcebook.Font.body1
        return lbl
    }()
    
    private var infoLabel1: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = Resourcebook.Font.caption1
        return lbl
    }()
    
    private var infoLabel2: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = Resourcebook.Font.caption1
        return lbl
    }()
    
    private var infoLabel3: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = Resourcebook.Font.caption1
        return lbl
    }()
    
    private var infoLabel4: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = Resourcebook.Font.body2
        return lbl
    }()
    
    private var descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = Resourcebook.Font.body1
        return lbl
    }()
    
    private lazy var rightButton: UIButton = {
        let btn = UIButton(primaryAction: .init(handler: { _ in
            self.didTapFavourite()
        }))
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var isSelected: Bool = false
    private var onTap: ((HeaderWithDetails) -> Void)?
    
    public init(with model: ViewModel? = nil ) {
        super.init(frame: .zero)
        setUp()
        guard let model = model else { return }
        configure(with: model)
    }
    
    public func configure(with model: ViewModel) {
        setImage(with: model.icon)
        setTextes(with: model)
        onTap = model.rightIcon?.onTap
        self.rightButton.isSelected = model.rightIcon?.rightIconIsActive ?? false
        rightButton.isHidden = model.rightIcon?.rightIconHide ?? true
        setState(rightIcon: model.rightIcon)
    }
    
    func didTapFavourite() {
        self.onTap?(self)
        self.rightButton.isSelected = !self.rightButton.isSelected
    }
    
    public func getIcon() -> UIImageView {
        return icon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Set  for configure
extension HeaderWithDetails {
    private func setTextes(with model: ViewModel) {
        titleLbl.text = model.title
        infoLabel1.text = model.info1
        infoLabel2.text = model.info2
        infoLabel3.text = model.info3
        infoLabel4.text = model.info4
        descriptionLbl.text = model.description
    }
    
    private func setImage(with type: HeaderWithDetails.ImageType?) {
        switch type {
        case .withIcon(let img):
            icon.image = img
        case .withURL(let url):
            DispatchQueue.main.async {
                self.icon.sd_setImage(with: url, completed: nil)
            }
        case .none:
            break
        }
    }
    
    private func setState(rightIcon: HeaderWithDetails.RightIcon?) {
        guard let rightIcon = rightIcon else { return }
        if #available(iOS 15.0, *) {
            let handler: UIButton.ConfigurationUpdateHandler = { button in
                switch button.state {
                case .selected:
                    button.configuration?.image = rightIcon.rightIconActive
                default:
                    button.configuration?.image = rightIcon.rightIconDissable
                }
            }
            rightButton.configuration = .borderless()
            rightButton.configurationUpdateHandler = handler
            
        } else {
            rightButton.setImage(rightIcon.rightIconActive, for: .selected)
            rightButton.setImage(rightIcon.rightIconDissable, for: .normal)
        }
    }
}

extension HeaderWithDetails {
    private func setUp() {
        setUpStackView()
        setUpMainStackSubviews()
        setUpTitleAndDescription()
    }
    
    private func setUpStackView() {
        self.addSubview(mainStackView)
        
        mainStackView.stretchLayout(to: self)
    }
    
    private func setUpMainStackSubviews() {
        self.mainStackView.addArrangedSubview(icon)
        icon.left(toView: self.mainStackView, constant: 4)
        
        self.mainStackView.addArrangedSubview(verticalStack)
        verticalStack.top(toView: self, constant: 16)
        verticalStack.bottom(toView: self, constant: 16)
        self.mainStackView.addArrangedSubview(rightButton)
    }
    
    private func setUpTitleAndDescription() {
        self.verticalStack.addArrangedSubview(titleLbl)
        self.verticalStack.addArrangedSubview(infoLabel1)
        self.verticalStack.addArrangedSubview(infoLabel2)
        self.verticalStack.addArrangedSubview(infoLabel3)
        self.verticalStack.addArrangedSubview(infoLabel4)
        self.verticalStack.addArrangedSubview(descriptionLbl)
    }
    
}
