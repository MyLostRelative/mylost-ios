
import UIKit

open class ListViewDataSource: NSObject  {
    
    var sections: [ListSection] = []
    weak var tv: UITableView?
    
    public var scrollHandler: ((UIScrollView) -> ())?
    public var scrollEndHandler: (() -> ())?
    public var needAnimation: Bool = false
    public var animationCells: [String] = []
    
    public init(tableView: UITableView,
                withTypes types: [Reusable.Type],
                reusableViews: [Reusable.Type] = []) {
        
        tv = tableView
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
        
        types.forEach(tableView.registerCell)
        reusableViews.forEach(tableView.registerFooterHeader)
    }
    
    public init(tableView: UITableView,
                withClasses classes: [Reusable.Type],
                reusableViews: [Reusable.Type] = []) {
        
        tv = tableView
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
        
        classes.forEach(tableView.registerCell)
        reusableViews.forEach(tableView.registerFooterHeader)
    }
    
    private func flatten(items: [ListSection]) -> [ReloadableSection<ChangeItem>] {
        let reloadableItems = items
            .enumerated()
            .map { ReloadableSection<ChangeItem>(key: $0.element.id, value: $0.element.changes!
            .enumerated()
            .map { ReloadableCell(key: "\($0.element.id)-\($0.offset)", value: $0.element, index: $0.offset)}, index: $0.offset) }
        return reloadableItems
    }
    
    open func reload(with sections: [ListSection]) {
        let changes = sections.map { $0.changes }.compactMap { $0 }
        changes.count == sections.count ? setup(newItems: sections) : reload(sections)
    }
    
    private func reload(_ sections: [ListSection]) {
        self.sections = sections
        tv?.reloadData()
    }
    
    private func setup(newItems: [ListSection]) {
        let oldData = flatten(items: self.sections)
        let newData = flatten(items: newItems)
        let sectionChanges = DiffCalculator.calculate(oldItems: oldData, newItems: newData)
        self.sections = newItems
        apply(changes: sectionChanges)
    }
  
    func apply(changes: SectionChanges) {
        self.tv?.beginUpdates()
        self.tv?.deleteSections(changes.deletes, with: .fade)
        self.tv?.insertSections(changes.inserts, with: .fade)
        self.tv?.reloadRows(at: changes.updates.reloads, with: .fade)
        self.tv?.insertRows(at: changes.updates.inserts, with: .fade)
        self.tv?.deleteRows(at: changes.updates.deletes, with: .fade)
        self.tv?.endUpdates()
    }
}

extension ListViewDataSource: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  sections[section].numberOfRows
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sections[indexPath.section].tableView(tableView, cellForRowAt: indexPath)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        sections[indexPath.section].tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = sections[section].tableView(tableView, viewForFooterInSection: section)
        return footer
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = sections[section].tableView(tableView, viewForHeaderInSection: section)
        return header
    }
}

extension ListViewDataSource: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      sections[indexPath.section].tapOnRow(at: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].tableView(tableView, heightForRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections[section].tableView(tableView, heightForFooterInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].tableView(tableView, heightForHeaderInSection: section)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollHandler?(scrollView)
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge >= scrollView.contentSize.height) {
            scrollEndHandler?()
        }
    }
}
