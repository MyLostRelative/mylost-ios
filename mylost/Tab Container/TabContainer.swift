//
//  TabContainer.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/19/21.
//

import UIKit

class ProductContainer: PagerTabStripViewController {
    enum UserType {
        case guest
        case user
    }
    
    @IBOutlet weak var segments: ScrollableTabView!
    var lastSelectedIndex = 0
    var moduleVisitDate: Date = Date()
    var userType: UserType = UserDefaultManager().getValue(key: "token") == nil ? .guest : .user{
        didSet {
            self.items = getDatasourceModels()
            self.segments.collectionView.reloadData()
            self.reloadPagerTabStripView()
            
        }
    }
    lazy var items: [ProductTabModel] = {
       return getDatasourceModels()
    }()
    
    override func viewDidLoad() {
        self.datasource = self
        self.navigationController?.view.backgroundColor = Resourcebook.Color.Invert.Background.canvas.uiColor
        super.viewDidLoad()
        configureSegmentsCollectionView()
    }
    
    private func configureSegmentsCollectionView() {
        self.containerView.isScrollEnabled = false
        self.segments.delegate = self
        self.segments.collectionView.backgroundColor = .clear
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
    
    func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        guard let signVC = DIAssembly(uiAssemblies: [SignInAssembly()], networkAssemblies: [LoginNetworkAssembly(), RegistrationNetworkAssembly()])
                .resolver.resolve(SignInViewController.self) else {
                    fatalError("errores")
                }
        
        var firstVc: UIViewController = signVC
        if let token = UserDefaultManager().getValue(key: "token") as? String {
            
            guard let userVc = DIAssembly(uiAssemblies: [MyProfileAssembly(userID: 1,
                                                                           bearerToken: token)],
                                          networkAssemblies: [UserInfoetworkAssembly(), UserInfoBearerNetworkAssembly(),   StatementNetworkAssembly()])
                    .resolver.resolve(MyProfileViewController.self) else {
                        fatalError("errores")
                    }
            firstVc = userVc
        }
        
        let otherPaymentConfigure = MyLostHomeConfiguratorImpl()
        let otherProductsVC = MyLostHomeController()
        otherPaymentConfigure.configure(otherProductsVC )
        
        let statementsConfigurator = StatementsConfiguratorImpl()
        let statementController = StatementsController()
        statementsConfigurator.configure(statementController )

        return [firstVc, otherProductsVC, statementController]
    }
    
    func getDatasourceModels() -> [ProductTabModel] {
        let dataSource = ProductsTabDataSource.init()
        return self.userType == .guest ? dataSource.models() : dataSource.loggedInmodels()
    }

}
