//
//  TiTleButtonTableCell.swift
//  TiTleButtonTableCell
//
//  Created by Nato Egnatashvili on 30.08.21.
//

import UIKit

public class TiTleButtonTableCell: ListRowCell {
    public typealias Model = TiTleButtonTableCell.ViewModel
    
    private let title: ClickableButton = {
        let r = ClickableButton()
        r.font = Resourcebook.Font.button1
        r.translatesAutoresizingMaskIntoConstraints = false
        r.isUserInteractionEnabled = true
        return r
    }()
    
    private var onTap: ((TiTleButtonTableCell) -> ())?
    
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
        title.onClick = {
            self.onTap?(self)
        }
    }
    public func configure(with model: Model) {
        title.text = model.title
        self.onTap = model.onTap
        title.textColor = model.colorStyle?.color()
    }
    
    private func styleUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    private func setUpConstraints() {
        self.contentView.addSubview(title)
        title.top(toView: self.contentView, constant: 6)
        title.bottom(toView: self.contentView, constant: 6)
        title.right(toView: self.contentView, constant: 16)
        title.left(toView: self.contentView, constant: 16)
    }
}
    
extension TiTleButtonTableCell {
    public struct ViewModel {
        let title: String?
        let colorStyle: TitleStyle?
        let onTap: ((TiTleButtonTableCell) -> ())?
        
        internal init(title: String?, colorStyle: TitleStyle = .normal, onTap: ((TiTleButtonTableCell) -> ())?) {
            self.title = title
            self.colorStyle = colorStyle
            self.onTap = onTap
        }
    }
    
    enum TitleStyle {
        case normal
        case positive
        case negative
        
        func color() -> UIColor{
            switch self {
            case .negative:
                return Resourcebook.Color.Negative.solid200.uiColor
            case .positive:
                return Resourcebook.Color.Positive.solid100.uiColor
            default:
                return Resourcebook.Color.Black.solid200.uiColor
            }
        }
        
    }
}

@IBDesignable class ClickableButton: UILabel {
    var onClick: () -> Void = {}
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textColor = .blue
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.textColor = .gray
        }
        onClick()
    }
}
