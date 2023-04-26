//
//  SubscriptionsViewModel.swift
//  Shugga
//
//  Created by Rodi on 4/16/23.
//

import Foundation
import SwiftUI
import StoreKit
import Combine

class SubscriptionsViewModel: ObservableObject {
    private var subscriptions = Subscriptions.shared
    
    @Published var monthlyProduct: SKProduct?
    @Published var yearlyProduct: SKProduct?

    init() {
        subscriptions.requestSubscriptionInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(handleProductsReceived(notification:)), name: .productsReceived, object: subscriptions)
    }

    @objc private func handleProductsReceived(notification: Notification) {
        DispatchQueue.main.async {
            self.monthlyProduct = self.subscriptions.monthlyProduct
            self.yearlyProduct = self.subscriptions.yearlyProduct
        }
    }

    func requestSubscriptionInfo() {
        subscriptions.requestSubscriptionInfo()
    }

    func purchaseSubscription(product: SKProduct) {
        subscriptions.purchaseSubscription(product: product)
    }

    func restorePurchases() {
        subscriptions.restorePurchases()
    }
}
