//
//  PrimaryButton.swift
//  Components
//
//  Created by Nato Egnatashvili on 08.11.21.
//

import UIKit

public class PrimaryButton: UIButton {
    private var onTap: ((PrimaryButton) -> Void)?
    
    public init(with model: ViewModel? = nil){
        super.init(frame: .zero)
        styleUI()
        guard let model = model else { return }
        configure(with: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: ViewModel) {
        self.backgroundColor = model.backgroundColor
        self.setTitle(model.title, for: .normal)
        self.setTitleColor(model.titleTint, for: .normal)
        self.onTap = model.onTap
        self.addTarget(self, action: #selector(handler), for: .touchUpInside)
    }
    
    @objc func handler( ) {
        self.onTap?(self)
    }
    
    private func styleUI() {
        self.height(equalTo: 40)
        self.roundCorners(with: .constant(radius: 10))
    }
}
