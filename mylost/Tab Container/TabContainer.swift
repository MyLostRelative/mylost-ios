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
    private var animationHappen: Bool = UserDefaultManagerImpl().getValue(key: "tipIsShown") != nil
    private var messages: [String] = ["Welcome to My Lost App",
                                      "This is Search App for lost people"]
    private let lbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .semibold)
        lbl.textColor = .gray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let vv: UIView = {
        let lbl = UIView()
        lbl.backgroundColor = Resourcebook.Color.Invert.Background.canvas.uiColor
        lbl.width(equalTo: UIScreen.main.bounds.width - 100)
        lbl.height(equalTo: 40)
        lbl.layer.cornerRadius = 10
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let adapter: StatementsAndBlogsAdapter = {
        StatementsAndBlogsAdapterImpl()
    }()
    
    lazy var items: [ProductTabModel] = {
        return getDatasourceModels()
    }()

    override func viewDidLoad() {
        self.datasource = self
        super.viewDidLoad()
        self.navigationController?.view.backgroundColor = Resourcebook.Color.Invert.Background.canvas.uiColor
        self.configureSegmentsCollectionView()
        self.changeTipDefault()
        self.addAnimationLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !animationHappen {
            self.showMessage(index: 0)
            animationHappen = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if !animationHappen {
            self.containerView.isHidden = true
            self.segments.isHidden = true
            searchFlyingAnimation()
        } else {
            self.lbl.isHidden  = true
            self.vv.isHidden = true
        }
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
               DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
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

// MARK: - Animations
extension ProductContainer{
    private func addAnimationLabel() {
        self.view.addSubview(vv)
        self.vv.addSubview(lbl)
        vv.centerHorizontally(to: self.view)
        vv.centerVertically(to: self.view)
        lbl.centerHorizontally(to: self.view)
        lbl.centerVertically(to: self.view)
        
    }
    
    func showMessage(index: Int) {
        lbl.text = messages[index]
        lbl.center.y = self.view.bounds.height/2 - 100
        UIView.transition(with: vv, duration: 2, options: [.curveEaseOut, .transitionCurlDown], animations: {
            self.lbl.isHidden  = false
            self.vv.isHidden = false
        }) { _ in
            UIView.animate(withDuration: 1.0, delay: 0, options: []) {
            } completion: { _ in
                if index < self.messages.count - 1 {
                    self.removeMessage(index: index)
                } else {
                    self.resetForm()
                }
            }
        }
    }
    
    func removeMessage(index: Int) {
        UIView.animate(withDuration: 1, delay: 0.3, options: [], animations: {
            self.lbl.center.x += self.view.frame.size.width
            self.vv.center.x += self.view.frame.size.width
        }) { _ in
            self.lbl.isHidden = true
            self.vv.isHidden = true
            self.lbl.center = self.view.center
            self.showMessage(index: index + 1)
        }
    }
    
    func resetForm() {
        containerLoadingANimation()
    }
    
    private func containerLoadingANimation() {
        UIView.animate(withDuration: 1, delay: 0,  options: [.curveLinear]) {
            self.lbl.isHidden = true
            self.vv.isHidden = true
            self.containerView.isHidden = false
            self.segments.isHidden = false
        }
    }
    
    private func searchFlyingAnimation() {
        let balloon = CALayer()
        balloon.contents = Resourcebook.Image.Icons24.systemSearch.template.cgImage
        balloon.frame = CGRect(x: -50.0, y: 0.0, width: 50.0, height: 50.0)
        self.view.layer.addSublayer(balloon)
        let flight = CAKeyframeAnimation(keyPath: "position")
        flight.duration = 4
        flight.values = [
            CGPoint(x: -50.0, y: 0.0),
            CGPoint(x: self.view.center.x - 40 , y: self.view.center.y - 40),
            CGPoint(x: self.view.center.x + 40 , y: self.view.center.y - 40),
            CGPoint(x: self.view.center.x + 40 , y: self.view.center.y + 40),
            CGPoint(x: self.view.center.x - 40 , y: self.view.center.y + 40),
            CGPoint(x: -50.0, y: self.view.center.y + 100)
        ].map { NSValue(cgPoint: $0) }
        balloon.add(flight, forKey: nil)
    }
}
