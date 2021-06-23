

import UIKit

public typealias ListHeaderFooter = UITableViewHeaderFooterView & Configurable

public protocol HeaderFooterProvider {
    var  height: CGFloat { get }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
}

open class ListViewHeaderFooter<HeaderFooter>: HeaderFooterProvider & Tappable where HeaderFooter: ListHeaderFooter  {
    
    private var model: HeaderFooter.Model?
    private var footerHeight: CGFloat
    
    public var height: CGFloat {
        return footerHeight
    }
  
    public init(model: HeaderFooter.Model? = nil,
                height: CGFloat) {
        self.model = model
        self.footerHeight = height
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return view(with: tableView)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return view(with: tableView)
    }
    
    func view(with tableView: UITableView) -> UIView? {
        let headerFooter: HeaderFooter = tableView.dequeueView()
        if let m = model {
            headerFooter.configure(with: m)
        }
        
        return headerFooter
    }
}
