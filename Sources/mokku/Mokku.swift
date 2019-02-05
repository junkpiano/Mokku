//
//  Mokku.swift
//  Mokku
//
//  Created by Yusuke Ohashi on 2019/02/05.
//  Copyright © 2019 Yusuke Ohashi All rights reserved.
//

import Foundation

public class Mokku {
    static var stubs: [Stub] = [Stub]()

    private static var shared: Mokku = Mokku()
    private var enabled: Bool = false

    public static func install(for request: URLRequest, response: Data) {
        if !shared.enabled {
            URLSessionConfiguration.setupMockSessionConfiguration()
            shared.enabled = true
        }

        let stub = Stub()
        stub.request = request
        stub.response = response
        addStub(stub: stub)
    }

    public static func install(for url: URL, response: Data) {
        let request = URLRequest(url: url)
        install(for: request, response: response)
    }

    public static func unInstall() {
        if shared.enabled {
            URLSessionConfiguration.destroyMockSessionConfiguration()
            shared.enabled = false
        }
    }

    static func addStub(stub: Stub) {
        stubs.append(stub)
    }

    static func removeAllStubs() {
        stubs.removeAll()
    }

    static func stubForRequest(request: URLRequest) -> Stub? {
        return nil
    }

    static func sendResponse(_ request: URLRequest) -> Data? {
        var data: Data?
        stubs.forEach { (stub) in
            if stub.match(for: request) {
                data = stub.response
                return
            }

        }
        return data
    }
}

class Stub {
    var request: URLRequest?
    var response: Data?

    func match(for request: URLRequest) -> Bool {
        return true
    }
}
