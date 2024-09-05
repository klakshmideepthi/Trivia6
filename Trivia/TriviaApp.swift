import SwiftUI

@main
struct TriviaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    if UserDefaults.standard.bool(forKey: "hasLoadedSampleData") == false {
                        SampleData.loadSampleData(context: persistenceController.container.viewContext)
                        UserDefaults.standard.set(true, forKey: "hasLoadedSampleData")
                    }
                }
        }
    }
}
