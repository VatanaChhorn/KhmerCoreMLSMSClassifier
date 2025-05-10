import SwiftUI
import KhmerCoreMLSMSClassifier

struct DetailedClassificationView: View {
    @StateObject private var viewModel = DetailedClassificationViewModel()
    @State private var inputText = ""
    @State private var isAnimating = false
    
    private let presetMessages: [(message: String, description: String)] = [
        (
            "ពេលនេះ​ លោកអ្នកទទួលបានប្រាក់ ១០០$ សូមចុចតំណរភ្ជាប់ដើម្បីទទួលយកប្រាក់ https://example.com/claim",
            "Likely spam - offering money"
        ),
        (
            "សូមជួបគ្នានៅភោជនីយដ្ឋានថ្មីនៅម៉ោង ៧ យប់ថ្ងៃនេះ",
            "Likely legitimate - meeting invitation"
        ),
        (
            "ការផ្សព្វផ្សាយពិសេស! ទិញ១ថែម១ នៅហាងទំនិញរបស់យើង!",
            "Likely spam - marketing message"
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                headerView
                
                messageInputSection
                
                presetMessagesSection
                
                if viewModel.hasResult {
                    resultSection
                }
            }
            .padding()
        }
        .navigationTitle("Detailed Classification")
        .background(Color(.systemGroupedBackground))
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.purple)
                    .symbolEffect(.variableColor, options: .repeating, value: isAnimating)
                    .onAppear {
                        isAnimating = true
                    }
            }
            
            Text("Detailed Classification")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("See confidence scores for spam or legitimate classification")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
    private var messageInputSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Message")
                .font(.headline)
                .padding(.leading, 5)
            
            TextEditor(text: $inputText)
                .frame(minHeight: 100)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                )
            
            Button {
                classifyWithAnimation()
            } label: {
                Text("Analyze with Confidence Scores")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.purple)
                    )
                    .foregroundColor(.white)
            }
            .buttonStyle(.plain)
            .disabled(inputText.isEmpty)
            .opacity(inputText.isEmpty ? 0.6 : 1.0)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private var presetMessagesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Try with these examples:")
                .font(.headline)
                .padding(.leading, 5)
            
            ForEach(presetMessages, id: \.message) { item in
                Button {
                    inputText = item.message
                    classifyWithAnimation()
                } label: {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(item.message)
                            .lineLimit(1)
                            .foregroundColor(.primary)
                        Text(item.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private var resultSection: some View {
        VStack(spacing: 20) {
            Text("Classification Results")
                .font(.headline)
                .padding(.top, 5)
            
            HStack(spacing: 15) {
                categoryIconView
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Category: \(viewModel.result.category)")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("Confidence: \(Int(viewModel.result.confidence * 100))%")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(viewModel.result.category == "Spam" ? Color.red.opacity(0.1) : Color.green.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(viewModel.result.category == "Spam" ? Color.red.opacity(0.3) : Color.green.opacity(0.3), lineWidth: 1)
                    )
            )
            
            VStack(spacing: 15) {
                Text("Confidence Distribution")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(viewModel.allConfidences.sorted(by: { $0.value > $1.value }), id: \.key) { category, confidence in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(category)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Text("\(Int(confidence * 100))%")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 12)
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(confidenceColor(for: category))
                                    .frame(width: geo.size.width * CGFloat(confidence), height: 12)
                                    .animation(.spring(response: 0.8, dampingFraction: 0.7), value: confidence)
                            }
                        }
                        .frame(height: 12)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .transition(.scale.combined(with: .opacity))
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: viewModel.hasResult)
    }
    
    private var categoryIconView: some View {
        ZStack {
            Circle()
                .fill(viewModel.result.category == "Spam" ? Color.red.opacity(0.2) : Color.green.opacity(0.2))
                .frame(width: 50, height: 50)
            
            Image(systemName: viewModel.result.category == "Spam" ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(viewModel.result.category == "Spam" ? .red : .green)
                .symbolEffect(.pulse, options: .speed(1.5), value: viewModel.result.category)
        }
    }
    
    private func confidenceColor(for category: String) -> Color {
        switch category {
        case "Spam":
            return .red
        case "Ham":
            return .green
        default:
            return .gray
        }
    }
    
    private func classifyWithAnimation() {
        withAnimation {
            viewModel.getDetailedClassification(message: inputText)
        }
    }
}

#Preview {
    DetailedClassificationView()
} 