//
//  VerbalixWidget.swift
//  VerbalixWidget
//
//  Created by Alex Beals on 10/22/24.
//

import WidgetKit
import SwiftUI
import SwiftData

var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Word.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
      SimpleEntry(date: Date(), word: Word(word: "feculent", definitions: ["Dirty with faeces or other impurities"], dateAdded: Date()))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
      let entry = fetchRandomWord()
              completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
      let currentDate = Date()
              let nextUpdate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!

              let entry = fetchRandomWord()
              let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))

              completion(timeline)
    }
  
  private func fetchRandomWord() -> SimpleEntry {
    let context = ModelContext(sharedModelContainer)

          // Fetch all words
          let fetchDescriptor = FetchDescriptor<Word>()
          let words = try? context.fetch(fetchDescriptor)
    
    print(words)

          // Choose a random word
          guard let randomWord = words?.randomElement() else {
              return SimpleEntry(date: Date(), word: Word(word: "No words added yet", definitions: [""], dateAdded: Date()))
          }

    return SimpleEntry(date: Date(), word: randomWord)
      }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let word: Word
}

struct VerbalixWidgetEntryView : View {
    var entry: Provider.Entry

  var body: some View {
    VStack(alignment: .leading) {
      Text(entry.word.word)
        .font(.title2)
      VStack(alignment: .leading) {
        ForEach(Array(entry.word.definitions), id: \.self) { definition in
          Text(definition)
            .font(.subheadline)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.vertical, 0) // Add some space between definitions
            .padding(.leading, 8)
        }
      }
    }
  }
}

struct VerbalixWidget: Widget {
    let kind: String = "VerbalixWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                VerbalixWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                VerbalixWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    VerbalixWidget()
} timeline: {
  SimpleEntry(date: .now, word: Word(word: "feculent", definitions: ["Dirty with faeces or other impurities"], dateAdded: Date()))
}
