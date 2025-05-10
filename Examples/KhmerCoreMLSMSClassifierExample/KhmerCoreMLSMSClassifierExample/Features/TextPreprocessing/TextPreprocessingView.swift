import SwiftUI
import KhmerCoreMLSMSClassifier

struct TextPreprocessingView: View {
    @StateObject private var viewModel = TextPreprocessingViewModel()
    @State private var inputText = ""
    @State private var isEditingInput = false
    @State private var isAnimating = false
    
    private let examples: [(raw: String, description: String)] = [
        (
            "  ពេលនេះ​ លោកអ្នកទទួលបានប្រាក់   ១០០$  សូមចុចតំណរភ្ជាប់ដើម្បីទទួលយកប្រាក់ https://example.com/claim  ",
            "Text with extra spaces and symbols"
        ),
        (
            "⭐️⭐️⭐️ សូមទិញទំនិញតាមអនឡាញ! 50% បញ្ចុះតម្លៃ! 🎁🎁🎁",
            "Text with emojis and special characters"
        ),
        (
            "លោកអ្នកបានឈ្នះ\nរង្វាន់ចំនួន\n១០០០$\nសូមទាក់ទងមកលេខ\n០៩៩៩៩៩៩៩៩",
            "Text with line breaks"
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                headerView
                
                textInputSection
                
                if !viewModel.processedText.isEmpty {
                    processedTextSection
                }
                
                examplesSection
            }
            .padding()
        }
        .navigationTitle("Text Preprocessing")
        .background(Color(.systemGroupedBackground))
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "character.textbox")
                    .font(.system(size: 46))
                    .foregroundColor(.purple)
                    .padding()
                    .rotationEffect(.degrees(isAnimating ? 5 : -5))
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                            isAnimating = true
                        }
                    }
            }
            
            Text("Khmer Text Preprocessing")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("See how the classifier normalizes and prepares Khmer text")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
    private var textInputSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Raw Input Text")
                    .font(.headline)
                
                Spacer()
                
                Button("Clear") {
                    withAnimation {
                        inputText = ""
                        viewModel.processedText = ""
                    }
                }
                .font(.subheadline)
                .foregroundColor(.purple)
                .opacity(inputText.isEmpty ? 0.5 : 1.0)
                .disabled(inputText.isEmpty)
            }
            .padding(.horizontal, 5)
            
            TextEditor(text: $inputText)
                .frame(minHeight: 100)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.purple.opacity(isEditingInput ? 0.6 : 0.3), lineWidth: isEditingInput ? 2 : 1)
                )
                .onTapGesture {
                    isEditingInput = true
                }
                .onChange(of: inputText) { _ in
                    if isEditingInput {
                        viewModel.processText(inputText)
                    }
                }
            
            Button {
                isEditingInput = false
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                processWithAnimation()
            } label: {
                Text("Process Text")
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
    
    private var processedTextSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Processed Output")
                    .font(.headline)
                
                Spacer()
                
                Text("Changes Applied")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.purple.opacity(0.1))
                    )
            }
            .padding(.horizontal, 5)
            
            VStack(alignment: .leading, spacing: 15) {
                Text(viewModel.processedText)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                    )
                
                if !viewModel.differences.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Changes Detected:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        ForEach(viewModel.differences, id: \.self) { difference in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 12))
                                
                                Text(difference)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .transition(.opacity)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    private var examplesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Try with these examples:")
                .font(.headline)
                .padding(.leading, 5)
            
            ForEach(examples, id: \.raw) { example in
                Button {
                    withAnimation {
                        inputText = example.raw
                        processWithAnimation()
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(example.raw)
                            .lineLimit(2)
                            .foregroundColor(.primary)
                        
                        Text(example.description)
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
    
    private func processWithAnimation() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            viewModel.processText(inputText)
        }
    }
}

#Preview {
    TextPreprocessingView()
} 