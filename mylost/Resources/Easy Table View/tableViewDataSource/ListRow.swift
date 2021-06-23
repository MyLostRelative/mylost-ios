

import UIKit

public typealias ListRowCell = UITableViewCell & Configurable

public protocol CellProvider {
    var height: CGFloat { get }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

open class ListRow<Cell>: CellProvider & Tappable where Cell: ListRowCell  {
    
    private var model: Cell.Model
    private var tapClosure: ((Int, Cell.Model) -> Void)?
    private var cellHeight: CGFloat
    
    public var height: CGFloat {
        return cellHeight
    }
  
    public init(model: Cell.Model,
                height: CGFloat,
                tapClosure: ((Int, Cell.Model) -> Void)? = nil) {
        self.model = model
        self.tapClosure = tapClosure
        self.cellHeight = height
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueCell(at: indexPath)
      
        cell.configure(with: model)
        return cell
    }
    
    public func performTap(at index: Int) {
        tapClosure?(index, model)
    }
}
