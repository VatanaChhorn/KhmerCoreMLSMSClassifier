import SwiftUI
import KhmerCoreMLSMSClassifier

struct BasicClassificationView: View {
    @StateObject private var viewModel = BasicClassificationViewModel()
    @State private var inputText = ""
    @State private var isAnimating = false
    
    private let presetMessages = [
        "ពេលនេះ​ លោកអ្នកទទួលបានប្រាក់ ១០០$ សូមចុចតំណរភ្ជាប់ដើម្បីទទួលយកប្រាក់ https://example.com/claim",
        "សូមជួបគ្នានៅភោជនីយដ្ឋានថ្មីនៅម៉ោង ៧ យប់ថ្ងៃនេះ",
        "សូមបញ្ជាក់លេខកូដសម្ងាត់របស់អ្នកដើម្បីទទួលបានរង្វាន់ ៥០០$"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                headerView
                
                messageInputSection
                
                presetMessagesSection
                
                if !viewModel.result.isEmpty {
                    resultView
                }
            }
            .padding()
        }
        .navigationTitle("Basic Classification")
        .background(Color(.systemGroupedBackground))
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            Image(systemName: "text.bubble.fill")
                .font(.system(size: 50))
                .foregroundColor(.purple)
                .padding()
                .background(
                    Circle()
                        .fill(Color.purple.opacity(0.2))
                        .frame(width: 100, height: 100)
                )
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        isAnimating = true
                    }
                }
            
            Text("Basic Message Classification")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Enter a Khmer SMS message to classify it as spam or legitimate")
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
                classify()
            } label: {
                Text("Classify")
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
            
            VStack(spacing: 10) {
                ForEach(presetMessages, id: \.self) { message in
                    Button {
                        inputText = message
                        classify()
                    } label: {
                        Text(message)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.secondarySystemBackground))
                            )
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.primary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private var resultView: some View {
        VStack(spacing: 15) {
            Text("Classification Result")
                .font(.headline)
            
            HStack(spacing: 15) {
                Image(systemName: viewModel.result == "Spam" ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(viewModel.result == "Spam" ? .red : .green)
                    .symbolEffect(.bounce, options: .speed(1.5), value: viewModel.result)
                
                Text(viewModel.result)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.result == "Spam" ? .red : .green)
                    .transition(.scale.combined(with: .opacity))
                    .id(viewModel.result)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(viewModel.result == "Spam" ? Color.red.opacity(0.1) : Color.green.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(viewModel.result == "Spam" ? Color.red.opacity(0.3) : Color.green.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }
    
    private func classify() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            viewModel.classifyMessage(inputText)
        }
    }
}

#Preview {
    BasicClassificationView()
} 