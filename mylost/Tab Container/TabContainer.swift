//
//  TabContainer.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/19/21.
//

import UIKit

class ProductContainer: PagerTabStripViewController {
    
    @IBOutlet weak var segments: ScrollableTabView!
    var lastSelectedIndex = 0
    var moduleVisitDate: Date = Date()
    
    lazy var items: [ProductTabModel] = {
       return getDatasourceModels()
    }()
    
    override func viewDidLoad() {
        self.datasource = self
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
        guard let signVC = DIAssembly(uiAssemblies: [SignInAssembly()], networkAssemblies: [])
                .resolver.resolve(SignInViewController.self) else {
                    fatalError("errores")
                }
        let otherPaymentConfigure = MyLostHomeConfiguratorImpl()
        let otherProductsVC = MyLostHomeController()
        otherPaymentConfigure.configure(otherProductsVC )
        
        let statementsConfigurator = StatementsConfiguratorImpl()
        let statementController = StatementsController()
        statementsConfigurator.configure(statementController )

        return [signVC, otherProductsVC, statementController]
    }
    
    func getDatasourceModels() -> [ProductTabModel] {
        let dataSource = ProductsTabDataSource.init()
        return dataSource.models()
    }

}
