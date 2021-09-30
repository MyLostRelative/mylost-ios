

import UIKit

public typealias ListRowCell = UITableViewCell & Configurable

public protocol CellProvider {
    var height: CGFloat { get }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
}

open class ListRow<Cell>: CellProvider & Tappable where Cell: ListRowCell  {
    
    private var model: Cell.Model
    private var tapClosure: ((Int, Cell.Model, Cell?) -> Void)?
    private var cellHeight: CGFloat
    private var needAnimation: Bool?
    private var heroID: String?
    private var cell: Cell?
    
    public var height: CGFloat {
        return cellHeight
    }
  
    public init(model: Cell.Model,
                height: CGFloat,
                tapClosure: ((Int, Cell.Model, Cell?) -> Void)? = nil,
                needAnimation: Bool? = nil,
                heroID: String? = nil) {
        self.model = model
        self.tapClosure = tapClosure
        self.cellHeight = height
        self.needAnimation = needAnimation
        self.heroID = heroID
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueCell(at: indexPath)
        cell.hero.id = heroID
        cell.configure(with: model)
        self.cell = cell
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let needAnimation = self.needAnimation else { return }
        if !needAnimation { return }
        let restorationPlatform = CATransform3DTranslate(CATransform3DIdentity, -200, 5, 0)
        cell.layer.transform = restorationPlatform
        UIView.animate(withDuration: 0.3) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    public func performTap(at index: Int) {
        tapClosure?(index, model, self.cell)
    }
}
