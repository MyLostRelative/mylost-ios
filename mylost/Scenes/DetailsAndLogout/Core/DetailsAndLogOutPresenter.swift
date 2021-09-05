//  
//  DetailsAndLogOutPresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 04.09.21.
//


import UIKit

protocol DetailsAndLogOutPresenter {
    func viewDidLoad()
    func attach(view: DetailsAndLogOutView)
}

class DetailsAndLogOutPresenterImpl: DetailsAndLogOutPresenter {
    
    private weak var view: DetailsAndLogOutView?
    private var tableViewDataSource: ListViewDataSource?
    private var router: DetailsAndLogOutRouter
    
    init(router: DetailsAndLogOutRouter) {
        self.router = router
    }
    
    func attach(view: DetailsAndLogOutView) {
        self.view = view
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
                    PageDescriptionTableCell.self,
                    TiTleButtonTableCell.self,
                    RowItemTableCell.self
                ])
        }
    }
    
    private func constructDataSource() {
        DispatchQueue.main.async {
            self.tableViewDataSource?.reload(
                with: [self.cardsSection()]
            )
        }
    }
    
    private func pageDescriptionRow() -> ListRow <PageDescriptionTableCell>  {
        ListRow(model: PageDescriptionTableCell.Model(imageType: (image: Resourcebook.Image.Icons24.channelPaybox.template,
                                                                  tint: Resourcebook.Color.Information.solid300.uiColor),
                                                      title: nil,
                                                      description: "ნატო ეგნატაშვილი"),
                height: UITableView.automaticDimension)
    }

    private func rowItem(model: RowItem.ViewModel) -> ListRow <RowItemTableCell> {
        ListRow(model: model,
                height: UITableView.automaticDimension)
    }
    
    private func clickableLabel(with model: TiTleButtonTableCell.ViewModel) -> ListRow<TiTleButtonTableCell> {
        ListRow(model: model,
                height: UITableView.automaticDimension)
    }
}

//MARK: Sign Up Section
extension DetailsAndLogOutPresenterImpl {
    private func cardsSection() -> ListSection{
        return ListSection.init(
            id: "",
            rows: [clickableLabel(with: .init(title: "უკან დაბრუნება",   onTap: { _ in
                self.router.backToProfile()
               })), self.pageDescriptionRow(),
                   self.rowItem(model: .init(title: "ასაკი", description: "22")),
            self.rowItem(model: .init(title: "სქესი", description: "მდედრობითი")),
            self.rowItem(model: .init(title: "მეილი", description: "negna16@freeuni.edu.ge")),
            self.rowItem(model: .init(title: "ტელეფონი", description: "597726269")),
                   clickableLabel(with: .init(title: "გასვლა", colorStyle: .negative,  onTap: { _ in
                    UserDefaultManager().removeValue(key: "token")
                    self.router.changeToLogOut()
                   }))] )
    }
    
}
