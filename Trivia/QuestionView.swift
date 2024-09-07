import SwiftUI
import CoreData

struct QuestionView: View {
    let pack: TriviaPack
    @State private var currentQuestionIndex = 0
    @State private var questions: [String] = []
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom navigation bar
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
                Spacer()
                Text(pack.title ?? "Questions")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    // Handle share action
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.black)
            
            // Question card
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(radius: 10)
                        
                        VStack {
                            Spacer()
                            Text(questions.isEmpty ? "No questions available" : questions[currentQuestionIndex])
                                .font(.title2)
                                .multilineTextAlignment(.center)
                                .padding()
                            Spacer()
                            Text(pack.title ?? "Unknown Pack")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .foregroundColor(.black)
                        .padding()
                    }
                    .aspectRatio(3/4, contentMode: .fit)
                    .padding()
                    
                    // Question counter and navigation buttons
                    VStack {
                        Text("\(currentQuestionIndex + 1) / \(questions.count)")
                            .foregroundColor(.white)
                            .padding(.bottom)
                        
                        HStack {
                            Button("Previous") {
                                if currentQuestionIndex > 0 {
                                    currentQuestionIndex -= 1
                                }
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .disabled(currentQuestionIndex == 0)
                            
                            Spacer()
                            
                            Button("Next") {
                                if currentQuestionIndex < questions.count - 1 {
                                    currentQuestionIndex += 1
                                }
                            }
                            .padding()
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .disabled(currentQuestionIndex == questions.count - 1)
                        }
                        .padding()
                    }
                }
            }
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
        .navigationBarHidden(true)
        .onAppear {
            loadQuestions()
        }
    }
    
    private func loadQuestions() {
        questions = pack.questions ?? []
        print("Loaded \(questions.count) questions")
    }
}
