import Foundation
import KhmerCoreMLSMSClassifier

extension TextPreprocessor {
    static func normalizeKhmerText(_ text: String) -> String {
        let normalized = (TextPreprocessor.self as any AnyObject).normalizeKhmerText(text)
        return normalized as? String ?? ""
    }
} 