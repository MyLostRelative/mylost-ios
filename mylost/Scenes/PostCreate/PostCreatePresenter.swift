//
//  PostCreatePresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import UIKit
import Core
import Components

protocol PostCreateView: AnyObject {
    var tableView: UITableView {get}
    func displayBanner(type: Bannertype, title: String, description: String)
}

protocol PostCreatePresenter {
    func viewDidLoad()
    func attach(view: PostCreateView)
}

class PostCreatePresenterImpl: PostCreatePresenter {
    
    private weak var view: PostCreateView?
    private var router: PostCreateRouter
    private let statementPostGateway: StatementPostGateway
    private let userID: Int
    private var tableViewDataSource: ListViewDataSource?
    private var titleField: LoginTextFieldTableCell?
    private var cityField: LoginTextFieldTableCell?
    private var imageField: LoginTextFieldTableCell?
    private var bloodType: Int?
    private var gender: Int?
    private var relative: Int?
    private var tapHappend: Bool = false
    private var pickerManager: PickerDataManager = PickerDataManagerImpl()
    private weak var myProfileDelegate: MyProfilePresenterDelegate?
    
    init(router: PostCreateRouter,
         statementPostGateway: StatementPostGateway,
         userID: Int,
         myProfileDelegate: MyProfilePresenterDelegate?) {
        self.router = router
        self.statementPostGateway = statementPostGateway
        self.userID = userID
        self.myProfileDelegate = myProfileDelegate
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

// MARK: Service Call
extension PostCreatePresenterImpl {
    private func postStatement(statementPost: StatementPost) {
        self.statementPostGateway.postStatementPost(params: statementPost.toJSON()) { result in
            switch result {
            case .success(_):
                self.postStatementSucceded()
            case .failure(_):
                self.view?.displayBanner(type: .negative,
                                         title: "დაფიქსირდა შეცდომა",
                                         description: "თქვენ ვერ დაამატეთ პოსტი , სცადეთ მოგვიანებით")
            }
            
        }
    }
    
    private func postStatementSucceded() {
        self.view?.displayBanner(type: .positive,
                                 title: "წარმატებით დასრულდა",
                                 description: "თქვენი პოსტი წარმატებით დაემატა")
        self.myProfileDelegate?.MyProfilePresenterUpdate(self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.router.moveToback()
        }
    }
}

// MARK: Table Section
extension PostCreatePresenterImpl {
    private func mainSection() -> ListSection {
        let titleRow = textField(with: .init(title: "განცხადების სახელი", onTap: { field in
            self.titleField = field
        }))
        let cityRow = textField(with: .init(title: "ქალაქი", onTap: { field in
            self.cityField = field
        }))
        let imageURLRow = textField(with: .init(title: "სურათის URL", onTap: { field in
            self.imageField = field
        }))
        return ListSection(id: "", rows: [backNavigateLabelRow(),
                                          titleRow,
                                          cityRow,
                                          imageURLRow,
                                          pickerRow(type: .bloodType) ,
                                          pickerRow(type: .relativeType),
                                          pickerRow(type: .sexType),
                                          postField()])
    }
}

// MARK: Table Rows
extension PostCreatePresenterImpl {
    private func clickableLabelRow(with model: TiTleButtonTableCell.ViewModel) -> ListRow<TiTleButtonTableCell> {
        ListRow(model: model,
                height: UITableView.automaticDimension)
    }
    
    private func backNavigateLabelRow() -> ListRow<TiTleButtonTableCell> {
        self.clickableLabelRow(with: .init(
            title: "უკან დაბრუნება",
            onTap: { _ in
                self.router.moveToback()
            }))
    }
    
    private func textField(with model: LoginTextFieldTableCell.Model) -> ListRow <LoginTextFieldTableCell> {
        ListRow(model: model, height: UITableView.automaticDimension)
    }
    
    private func pickerRow(type: PickerDataManagerImpl.PickerType) -> ListRow <PickerViewCell> {
        ListRow(
            model: PickerViewCell.ViewModel(title: type.title,
                                            pickerData: [type.data],
                                            onTap: { pickers in
                                                self.didChangePicker(type: type, pickers: pickers)
                                            }),
            height: UITableView.automaticDimension)
    }
    
    private func postField() -> ListRow <RoundedTextFieldTableCell> {
        ListRow(model: RoundedTextFieldTableCell.Model(placeHolderText: "დაწერეთ",
                                                       title: "დაპოსტვა",onTap: { (field) in
                                                        if !self.tapHappend {
                                                            self.tapHappend = true
                                                            self.didTapPost(field: field)
                                                        }
                                                       }),
                height: UITableView.automaticDimension)
    }
}

// MARK: Taps
extension PostCreatePresenterImpl {
    private func didChangePicker(type: PickerDataManagerImpl.PickerType, pickers: [String]) {
        let index = self.pickerManager.getIntType(with: type,
                                                  chooseValue: pickers.first ?? "")
        switch type {
        case .bloodType:
            self.bloodType = index
        case .relativeType:
            self.relative = index
        case .sexType:
            self.gender = index
        case .city:
            break
        case .age:
            break
        }
    }
    
    private func didTapPost(field: RoundedTextField) {
        guard let title = self.titleField?.getText(),
              let description = field.getText() else {
            self.view?.displayBanner(type: .negative,
                                     title: "არავალიდურია",
                                     description: "სათაური და აღწერა სავალდებულოა")
            return
        }
       let entity = StatementPost(userID: self.userID,
                      title: title,
                      description: description,
                      imageUrl: imageField?.getText(),
                      gender: self.gender,
                      city: self.cityField?.getText(),
                      relationType: self.relative,
                      bloodType: self.bloodType)
        self.postStatement(statementPost: entity)
       }
}
