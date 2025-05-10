import Foundation

public class TextPreprocessor {
    private static let khmerCharacterRange = 0x1780...0x17FF as ClosedRange<UInt32>

    public static func normalizeKhmerText(_ text: String) -> String {
        var normalized = text.trimmingCharacters(in: .whitespacesAndNewlines)
        normalized = normalized.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        
        let filtered = normalized.filter { char in
            if let scalar = char.unicodeScalars.first,
               khmerCharacterRange.contains(scalar.value) {
                return true
            }
            
            return char.isLetter || char.isNumber || char.isPunctuation || char.isWhitespace
        }
        
        return filtered
    }
}