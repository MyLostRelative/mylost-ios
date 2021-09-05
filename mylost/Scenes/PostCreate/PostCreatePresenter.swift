//
//  PostCreatePresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import UIKit

protocol PostCreateView: AnyObject {
    var tableView: UITableView {get}
}

protocol PostCreatePresenter {
    func viewDidLoad()
    func attach(view: PostCreateView)
}

class PostCreatePresenterImpl: PostCreatePresenter {
    
    private weak var view: PostCreateView?
    private var router: PostCreateRouter
    private var tableViewDataSource: ListViewDataSource?
    private var titleField: LoginTextFieldTableCell?
    private var cityField: LoginTextFieldTableCell?
    private var bloodType: String?
    private var gender: String?
    
    init(router: PostCreateRouter) {
        self.router = router
    }
    
    func viewDidLoad() {
        configureDataSource()
        constructDataSource()
    }
    
    func attach(view: PostCreateView) {
        self.view = view
    }
    
    private func configureDataSource() {
        self.view.unwrap { v in
            tableViewDataSource = ListViewDataSource.init(
                tableView: v.tableView,
                withClasses: [
                    HeaderWithDetailsCell.self,
                    TitleAndDescriptionCardTableCell.self,
                    TiTleButtonTableCell.self,
                    LoginTextFieldTableCell.self,
                    PickerViewCell.self,
                    LoginTextFieldTableCell.self,
                    RoundedTextFieldTableCell.self
                ])
        }
    }
    
    
    private func constructDataSource() {
        DispatchQueue.main.async {
            self.tableViewDataSource?.reload(
                with: [self.mainSection()]
            )
        }
    }
}

//MARK: Table Section
extension PostCreatePresenterImpl {
    private func mainSection()-> ListSection {
        let titleRow = textField(with: .init(title: "განცხადების სახელი", onTap: { field in
            self.titleField = field
        }))
        let cityRow = textField(with: .init(title: "ქალაქი", onTap: { field in
            self.cityField = field
        }))
        return ListSection(id: "", rows: [backNavigateLabelRow(),
                                          titleRow,
                                          cityRow,
                                          pickerRowSex() ,
                                          pickerRowBloodType(),
                                          postField()])
    }
}

//MARK: Table Rows
extension PostCreatePresenterImpl {
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
    
    private func textField(with model: LoginTextFieldTableCell.Model) -> ListRow <LoginTextFieldTableCell> {
        ListRow(model: model, height: UITableView.automaticDimension)
    }
    
    private func pickerRowSex() -> ListRow <PickerViewCell>{
        ListRow(
            model: PickerViewCell.ViewModel(title: "სქესი", pickerData: [["მდედრობითი", "მამრობითი"]], onTap:  {
                pickers in
                self.gender = pickers.first
            }),
            height: UITableView.automaticDimension)
    }
    
    private func pickerRowBloodType() -> ListRow <PickerViewCell>{
        ListRow(
            model: PickerViewCell.ViewModel(title: "სისხლის ტიპი", pickerData: [["a", "b", "ab"]], onTap:  {
                pickers in
                self.bloodType = pickers.first
            }),
            height: UITableView.automaticDimension)
    }
    
    
    private func postField() -> ListRow <RoundedTextFieldTableCell>{
        ListRow(model: RoundedTextFieldTableCell.Model(placeHolderText: "დაწერეთ",
                                                       title: "დაპოსტვა",
                                                       onTap: { (field) in
                                                        let params = ["title":  self.titleField?.getText(),
                                                                      "city": self.cityField?.getText(),
                                                                      "bloodType": self.bloodType,
                                                                      "gender": self.gender,
                                                                      "detail": field.getText()
                                                        ]
                                                        
                                                       }),
                height: UITableView.automaticDimension)
    }
}
