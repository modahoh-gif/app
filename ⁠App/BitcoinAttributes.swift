import ActivityKit
import Foundation

public struct BitcoinAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var price: String
        public init(price: String) {
            self.price = price
        }
    }
    public var pair: String
    public init(pair: String) {
        self.pair = pair
    }
}
