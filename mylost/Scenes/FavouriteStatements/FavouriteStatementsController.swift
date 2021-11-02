//  
//  FavouriteStatementsController.swift
//  mylost
//
//  Created by Nato Egnatashvili on 27.09.21.
//

import RxSwift
import RxCocoa
import RxDataSources
import Components

class FavouriteStatementsController: UIViewController , RXTableConfigurable {
    
    var presenter: FavouriteStatementsPresenter?
    var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = Resourcebook.Color.Invert.Background.canvas.uiColor
        table.separatorStyle = .none
        return table
    }()
    
    private let bag = DisposeBag()
    var viewModel = FavouriteViewModel()
    
    override func viewDidLoad() {
        addTableView()
        registerCells()
        setTableDataSource()
        presenter?.viewDidLoad()
    }
    private func addTableView() {
        self.view.addSubview(tableView)
        tableView.stretchLayout(to: self.view)
    }
    
    private func setTableDataSource() {
        tableView.rx.setDelegate(self).disposed(by: bag)
        viewModel.items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
    }
    
    private func registerCells() {
        tableView.registerCell(reusable: PageDescriptionTableCell.self)
        tableView.registerCell(reusable: RoundCard.self)
        tableView.registerCell(reusable: TitleAndDescriptionCardTableCell.self)
        
    }
}

extension FavouriteStatementsController: FavouriteStatementsView {
    
}

extension FavouriteStatementsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension FavouriteStatementsController: customNavigatable {
    var navTiTle: String {
        return "ფავორიტების სია"
    }
}
