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
    
    func getInformation() {
        var subItems = [TableCellModel]()
        
        //server call
        //database query
        subItems = ([ PageDescriptionTableCell.CellModel(pageDescModel: .init(imageType: (image: Resourcebook.Image.Icons24.accountsAccounts.image, tint: .red),
                                                                              title: "fef", description: "evewfe")) ,
                     PageDescriptionTableCell.CellModel(pageDescModel: .init(imageType: (image: Resourcebook.Image.Icons24.accountsAccounts.image, tint: .red),
                                                        title: "fef", description: "evewfe")),
                     RoundCard.CellModel(roundModel: .init(title: "dmkw", description: "wjsnek")),
                     RoundCard.CellModel(roundModel: .init(title: "dmkw", description: "wjsnek"))
        ])
        
        items.onNext([SectionOfFavourites(model: .main, items: subItems)])
    }
}

protocol RXTableConfigurable {
    var dataSource: RxTableViewSectionedReloadDataSource<SectionOfFavourites> { get }
    var configureCell: RxTableViewSectionedReloadDataSource<SectionOfFavourites >.ConfigureCell  { get }
    
}

extension RXTableConfigurable where Self: UIViewController{
    var dataSource: RxTableViewSectionedReloadDataSource<SectionOfFavourites>  { RxTableViewSectionedReloadDataSource<SectionOfFavourites>(configureCell: configureCell)
    }
    
    var configureCell: RxTableViewSectionedReloadDataSource<SectionOfFavourites >.ConfigureCell { { (dataSource, tableView, indexPath, item) in
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: item.nibIdentifier,
            for: indexPath)
        if let cell = cell as? ConfigurableTableCell  {
            cell.configure(with: item)
        }
        return cell
    }
    }
}
