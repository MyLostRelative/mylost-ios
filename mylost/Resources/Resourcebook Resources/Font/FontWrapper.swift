

import UIKit

public struct FontWrapper {
    // MARK: private properties
    private let name: String
    
    // MARK: initialization
    public init(name: String) {
        self.name = name
    }
    
    public var designSystemName: String {
        return name
    }
    
    /// UIFont value of the selected font type and size, returns nil if such font is not found in the `BrandBook` resources
    public func sized(_ size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size)!
    }
    
    /// UIFont value of the selected font type and size, returns nil if such font is not found in the `BrandBook` resources
    public func sized(_ size: Int) -> UIFont {
        guard let font = UIFont(name: name, size: CGFloat(size)) else {
            return UIFont.systemFont(ofSize: CGFloat(size))
        }
        return font
    }

}
