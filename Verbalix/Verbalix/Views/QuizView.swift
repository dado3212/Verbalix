//
//  QuizView.swift
//  Verbalix
//
//  Created by Alex Beals on 11/3/24.
//

import SwiftUI
import SwiftData

struct QuizView: View {
  @Query private var _words: [Word]
  @State private var shuffledWords: [Word] = []
  @State private var currentIndex = 0
  @State private var showDefinition = false
  
  var body: some View {
    ZStack {
      Button(action: {
        // No spoilers :D
        showDefinition = false
        currentIndex = (currentIndex + 1) % shuffledWords.count
      }) {
        Text("Next Word")
          .font(.headline)
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(8)
      }.padding(.top, 10)
        .padding(.trailing, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
      
      VStack {
        if !shuffledWords.isEmpty {
          VStack {
            Text(shuffledWords[currentIndex].word)
              .font(.largeTitle)
              .padding()
              .onTapGesture {
                showDefinition.toggle()
              }
            
            Text(shuffledWords[currentIndex].definitions.first!)
              .font(.title3)
              .padding()
              .transition(.opacity)
              .opacity(showDefinition ? 1 : 0)
          }
          .padding(.bottom, 50)
        } else {
          Text("No words available.")
        }
      }
    }
    .onAppear {
      if shuffledWords.isEmpty {
        shuffledWords = _words.shuffled()
        currentIndex = 0
      }
    }
  }
}

#Preview {
  
  let config = ModelConfiguration(isStoredInMemoryOnly: true)
  let container = try! ModelContainer(for: Word.self, configurations: config)
  
  container.mainContext.insert(Word(word: "feculent", definitions: ["Dirty with faeces or other impurities"], dateAdded: Date()))
  container.mainContext.insert(Word(word: "feculentOther", definitions: ["No definition :("], dateAdded: Date()))
  
  return QuizView()
    .modelContainer(container)
}
