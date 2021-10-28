//
//  FavouriteStatementModel.swift
//  mylost
//
//  Created by Nato Egnatashvili on 27.09.21.
//

import RxSwift
import RxDataSources
import  UIKit

typealias SectionOfFavourites = SectionModel<TableViewSection,TableCellModel>

enum TableViewSection {
    case main
}

class FavouriteViewModel {
    let items = PublishSubject<[SectionOfFavourites]>()
    
    func subscribeWithItems(subItems: [TableCellModel] ) {
        items.onNext([SectionOfFavourites(model: .main, items: subItems)])
    }
}

protocol RXTableConfigurable {
    var dataSource: RxTableViewSectionedReloadDataSource<SectionOfFavourites> { get }
    var configureCell: RxTableViewSectionedReloadDataSource<SectionOfFavourites >.ConfigureCell  { get }
    
}

extension RXTableConfigurable where Self: UIViewController {
    var dataSource: RxTableViewSectionedReloadDataSource<SectionOfFavourites> { RxTableViewSectionedReloadDataSource<SectionOfFavourites>(configureCell: configureCell)
    }
    
    var configureCell: RxTableViewSectionedReloadDataSource<SectionOfFavourites >.ConfigureCell { { (_, tableView, indexPath, item) in
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: item.nibIdentifier,
            for: indexPath)
        if let cell = cell as? ConfigurableTableCell {
            cell.configure(with: item)
        }
        return cell
    }
    }
}
