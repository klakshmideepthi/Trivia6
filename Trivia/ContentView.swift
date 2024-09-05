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

    var body: some View {
        NavigationView {
            VStack {
                List {
                   ForEach(packs.filter { $0.category == selectedCategory }) { pack in
                       NavigationLink(destination: QuestionView(pack: pack).navigationBarBackButtonHidden(true)) {
                           TriviaPackRow(pack: pack)
                               .contentShape(Rectangle())
                       }
                       .buttonStyle(PlainButtonStyle())
                       .listRowBackground(Color.clear)
                       .listRowSeparator(.hidden)
                   }
               }
                .listStyle(PlainListStyle())
                
                HStack {
                    CategoryButton(title: "Deep", isSelected: selectedCategory == "Deep", action: { selectedCategory = "Deep" })
                    CategoryButton(title: "Couple", isSelected: selectedCategory == "Couple", action: { selectedCategory = "Couple" })
                    CategoryButton(title: "Gossip", isSelected: selectedCategory == "Gossip", action: { selectedCategory = "Gossip" })
                }
                .padding()
            }
            .navigationTitle("Select a Pack")
            .navigationBarItems(trailing: HStack {
                Button(action: { showInfo = true }) {
                    Image(systemName: "info.circle")
                }
                Button(action: { showSettings = true }) {
                    Image(systemName: "gearshape")
                }
            })
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
        HStack {
            Text(pack.emoji ?? "")
            VStack(alignment: .leading) {
                Text(pack.title ?? "").font(.headline)
                Text(pack.subtitle ?? "").font(.subheadline).foregroundColor(.gray)
            }
            Spacer()
            if pack.isLocked {
                Image(systemName: "lock.fill")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(isSelected ? Color.black : Color.clear)
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(20)
        }
    }
}
