import SwiftUI
import KhmerCoreMLSMSClassifier

class TextPreprocessingViewModel: ObservableObject {
    @Published var processedText = ""
    @Published var differences: [String] = []
    
    func processText(_ text: String) {
        guard !text.isEmpty else { return }
        
        let normalized = TextPreprocessor.normalizeKhmerText(text)
        processedText = normalized
        
        calculateDifferences(original: text, processed: normalized)
    }
    
    private func calculateDifferences(original: String, processed: String) {
        differences = []
        
        if original.contains("  ") || original.hasPrefix(" ") || original.hasSuffix(" ") {
            differences.append("Extra whitespace removed")
        }
        
        if containsEmoji(original) && !containsEmoji(processed) {
            differences.append("Emojis removed")
        }
        
        if original.contains("$") && !processed.contains("$") {
            differences.append("Currency symbols normalized")
        }
        
        if original.contains("\n") && !processed.contains("\n") {
            differences.append("Line breaks normalized")
        }
        
        if differences.isEmpty && original != processed {
            differences.append("Special characters normalized")
        }
    }
    
    private func containsEmoji(_ text: String) -> Bool {
        for scalar in text.unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
                 0x1F300...0x1F5FF, // Misc Symbols and Pictographs
                 0x1F680...0x1F6FF, // Transport and Map
                 0x1F700...0x1F77F, // Alchemical Symbols
                 0x1F780...0x1F7FF, // Geometric Shapes
                 0x1F800...0x1F8FF, // Supplemental Arrows-C
                 0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
                 0x1FA00...0x1FA6F, // Chess Symbols
                 0x1FA70...0x1FAFF, // Symbols and Pictographs Extended-A
                 0x2600...0x26FF,   // Miscellaneous Symbols
                 0x2700...0x27BF:   // Dingbats
                return true
            default:
                continue
            }
        }
        return false
    }
} 