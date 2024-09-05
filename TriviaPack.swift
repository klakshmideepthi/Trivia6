//
//  TriviaPack.swift
//  Trivia
//
//  Created by Lakshmi Deepthi Kurugundla on 9/4/24.
//

import Foundation
import CoreData

@objc(TriviaPack)
public class TriviaPack: NSManagedObject {
    @NSManaged public var title: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var emoji: String?
    @NSManaged public var isLocked: Bool
    @NSManaged public var category: String?
    @NSManaged public var questions: [String]?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TriviaPack> {
        return NSFetchRequest<TriviaPack>(entityName: "TriviaPack")
    }
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
