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
        guard viewControllers.count == 2 else { return }
        
        items[1 - index].state = .enabled
        items[index].state = .active
        self.moveTo(viewController: viewControllers[index])
    }
    
    var numberOfItems: Int {
        return items.count
    }
}

extension ProductContainer: PagerTabStripDataSource {
    
    func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let otherPaymentConfigure = MyLostHomeConfiguratorImpl()
        let otherProductsVC = MyLostHomeController()
        otherPaymentConfigure.configure(otherProductsVC )
        
        let statementsConfigurator = StatementsConfiguratorImpl()
        let statementController = StatementsController()
        statementsConfigurator.configure(statementController )

        return [otherProductsVC, statementController]
    }
    
    func getDatasourceModels() -> [ProductTabModel] {
        let dataSource = ProductsTabDataSource.init()
        return dataSource.models()
    }

}
