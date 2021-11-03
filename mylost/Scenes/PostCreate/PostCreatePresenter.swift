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
                    RoundedTextFieldTableCell.self,
                    PickerViewCell.self,
                    RoundButtonTableCell.self,
                    MaterialChipsTableCell.self,
                    TwoInputTableCell.self
                ], reusableViews: [TitleHeaderCell.self])
        }
    }
    
    private func constructDataSource() {
        DispatchQueue.main.async {
            self.tableViewDataSource?.reload(
                with: [self.textFieldSection()] + self.chipsSections() + [self.postFieldSection()]
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
    private func textFieldSection() -> ListSection {
        let titleRow = textField(with: .init(title: "განცხადების სახელი", onTap: { field in
            self.titleField = field
        }))
        let cityRow = textField(with: .init(title: "ქალაქი", onTap: { field in
            self.cityField = field
        }))
        let imageURLRow = textField(with: .init(title: "სურათის URL", onTap: { field in
            self.imageField = field
        }))
        return ListSection(id: "", rows: [
                                          titleRow,
                                          cityRow,
                                          imageURLRow])
    }
}

// MARK: Table Rows
extension PostCreatePresenterImpl {
    private func postFieldSection() -> ListSection {
        ListSection(id: "postField",
                    rows: [postField()])
    }
    
    private func textField(with model: LoginTextFieldTableCell.Model) -> ListRow <LoginTextFieldTableCell> {
        ListRow(model: model, height: UITableView.automaticDimension)
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
    
    private func chipsSections() -> [ListSection] {
        [self.chipsSection(type: .bloodType),
         self.chipsSection(type: .relativeType),
         self.chipsSection(type: .sexType)]
    }
    
    private func chipsSection(type: PickerDataManagerImpl.PickerType) -> ListSection {
        ListSection(id: "chips",
                    header: customHeader(title: type.title),
                    rows: [chipsRow(type: type, data: type.vectorData[0])])
    }
    
    private func chipAgeSection() -> ListSection {
        let type = PickerDataManagerImpl.PickerType.age
        return ListSection(id: "age inputs",
                    header: customHeader(title: type.title),
                    rows: [ageInputField()])
    }
    
    private func customHeader(title: String) -> ListViewHeaderFooter <TitleHeaderCell> {
        return ListViewHeaderFooter(model: TitleHeaderCell.ViewModel(title: title),
                                    height: UITableView.automaticDimension)
    }
    
    private func chipsRow(type: PickerDataManagerImpl.PickerType, data: [String]) -> ListRow <MaterialChipsTableCell> {
        return ListRow(
            model: .init(chipTitles: data, onTap: { [weak self] chip in
                self?.didChangePicker(type: type, pickers: [chip])
            }),
                       height: 90)
    }
    
    private func ageInputField() -> ListRow <TwoInputTableCell> {
        ListRow(model: .init(firstInputPlaceHolder: "From",
                             secondInputPlaceHolder: "To",
                             delegate: self),
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

extension PostCreatePresenterImpl: TwoInputTableCellDelegate {
    func TwoInputTableCellDelegate(_ cell: TwoInputTableCell, firstText: String, secondText: String) {
        self.didChangePicker(type: .age, pickers: [firstText, secondText])
    }
}
