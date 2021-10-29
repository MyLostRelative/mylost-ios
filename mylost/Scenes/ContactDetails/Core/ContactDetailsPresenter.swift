//  
//  ContactDetailsPresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 06.09.21.
//
import UIKit
import Core
import Components

protocol ContactDetailsView: AnyObject {
    var tableView: UITableView {get}
    func displayBanner(type: Bannertype, title: String, description: String)
    func setImg(with url: String)
}

protocol ContactDetailsPresenter {
    func viewDidLoad()
    func attach(view: ContactDetailsView)
}

class ContactDetailsPresenterImpl: ContactDetailsPresenter {
    
    private weak var view: ContactDetailsView?
    private var router: ContactDetailsRouter
    private let guestImgUrl: String?
    private var tableViewDataSource: ListViewDataSource?
    private let guestUserID: Int
    private var guestUserInfo: GuestUserInfo?
    private let userInfoGateway: UserInfoGateway
    private var isLoading: Bool = true
    
    init(router: ContactDetailsRouter,
         guestUserID: Int,
         guestImgUrl: String?,
         userInfoGateway: UserInfoGateway) {
        self.router = router
        self.guestUserID = guestUserID
        self.userInfoGateway = userInfoGateway
        self.guestImgUrl = guestImgUrl
    }
    
    func viewDidLoad() {
        fetchGuestUserInfo()
        setImg()
        configureDataSource()
        constructDataSource()
    }
    
    func attach(view: ContactDetailsView) {
        self.view = view
    }
    
    private func configureDataSource() {
        self.view.unwrap { v in
            tableViewDataSource = ListViewDataSource.init(
                tableView: v.tableView,
                withClasses: [
                    TiTleButtonTableCell.self,
                    RowItemTableCell.self,
                    PageDescriptionTableCell.self,
                    CardAnimationTableCell.self
                ])
        }
    }
    
    
    private func constructDataSource() {
        let state: [ListSection] = isLoading ? [mainSection(),  cardAnimationSection()] :
            [self.mainSection(), self.rowItemSection()]
        DispatchQueue.main.async {
            self.tableViewDataSource?.reload(
                with: state
            )
        }
    }
    
    private func fetchGuestUserInfo() {
        self.userInfoGateway.getUser(userID: guestUserID) { [weak self] result in
            self?.isLoading = false
            switch result{
            case .success(let resp):
                self?.guestUserInfo = resp.getGuestUserInfo()
                self?.constructDataSource()
            case .failure(_):
                self?.view?.displayBanner(type: .negative,
                                         title: "დაფიქსირდა შეცდომა",
                                         description: "თქვენ ვერ დაამატეთ პოსტი , სცადეთ მოგვიანებით")
            }
        }
    }
    
    private func setImg() {
        guard let guestImg = self.guestImgUrl else { return }
        self.view?.setImg(with: guestImg)
    }
}


//MARK: Table Section
extension ContactDetailsPresenterImpl {
    private func mainSection()-> ListSection {
        return ListSection(id: "", rows: [ pageDescriptionRow() ])
    }
}

//MARK: Table Rows
extension ContactDetailsPresenterImpl {
    private func rowItemSection() -> ListSection {
        var rowItems: [ListRow <RowItemTableCell> ] = []
        if let name = guestUserInfo?.firstName,
            let mobileNumber = guestUserInfo?.mobileNumber,
              let email = guestUserInfo?.email {
            rowItems.append(self.rowItem(model: .init(title: "სახელი", description: name)))
            rowItems.append(self.rowItem(model: .init(title: "ტელეფონი", description: mobileNumber)))
      
            rowItems.append(self.rowItem(model: .init(title: "მეილი", description: email )))
        }
        
        return ListSection(id: "", rows: rowItems)
    }
    
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
    
    private func rowItem(model: RowItem.ViewModel) -> ListRow <RowItemTableCell> {
        ListRow(model: model,
                height: UITableView.automaticDimension)
    }
    
    private func pageDescriptionRow() -> ListRow <PageDescriptionTableCell>  {
        ListRow(model: PageDescriptionTableCell.Model(imageType: (image: Resourcebook.Image.Icons24.contactsContacts.template,
                                                                  tint: Resourcebook.Color.Information.solid300.uiColor),
                                                      title: "დაკონტაქტება",
                                                      description: "დაუკავშირდით მეილით ან მობილურით"),
                height: UITableView.automaticDimension)
    }
    
    private func cardAnimationSection() -> ListSection {
        ListSection(id: "",
                    rows: [self.cardAnimationRow(), cardAnimationRow()])
    }

    private func cardAnimationRow() -> ListRow <CardAnimationTableCell>{
        ListRow(
            model: "",
            height: UITableView.automaticDimension)
    }
    
}
