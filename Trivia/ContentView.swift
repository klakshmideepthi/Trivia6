import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: TriviaPack.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TriviaPack.title, ascending: true)],
        animation: .default)
    private var packs: FetchedResults<TriviaPack>
    @State private var selectedCategory = "Deep"
    @State private var showSettings = false
    @State private var showInfo = false
    @State private var oninfoPage = 0
    @State private var selectedCategoryIndex = 0
    @State private var selectedPack: TriviaPack?
    let categories = ["Deep", "Couple", "Gossip"]
    @Namespace private var animation

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack {
                    HStack(spacing: 20) {
                        Text("Select a Pack")
                            .font(.title2)
                            .fontWeight(.heavy)
                        Spacer()
                        Button(action: { showInfo = true }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.white)
                        }
                        Button(action: { showSettings = true }) {
                            Image(systemName: "gearshape")
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 2)
                }
                .background(Color(.systemBackground))
                
                List {
                    ForEach(packs.filter { $0.category == categories[selectedCategoryIndex] }) { pack in
                        TriviaPackRow(pack: pack)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedPack = pack
                            }
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                            .listRowSeparator(.hidden)
                            .padding(.top, 10)
                    }
                }
                .listStyle(PlainListStyle())
                .id(selectedCategoryIndex)
                .transition(.slide)
                .animation(.easeInOut, value: selectedCategoryIndex)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 2)
                
                // Custom category picker
                ZStack {
                    // Background capsule
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                    
                    // Sliding indicator
                    GeometryReader { geometry in
                        Capsule()
                            .fill(Color.white)
                            .frame(width: geometry.size.width / CGFloat(categories.count))
                            .offset(x: CGFloat(selectedCategoryIndex) * (geometry.size.width / CGFloat(categories.count)))
                            .animation(.spring(), value: selectedCategoryIndex)
                    }
                    
                    HStack(spacing: 0) {
                        ForEach(0..<categories.count, id: \.self) { index in
                            Button(action: {
                                withAnimation(.spring()) {
                                    selectedCategoryIndex = index
                                }
                            }) {
                                Text(categories[index])
                                    .font(.system(size: 18, weight: .heavy))
                                    .foregroundColor(selectedCategoryIndex == index ? .black : .gray)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                            }
                        }
                    }
                }
                .frame(height: 44)
                .clipShape(Capsule())
                .padding(.horizontal)
                .padding(.vertical, 16)
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
            .navigationDestination(item: $selectedPack) { pack in
                QuestionView(pack: pack)
            }
        }
        .overlay(
            Group {
                if showInfo {
                    InfoView(currentPage: $oninfoPage, showOverlay: $showInfo)
                        .edgesIgnoringSafeArea(.all)
                }
                if showSettings {
                    SettingsView(showSettings: $showSettings)
                        .edgesIgnoringSafeArea(.all)
                }
            }
        )
    }
}

struct TriviaPackRow: View {
    let pack: TriviaPack
    
    var body: some View {
        HStack(spacing: 2) {
            Text(pack.emoji ?? "")
                .font(.system(size: 24))
                .frame(width: 40, alignment: .leading)
            VStack(alignment: .leading, spacing: 4) {
                // Title
                Text(pack.title ?? "")
                    .font(.title2.weight(.heavy))
                    .foregroundColor(.white)
                // Subtitle and lock icon
                HStack {
                    Text(pack.subtitle ?? "")
                        .font(.caption2.weight(.heavy))
                        .foregroundColor(.gray)
                    if pack.isLocked {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 10))
                    }
                }
            }
            Spacer(minLength: 2)
        }
        .padding(.vertical, 20)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 3)
        )
        .cornerRadius(10)
    }
}
