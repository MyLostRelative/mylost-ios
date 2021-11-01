//
//  ProductTabCell.swift
//  mBank
//
//  Created by Nato Egnatashvili on 4/8/21.
//  Copyright © 2021 Bank Of Georgia. All rights reserved.
//

import UIKit
import Components

class ProductTabCell: UICollectionViewCell {
    private typealias Constraints = ProductTabCell.Constants.Constraints
    
    private var state: State = .enabled
    
    private let label: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = Resourcebook.Font.captionBig
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        view.height(equalTo: 3)
        return view
    }()
    
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override  func awakeFromNib() {
        setUp()
    }
}

// MARK:- Setup
private extension ProductTabCell {
    func setUp() {
        self.contentView.addSubview(stackView)
        
        stackView.left(toView: self, constant: Constraints.stackLeft)
        stackView.right(toView: self, constant: Constraints.stackRight)
        stackView.top(toView: self, constant: Constraints.stackTop)
        stackView.bottom(toView: self)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(lineView)
        lineView.bottom(toView: self)
    }
}

// MARK:- Configuration
extension ProductTabCell : CollectionConfigurable {
    func configure(model: TabCollectionCellModel) {
        if let model = model as?  ProductTabModel{
            self.configure(title: model.title , state: model.state)
        }
    }
    
    func configure(title: String, state: ProductTabCell.State) {
        self.state = state
        lineView.isHidden = !(state == .active)
        backgroundColor = state.getBackgroundColor()
        label.text = title
        label.textColor = state.getLabelColor()
    }
}

// MARK:- Touches
extension ProductTabCell {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        setPressedColors()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        revertPressedColors()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        revertPressedColors()
    }
    
    private func setPressedColors() {
        guard state != .disabled else { return }
        
        backgroundColor = state.getBackgroundColor()
        if state != .active { label.textColor = state.getLabelColor()}
    }
    
    private func revertPressedColors() {
        guard state != .disabled else { return }
        
        backgroundColor = state.getBackgroundColor()
        label.textColor = state.getLabelColor()
    }
}

extension ProductTabCell {
    struct Constants {
        struct Constraints {
            static let stackLeft: CGFloat = 16
            static let stackRight: CGFloat = 16
            static let stackTop: CGFloat = 15
        }

    }
}

extension ProductTabCell{
    enum State { case active, enabled, pressed, disabled }
}

extension ProductTabCell.State {
    func getBackgroundColor()-> UIColor? {
        switch self {
        case .active: return .clear
        case .enabled: return .clear
        case .pressed: return .red
        case .disabled: return .clear
        }
    }
    
    func getLabelColor() -> UIColor? {
        switch self {
        case .active: return Resourcebook.Color.Invert.Component.solid500.uiColor
        case .enabled: return Resourcebook.Color.Black.tr100.uiColor
        case .pressed: return Resourcebook.Color.Black.tr100.uiColor
        case .disabled: return Resourcebook.Color.Black.tr100.uiColor
        }
    }
}
