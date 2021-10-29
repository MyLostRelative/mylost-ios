
extension Resourcebook {
    
    /// Font library for simple usability of design system fonts
    /// ## Usage example ##
    ///     let fontWrapper = Brandbook.Font.Bog.medium
    ///     let label = LocalLabel()
    ///         label.font = fontWrapper.sized(12)
    ///         label.font = Brandbook.Font.Bog.Medium.sized(12)
    public struct Font {
        
        public static let headline1   = Font.bold.sized(32)
        public static let headline2   = Font.medium.sized(24)
        public static let headline3   = Font.medium.sized(18)
        public static let headline4   = Font.bold.sized(16)
        public static let subtitle1   = Font.Headline.bold.sized(14)
        public static let subtitle2   = Font.semiBold.sized(14)
        public static let body1       = Font.medium.sized(14)
        public static let body2       = Font.medium.sized(12)
        public static let button1     = Font.Headline.bold.sized(14)
        public static let button2     = Font.Headline.semiBold.sized(11)
        public static let smallButton = Font.semiBold.sized(12)
        public static let caption1    = Font.regular.sized(11)
        public static let caption2    = Font.semiBold.sized(11)
        public static let captionBig  = Font.regular.sized(14)
        public static let overline1   = Font.medium.sized(14)
        public static let overline2   = Font.regular.sized(12)
    }
}

extension Resourcebook.Font {
        static let bold = FontWrapper(name: "BOG-Bold")
        static let semiBold = FontWrapper(name: "BOG-SemiBold")
        static let medium = FontWrapper(name: "BOG-Medium")
        static let regular = FontWrapper(name: "BOG-Regular")
        
        struct Headline {
            
            static let bold = FontWrapper(name: "BOG-Headline-Bold")
            static let semiBold = FontWrapper(name: "BOG-Headline-SemiBold")
        }
}
