//
//  ScrollableTabsConstants.swift
//  mBank
//
//  Created by Nikoloz Pirtskhalava on 5/13/19.
//  Copyright © 2019 Bank Of Georgia. All rights reserved.
//

import UIKit
import Components

struct AppScrollableTabs {
    
    struct CollectionItem {
        static let ID = "ScrollableTabCell"
        static let tabComponentID = "ProductTabCell"
    }
    
    struct Background {
        struct HexColor {
            static let RB = "E25C16"
            static let SOLO = "2E3A47"
        }
    }
    
    struct Title {
        struct HexColor {
            static let selectedRB = "FFFFFF"
            static let selectedSolo = "FFFFFF"
            static let deselectedRB = "FFC3A4"
            static let deslectedSolo = "A1A9B3"
        }
    }
    
    struct Plist {
        
        static let name = "ScrollableTabs"
        static let ext = "plist"
        
        struct Item {
            static let title = "title"
            static let selected = "isSelected"
            static let fontName = "fontName"
            static let fontSize = "fontSize"
        }
    }
    
    struct ProductTab {
        static let padding: CGFloat = 35
        static let height:CGFloat = 25
        
        struct Colors {
            static let background: UIColor? = Resourcebook.Color.Information.solid150.uiColor
        }
    }
}
