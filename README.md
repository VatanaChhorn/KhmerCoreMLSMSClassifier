# KhmerCoreMLSMSClassifier

![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2016.0+%20|%20macOS%2013.0+-lightgrey.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

A Swift package for classifying Khmer SMS messages as spam or legitimate using CoreML. Built with modern Swift practices and optimized for on-device machine learning.

## Features

- 🚀 Lightweight, efficient SMS classification
- 🇰🇭 Specifically designed for Khmer language messages
- 📱 Works completely offline with on-device processing
- 🔄 Handles text preprocessing for improved accuracy
- 🧠 Leverages CoreML for efficient inference
- ⚙️ Easily customizable with your own trained models

## Requirements

- iOS 16.0+ / macOS 13.0+
- Swift 6.0+
- Xcode 15.0+

## Installation

### Swift Package Manager

Add the following line to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/vatanachhorn/KhmerCoreMLSMSClassifier.git", from: "1.0.0")
]
```

Or add it directly in Xcode:

1. Go to File > Add Package Dependencies
2. Enter the repository URL: `https://github.com/vatanachhorn/KhmerCoreMLSMSClassifier.git`
3. Select the version or branch you want to use

## Usage

### Basic Classification

```swift
import KhmerCoreMLSMSClassifier

// Initialize the classifier
let classifier = KhmerCoreMLSMSClassifier()

// Classify a Khmer message
let message = "ពេលនេះ​ លោកអ្នកទទួលបានប្រាក់ ១០០$ សូមចុចតំណរភ្ជាប់ដើម្បីទទួលយកប្រាក់ https://example.com/claim"
let category = classifier.classify(message: message)

switch category {
case .spam:
    print("This message is spam")
case .ham:
    print("This message is legitimate")
case .unknown:
    print("Could not determine message category")
}
```

### Classification with Confidence Score

```swift
// Get classification with confidence score
let result = classifier.getDetailedClassification(message: message)
print("Category: \(result.category.rawValue), Confidence: \(result.confidence * 100)%")

// Get all confidence scores for each category
let confidences = classifier.classifyWithConfidence(message: message)
for (category, confidence) in confidences {
    print("\(category.rawValue): \(confidence * 100)%")
}
```

### Text Preprocessing

The package includes a text preprocessor specifically designed for Khmer language:

```swift
import KhmerCoreMLSMSClassifier

let originalText = "  ពេលនេះ​ លោកអ្នកទទួលបានប្រាក់   ១០០$  សូមចុចតំណរភ្ជាប់ដើម្បីទទួលយកប្រាក់ https://example.com/claim  "
let normalizedText = TextPreprocessor.normalizeKhmerText(originalText)
print(normalizedText)
// Output: "ពេលនេះ លោកអ្នកទទួលបានប្រាក់ ១០០ សូមចុចតំណរភ្ជាប់ដើម្បីទទួលយកប្រាក់ https://example.com/claim"
```

## Architecture

The package is organized into a modular structure:

```
Sources/
└── KhmerCoreMLSMSClassifier/
    ├── Core/            # Core functionality and primary classifier
    ├── Models/          # CoreML model loader and generated model classes
    ├── Utils/           # Helper utilities such as text preprocessing
    └── Resources/       # CoreML model files
```

## Running the Demo

The package includes a demo application that demonstrates the classifier in action:

```bash
swift run KhmerCoreMLSMSClassifierDemo
```

## Performance Considerations

- The classifier works entirely on-device, maintaining user privacy
- Model inference is fast and suitable for real-time classification
- Memory usage is minimal, making it suitable for mobile applications

## License

This project is available under the [MIT License](LICENSE).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Author

Created by [Vatana Chhorn](https://github.com/vatanachhorn)