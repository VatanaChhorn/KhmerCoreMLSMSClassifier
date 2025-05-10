import Testing
@testable import KhmerCoreMLSMSClassifier

@Test func testTextPreprocessor() {
    let text = "  ពេលនេះ​ លោកអ្នក   ១០០$  "
    let normalized = TextPreprocessor.normalizeKhmerText(text)
    
    #expect(!normalized.hasPrefix(" "))
    #expect(!normalized.hasSuffix(" "))
    #expect(!normalized.contains("$"))
    #expect(!normalized.contains("  "))
}

@Test func testClassification() {
    let classifier = KhmerCoreMLSMSClassifier()
    let spamMessage = "ពេលនេះ​ លោកអ្នកទទួលបានប្រាក់ ១០០$ សូមចុចតំណរភ្ជាប់ដើម្បីទទួលយកប្រាក់ https://example.com/claim"
    let category = classifier.classify(message: spamMessage)
    #expect(category == .spam || category == .ham || category == .unknown)
    
    let confidence = classifier.classifyWithConfidence(message: spamMessage)
    #expect(!confidence.isEmpty)
}

@Test func testDetailedClassification() {
    let classifier = KhmerCoreMLSMSClassifier()
    let message = "សួស្តី! សូមជួបគ្នានៅភោជនីយដ្ឋាន ម៉ោង ៧ យប់នេះ។"
    
    let result = classifier.getDetailedClassification(message: message)
    
    #expect([SMSCategory.spam, .ham, .unknown].contains(result.category), "Category should be one of the defined categories")
    #expect(result.confidence >= 0.0 && result.confidence <= 1.0)
}
