
import UIKit

public struct ChangeItem: Equatable {
    var value: CustomStringConvertible
    var id: String

    public init(id: String, value: CustomStringConvertible) {
        self.value = value
        self.id = id
    }
    
    public static func ==(lhs: ChangeItem, rhs: ChangeItem) -> Bool {
        return lhs.id == rhs.id && lhs.value.description == rhs.value.description
    }
}

public protocol Reusable: AnyObject {
    static var reuseID: String { get }
}

public extension Reusable {
    static var reuseID: String { return "\(self)"}
}

extension UITableViewCell: Reusable {}
extension UICollectionViewCell: Reusable {}
extension UITableViewHeaderFooterView: Reusable {}
