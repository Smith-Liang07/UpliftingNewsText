//
// InAppPurchaseProductRequest.swift
// SwiftyStoreKit
//
// Copyright (c) 2015 Andrea Bizzotto (bizz84@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import StoreKit

public enum ResponseError : Error {
    case invalidProducts(invalidProductIdentifiers: [String])
    case noProducts
    case requestFailed(error: NSError)
}
class InAppProductQueryRequest: NSObject, SKProductsRequestDelegate {

    enum ResultType {
        case success(products: [SKProduct])
        case error(e: ResponseError)
    }

    typealias RequestCallback = (_ result: ResultType) -> ()
    fileprivate let callback: RequestCallback
    fileprivate let request: SKProductsRequest
    // http://stackoverflow.com/questions/24011575/what-is-the-difference-between-a-weak-reference-and-an-unowned-reference
    deinit {
        request.delegate = nil
    }
    fileprivate init(productIds: Set<String>, callback: @escaping RequestCallback) {
        
        self.callback = callback
        request = SKProductsRequest(productIdentifiers: productIds)
        super.init()
        request.delegate = self
    }
    
    class func startQuery(_ productIds: Set<String>, callback: @escaping RequestCallback) -> InAppProductQueryRequest {
        let request = InAppProductQueryRequest(productIds: productIds, callback: callback)
        request.start()
        return request
    }

    func start() {
        DispatchQueue.global().async {
            self.request.start()
        }
    }
    func cancel() {
        DispatchQueue.global().async {
            self.request.cancel()
        }
    }
    
    // MARK: SKProductsRequestDelegate
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        if response.invalidProductIdentifiers.count > 0 {
            let error = ResponseError.invalidProducts(invalidProductIdentifiers: response.invalidProductIdentifiers)
            DispatchQueue.main.async(execute: {
                self.callback(.error(e: error))
            })
            return
        }
        if response.products.count == 0 {
            let error = ResponseError.noProducts
            DispatchQueue.main.async(execute: {
                self.callback(.error(e: error))
            })
            return
        }
        callback(.success(products: response.products))
    }
    
    func requestDidFinish(_ request: SKRequest) {
        
    }
    func request(_ request: SKRequest, didFailWithError error: Error) {
        
        let error = ResponseError.requestFailed(error: error as NSError)
        DispatchQueue.main.async(execute: {
            self.callback(.error(e: error))
        })
    }
}
