//
//  StatementsPresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import UIKit

protocol StatementsView: AnyObject {
    var tableView: UITableView {get}
}

protocol StatementsPresenter {
    func viewDidLoad()
}

class StatementsPresenterImpl: StatementsPresenter {
    
    private weak var view: StatementsView?
    private var router: StatementsRouter
    private var tableViewDataSource: ListViewDataSource?
    
    init(view: StatementsView, router: StatementsRouter) {
        self.view = view
        self.router = router
    }
    
    func viewDidLoad() {
        configureDataSource()
        constructDataSource()
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
                        rows: [ self.statementRow(),
                                self.statementRow(),
                                self.statementRow()]
                )]
            )
        }
    }
    
    private func constructDataSourceForLargeStatement() {
        DispatchQueue.main.async {
            self.tableViewDataSource?.reload(
                with: [
                    ListSection.init(
                        id: "",
                        rows: [ self.largestatementRow(),
                                self.backNavigateLabelRow()]
                )]
            )
        }
    }
    
    private func clickableLabel(with model: TiTleButtonTableCell.ViewModel) -> ListRow<TiTleButtonTableCell> {
        ListRow(model: model,
    height: UITableView.automaticDimension,
    tapClosure: nil)
    }
    
    private func statementRow() -> ListRow <TitleAndDescriptionCardTableCell>{
        ListRow(
            model: TitleAndDescriptionCardTableCell
                .Model(headerModel:
                        HeaderWithDetailsCell.Model(
                            icon: Resourcebook.Image.Icons24.channelServiceCenter.template,
                            title: "სელებრითები",
                            description: "ავთო ცქვიტინიძის ქორწილი"),
                       cardModel: .init(title: "სიახლე",
                                        description: "ავთო ცქვიტინიძის ქორწილში დიდი მოვლენები გავითარდა. ჩართეთ დაგაიგეთ მეტი წყვილის შესახებ")),
            
            height: UITableView.automaticDimension,
            tapClosure: {_,_ in
                self.constructDataSourceForLargeStatement()
            })
    }
    
    private func largestatementRow() -> ListRow <TitleAndDescriptionCardTableCell>{
        ListRow(
            model: TitleAndDescriptionCardTableCell.Model(headerModel: HeaderWithDetailsCell.Model(icon: Resourcebook.Image.Icons24.channelServiceCenter.template,
                                                                                                        title: "სელებრითები",
                                                                                                   description: "ავთო ცქვიტინიძის ქორწილი"), cardModel: .init(title: "სიახლე",
                                                                                                                                                              icon: Resourcebook.Image.Icons24.cardDebitOutline.image, 
                                                                                                                                                                                                                                   description: "ავთო ცქვიტინიძის ქორწილში დიდი მოვლენები გავითარდა. ჩართეთ დაგაიგეთ მეტი წყვილის შესახებ, ავთო ცქვიტინიძის ქორწილში დიდი მოვლენები გავითარდა. ჩართეთ დაგაიგეთ მეტი წყვილის შესახებ, ავთო ცქვიტინიძის ქორწილში დიდი მოვლენები გავითარდა. ჩართეთ დაგაიგეთ მეტი წყვილის შესახებ, ავთო ცქვიტინიძის ქორწილში დიდი მოვლენები გავითარდა. ჩართეთ დაგაიგეთ მეტი წყვილის შესახებ, ავთო ცქვიტინიძის ქორწილში დიდი მოვლენები გავითარდა. ჩართეთ დაგაიგეთ მეტი წყვილის შესახებ, ავთო ცქვიტინიძის ქორწილში დიდი მოვლენები გავითარდა. ჩართეთ დაგაიგეთ მეტი წყვილის შესახებ , ავთო ცქვიტინიძის ქორწილში დიდი მოვლენები გავითარდა. ჩართეთ დაგაიგეთ მეტი წყვილის შესახებ")),
            height: UITableView.automaticDimension)
    }
    
    private func backNavigateLabelRow() -> ListRow<TiTleButtonTableCell>  {
        self.clickableLabel(with: .init(
            title: "უკან დაბრუნება",
            onTap: { _ in
                self.constructDataSource()
            }))
    }
}


