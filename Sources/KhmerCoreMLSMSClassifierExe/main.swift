import Foundation
import KhmerCoreMLSMSClassifier

@main
struct KhmerCoreMLSMSClassifierDemo {
    static func main() {
        print("KhmerCoreMLSMSClassifier Demo")
        print("============================\n")
        
        // Run classifier demo with sample messages
        let messages = [
            "ពេលនេះ​ លោកអ្នកទទួលបានប្រាក់ ១០០$ សូមចុចតំណរភ្ជាប់ដើម្បីទទួលយកប្រាក់ https://example.com/claim",
            "សួស្តី! សូមជួបគ្នានៅភោជនីយដ្ឋាន ម៉ោង ៧ យប់នេះ។",
            "ប្រញាប់ឡើង! លោកអ្នកឈ្នះរង្វាន់ ១០០០$ ចូលមើលនៅ https://example.com/win",
            "សូមជូនពរខួបកំណើត។ សង្ឃឹមថាថ្ងៃនេះជាថ្ងៃដ៏សប្បាយសម្រាប់អ្នក។"
        ]
        
        let classifier = KhmerCoreMLSMSClassifier()
        
        for (index, message) in messages.enumerated() {
            print("Message \(index + 1): \(message)")
            
            // Get classification with confidence scores
            let result = classifier.getDetailedClassification(message: message)
            print("Classification: \(result.category.rawValue)")
            print("Confidence: \(String(format: "%.2f", result.confidence * 100))%\n")
            
            // Alternative approach - get all confidence scores
            print("All confidence scores:")
            let confidences = classifier.classifyWithConfidence(message: message)
            for (category, confidence) in confidences {
                print("\(category.rawValue): \(String(format: "%.2f", confidence * 100))%")
            }
            print("\n" + String(repeating: "-", count: 50) + "\n")
        }
    }
} 