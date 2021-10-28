import Swinject

class RegistrationAssembly: UIAssembly {
    
    func assemble(container: Container) {
        container.register(RegistrationController.self) {resolver in
            let controller  = RegistrationController()
            let presenter = resolver.resolve(RegistrationPresenterImpl.self)
            controller.presenter_ = presenter
            return controller
        }.initCompleted { resolver, vc in
            resolver.resolve(RegistrationRouterImpl.self)?.attach(controller: vc)
            resolver.resolve(RegistrationPresenterImpl.self)?.attach(view: vc)
        }
        
        container.register(RegistrationPresenterImpl.self) {resolver in
            let presenter = RegistrationPresenterImpl(
                router: resolver.resolve(RegistrationRouterImpl.self)!,
                modelsFactory: resolver.resolve(RegistrationModelsFactoryImpl.self)!,
                registrationGateway: resolver.resolve(RegistrationGatewayImpl.self)!,
            userDefaultManager: UserDefaultManagerImpl())
            return presenter
        }
        
        container.register(RegistrationRouterImpl.self) {_ in
            return RegistrationRouterImpl()
        }
        
        container.register(RegistrationModelsFactoryImpl.self) {_ in
            return RegistrationModelsFactoryImpl()
        }
    }
    
}
