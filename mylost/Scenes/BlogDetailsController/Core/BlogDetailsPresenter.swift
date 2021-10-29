//
//  BlogDetailsPresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import UIKit
import Core
import Components

protocol BlogDetailsView: AnyObject {
    var tableView: UITableView {get}
}

protocol BlogDetailsPresenter {
    func viewDidLoad()
    func attach(view: BlogDetailsView)
}

class BlogDetailsPresenterImpl: BlogDetailsPresenter {
    
    private weak var view: BlogDetailsView?
    private var router: BlogDetailsRouter
    private var tableViewDataSource: ListViewDataSource?
    private var blog: Blog
    
    init(router: BlogDetailsRouter,
         blog: Blog) {
        self.router = router
        self.blog = blog
    }
    
    func viewDidLoad() {
        configureDataSource()
        constructDataSource()
    }
    
    func attach(view: BlogDetailsView) {
        self.view = view
    }
    
    private func configureDataSource() {
        self.view.unwrap { v in
            tableViewDataSource = ListViewDataSource.init(
                tableView: v.tableView,
                withClasses: [
                    HeaderWithDetailsCell.self,
                    TitleAndDescriptionCardTableCell.self,
                    TiTleButtonTableCell.self
                ])
        }
    }
    
    private func constructDataSource() {
        DispatchQueue.main.async {
            self.tableViewDataSource?.reload(
                with: [
                 ListSection.init(
                    id: "",
                    rows: [ self.blogDetailRow(blog: self.blog)]
                )
                ]
            )
        }
    }
}

// MARK: Table Rows
extension BlogDetailsPresenterImpl {
    private func clickableLabelRow(with model: TiTleButtonTableCell.ViewModel) -> ListRow<TiTleButtonTableCell> {
        ListRow(model: model,
                height: UITableView.automaticDimension)
    }
    
    private func blogDetailRow(blog: Blog) -> ListRow <TitleAndDescriptionCardTableCell> {
    ListRow(
            model: TitleAndDescriptionCardTableCell
                .Model(headerModel:
                        HeaderWithDetailsCell.Model(
                            icon: .withURL(url: URL(string: blog.imageUrl ?? "")),
                            title: blog.statementTitle,
                            info1: (blog.createDate ?? "").convertedDate,
                            description: nil,
                        rightIcon: nil),
                       cardModel: .init(title: "",
                                        description: blog.statementDescription)),
            
            height: UITableView.automaticDimension)
    }
}
