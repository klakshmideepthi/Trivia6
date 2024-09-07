import SwiftUI

struct InfoView: View {
    @Binding var currentPage: Int
    @Binding var showOverlay: Bool
    @State private var timer: Timer?
    @State private var offset: CGFloat = UIScreen.main.bounds.height
    @State private var dragOffset: CGFloat = 0
    @State private var isGotItPressed = false
    @State private var isPressedPermanently = false
    @State private var buttonOffset: CGFloat = 0

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
                    
                    VStack(spacing: 20) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.gray)
                            .frame(width: 40, height: 5)
                            .padding(.top, 10)
                        
                        TabView(selection: $currentPage) {
                            instructionView(
                                image: Image(systemName: "hand.tap.fill"),
                                text: "Click to change the theme",
                                subImage: Image("theme-selector")
                            ).tag(0)           
                            instructionView(
                                image: Image(systemName: "hand.tap.fill"),
                                text: "Click a pack for new questions",
                                subImage: Image("pack-selector")
                            ).tag(1)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: 200)
                        .transition(.slide)
                        .foregroundColor(.black)
                        
                        HStack {
                            Circle()
                                .fill(currentPage == 0 ? Color.red : Color.gray)
                                .frame(width: 8, height: 8)
                            Circle()
                                .fill(currentPage == 1 ? Color.red : Color.gray)
                                .frame(width: 8, height: 8)
                        }
                        
                        Button(action: {
                            if !isPressedPermanently {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isGotItPressed = true
                                    isPressedPermanently = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    dismissOverlay(geometry: geometry)
                                }
                            }
                        }) {
                            Text("Got it!")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(10)
                        }
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isGotItPressed)
                        .padding(.bottom, 20)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
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
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func dismissOverlay(geometry: GeometryProxy) {
        withAnimation(.spring()) {
            offset = geometry.size.height
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showOverlay = false
        }
    }
    
    func instructionView(image: Image, text: String, subImage: Image) -> some View {
        VStack(spacing: 20) {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.yellow)
            
            Text(text)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            subImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentPage = (currentPage + 1) % 2
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
