import SwiftUI

struct SettingsView: View {
    @Binding var showSettings: Bool
    @State private var offset: CGFloat = UIScreen.main.bounds.height
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        dismissOverlay(geometry: geometry)
                    }
                
                VStack {
                    Spacer()
                    
                    VStack() {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.gray)
                            .frame(width: 40, height: 5)
                            .padding(.top, 10)
                        
                        Text("Settings")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top)
                            .foregroundColor(.black)
                        
                        VStack(spacing: 0) {
                            SettingsButton(text: "Promo Code", iconName: "lock.fill")
                            SettingsButton(text: "Share the app", iconName: "link")
                            SettingsButton(text: "I have feedback", iconName: "heart.fill")
                            SettingsButton(text: "Send us a message", iconName: "hand.wave.fill")
                        }
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(Color(hex: "#F5F6F4")) // Changed from Color.gray
                    .cornerRadius(20)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.5) // Changed height
                }
                .offset(y: offset + dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.height > 0 {
                                dragOffset = value.translation.height
                            }
                        }
                        .onEnded { value in
                            if value.translation.height > 50 {
                                dismissOverlay(geometry: geometry)
                            } else {
                                withAnimation(.spring()) {
                                    dragOffset = 0
                                }
                            }
                        }
                )
            }
        }
        .onAppear {
            withAnimation(.spring()) {
                offset = 0
            }
        }
    }
    
    private func dismissOverlay(geometry: GeometryProxy) {
        withAnimation(.spring()) {
            offset = geometry.size.height
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showSettings = false
        }
    }
}

struct SettingsButton: View {
    let text: String
    let iconName: String
    
    var body: some View {
        Button(action: {}) {
            HStack {
                Text(text)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: iconName)
                    .foregroundColor(.black)
            }
            .padding()
        }
        .background(Color.white)
    }
}

// Add this extension at the end of the file
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
