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
    private var tipsDataSource: [TipModel] = TipDataSource.init().models()
    var moduleVisitDate: Date = Date()
    private let userDef = UserDefaultManagerImpl()
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
        changeTipDefault()
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
    
    private func changeTipDefault() {
        guard let tipIsShown = userDef.getValue(key: "tipIsShown") as? Bool,
           tipIsShown else {
               userDef.saveKeyName(key: "tipIsShown", value: true)
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                   self.tipCol()
               }
               return
        }
    
    }
    
    private func tipCol() {
        let vc = TipComponent.init(model: TipComponent.ViewModel.init(
            imageType: (image: Resourcebook.Image.Icons24.systemInfoFill.template,
                        tint: .blue),
            title: tipsDataSource[lastSelectedIndex].title,
            description: nil,
            type: .up,
            buttonType: .title(title: tipsDataSource[lastSelectedIndex].buttonTitle,
                               color: tipsDataSource[lastSelectedIndex].buttonColor),
            viewFrame: segments.segmentFrames[lastSelectedIndex], onTap: { _ in
                self.changeTabAndTip()
            }))
        self.present(vc, animated: true, completion: nil)
    }
    private func changeTabAndTip() {
        self.dismiss(animated: true, completion: nil)
        self.lastSelectedIndex += 1
        
        if self.lastSelectedIndex != numberOfItems {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.tipCol()
            }
        } else {
            lastSelectedIndex = 0
        }
        
        self.itemSelected(at: lastSelectedIndex)
        self.segments.collectionView.reloadData()
        self.reloadPagerTabStripView()
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
        let BlogConfigurator = StatementsConfiguratorImpl(statementsAndBlogsAdapter: adapter)
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
