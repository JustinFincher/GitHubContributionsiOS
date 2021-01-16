//
//  IAPManager.swift
//  Mapaper
//
//  Created by fincher on 12/27/20.
//

import Foundation
import SwiftUI
import StoreKit

class IAPManager : RuntimeManagableSingleton, SKProductsRequestDelegate, SKPaymentTransactionObserver
{
    // MARK: Variables
    public static let IapIdentiferBuyCoffeeTier1 : String = "com.JustZht.GitHubContributions.IAP.BuyCoffeeTier1"
    public static let IapIdentiferBuyCoffeeTier2 : String = "com.JustZht.GitHubContributions.IAP.BuyCoffeeTier2"
    public static let IapIdentiferBuyCoffeeTier3 : String = "com.JustZht.GitHubContributions.IAP.BuyCoffeeTier3"
    public static let IapIdentifers : Set<String> = [
        IapIdentiferBuyCoffeeTier1,
        IapIdentiferBuyCoffeeTier2,
        IapIdentiferBuyCoffeeTier3
    ]

    private var availableProducts : [SKProduct] = []
    func getProduct(identifer: String) -> SKProduct? {
        availableProducts.first { product -> Bool in
            product.productIdentifier == identifer
        }
    }
    
    // MARK: SKPaymentTransactionObserver
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("purchasing \(transaction.payment)");
                EnvironmentManager.shared.env.showView(view: AnyView(ToastView(title: "title_thankyou")), forTime: .seconds(3))
                break
            case .deferred: print("deferred \(transaction.payment)"); break
            case .purchased:
                print("purchased \(transaction.payment)");
                break
            case .failed: print("failed \(transaction.payment)"); break
            case .restored: print("restored \(transaction.payment)"); break
            @unknown default: break
            }
        }
        readTranscations(transactions: transactions)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        readTranscations(transactions: queue.transactions)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        
    }
    
    func readTranscations(transactions : [SKPaymentTransaction]) -> Void {
        print("IAPManager.readTranscations \(transactions)")
        DispatchQueue.main.async {
        }
    }
    
    // MARK: SKProductsRequestDelegate
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("IAPManager.productsRequest \(request) didReceive \(response)")
        if !response.products.isEmpty
        {
            response.products.forEach { product in
                print("IAPManager.productsRequest \(product.localizedTitle) (\(product.productIdentifier)) for \(String(describing: product.regularPrice))")
            }
            availableProducts = response.products
            DispatchQueue.main.async {
                
            }
        }
        if !response.invalidProductIdentifiers.isEmpty
        {
            response.invalidProductIdentifiers.forEach { identifier in
                print("invalidProductIdentifiers \(identifier)")
            }
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print(error)
    }
    
    // MARK: Logic
    static let shared: IAPManager = {
        let instance = IAPManager()
        return instance
    }()
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    override class func setup() {
        print("IAPManager.setup")
        IAPManager.shared.fetchIAP()
    }
    
    var canUseIAP: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func fetchIAP() -> Void {
        EnvironmentManager.shared.env.canUseIAP = canUseIAP
        if canUseIAP {
            let productsRequest = SKProductsRequest(productIdentifiers: IAPManager.IapIdentifers)
            productsRequest.delegate = self
            productsRequest.start()
        }
    }
    
    func buyIAP(product: SKProduct) -> Void {
        if canUseIAP {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
           print("cannot use IAP")
        }
    }
    
    func restorePurchase() -> Void {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
