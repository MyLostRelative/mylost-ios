//
//  StatementsPresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import UIKit
import RxRelay
import Core
import Components

protocol StatementsView: AnyObject {
    var tableView: UITableView {get}
    func displayBanner(type: Bannertype, title: String, description: String)
}

protocol StatementsPresenter {
    func viewDidLoad()
    func viewWillAppear()
}

class StatementsPresenterImpl: StatementsPresenter {
    
    private weak var view: StatementsView?
    private var router: StatementsRouter
    private var tableViewDataSource: ListViewDataSource?
    private let blogGateway: BlogGateway
    private var blogFetchFailed: Bool = false
    private var isLoading: Bool = true
    private var blogs: [Blog] = []
    private let modelBuilder = ModelBuilder()
    private var readedBlogs: BehaviorRelay<[Blog]> = BehaviorRelay(value: [])
    
    init(view: StatementsView, router: StatementsRouter, blogGateway: BlogGateway) {
        self.view = view
        self.router = router
        self.blogGateway = blogGateway
    }
    
    func viewDidLoad() {
        fetchBlogsList()
        configureDataSource()
        constructDataSource()
    }
    
    func viewWillAppear() {
        constructDataSource()
    }
    
    private func configureDataSource() {
        self.view.unwrap { v in
            tableViewDataSource = ListViewDataSource.init(
                tableView: v.tableView,
                withClasses: [
                    HeaderWithDetailsCell.self,
                    TitleAndDescriptionCardTableCell.self,
                    TiTleButtonTableCell.self,
                    CardAnimationTableCell.self,
                    PageDescriptionTableCell.self,
                    MaterialChipsTableCell.self
                ], reusableViews: [TitleHeaderCell.self])
        }
    }
    
    private func retry() {
        self.isLoading = true
        self.blogFetchFailed = false
        self.constructDataSource()
        self.fetchBlogsList()
    }
    
    private func constructDataSource() {
        let stateDependent =  self.isLoading ? animationState() :
            self.blogFetchFailed ? errorState() :
            self.blogs.isEmpty ? emptyState() :
        [self.cardsSection()]
            
        DispatchQueue.main.async {
            self.tableViewDataSource?.reload(
                with: stateDependent
            )
        }
    }
    
    private func animationState() -> [ListSection] {
        [ListSection(
            id: "",
            rows: [self.cardAnimation(), self.cardAnimation(),  self.cardAnimation()] )]
    }
    
    private func emptyState() -> [ListSection] {
        [ListSection(
            id: "",
            rows:  [emptyPageDescriptionRow()])]
    }
    
    private func errorState() -> [ListSection] {
        [ListSection(
            id: "",
            rows:  [errorPageDescriptionRow()])]
    }
}

// MARK: Services
extension StatementsPresenterImpl {
    private func fetchBlogsList() {
        self.blogGateway.getBlogList { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let statements):
                self.blogsFetchSuccess(statements)
            case .failure(let err):
                self.blogsFetchFailed(err)
            }
        }
    }
    
    private func blogsFetchSuccess(_ blogs: [Blog]) {
        self.blogFetchFailed = false
        self.blogs = blogs
        self.constructDataSource()
    }
    
    private func blogsFetchFailed(_ error: Error) {
        self.blogFetchFailed = true
        self.view?.displayBanner(type: .negative, title: "ოპერაცია წარმატებით შესრულდა",
                                  description: error.localizedDescription)
        self.constructDataSource()
    }
}

// MARK: - Table Rows
extension StatementsPresenterImpl {
    
    private func cardAnimation() -> ListRow <CardAnimationTableCell> {
        ListRow(
            model: "",
            height: UITableView.automaticDimension)
    }
    
    private func clickableLabelRow(with model: TiTleButtonTableCell.ViewModel) -> ListRow<TiTleButtonTableCell> {
        ListRow(model: model,
                height: UITableView.automaticDimension)
    }
    
    private func cardsSection() -> ListSection {
        let blogRows = blogs.map({blogRow(blog: $0)})
        return ListSection.init(
            id: "",
            rows: [self.readedBlogsLabel()] + blogRows
        )
    }
    
    private func blogRow(blog: Blog) -> ListRow <TitleAndDescriptionCardTableCell> {
        let isReaded = self.readedBlogs.value.contains(where: { $0 == blog })
        return ListRow(
            model: TitleAndDescriptionCardTableCell
                .Model(headerModel:
                        HeaderWithDetailsCell.Model(
                            icon: .withURL(url: URL(string: blog.imageUrl ?? "")),
                            title:  blog.statementTitle,
                            info1: (blog.createDate ?? "").convertedDate, 
                            description: nil,
                            rightIcon: .init(
                                rightIconIsActive: isReaded,
                                rightIconActive: Resourcebook.Image.Icons24.contactsEmailCloseFill.image,
                                rightIconDissable: Resourcebook.Image.Icons24.contactsEmailCloseOutline.image,
                                rightIconHide: false,
                                onTap: { _ in
                                    self.setReaded(becomeReaded: !isReaded,
                                              blog: blog)
                                })),
                       cardModel: .init(title: blog.statementDescription.suffix(15).base + "...",
                                        description: nil)),
            
            height: UITableView.automaticDimension,
            tapClosure: {row,_,_  in
                self.setReaded(becomeReaded: true, blog: self.blogs[row - 1])
                self.router.move2BlogDetails(blog: self.blogs[row - 1])
            })
    }
    
    // FAKE SERVICE
    private func setReaded(
        success: Bool = true,
        becomeReaded: Bool,
        blog: Blog) {
            if success {
                if becomeReaded {
                    self.readedBlogs.accept(self.readedBlogs.value + [blog])
                } else {
                    let removedFav = self.readedBlogs.value.filter({ $0 != blog })
                    self.readedBlogs.accept(removedFav)
                }
                constructDataSource()
            } else {
                
            }
        }
    
    private func readedBlogsLabel() -> ListRow<TiTleButtonTableCell> {
        self.clickableLabelRow(with: .init(
            title: "წაკითხული ბლოგების ნახვა",
            onTap: { _ in
                self.router.move2ReadedBlogs(readedBlogs: self.readedBlogs)
            }))
    }
    
    private func emptyPageDescriptionRow() -> ListRow <PageDescriptionTableCell> {
        ListRow(
            model: modelBuilder.getEmptyPageDescription,
            height: UITableView.automaticDimension)
    }
    
    private func errorPageDescriptionRow() -> ListRow <PageDescriptionWithButtonTableCell> {
        ListRow(
            model: modelBuilder.getErrorPgaeDescription(tap: { (_) in
                self.retry()
            }),
            height: UITableView.automaticDimension)
    }
}
