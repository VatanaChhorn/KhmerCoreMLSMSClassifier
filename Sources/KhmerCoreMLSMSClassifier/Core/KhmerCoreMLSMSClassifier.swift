// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import CoreML
import NaturalLanguage

public enum SMSCategory: String {
    case ham = "Ham"
    case spam = "Spam"
    case unknown = "unknown"
}

public enum ClassificationError: Error {
    case missingProbabilities
    case modelPredictionFailed
    case modelNotAvailable
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
    
    public func classify(message: String) throws -> SMSCategory {
        guard let result = try classifyWithConfidence(message: message).max(by: { $0.value < $1.value }) else {
            return .unknown
        }
        
        return result.key
    }
    
    public func classifyWithConfidence(message: String) throws -> [SMSCategory: Double] {
        let normalizedText = TextPreprocessor.normalizeKhmerText(message)
        
        guard let model = model else {
            throw ClassificationError.modelNotAvailable
        }
        
        let nlmodel = try NLModel(mlModel: model)
        let prediction = nlmodel.predictedLabel(for: normalizedText)
        let predictionSet = nlmodel.predictedLabelHypotheses(for: normalizedText, maximumCount: 2)
        
        guard let predictedLabel = prediction else {
            throw ClassificationError.modelPredictionFailed
        }
        
        let category: SMSCategory = (predictedLabel == "Spam") ? .spam : .ham
        let confidence = predictionSet[predictedLabel] ?? 0.0
        let oppositeCategory: SMSCategory = (category == .spam) ? .ham : .spam
        let oppositeConfidence = 1.0 - confidence
        
        return [category: confidence, oppositeCategory: oppositeConfidence]
    }
    
    public func getDetailedClassification(message: String) throws -> ClassificationResult {
        let results = try classifyWithConfidence(message: message)
        
        guard let topResult = results.max(by: { $0.value < $1.value }) else {
            return ClassificationResult(category: .unknown, confidence: 0.0)
        }
        
        return ClassificationResult(category: topResult.key, confidence: topResult.value)
    }
}

