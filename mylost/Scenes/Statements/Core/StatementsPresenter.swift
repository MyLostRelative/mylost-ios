//
//  StatementsPresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import UIKit

protocol StatementsView: AnyObject {
    var tableView: UITableView {get}
    func displayBanner(type: Bannertype, title: String, description: String)
}

protocol StatementsPresenter {
    func viewDidLoad()
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
    
    private func configureDataSource() {
        self.view.unwrap { v in
            tableViewDataSource = ListViewDataSource.init(
                tableView: v.tableView,
                withClasses: [
                    HeaderWithDetailsCell.self,
                    TitleAndDescriptionCardTableCell.self,
                    TiTleButtonTableCell.self,
                    CardAnimationTableCell.self,
                    PageDescriptionTableCell.self
                ])
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
    
    private func animationState()-> [ListSection] {
        [ListSection(
            id: "",
            rows: [self.cardAnimation(), self.cardAnimation(),  self.cardAnimation()] )]
    }
    
    private func emptyState() -> [ListSection]{
        [ListSection(
            id: "",
            rows:  [emptyPageDescriptionRow()])]
    }
    
    private func errorState() -> [ListSection]{
        [ListSection(
            id: "",
            rows:  [errorPageDescriptionRow()])]
    }
}


//MARK: Services
extension StatementsPresenterImpl {
    private func fetchBlogsList() {
        self.blogGateway.getBlogList { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false
            switch result{
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

//MARK: Table Rows
extension StatementsPresenterImpl {
    
    private func cardAnimation() -> ListRow <CardAnimationTableCell>{
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
            rows: blogRows
        )
    }
    
    private func blogRow(blog: Blog) -> ListRow <TitleAndDescriptionCardTableCell>{
        ListRow(
            model: TitleAndDescriptionCardTableCell
                .Model(headerModel:
                        HeaderWithDetailsCell.Model(
                            icon: .withURL(url: URL(string: blog.imageUrl ?? "")),
                            title:  blog.statementTitle,
                            info1: (blog.createDate ?? "").convertedDate, 
                            description: nil),
                       cardModel: .init(title: blog.statementDescription.suffix(15).base + "...",
                                        description: nil)),
            
            height: UITableView.automaticDimension,
            tapClosure: {row,_ in
                self.router.move2BlogDetails(blog: self.blogs[row])
            })
    }
    
    private func backNavigateLabelRow() -> ListRow<TiTleButtonTableCell>  {
        self.clickableLabelRow(with: .init(
            title: "უკან დაბრუნება",
            onTap: { _ in
                self.constructDataSource()
            }))
    }
    
    private func emptyPageDescriptionRow() -> ListRow <PageDescriptionTableCell>{
        ListRow(
            model: modelBuilder.getEmptyPageDescription,
            height: UITableView.automaticDimension)
    }
    
    
    private func errorPageDescriptionRow() -> ListRow <PageDescriptionWithButtonTableCell>{
        ListRow(
            model: modelBuilder.getErrorPgaeDescription(tap: { (_) in
                self.retry()
            }),
            height: UITableView.automaticDimension)
    }
}

