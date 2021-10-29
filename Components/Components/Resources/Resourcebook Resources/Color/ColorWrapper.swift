

import UIKit

public struct ColorWrapper{
    // MARK: private properties
    private let name: String
    
    // MARK: initialization
    public init(name: String) {
        self.name = name
    }
    
    // MARK: public interface
    /// Full identifier of color, only use for dynamic purposes
    public var designSystemName: String {
        return name
    }
    
    public var uiColor: UIColor {
        return UIColor(named: designSystemName)!
    }
    
    public var cgColor: CGColor {
        return uiColor.cgColor
    }
}
