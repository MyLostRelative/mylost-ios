//
//  TableSectionProtocols.swift
//  mylost
//
//  Created by Nato Egnatashvili on 27.09.21.
//

import Foundation

public struct TableSection {
    var header: TableHeaderFooterModel?
    var cells: [TableCellModel]
    var footer: TableHeaderFooterModel?
    
    init(header: TableHeaderFooterModel? = nil,
         cells: [TableCellModel],
         footer: TableHeaderFooterModel? = nil) {
        self.header = header
        self.cells = cells
        self.footer = footer
    }
}


public protocol TableHeaderFooterModel {
    var nibIdentifier: String { get }
    var height: Double { get }
}


public protocol TableCellModel {
    var nibIdentifier: String { get }
    var height: Double { get }
}


public protocol ConfigurableTableHeaderFooter {
    func configure(with model: TableHeaderFooterModel)
}


public protocol ConfigurableTableCell {
    func configure(with model: TableCellModel)
}
