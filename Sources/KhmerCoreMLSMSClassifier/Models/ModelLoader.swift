import Foundation
import CoreML

internal class ModelLoader {
    static func loadModel(named name: String) -> MLModel? {
        guard let modelURL = findModelURL(named: name) else {
            print("Error: Could not find model file \(name).mlmodelc in the bundle")
            return nil
        }
        
        do {
            return try MLModel(contentsOf: modelURL)
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }
    
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, visionOS 1.0, *)
    static func loadClassifier(named name: String = "kh-sms-classifier") -> kh_sms_classifier? {
        guard let modelURL = findModelURL(named: name) else {
            print("Error: Could not find model file \(name).mlmodelc in the bundle")
            return nil
        }
        
        do {
            let model = try MLModel(contentsOf: modelURL)
            return kh_sms_classifier(model: model)
        } catch {
            print("Error loading classifier model: \(error)")
            return nil
        }
    }
    
    private static func findModelURL(named name: String) -> URL? {
        if let modelURL = Bundle.module.url(forResource: name, withExtension: "mlmodelc") {
            return modelURL
        }
        
        let resourcesURL = Bundle.module.resourceURL?.appendingPathComponent("Resources")
        
        let resourceModelURL = resourcesURL?.appendingPathComponent("\(name).mlmodelc")
        if let resourceModelURL = resourceModelURL, FileManager.default.fileExists(atPath: resourceModelURL.path) {
            return resourceModelURL
        }
        
        if let resourcesURL = resourcesURL,
           let contents = try? FileManager.default.contentsOfDirectory(at: resourcesURL, includingPropertiesForKeys: nil) {
            for item in contents {
                if item.lastPathComponent == "\(name).mlmodelc" {
                    return item
                }
            }
        }
        
        print("Could not locate model \(name).mlmodelc in any location")
        return nil
    }
    
    static func modelExists(named name: String) -> Bool {
        return findModelURL(named: name) != nil
    }
    
    static func availableModels() -> [String] {
        return []
    }
} 
