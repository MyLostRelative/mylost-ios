//  
//  MyLostHomeRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import Foundation

protocol MyLostHomeRouter {
    func move2UserDetails()
}

class MyLostHomeRouterImpl: MyLostHomeRouter {
    
    private weak var controller: MyLostHomeController?
    
    init(_ controller: MyLostHomeController?) {
        self.controller = controller
    }
    
    func move2UserDetails() {
        filterController()
    }
    
    func filterController() {
        
//        let container = FilterContainer(
//            rootFilters: [
//                // Multi-level list filter
//                Filter(title: "Area", key: "area", subfilters: [
//                    Filter(title: "Oslo", key: "area", value: "Oslo"),
//                    Filter(title: "Bergen", key: "area", value: "Bergen"),
//                ]),
//                // Range slider with number inputs
//                Filter.range(
//                    title: "Price",
//                    key: "price",
//                    lowValueKey: "price_from",
//                    highValueKey: "price_to",
//                    config: RangeFilterConfiguration(
//                        minimumValue: 1000,
//                        maximumValue: 100000,
//                        valueKind: .incremented(1000),
//                        hasLowerBoundOffset: false,
//                        hasUpperBoundOffset: true,
//                        unit: .currency,
//                        usesSmallNumberInputFont: false
//                    )
//                ),
////                // Map filter
////                Filter.map(
////                    title: "Map",
////                    key: "map",
////                    latitudeKey: "latitude",
////                    longitudeKey: "longitude",
////                    radiusKey: "radius",
////                    locationKey: "location"
////                )
//            ],
//            freeTextFilter: Filter.freeText(key: "query"),
//            inlineFilter: Filter.inline(title: "", key: "inline", subfilters: []),
//            numberOfResults: 100
//        )
//        
//        let viewController = CharcoalViewController()
//        viewController.filterContainer = container
//        controller?.navigationController?.pushViewController(viewController,
//                                                             animated: true)
    }
}
