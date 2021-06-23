

import UIKit

public typealias CollectionRowCell = UICollectionViewCell & Configurable

public protocol CollectionItemProvider {
    var  size: CGSize? { get }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

public class CollectionViewRow<CollectionCell>: CollectionItemProvider & Tappable where CollectionCell: CollectionRowCell  {
    
    private var model: CollectionCell.Model
    private var cellSize: CGSize?
    private var tapClosure: ((Int, CollectionCell.Model) -> Void)?
    
    public var size: CGSize? {
        return cellSize
    }

    public init(model: CollectionCell.Model,
                size: CGSize? = nil,
                tapClosure: ((Int, CollectionCell.Model) -> Void)? = nil) {
        self.model = model
        self.cellSize = size
        self.tapClosure = tapClosure
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionCell = collectionView.dequeueCell(at: indexPath)
            cell.configure(with: model)
        return cell
    }
    
    public func performTap(at index: Int) {
        tapClosure?(index, model)
    }
}
