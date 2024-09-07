import Foundation
import CoreData

struct SampleData {
    static func loadSampleData(context: NSManagedObjectContext) {
        let gossipPacks = [
            ("Spill the Tea", "pov: you just had an hour-long gossip session", "😈", false),
            ("Juicy Convos", "All about relationships, cheating, and exes!", "🍑", true),
            ("Confessions", "Expose your hidden secrets, no one is safe.", "🤫", true),
            ("Spicy Questions", "Turn up the heat with - extra risqué dares.", "🥵", true),
            ("Would You Rather", "The classic game but much more intense.", "🤔", true)
        ]
        
        let couplePacks = [
            ("Couple Questions", "Questions that will leave you feeling closer.", "💌", false),
            ("For Soulmates", "Get real, vulnerable and — deepen your love.", "💞", true),
            ("Couple Therapy", "Deep & rarely-asked questions. Meant to heal.", "🤍", true),
            ("For Long-Distance", "Warning: this will make it difficult to hang up.", "📹", true),
            ("Naughty Questions", "Questions for every couple's favorite subject.", "💋", true)
        ]
        
        let deepPacks = [
            ("Deep Questions", "Questions that hit deep.", "✨", false),
            ("Late Night Talks", "Get to know each other — for real.", "🌙", true),
            ("For Best Friends", "How well do you really know them?", "✌️", true),
            ("Getting to Know", "Questions to meet someone new.", "👥", true),
            ("For Siblings", "Ask each other before it's too late.", "🖤", true)
        ]
        
        func createPacks(_ packs: [(String, String, String, Bool)], category: String) {
            for pack in packs {
                let newPack = TriviaPack(context: context)
                newPack.title = pack.0
                newPack.subtitle = pack.1
                newPack.emoji = pack.2
                newPack.isLocked = pack.3
                newPack.category = category
                
                // Add 20 random questions to each pack
                let randomQuestions = generateRandomQuestions(20)
                newPack.questions = randomQuestions
            }
        }
        
        createPacks(deepPacks, category: "Deep")
        createPacks(couplePacks, category: "Couple")
        createPacks(gossipPacks, category: "Gossip")
        
        do {
            try context.save()
            print("Sample data saved successfully")
        } catch {
            print("Error saving context: \(error)")
        }
    }

    static func generateRandomQuestions(_ count: Int) -> [String] {
        let questionTemplates = [
            "What's your favorite memory of %@?",
            "If you could change one thing about %@, what would it be?",
            "What's the most challenging aspect of %@?",
            "How has %@ impacted your life?",
            "What's a common misconception about %@?",
            "If you could be an expert in %@, what would you do?",
            "What's the funniest thing that happened to you related to %@?",
            "How do you think %@ will change in the next 10 years?",
            "What's the best advice you've received about %@?",
            "If you could meet anyone associated with %@, who would it be and why?"
        ]

        let topics = [
            "your childhood", "your career", "technology", "relationships",
            "travel", "food", "music", "movies", "books", "sports",
            "politics", "science", "art", "fashion", "education",
            "health", "nature", "social media", "history", "the future"
        ]

        return (0..<count).map { _ in
            let template = questionTemplates.randomElement()!
            let topic = topics.randomElement()!
            return String(format: template, topic)
        }
    }
}
