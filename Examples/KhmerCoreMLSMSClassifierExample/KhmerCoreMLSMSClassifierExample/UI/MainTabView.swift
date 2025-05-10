import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            BasicClassificationView()
                .tabItem {
                    Label("Basic", systemImage: "text.bubble")
                }
                .tag(0)
            
            DetailedClassificationView()
                .tabItem {
                    Label("Detailed", systemImage: "chart.bar")
                }
                .tag(1)
            
            TextPreprocessingView()
                .tabItem {
                    Label("Preprocess", systemImage: "character")
                }
                .tag(2)
        }
        .tint(Color("AccentColor"))
    }
}

#Preview {
    MainTabView()
} 