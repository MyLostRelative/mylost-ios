//  
//  BlogDetailsReactiveController.swift
//  mylost
//
//  Created by Nato Egnatashvili on 26.10.21.
//

import RxSwift
import RxCocoa
import RxDataSources
import LifetimeTracker
import Components

class ReadedBlogsController: UIViewController, LifetimeTrackable, RXTableConfigurable {
class var lifetimeConfiguration: LifetimeConfiguration {
            return LifetimeConfiguration(maxCount: 1, groupName: "VC")
        }
    var presenter_: ReadedBlogsPresenter!
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
        presenter_.viewDidLoad()
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

extension ReadedBlogsController: ReadedBlogsView {
    func displayBanner(type: Bannertype, title: String, description: String) {
        DispatchQueue.main.async {
            self.displayBanner(banner: .init(type: type, title: title, description: description))
        }
    }
}

extension ReadedBlogsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ReadedBlogsController: customNavigatable {
    var navTiTle: String {
        "წაკითხული/მონიშნული ბლოგები"
    }
}
