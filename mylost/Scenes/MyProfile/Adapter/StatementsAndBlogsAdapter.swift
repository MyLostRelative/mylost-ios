//
//  StatementsAndBlogsAdapter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 01.11.21.
//

import RxRelay
import Core

protocol StatementsAndBlogsAdapter {
    var favouriteStatements: BehaviorRelay<[Statement]> {get set}
    var readedBlogs: BehaviorRelay<[Blog]> {get set}
}

class StatementsAndBlogsAdapterImpl: StatementsAndBlogsAdapter {
    var readedBlogs: BehaviorRelay<[Blog]> {
        didSet {
            print("ფავ")
        }
    }
    
    var favouriteStatements: BehaviorRelay<[Statement]> {
        didSet {
            print("ფავ")
        }
    }
    
    init() {
        self.favouriteStatements = BehaviorRelay<[Statement]>.init(value: [])
        self.readedBlogs = BehaviorRelay<[Blog]>.init(value: [])
    }
}
