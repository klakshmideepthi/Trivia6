import SwiftUI

struct SettingsView: View {
    @Binding var showSettings: Bool
    @State private var offset: CGFloat = UIScreen.main.bounds.height
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        dismissOverlay(geometry: geometry)
                    }
                
                VStack {
                    Spacer()
                    
                    VStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.gray)
                            .frame(width: 40, height: 5)
                            .padding(.top, 10)
                        
                        Text("Settings")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top)
                        
                        List {
                            Button(action: {}) {
                                HStack {
                                    Text("Promo Code")
                                    Spacer()
                                    Image(systemName: "lock.fill")
                                }
                            }
                            Button(action: {}) {
                                HStack {
                                    Text("Share the app")
                                    Spacer()
                                    Image(systemName: "link")
                                }
                            }
                            Button(action: {}) {
                                HStack {
                                    Text("I have feedback")
                                    Spacer()
                                    Image(systemName: "heart.fill")
                                }
                            }
                            Button(action: {}) {
                                HStack {
                                    Text("Send us a message")
                                    Spacer()
                                    Image(systemName: "hand.wave.fill")
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .frame(width: geometry.size.width, height: 380)
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
