
import UIKit

public class CollectionViewDataSource: NSObject  {
    
    public var onItemTap: ((Int) -> ())?
    public var rows: [CollectionItemProvider & Tappable] = []
    public var collection: UICollectionView
    public init(collectionView: UICollectionView,
                withTypes types: [Reusable.Type] = [],
                withClassTypes classTypes: [Reusable.Type] = []) {
        
        collection = collectionView
        super.init()
        
        collection.dataSource = self
        collection.delegate = self
        
        types.forEach(collection.registerNibItem)
        classTypes.forEach(collection.registerItem)
    }
    
    public func reload(with rows: [CollectionItemProvider & Tappable]) {
        self.rows = rows
        let layout = collection.collectionViewLayout as! UICollectionViewFlowLayout
        
        guard let size = rows.first?.size else {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            return collection.reloadData()
        }
        
        layout.itemSize = size
        collection.reloadData()
    }
}

extension CollectionViewDataSource: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        rows[indexPath.row].performTap(at: indexPath.row)
        onItemTap?(indexPath.row)
    }
}

extension CollectionViewDataSource: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        rows.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        rows[indexPath.row].collectionView(collectionView, cellForItemAt: indexPath)
    }
}

extension UICollectionView {
    
    func dequeueCell<T>(at indexPath: IndexPath)  -> T where  T: UICollectionViewCell {
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("Unexpected ReusableCell Type for reuseID \(T.reuseID)")
        }
        return cell
    }
    
    func registerItem(reusable: Reusable.Type) {
        register(reusable, forCellWithReuseIdentifier: reusable.reuseID)
    }
    
    func registerNibItem(reusable: Reusable.Type) {
        register(UINib.init(nibName: reusable.reuseID, bundle: nil), forCellWithReuseIdentifier: reusable.reuseID)
    }
}
