//
//  URLSessionConfiguration+Mock.swift
//  Mokku
//
//  Created by Yusuke Ohashi on 2019/02/05.
//  Copyright © 2019 Yusuke Ohashi All rights reserved.
//

import Foundation

let swizzleDefaultSessionConfiguration: Void = {
    let defaultSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.default))
    let mockDefaultSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.mock))
    method_exchangeImplementations(defaultSessionConfiguration!, mockDefaultSessionConfiguration!)
}()

let deSwizzleDefaultSessionConfiguration: Void = {
    let defaultSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.default))
    let mockDefaultSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.mock))
    method_exchangeImplementations(mockDefaultSessionConfiguration!, defaultSessionConfiguration!)
}()

extension URLSessionConfiguration {
    
    public class func setupMockSessionConfiguration() {
        swizzleDefaultSessionConfiguration
    }
    
    public class func destroyMockSessionConfiguration() {
        deSwizzleDefaultSessionConfiguration
    }
    
    @objc dynamic class var mock: URLSessionConfiguration {
        let configuration = self.mock
        configuration.protocolClasses?.insert(MockURLProtocol.self, at: 0)
        configuration.protocolClasses = [MockURLProtocol.self] as [AnyClass] + configuration.protocolClasses!
        URLProtocol.registerClass(MockURLProtocol.self)
        return configuration
    }
}
