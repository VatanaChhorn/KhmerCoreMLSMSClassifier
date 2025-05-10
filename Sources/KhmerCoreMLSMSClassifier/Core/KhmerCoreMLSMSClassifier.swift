// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import CoreML

public enum SMSCategory: String {
    case ham = "Ham"
    case spam = "Spam"
    case unknown = "unknown"
}

public enum ClassificationError: Error {
    case missingProbabilities
}

@available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, visionOS 1.0, *)
public class KhmerCoreMLSMSClassifier {
    private var model: MLModel?
    private var classifier: kh_sms_classifier?
    private let modelName: String
    
    public init(modelName: String? = nil) {
        self.modelName = modelName ?? "kh-sms-classifier"
        loadModel()
    }
    
    private func loadModel() {
        model = ModelLoader.loadModel(named: modelName)
        classifier = ModelLoader.loadClassifier(named: modelName)
        
        if model == nil && classifier == nil {
            print("Warning: Failed to load model '\(modelName)'. Classification will return placeholder results.")
        } else {
            print("Successfully loaded model '\(modelName)'")
        }
    }
    
    public func classify(message: String) -> SMSCategory {
        guard let result = classifyWithConfidence(message: message).max(by: { $0.value < $1.value }) else {
            return .unknown
        }
        
        return result.key
    }
    
    public func classifyWithConfidence(message: String) -> [SMSCategory: Double] {
        let normalizedText = TextPreprocessor.normalizeKhmerText(message)
        if let classifier = classifier {
            do {
                let output = try classifier.prediction(text: normalizedText)
                let label = output.label
                
                let labelCategory: SMSCategory
                if label == "Spam" {
                    labelCategory = .spam
                } else if label == "Ham" {
                    labelCategory = .ham
                } else {
                    return [.unknown: 1.0]
                }
                
                if let spamProb = output.featureValue(for: "labelProbability[Spam]")?.doubleValue,
                   let hamProb = output.featureValue(for: "labelProbability[Ham]")?.doubleValue {
                    return [.spam: spamProb, .ham: hamProb]
                }
                
                return [labelCategory: 1.0, (labelCategory == .spam ? .ham : .spam): 0.0]
            } catch {
                print("Classification error with typed model: \(error)")
            }
        }
        
        print("Error: No model available for classification")
        return [.unknown: 1.0]
    }
    
    public func getDetailedClassification(message: String) -> ClassificationResult {
        let results = classifyWithConfidence(message: message)
        
        if let topResult = results.max(by: { $0.value < $1.value }) {
            return ClassificationResult(category: topResult.key, confidence: topResult.value)
        }
        
        return ClassificationResult(category: .unknown, confidence: 0.0)
    }
}

