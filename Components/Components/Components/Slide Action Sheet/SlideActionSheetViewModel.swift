//
//  SlideActionSheetViewModel.swift
//  Components
//
//  Created by Nato Egnatashvili on 01.11.21.
//

import Foundation

extension SlideActionSheet {
    public struct ViewModel {
        let sections: [ListSection]
        let reusableClasses: [Reusable.Type]
        
        public init(sections: [ListSection],
                    reusableClasses: [Reusable.Type]) {
            self.sections = sections
            self.reusableClasses = reusableClasses
        }
    }
}
