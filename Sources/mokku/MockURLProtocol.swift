//
//  MockURLProtocol.swift
//  Mokku
//
//  Created by Yusuke Ohashi on 2019/02/05.
//  Copyright © 2019 Yusuke Ohashi All rights reserved.
//

import Foundation

public class MockURLProtocol: URLProtocol {

    override open class func canInit(with request:URLRequest) -> Bool {
        return true
    }

    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override open func startLoading() {
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        self.client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
        if let data = Mokku.sendResponse(request) {
            self.client?.urlProtocol(self, didLoad: data)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override open func stopLoading() {
    }

}
