//
//  DialogComponent.swift
//  Components
//
//  Created by Nato Egnatashvili on 08.11.21.
//

import UIKit

public class DialogComponent: UIViewController {
    
    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var contentStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    private var trailingStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 4
        view.axis = .vertical
        view.alignment = .trailing
        
        return view
    }()
    
    private var verticalStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 20
        view.axis = .vertical
        view.alignment = .center
        
        return view
    }()
    
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.height(equalTo: 18)
        btn.width(equalTo: 18)
        btn.setImage(Resourcebook.Image.Icons24.systemClose.image, for: .normal)
        btn.imageView?.tintColor = Resourcebook.Color.Black.tr25.uiColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        return btn
    }()
    
    private var icon: UIImageView = {
        let img = UIImageView()
        img.height(equalTo: 24)
        img.width(equalTo: 24)
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = Resourcebook.Font.captionBig
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private var descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = Resourcebook.Font.caption2
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var longButton: PrimaryButton = {
        let btn = PrimaryButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var secondButton: PrimaryButton = {
        let btn = PrimaryButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let model: ViewModel
    
    @objc private func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    public init(model: ViewModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
        self.view.backgroundColor = Resourcebook.Color.Black.tr25.uiColor
    }
    /// :nodoc:
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:- Dialog Lifecycle Events
extension DialogComponent {
    /// :nodoc:
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        styleUI()
        configure(with: model)
        prepareForAnimation()
    }
    /// :nodoc:
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performAnimation()
    }
}


// MARK:- Dialog Animations
extension DialogComponent {
    
    private func prepareForAnimation() {
        contentView.alpha = 0
        contentView.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    private func performAnimation() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .curveEaseOut,
            animations: {
                self.contentView.alpha = 1
                self.contentView.transform = .identity
            },
            completion: nil
        )
    }
}

extension DialogComponent {
    public func configure(with model: ViewModel){
        titleLbl.text = model.title
        descriptionLbl.text = model.description
        icon.image = model.imageType.image
        icon.tintColor = model.imageType.tint
        longButton.configure(with: model.firstButtonModel)
        secondButton.configure(with: model.secondButtonModel)
    }
    
    private func styleUI() {
        self.contentView.backgroundColor = .white
        self.contentView.roundCorners(with: .constant(radius: 30))
    }
    
    private func setUp() {
        self.view.addSubview(contentView)
        setUpContentViewConstraints()
        setUpSubviews()
    }
    
    private func setUpContentViewConstraints() {
        contentView.centerVertically(to: self.view)
        contentView.centerHorizontally(to: self.view)
        contentView.left(toView: self.view, constant: 50)
    }
    
    private func setUpSubviews() {
        setUpContentStack()
        addSubviewToTrailingStack()
        addSubviewsToVerticalStack()
        addSubviewsToContentStack()
    }
    
    private func setUpContentStack() {
        self.contentView.addSubview(contentStackView)
        contentStackView.stretchLayout(with: 16, to: self.contentView)
    }
    
    
    private func addSubviewToTrailingStack() {
        self.trailingStack.addArrangedSubview(closeBtn)
    }
    
    private func addSubviewsToVerticalStack() {
        self.verticalStack.addArrangedSubview(icon)
        self.verticalStack.addArrangedSubview(titleLbl)
        self.verticalStack.addArrangedSubview(descriptionLbl)
        self.verticalStack.addArrangedSubview(longButton)
        self.verticalStack.addArrangedSubview(secondButton)
    }
    
    private func addSubviewsToContentStack() {
        contentStackView.addArrangedSubview(trailingStack)
        contentStackView.addArrangedSubview(verticalStack)
        longButtonConstraint()
        secondButtonConstraint()
    }
    
    private func longButtonConstraint() {
        longButton.left(toView: contentView, constant: 16)
        longButton.right(toView: contentView, constant: 16)
    }
    
    private func secondButtonConstraint() {
        secondButton.left(toView: contentView, constant: 16)
        secondButton.right(toView: contentView, constant: 16)
    }
}
