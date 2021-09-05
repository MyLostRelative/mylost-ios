//
//  MyProfilePresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 01.09.21.
//

import UIKit

protocol MyProfilePresenter {
    func viewDidLoad()
    func attach(view: MyProfileView)
}

class MyProfilePresenterImpl: MyProfilePresenter {
    
    private weak var view: MyProfileView?
    private var tableViewDataSource: ListViewDataSource?
    private let router: MyProfileRouter
    
    init(router: MyProfileRouter) {
        self.router = router
    }
    
    func attach(view: MyProfileView) {
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
                    LoginTextFieldTableCell.self,
                    PageDescriptionTableCell.self,
                    TiTleButtonTableCell.self,
                    RoundedButtonTableCell.self,
                    SavedUserTableCell.self,
                    RoundedTextFieldTableCell.self
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
    
    private func userCardRow() -> ListRow <SavedUserTableCell>  {
        ListRow(model: .init(avatar: Resourcebook.Image.Icons24.accountsAccounts.image,
                             username: "Nato Egnatashvili",
                             buttonTitle: "პროფილი") { cell in
            self.router.move2ProfileDetails()
            
        },
                height: UITableView.automaticDimension)
    }
    
    private func pageDescriptionRow() -> ListRow <PageDescriptionTableCell>  {
        ListRow(model: PageDescriptionTableCell.Model(imageType: (image: Resourcebook.Image.Icons24.channelPaybox.template,
                                                                  tint: Resourcebook.Color.Positive.solid300.uiColor),
                                                      title: "My Lost",
                                                      description: "გაიარეთ რეგისტრაცია ან დალოგინდით"),
                height: UITableView.automaticDimension)
    }
    
    private func textField(with model: LoginTextFieldTableCell.Model) -> ListRow <LoginTextFieldTableCell> {
        ListRow(model: model, height: UITableView.automaticDimension)
    }
    
    private func button(with model: RoundedButtonTableCell.ViewModel) -> ListRow<RoundedButtonTableCell> {
        ListRow(model: model,
                height: UITableView.automaticDimension)
    }
    
    private func clickableLabel(with model: TiTleButtonTableCell.ViewModel) -> ListRow<TiTleButtonTableCell> {
        ListRow(model: model,
    height: UITableView.automaticDimension)
    }
}

//MARK: Sign Up Section
extension MyProfilePresenterImpl {
    private func cardsSection() -> ListSection{
        return ListSection.init(
            id: "",
            rows: [self.userCardRow(), 
                   self.textfield()] )
    }
    
    private func textfield() -> ListRow <RoundedTextFieldTableCell>{
        ListRow(model: RoundedTextFieldTableCell.Model(placeHolderText: "დაწერეთ",
                                                       title: "დაპოსტვა",
                                                       onTap: { (field) in
                                                        print(field.getText())
                                                       }),
                height: UITableView.automaticDimension)
    }
    
}
