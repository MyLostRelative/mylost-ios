//
//  MaterialChipsTableCell.swift
//  mylost
//
//  Created by Nato Egnatashvili on 27.10.21.
//

import MaterialComponents.MaterialChips

public class MaterialChipsTableCell: ListRowCell {
    public typealias Model = ViewModel
    
    private lazy var collectionView: UICollectionView = {
        let layout = MDCChipCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var chipTitles = [String]()
    private var onTap: ((String) -> Void)?
    
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
        collectionView.register(
            MDCChipCollectionViewCell.self,
            forCellWithReuseIdentifier: "identifier")
    }
    
    private func styleUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    private func setUpConstraints() {
        self.contentView.addSubview(collectionView)
        collectionView.stretchLayout(to: self.contentView)
    }
}

extension MaterialChipsTableCell {
    
    public func configure(with model: Model) {
        self.chipTitles = model.chipTitles
        self.onTap = model.onTap
        collectionView.reloadData()
    }
    
    public  func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier",
                                                      for: indexPath) as! MDCChipCollectionViewCell
        let chipView = cell.chipView
        chipView.titleLabel.text = chipTitles[indexPath.row]
        chipView.backgroundColor = .gray
        chipView.setBackgroundColor(.red, for: .selected)
        
        return cell
    }
    
}

extension MaterialChipsTableCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chipTitles.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onTap?(chipTitles[indexPath.row])
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = Resourcebook.Font.headline1.getWidth(of: chipTitles[indexPath.row])
        return CGSize(width: size.width, height: 50)
    }
}

extension UIFont {
    func getWidth(of text: String) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: self]
        return (text as NSString).size(withAttributes: fontAttributes)
    }
}
