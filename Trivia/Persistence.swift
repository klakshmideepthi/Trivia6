import CoreData

extension NSManagedObjectContext {
    func createTriviaPack() -> TriviaPack {
        let entity = NSEntityDescription.entity(forEntityName: "TriviaPack", in: self)!
        return TriviaPack(entity: entity, insertInto: self)
    }
}

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
            let result = PersistenceController(inMemory: true)
            let viewContext = result.container.viewContext
            
            for i in 0..<10 {
                let newPack = viewContext.createTriviaPack()
                newPack.title = "Sample Pack \(i + 1)"
                newPack.subtitle = "This is a sample trivia pack"
                newPack.emoji = "🎲"
                newPack.category = "Sample"
                newPack.isLocked = false
            }
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            return result
        }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TriviaPack")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
