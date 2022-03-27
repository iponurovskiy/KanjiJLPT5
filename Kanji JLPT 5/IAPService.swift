//
//  IAPService.swift
//  Kanji JLPT 5
//
//  Created by Ivan on 19/12/2018.
//

import Foundation
import StoreKit

/*class IAPService: NSObject {
    private override init() {}
    static let shared = IAPService()
    static let InAppPurchaseID = "com.KanjiJLPT5.RemoveAds"
    
    let paymentQueue = SKPaymentQueue.default()
    var products = [SKProduct]()
    
    func getProducts() {
        let products: Set = [IAPService.InAppPurchaseID]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func purchase() {
        guard let productToPurchase = products.filter({$0.productIdentifier == IAPService.InAppPurchaseID}).first else {return}
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restorePurchases() {
        print("restoring")
        paymentQueue.restoreCompletedTransactions()
        
    }
}*/

/*extension IAPService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        self.products = response.products
        for product in response.products {
            print(product.localizedTitle)
        }
    }
}

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .failed:
                queue.finishTransaction(transaction)
                break
            case .purchased:
                fallthrough
            case .restored:
                UserDefaults.standard.set(true, forKey: "isAdRemoved");
                queue.finishTransaction(transaction)
                break
            case .purchasing:
                break
            case .deferred:
                break
            }
        }
    }
}

extension SKPaymentTransactionState {
    func status()->String {
        switch self {
            case .deferred: return "deferred"
            case .failed: return "failed"
            case .purchased: return "purchased"
            case .purchasing: return "purchasing"
            case .restored: return "restored"
        }
    }
}*/
