//
//  CardAnimationTableCell.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/25/21.
//

import UIKit


public class CardAnimationTableCell: ListRowCell {
    
    private let mainstack: UIStackView = {
        let r = UIStackView()
        r.translatesAutoresizingMaskIntoConstraints = false
        r.axis = .vertical
        r.alignment = .center
        r.backgroundColor = .white
        r.spacing = 10
        r.roundCorners(with: .constant(radius: 10), with: .round)
        return r
    }()
    
    private let headerStack: UIStackView = {
        let r = UIStackView()
        r.alignment = .center
        r.spacing = 10
        r.translatesAutoresizingMaskIntoConstraints = false
        return r
    }()
    
    private let bodyStack: UIStackView = {
        let r = UIStackView()
        r.spacing = 5
        r.translatesAutoresizingMaskIntoConstraints = false
        r.axis = .vertical
        r.alignment = .leading
        return r
    }()
    
    private let avatarAnimationView: AnimatorView = {
       let view = AnimatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.height(equalTo: 40)
        view.width(equalTo: 40)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = Resourcebook.Color.Invert.Background.additional.uiColor
        view.animateOpacity(
            beginTime: CACurrentMediaTime() + 0.5,
            toValue: 0.2,
            reversed: true)
        return view
    }()
    
    private let lineAnimationView: AnimatorView = {
       let view = AnimatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor =  Resourcebook.Color.Invert.Background.additional.uiColor
        view.height(equalTo: 10)
        view.width(equalTo: UIScreen.main.bounds.width - 100)
        view.roundCorners(with: .constant(radius: 4), with: .round)
        view.animateOpacity(
            beginTime: CACurrentMediaTime() + 0.5,
            toValue: 0.2,
            reversed: true)
        return view
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

    
    private func styleUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    private func setUpConstraints() {
        setUpMainStack()
        setUpHeaderStack()
        setUpBodyrStack()
    }
    
    private func setUpMainStack() {
        self.contentView.addSubview(mainstack)
        mainstack.stretchLayout(with: 16, to: self.contentView)
    }
    
    private func setUpHeaderStack() {
        mainstack.addArrangedSubview(headerStack)
        headerStack.top(toView: self.contentView, constant: 32)
        
        headerStack.addArrangedSubview(avatarAnimationView)
       // avatarAnimationView.top(toView: self.contentView, constant: 32)
        headerStack.addArrangedSubview(lineAnimationView)
    }
    
    private func setUpBodyrStack() {
        mainstack.addArrangedSubview(bodyStack)
        bodyStack.bottom(toView: self.contentView, constant: 32)
        
        let view1 = getLineAnimation(width: 100, height: 8, radius: 3)
         bodyStack.addArrangedSubview(view1)
        for _ in 0...2{
            let view = getLineAnimation(width: UIScreen.main.bounds.width - 50, height: 10, radius: 5)
            bodyStack.addArrangedSubview(view)
        }
        
    }
    
    private func getLineAnimation(width: CGFloat,
                                  height: CGFloat,
                                  radius: CGFloat)-> AnimatorView{
        let view = AnimatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Resourcebook.Color.Invert.Background.additional.uiColor
        view.height(equalTo: height)
        view.width(equalTo: width)
        view.animateOpacity(
            beginTime: CACurrentMediaTime() + 0.5,
            toValue: 0.2,
            reversed: true)
        view.roundCorners(with: .constant(radius: radius), with: .round)
        return view
    }
}

