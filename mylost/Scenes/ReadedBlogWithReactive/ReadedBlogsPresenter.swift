//  
//  BlogDetailsReactivePresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 26.10.21.
//

import RxSwift
import RxRelay

protocol ReadedBlogsView: AnyObject {
    var viewModel: FavouriteViewModel { get }
    func displayBanner(type: Bannertype, title: String, description: String)
}

protocol ReadedBlogsPresenter {
    func viewDidLoad()
    func attach(view: ReadedBlogsView)
}

class ReadedBlogsPresenterImpl: ReadedBlogsPresenter {
    
    private weak var view: ReadedBlogsView?
    private var router: ReadedBlogsRouter
    private var tableViewDataSource: ListViewDataSource?
    private var readedBlogs: BehaviorRelay<[Blog]>
    private var readedBlogsFactory: ReadedBlogsFactory
    init(router: ReadedBlogsRouter,
         readedBlogsFactory: ReadedBlogsFactory,
         readedBlogs: BehaviorRelay<[Blog]>) {
        self.router = router
        self.readedBlogs = readedBlogs
        self.readedBlogsFactory = readedBlogsFactory
    }
    
    func attach(view: ReadedBlogsView ) {
        self.view = view
    }
    
    func viewDidLoad() {
        configureDataSource()
    }
}

extension ReadedBlogsPresenterImpl {
    private func configureDataSource() {
        let models = readedBlogs.value.map({ blog in
            self.readedBlogsFactory.getTitleAndDescription(blog: blog) { _ in
                self.removeFromReaded(blog: blog)
            }  })
        self.view?.viewModel.subscribeWithItems(subItems: models)
    }
    
    private func removeFromReaded( blog: Blog) {
        let blogArray = readedBlogs.value.filter({$0.id != blog.id})
        readedBlogs.accept(blogArray)
        configureDataSource()
    }
    
}
