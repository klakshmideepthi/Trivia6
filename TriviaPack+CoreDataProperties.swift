import Foundation
import CoreData

extension TriviaPack {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TriviaPack> {
        return NSFetchRequest<TriviaPack>(entityName: "TriviaPack")
    }

    @NSManaged public var title: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var emoji: String?
    @NSManaged public var isLocked: Bool
    @NSManaged public var category: String?
    @NSManaged public var questions: [String]?
}

extension TriviaPack {
    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: String)

    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: String)

    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSSet)

    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSSet)
}

extension TriviaPack : Identifiable {
}