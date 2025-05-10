import SwiftUI
import KhmerCoreMLSMSClassifier

class DetailedClassificationViewModel: ObservableObject {
    private let classifier = KhmerCoreMLSMSClassifier()
    @Published var result = ClassificationResult(category: "", confidence: 0.0)
    @Published var allConfidences: [String: Double] = [:]
    
    var hasResult: Bool {
        !result.category.isEmpty && !allConfidences.isEmpty
    }
    
    func getDetailedClassification(message: String) {
        guard !message.isEmpty else { return }
        
        if let detailedResult = try? classifier.getDetailedClassification(message: message) {
            result = ClassificationResult(
                category: detailedResult.category.rawValue,
                confidence: detailedResult.confidence
            )
        }
        
        if let confidences = try? classifier.classifyWithConfidence(message: message) {
            allConfidences = confidences.reduce(into: [:]) { result, item in
                result[item.key.rawValue] = item.value
            }
        }
        
    }
} 
