//
//  DomingoWidget.swift
//  DomingoWidget
//
//  Created by Alasdair Casperd on 30/11/2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct DomingoWidgetEntryView : View {
    var entry: Provider.Entry

    var puzzle: Puzzle {
        return Progress.loadStoredPuzzle(for: Puzzle.dailyPuzzle)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Daily Puzzle")
                    .font(.body.weight(.bold))
                    .foregroundColor(Domingo.themeColor)
                Text(Date().formatted(.dateTime.day().month(.wide)))
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    if puzzle.completed {
                        Text("Congratulations! You've already finished today's puzzle.")
                    }
                    else {
                        
                        ForEach(puzzle.questions) { question in
                            HStack {
                                if question.guessed {
                                    Text(question.left.capitalized)
                                    + Text(question.formattedInsert)
                                    + Text(question.right)
                                }
                                else {
                                    if question.left != "" {
                                        Text(question.left.capitalized)
                                    }
                                    Text(Domingo.placeholder)
                                        .foregroundColor(Domingo.themeColor)
                                    Text(question.right)
                                }
                            }
                            .padding(.vertical, 2)
                            .font(.caption.weight(.semibold))
                            if question.id != Puzzle.dailyPuzzleLength - 1 {
                                Divider()
                            }
                        }
                    }
                }
            }
            .padding()
            Spacer()
        }
        .foregroundColor(.primary)
    }
}

struct DomingoWidget: Widget {
    let kind: String = "DomingoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            DomingoWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Daily Puzzle")
        .description("View each day's Daily Puzzle from the comfort of your home screen.")
    }
}

struct DomingoWidget_Previews: PreviewProvider {
    static var previews: some View {
        DomingoWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
