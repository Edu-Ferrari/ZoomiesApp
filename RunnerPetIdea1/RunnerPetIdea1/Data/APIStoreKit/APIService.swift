//
//  APIService.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//

import StoreKit

@MainActor
final class APIService: ObservableObject {
    @Published var products: [Product] = []

    func load(productIDs: [String]) async {
        do { products = try await Product.products(for: productIDs) }
        catch { print("IAP load error: \(error)") }
    }

    func buy(_ product: Product) async {
        do {
            let result = try await product.purchase()
            if case .success(let verification) = result, case .verified(let tx) = verification {
                // TODO: unlock by tx.productID
                await tx.finish()
            }
        } catch { print("IAP buy error: \(error)") }
    }

    func restoreEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let tx) = result {
                // TODO: unlock persisted entitlement
                _ = tx
            }
        }
    }
}
