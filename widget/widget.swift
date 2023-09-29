//
//  widget.swift
//  widget
//
//  Created by Виктор Щелочков on 28.09.2023.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry()
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(/*date: Date(), configuration: configuration*/)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(/*date: entryDate*/)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date = Date()
//    let configuration: ConfigurationIntent
}

struct widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Ring my\nSamsung")
                    .foregroundColor(Color.white)
                    .font(.custom("Samsung Sharp Sans", size: 20).weight(.bold))
            }
        }
        .widgetURL(URL(string: "samsung-pinger-widget://ring"))
    }
}

@main
struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            widgetEntryView(entry: entry)
        }
        .configurationDisplayName("Samsung Pinger Widget")
        .description("Ping your Samsung device")
        .supportedFamilies([.systemSmall])
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        widgetEntryView(entry: SimpleEntry(/*date: Date(), configuration: ConfigurationIntent()*/))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
