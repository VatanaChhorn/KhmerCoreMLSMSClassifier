import Foundation

public struct ClassificationResult {
    public let category: SMSCategory
    public let confidence: Double
    
    public init(category: SMSCategory, confidence: Double) {
        self.category = category
        self.confidence = confidence
    }
}