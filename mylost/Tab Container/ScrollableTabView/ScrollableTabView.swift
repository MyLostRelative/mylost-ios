import UIKit

struct ScrollableTabViewModel {
    var title: String
    var titleColor: String
}

protocol ScrollableTabViewDelegate: AnyObject {
    var numberOfItems: Int { get }
    func itemSelected(at index:Int)
    func model(at index: Int) -> TabCollectionCellModel?
}

class ScrollableTabView: UIView {
    
    typealias CellIdentifier = AppScrollableTabs.CollectionItem

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: ScrollableTabViewDelegate?
    public var segmentFrames: [CGRect] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(UINib.init(nibName: CellIdentifier.ID, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.ID)
        
        self.collectionView.register(UINib.init(nibName: CellIdentifier.tabComponentID, bundle: nil),
                                     forCellWithReuseIdentifier: CellIdentifier.tabComponentID)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.contentView.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ScrollableTabView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

extension ScrollableTabView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.itemSelected(at: indexPath.row)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.collectionView.reloadData()
    }
}

extension ScrollableTabView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.delegate?.numberOfItems ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let nib = self.delegate?.model(at: indexPath.row)?.nibName ,
              let model = self.delegate?.model(at: indexPath.row) else {return UICollectionViewCell()}
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nib, for: indexPath) as? CollectionConfigurable {
            cell.configure(model: model)
            segmentFrames.append((cell as! UICollectionViewCell).frame)
            return cell as! UICollectionViewCell
        }
        return UICollectionViewCell()
    }
}

extension ScrollableTabView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let width = self.delegate?.model(at: indexPath.row)?.width else {
            return .zero
        }
        
        return CGSize(width: width, height: self.collectionView.frame.height)
    }
}
