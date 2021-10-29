
import Foundation


public protocol Configurable {
    associatedtype Model = String
    func configure(with model: Model)
}

public extension Configurable {
    func configure(with model: Model) {}
}

public protocol Tappable {
    func performTap(at index: Int)
}

extension Tappable {
    public func performTap(at index: Int) {}
}
