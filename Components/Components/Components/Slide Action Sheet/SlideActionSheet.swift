//
//  SlideActionSheet.swift
//  Components
//
//  Created by Nato Egnatashvili on 01.11.21.
//

import UIKit

open class SlideActionSheet: UIViewController {
    
    private lazy var backdropView: UIView = {
        let bdView = UIView(frame: self.view.bounds)
        var darkBlur = UIBlurEffect(style: UIBlurEffect.Style.light)
        var blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = bdView.bounds
        bdView.addSubview(blurView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SlideActionSheet.handleTap(_:)))
        bdView.addGestureRecognizer(tapGesture)
        return bdView
    }()
    
    private let menuView: UIView = {
        let menuView = UIView()
        menuView.height(equalTo: UIScreen.main.bounds.height)
        menuView.width(equalTo: UIScreen.main.bounds.width / 1.2)
        menuView.translatesAutoresizingMaskIntoConstraints = false
        return menuView
    }()
    
    private var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = Resourcebook.Color.Invert.Background.canvas.uiColor
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        return table
    }()
    
    private var tableViewDataSource: ListViewDataSource?
    private var isPresenting = false
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        animationHalf()
        addTableView()
    }
    
    private func setUpMenuConstraint() {
        menuView.bottom(toView: view)
        menuView.left(toView: view)
    }
    
    func animationHalf() {
        view.backgroundColor = .clear
        view.addSubview(backdropView)
        view.addSubview(menuView)
        setUpMenuConstraint()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    private func addTableView() {
        self.menuView.addSubview(tableView)
        tableView.stretchLayout(to: self.menuView)
    }
}

extension SlideActionSheet {
    public func configure(with viewModel: ViewModel? ) {
        guard let viewModel = viewModel else {
            return
        }
        configureDataSource(reusableClasses: viewModel.reusableClasses)
        constructDataSource(listSections: viewModel.sections)
        
    }
    
    private func configureDataSource(reusableClasses: [Reusable.Type]) {
        
        tableViewDataSource = ListViewDataSource.init(
            tableView: tableView,
            withClasses: reusableClasses,
            reusableViews: [
            ])
        tableViewDataSource?.needAnimation = true
    }
    
    private func constructDataSource(listSections: [ListSection]) {
        DispatchQueue.main.async {
            self.tableViewDataSource?.reload(
                with: listSections
            )
        }
    }
}



extension SlideActionSheet: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresenting = !isPresenting
        isPresenting ? presentActionSheet(transitionContext: transitionContext) :
        dismissActionSheet(transitionContext: transitionContext)
    }
    
    private func presentActionSheet(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let toVC = toViewController else { return }
        transitionContext.containerView.addSubview(toVC.view)
        
        animation(height: -UIScreen.main.bounds.height + 50,
                  alpha: 1,
                  transitionContext: transitionContext)
    }
    
    private func dismissActionSheet(transitionContext: UIViewControllerContextTransitioning) {
        animation(height: UIScreen.main.bounds.height - 50,
                  alpha: 0,
                  transitionContext: transitionContext)
    }
    
    private func animation(height: CGFloat,
                           alpha: CGFloat,
                           transitionContext: UIViewControllerContextTransitioning) {
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
            self.menuView.frame.origin.y += height
            self.backdropView.alpha = alpha
        }, completion: { (finished) in
            transitionContext.completeTransition(true)
        })
    }
}
