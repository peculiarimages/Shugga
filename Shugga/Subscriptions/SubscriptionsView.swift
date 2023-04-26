//
//  SubscriptionsView.swift
//  Shugga
//
//  Created by Rodi on 4/16/23.
//

import SwiftUI
import StoreKit

struct SubscriptionsView: View {
    @ObservedObject private var subscriptionsViewModel = SubscriptionsViewModel()

    var body: some View {
        VStack {
            Text("Choose Your Subscription")
                .font(.largeTitle)
                .padding()

            if let monthlyProduct = subscriptionsViewModel.monthlyProduct {
                SubscriptionOptionView(product: monthlyProduct, action: {
                    subscriptionsViewModel.purchaseSubscription(product: monthlyProduct)
                })
            }

            if let yearlyProduct = subscriptionsViewModel.yearlyProduct {
                SubscriptionOptionView(product: yearlyProduct, action: {
                    subscriptionsViewModel.purchaseSubscription(product: yearlyProduct)
                })
            }

            Button(action: {
                subscriptionsViewModel.restorePurchases()
            }) {
                Text("Restore Purchases")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .onAppear {
            subscriptionsViewModel.requestSubscriptionInfo()
        }
    }
}

struct SubscriptionOptionView: View {
    let product: SKProduct
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.localizedTitle)
                        .font(.headline)
                    Text(product.localizedDescription)
                        .font(.subheadline)
                }
                Spacer()
                Text("\(product.priceLocale.currencySymbol ?? "")\(product.price.stringValue)")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SubscriptionsView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionsView()
    }
}
