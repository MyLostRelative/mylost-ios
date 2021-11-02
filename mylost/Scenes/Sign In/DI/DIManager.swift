//
//  DIManager.swift
//  DIManager
//
//  Created by Nato Egnatashvili on 30.08.21.
//

import Swinject
import Core

class DIAssembly: NSObject {
    var uiAssemblies: [UIAssembly]
    var networkAssemblies: [NetworkAssembly]
    
    init(uiAssemblies: [UIAssembly],
         networkAssemblies: [NetworkAssembly]) {
        self.uiAssemblies = uiAssemblies
        self.networkAssemblies = networkAssemblies
    }
    
    var resolver: Resolver {
        return Assembler(uiAssemblies + networkAssemblies).resolver
    }
}

protocol UIAssembly: Assembly {
    
}
