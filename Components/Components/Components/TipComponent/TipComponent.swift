//
//  TipComponent.swift
//  Components
//
//  Created by Nato Egnatashvili on 05.11.21.
//

import UIKit

public class TipComponent: UIViewController {
    
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
        view.spacing = 4
        view.axis = .vertical
        view.alignment = .center
        
        return view
    }()
    
    private var commentArrowUp: UIImageView = {
        let img = UIImageView()
        img.image = Resourcebook.Image.Icons24.systemCommentUp.template
        img.tintColor = .white
        img.width(equalTo: 24)
        img.height(equalTo: 12)
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private var commentArrow: UIImageView = {
        let img = UIImageView()
        img.image = Resourcebook.Image.Icons24.systemComment.template
        img.tintColor = .white
        img.width(equalTo: 24)
        img.height(equalTo: 12)
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
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
    
    private lazy var longButton: UIButton = {
        let btn = UIButton()
        btn.height(equalTo: 40)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(longButtonTap), for: .touchUpInside)
        btn.roundCorners(with: .constant(radius: 10))
        return btn
    }()
    
    let model: ViewModel
    
    @objc private func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func longButtonTap() {
        model.onTap(self)
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
extension TipComponent {
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
extension TipComponent {
    
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

extension TipComponent {
    public func configure(with model: ViewModel){
        titleLbl.text = model.title
        descriptionLbl.text = model.description
        icon.image = model.imageType.image
        icon.tintColor = model.imageType.tint
        switch model.buttonType {
        case .imageWithTitle(let title, let image, let color):
            longButton.backgroundColor = color
            longButton.setImage(image, for: .normal)
            longButton.titleLabel?.text = title
        case .title(let title, let color):
            longButton.backgroundColor = color
            longButton.setTitle(title, for: .normal)
        }
    }
    
    private func styleUI() {
        self.contentView.backgroundColor = .white
        self.contentView.roundCorners(with: .constant(radius: 30))
    }
    
    private func setUp() {
        self.view.addSubview(contentView)
        setUpContentViewConstraints()
        switch model.type {
        case .up:
            self.view.addSubview(commentArrowUp)
            setUpCommentUpConstraints()
        case .down:
            self.view.addSubview(commentArrow)
            setUpCommentArrowConstraints()
            
        }
        setUpSubviews()
    }
    
    private func setUpContentViewConstraints() {
        if model.viewFrame.minX < UIScreen.main.bounds.width/4 {
            contentView.left(toView: self.view, constant: 16)
        }else  if model.viewFrame.minX < UIScreen.main.bounds.width/2 {
            contentView.left(toView: self.view, constant: 32)
        }else if model.viewFrame.minX >= UIScreen.main.bounds.width/2 {
            contentView.right(toView: self.view, constant: 32)
        }else {
            contentView.left(toView: self.view, constant: 16)
        }
        if (model.viewFrame.minY >  UIScreen.main.bounds.width/2) {
            contentView.bottom(toView: self.view, constant: 50)
        }else {
            contentView.top(toView: self.view, constant: model.viewFrame.maxY + 10)
        }
        contentView.width(equalTo: UIScreen.main.bounds.width*2/3)
    }
    
    private func setUpCommentArrowConstraints() {
        
        commentArrow.relativeTop(toView: self.contentView)
        commentArrowUp.left(toView: self.view, constant: model.viewFrame.minX + model.viewFrame.width/2 - commentArrowUp.frame.width/2)
    }
    
    private func setUpCommentUpConstraints() {
        commentArrowUp.relativeBottom(toView: self.contentView)
        commentArrowUp.left(toView: self.view, constant: model.viewFrame.minX + model.viewFrame.width/2 - commentArrowUp.frame.width/2)
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
    }
    
    private func addSubviewsToContentStack() {
        contentStackView.addArrangedSubview(trailingStack)
        contentStackView.addArrangedSubview(verticalStack)
        longButtonConstraint()
    }
    
    private func longButtonConstraint() {
        longButton.left(toView: contentView, constant: 16)
        longButton.right(toView: contentView, constant: 16)
    }
}
