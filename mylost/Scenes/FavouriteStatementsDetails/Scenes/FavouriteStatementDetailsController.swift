//  
//  FavouriteStatementDetailsController.swift
//  mylost
//
//  Created by Nato Egnatashvili on 19.10.21.
//

import RxSwift
import RxCocoa
import RxDataSources

class FavouriteStatementDetailsController: UIViewController, RXTableConfigurable {

    
    var presenter: FavouriteStatementDetailsPresenter?
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

extension FavouriteStatementDetailsController: FavouriteStatementDetailsView {
    
}

extension FavouriteStatementDetailsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
