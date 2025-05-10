# KhmerCoreMLSMSClassifier Example

This is an example iOS application demonstrating the usage of the KhmerCoreMLSMSClassifier Swift package.

## Features

The example app showcases three main features of the package:

1. **Basic Classification**: Simple spam/ham classification of Khmer SMS messages
2. **Detailed Classification**: Classification with confidence scores and distribution visualization
3. **Text Preprocessing**: Demonstration of the text normalization for Khmer language

## Project Structure

The project follows MVVM architecture and is organized into the following structure:

```
KhmerCoreMLSMSClassifierExample/
├── Core/
│   └── KhmerCoreMLSMSClassifierExampleApp.swift
├── UI/
│   ├── ContentView.swift
│   └── MainTabView.swift
├── Features/
│   ├── BasicClassification/
│   │   ├── BasicClassificationView.swift
│   │   └── BasicClassificationViewModel.swift
│   ├── DetailedClassification/
│   │   ├── DetailedClassificationView.swift
│   │   ├── DetailedClassificationViewModel.swift
│   │   └── Models/
│   │       └── ClassificationResult.swift
│   └── TextPreprocessing/
│       ├── TextPreprocessingView.swift
│       ├── TextPreprocessingViewModel.swift
│       └── Extensions/
│           └── TextPreprocessorExtension.swift
└── Assets.xcassets/
```

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 6.0+

## Installation

1. Clone the repository
2. Open the `KhmerCoreMLSMSClassifierExample.xcodeproj` file in Xcode
3. Build and run the project on your device or simulator

## Usage

The app provides a tabbed interface to access each feature:

- **Basic Tab**: Enter a Khmer text message or use one of the preset examples to see if it's classified as spam or legitimate
- **Detailed Tab**: See the detailed classification results with confidence scores for each category
- **Preprocess Tab**: Visualize how the text processor normalizes Khmer text for better classification

## Implementation Notes

- The app uses SwiftUI for the user interface
- MVVM architecture is used to separate business logic from presentation
- The folder structure follows a feature-based organization
- The UI includes animations and transitions using modern Swift features

## License

This example app is available under the MIT license. See the LICENSE file for more info. 