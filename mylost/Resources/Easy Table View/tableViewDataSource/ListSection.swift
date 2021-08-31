
import UIKit

public struct ListSection {
    public typealias Row = CellProvider & Tappable
    public typealias HeaderFooter = HeaderFooterProvider & Tappable
    
    let id: String
    var numberOfRows: Int { rows.count }
    var changes: [ChangeItem]?
    private(set) var rows: [Row]
    private(set) var footer: HeaderFooter?
    private(set) var header: HeaderFooter?
    
    public init(
        id: String,
        rows: [Row] = [],
        footer: HeaderFooter?) {
        self.init(
            id: id,
            header: nil,
            rows: rows,
            footer: footer)
    }
    
    public init(
        id: String,
        rows: [Row] = [],
        footer: HeaderFooter,
        changes: [ChangeItem]) {
        self.init(
            id: id,
            header: nil,
            rows: rows,
            footer: footer,
            changes: changes)
    }
    
    public init(
        id: String,
        header: HeaderFooter?,
        rows: [Row] = []) {
        self.init(
            id: id,
            header: header,
            rows: rows,
            footer: nil)
    }
    
    public init(
        id: String,
        header: HeaderFooter,
        rows: [Row] = [],
        changes: [ChangeItem]) {
        self.init(
            id: id,
            header: header,
            rows: rows,
            footer: nil,
            changes: changes)
    }
    
    public init(
        id: String,
        header: HeaderFooter? = nil,
        rows: [Row] = [],
        footer: HeaderFooter? = nil,
        changes: [ChangeItem]? = nil) {
        self.id = id
        self.rows = rows
        self.footer = footer
        self.header = header
        self.changes = changes
    }
}

extension ListSection {
    public mutating func addRows(_ rows: [Row]) {
        self.rows.append(contentsOf: rows)
    }
}

extension ListSection {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        rows[indexPath.row].tableView(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rows[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footer?.tableView(tableView, viewForFooterInSection: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header?.tableView(tableView, viewForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let height = footer?.height else { return 0 }
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let height = header?.height else { return 0 }
        return height
    }

    func tapOnRow(at index: Int) {
        guard  rows.count > index else { return }
        rows[index].performTap(at: index)
    }
    
}
