//  
//  FilterDetailsPresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 06.09.21.
//

import UIKit

protocol FilterDetailsPresenterDelegate: AnyObject {
    func FilterDetailsPresenterDelegate(filter with: StatementSearchEntity)
}

protocol FilterDetailsView: AnyObject {
    var tableView: UITableView {get}
    func displayBanner(type: Bannertype, title: String, description: String)
}

protocol FilterDetailsPresenter {
    func viewDidLoad()
    func attach(view: FilterDetailsView)
}

class FilterDetailsPresenterImpl: FilterDetailsPresenter {
    
    private weak var view: FilterDetailsView?
    private var router: FilterDetailsRouter
    private var tableViewDataSource: ListViewDataSource?
    private weak var delegate: FilterDetailsPresenterDelegate?
    private let manager: PickerDataManager = PickerDataManagerImpl()
    
    init(router: FilterDetailsRouter,
         delegate: FilterDetailsPresenterDelegate?) {
        self.router = router
        self.delegate = delegate
    }
    
    func viewDidLoad() {
        configureDataSource()
        constructDataSource()
    }
    
    func attach(view: FilterDetailsView) {
        self.view = view
    }
    
    private func configureDataSource() {
        self.view.unwrap { v in
            tableViewDataSource = ListViewDataSource.init(
                tableView: v.tableView,
                withClasses: [
                    TiTleButtonTableCell.self,
                    PickerViewCell.self,
                    RoundButtonTableCell.self
                ])
        }
    }
    
    
    private func constructDataSource() {
        DispatchQueue.main.async {
            self.tableViewDataSource?.reload(
                with: [self.filterSection()]
            )
        }
    }
    
}


//MARK: Table Rows
extension FilterDetailsPresenterImpl {
    private func clickableLabelRow(with model: TiTleButtonTableCell.ViewModel) -> ListRow<TiTleButtonTableCell> {
        ListRow(model: model,
                height: UITableView.automaticDimension)
    }
    
    private func backNavigateLabelRow() -> ListRow<TiTleButtonTableCell>  {
        self.clickableLabelRow(with: .init(
            title: "უკან დაბრუნება",
            onTap: { _ in
                self.router.moveToback()
            }))
    }
    
    private func buttonRow( ) -> ListRow <RoundButtonTableCell> {
        ListRow(
            model: .init(title: "გაფილტვრა", onTap: { _ in
                self.delegate?.FilterDetailsPresenterDelegate(filter: self.manager.statementSearchEntity)
                self.router.moveToback()
            }),
            height: UITableView.automaticDimension)
    }
    
    private func pickerRow(type: PickerDataManagerImpl.PickerType) -> ListRow <PickerViewCell> {
        ListRow(
            model: PickerViewCell.ViewModel(title: type.title,
                                            pickerData: type.vectorData,
                                            onTap:  {
                                                pickers in
                                                self.manager.addPickerTypeToDict(type: type, data: pickers)
                                            }),
            height: UITableView.automaticDimension)
    }
    
    private func filterSection() -> ListSection {
        ListSection(
            id: "",
            rows:  [backNavigateLabelRow(),
                    pickerRow(type: .relativeType),
                    pickerRow(type: .sexType),
                    pickerRow(type: .age),
                    pickerRow(type: .bloodType),
                    pickerRow(type: .city),
                    buttonRow()])
    }
    
}
