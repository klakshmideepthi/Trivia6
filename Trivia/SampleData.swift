import Foundation
import CoreData

struct SampleData {
    static func loadSampleData(context: NSManagedObjectContext) {
        let deepPacks = [
            ("History Buffs", "Test your knowledge of the past", "📜", false),
            ("Science Geeks", "Explore the wonders of science", "🔬", true),
            ("Pop Culture Pros", "From movies to music, prove your expertise", "🎬", true),
            ("Geography Gurus", "Travel the world with your mind", "🌎", true),
            ("Literature Lovers", "Dive into the world of books", "📚", true)
        ]
        
        let couplePacks = [
            ("Relationship Quiz", "How well do you know your partner?", "❤️", false),
            ("Date Night Trivia", "Spice up your evening with fun questions", "🍷", true),
            ("Love Language Test", "Discover your love languages", "💕", true),
            ("Couples' Compatibility", "Are you truly meant to be?", "🔐", true),
            ("Romantic Movie Buff", "Test your knowledge of rom-coms", "🎥", true)
        ]
        
        let gossipPacks = [
            ("Celebrity Gossip", "Stay up-to-date with the stars", "🌟", false),
            ("Scandal Central", "Revisit the biggest controversies", "🗞️", true),
            ("Reality TV Drama", "From housewives to bachelors", "📺", true),
            ("Fashion Faux Pas", "Relive the most memorable style mishaps", "👗", true),
            ("Social Media Buzz", "Test your knowledge of viral moments", "📱", true)
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
