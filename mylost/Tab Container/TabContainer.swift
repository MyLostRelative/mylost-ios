//
//  TabContainer.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/19/21.
//

import UIKit
import Core
import Components

class ProductContainer: PagerTabStripViewController {
    enum UserType {
        case guest
        case user
    }
    
    @IBOutlet weak var segments: ScrollableTabView!
    var lastSelectedIndex = 0
    var moduleVisitDate: Date = Date()
    var userType: UserType = UserDefaultManagerImpl().getValue(key: "token") == nil ? .guest : .user {
        didSet {
            self.items = getDatasourceModels()
            self.segments.collectionView.reloadData()
            self.reloadPagerTabStripView()
            
        }
    }
    
    private let adapter: StatementsAndBlogsAdapter = {
        StatementsAndBlogsAdapterImpl()
    }()
    
    lazy var items: [ProductTabModel] = {
        return getDatasourceModels()
    }()
    
    override func viewDidLoad() {
        self.datasource = self
        self.navigationController?.view.backgroundColor = Resourcebook.Color.Invert.Background.canvas.uiColor
        super.viewDidLoad()
        configureSegmentsCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func configureSegmentsCollectionView() {
        self.containerView.isScrollEnabled = false
        self.segments.delegate = self
        self.segments.collectionView.backgroundColor = Resourcebook.Color.Invert.Background.canvas.uiColor
    }
}

extension ProductContainer: ScrollableTabViewDelegate {
    func model(at index: Int) -> TabCollectionCellModel? {
        return items[index]
    }
    
    func itemSelected(at index: Int) {
        for i in 0..<viewControllers.count {
            items[i].state = i == index ? .active : .enabled
        }
        self.moveTo(viewController: viewControllers[index])
    }
    
    var numberOfItems: Int {
        return items.count
    }
}

extension ProductContainer: PagerTabStripDataSource {
    
    private var signVC: UIViewController? {
        DIAssembly(uiAssemblies: [SignInAssembly()], networkAssemblies: [LoginNetworkAssembly(), RegistrationNetworkAssembly()])
            .resolver.resolve(SignInViewController.self)
    }
    
    private var userVC: UIViewController? {
        if let token = UserDefaultManagerImpl().getValue(key: "token") as? String {
            let uiAssemblies =  [MyProfileAssembly(userID: 1, bearerToken: token, statementsAndBlogsAdapter: adapter)]
            let networkAssemblies: [NetworkAssembly] = [UserInfoetworkAssembly(), UserInfoBearerNetworkAssembly(),   StatementNetworkAssembly()]
            
            return DIAssembly(uiAssemblies: uiAssemblies,
                              networkAssemblies: networkAssemblies)
                .resolver.resolve(MyProfileViewController.self)
        }
        return nil
    }
    
    private var statementVC: UIViewController? {
        DIAssembly(uiAssemblies: [MyLostHomeAssembly(statementsAndBlogsAdapter: adapter)],
                   networkAssemblies: [StatementNetworkAssembly()])
            .resolver.resolve(MyLostHomeController.self)
    }
    
    private var blogVC: UIViewController {
        let BlogConfigurator = StatementsConfiguratorImpl()
        let BlogController = StatementsController()
        BlogConfigurator.configure(BlogController )
        return BlogController
    }
    
    func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        guard let signVC = self.signVC else {
            return []
        }
        var firstVc: UIViewController = signVC
        if let _ = UserDefaultManagerImpl().getValue(key: "token") as? String,
           let userVC = userVC {
            firstVc = userVC
        }
        
        return [firstVc, statementVC, blogVC].compactMap({$0})
    }
    
    func getDatasourceModels() -> [ProductTabModel] {
        let dataSource = ProductsTabDataSource.init()
        return self.userType == .guest ? dataSource.models() : dataSource.loggedInmodels()
    }
    
}
