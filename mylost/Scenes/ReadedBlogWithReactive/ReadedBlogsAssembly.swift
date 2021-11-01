import Swinject
import RxSwift
import RxRelay
import Core

class ReadedBlogsAssembly: UIAssembly {
    private var readedBlogs: BehaviorRelay<[Blog]>
    
    init( readedBlogs: BehaviorRelay<[Blog]>) {
        self.readedBlogs = readedBlogs
    }
    
    func assemble(container: Container) {
        registerController(with: container)
        registerPresenter(with: container)
        registerRouter(with: container)
    }
    
    private func registerController(with container: Container) {
        container.register(ReadedBlogsController.self) {resolver in
            let controller  = ReadedBlogsController()
            let presenter = resolver.resolve(ReadedBlogsPresenterImpl.self)
            controller.presenter_ = presenter
            return controller
        }.initCompleted { resolver, vc in
            resolver.resolve(ReadedBlogsRouterImpl.self)?.attach(controller: vc)
            resolver.resolve(ReadedBlogsPresenterImpl.self)?.attach(view: vc)
        }
    }
    
    private func registerPresenter(with container: Container) {
        container.register(ReadedBlogsPresenterImpl.self) {resolver in
            let router = resolver.resolve(ReadedBlogsRouterImpl.self)!
            let factory = ReadedBlogsFactoryImpl()
            let presenter = ReadedBlogsPresenterImpl(
                router: router,
                readedBlogsFactory: factory,
                readedBlogs: self.readedBlogs)
            return presenter
        }
    }
    
    
    private func registerRouter(with container: Container) {
        container.register(ReadedBlogsRouterImpl.self) {_ in
            return ReadedBlogsRouterImpl()
        }
    }
}
