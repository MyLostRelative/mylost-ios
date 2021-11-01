
import UIKit

public struct ImageWrapper {
    // MARK: private properties
    private let name: String
    static var bundle = Bundle(identifier: "com.BOG.BrandBook")
    
    // MARK: initialization
    public init(name: String) {
        self.name = name
    }
    
    // MARK: public interface
    /// Full identifier of Image, only use for dynamic purposes
    public var designSystemName: String {
        return name
    }
    
    /// UIImage instance of selected image
    public var image: UIImage {
        return UIImage(named: name, in: Self.bundle, compatibleWith: nil)!
    }

    /// UIImage instance with template rendering mode
    public var template: UIImage {
        return image.withRenderingMode(.alwaysTemplate)
    }
    
    /// UIImage instance with original rendering mode
    public var original: UIImage {
        return image.withRenderingMode(.alwaysOriginal)
    }
}
