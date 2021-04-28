//
//  SKProduct+Extension.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 27.04.2021.
//

import StoreKit

extension SKProduct {

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    var isFree: Bool {
        price == 0.00
    }

    var localizedPrice: String? {
        guard !isFree else {
            return nil
        }
        
        let formatter = SKProduct.formatter
        formatter.locale = priceLocale

        return formatter.string(from: price)
    }

}

extension SKProductSubscriptionPeriod {
    
    public var localizedDescription: String {
        let period:String = {
            switch self.unit {
            case .day: return "day"
            case .week: return "week"
            case .month: return "month"
            case .year: return "year"
            @unknown default:
                return "unknown period"
            }
        }()
    
        let plural = numberOfUnits > 1 ? "s" : ""
        return "\(numberOfUnits) \(period)\(plural)"
    }
}
