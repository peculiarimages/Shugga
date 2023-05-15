//
//  Subscriptions.swift
//  Shugga
//
//  Created by Rodi on 4/16/23.
//

import Foundation
import StoreKit
import NotificationCenter

extension Notification.Name {
    static let productsReceived = Notification.Name("productsReceived")
}

class Subscriptions: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = Subscriptions()
    
    let monthlySubscriptionProductID =  "Month_01"
    let yearlySubscriptionProductID =   "Month_12"
    var monthlyProduct: SKProduct?
    var yearlyProduct: SKProduct?
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func requestSubscriptionInfo() {
        let productIdentifiers = Set([monthlySubscriptionProductID, yearlySubscriptionProductID])
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }
    
    
    
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in response.products {
            if product.productIdentifier == monthlySubscriptionProductID {
                monthlyProduct = product
                print("Monthly product received: \(product.localizedTitle) - \(product.localizedDescription) - \(product.price)")
            } else if product.productIdentifier == yearlySubscriptionProductID {
                yearlyProduct = product
                print("Yearly product received: \(product.localizedTitle) - \(product.localizedDescription) - \(product.price)")
            }
        }

        if response.products.isEmpty {
            print("No products found.")
        }

        NotificationCenter.default.post(name: .productsReceived, object: self)
    }

    
    
    
    
    
    
    
    func purchaseSubscription(product: SKProduct) {
        guard SKPaymentQueue.canMakePayments() else {
            print("Cannot make purchase")
            return
        }
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("Subscription purchased")
                unlockSubscriptionContent()
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                print("Transaction failed: \(String(describing: transaction.error?.localizedDescription))")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                print("Subscription restored")
                unlockSubscriptionContent()
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func unlockSubscriptionContent() {
        // Unlock the content or features for the user based on their subscription
    }
}
