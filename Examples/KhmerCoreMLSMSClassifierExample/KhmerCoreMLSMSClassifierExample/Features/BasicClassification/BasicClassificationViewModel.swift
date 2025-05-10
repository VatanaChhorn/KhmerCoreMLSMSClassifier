import SwiftUI
import KhmerCoreMLSMSClassifier

class BasicClassificationViewModel: ObservableObject {
    private let classifier = KhmerCoreMLSMSClassifier()
    @Published var result = ""
    
    func classifyMessage(_ message: String) {
        guard !message.isEmpty else { return }
        
        let category = classifier.classify(message: message)
        result = category.rawValue
    }
} 