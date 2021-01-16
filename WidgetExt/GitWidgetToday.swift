//
//  GitWidgetToday.swift
//  WidgetExtExtension
//
//  Created by fincher on 1/10/21.
//

import WidgetKit
import SwiftUI
import Intents

class TodayConfigurationIntentHandler: INExtension, TodayConfigurationIntentHandling {
    func provideUserNameOptionsCollection(for intent: TodayConfigurationIntent, with completion: @escaping (INObjectCollection<NSString>?, Error?) -> Void) {
        completion(INObjectCollection(items: EnvironmentManager.shared.env.userNames.map({ s -> NSString in
            s as NSString
        })), nil)
    }
    
}

struct TodayStyleProvider : IntentTimelineProvider
{
    func placeholder(in context: Context) -> TodayStyleTimelineEntry {
        TodayStyleTimelineEntry(
            entryDate: Date(),
            configuration: TodayConfigurationIntent(),
            placeholder: true,
            preview: context.isPreview
        )
    }

    func getSnapshot(for configuration: TodayConfigurationIntent, in context: Context, completion: @escaping (TodayStyleTimelineEntry) -> ())
    {
        let currentDate = Date()
        let entry = TodayStyleTimelineEntry(
            entryDate: currentDate,
            configuration: configuration,
            placeholder: false,
            preview: context.isPreview
        )
        completion(entry)
    }
    
    func getTimeline(for configuration: TodayConfigurationIntent, in context: Context, completion: @escaping (Timeline<TodayStyleTimelineEntry>) -> ())
    {
        var entries: [TodayStyleTimelineEntry] = []
        let currentDate = Date()
        for times in 0 ..< 2 {
            let minutes = times * 15;
            let entryDate = Calendar.autoupdatingCurrent.date(byAdding: .minute, value: minutes, to: currentDate)!
            let entry = TodayStyleTimelineEntry(
                entryDate: entryDate,
                configuration: configuration,
                placeholder: false,
                preview: context.isPreview
            )
            entries.append(entry)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}


struct TodayStyleTimelineEntry: TimelineEntry {
    let date: Date
    let configuration: TodayConfigurationIntent
    let placeholder: Bool
    let preview: Bool
    var relevance: TimelineEntryRelevance? {
        let score = Float(((300.0 - abs(date.timeIntervalSinceNow)) / 300.0).clamped(to: 0...1) * 100.0)
        return TimelineEntryRelevance.init(score: score, duration: 600)
    }
    
    init(entryDate: Date, configuration: TodayConfigurationIntent, placeholder: Bool, preview: Bool) {
        self.date = entryDate
        self.configuration = configuration
        self.placeholder = placeholder
        self.preview = preview
    }
}

struct TodayStyleWidget: View
{
    var entry: TodayStyleProvider.Entry
    @EnvironmentObject var environment: Env
    @Environment(\.widgetFamily) var family : WidgetFamily
    @State var showHorizontal : Bool = true
    @Environment(\.colorScheme) var colorScheme
    
    var getUserAndContributions: (userName: String, contributions: Contributions)? {
        var userName : String?
        var contributions : Contributions?
        if entry.preview || entry.placeholder {
            let sample = environment.userContributions.generateSampleData()
            userName = sample.0
            contributions = sample.1
        } else {
            userName = (entry.configuration.customUserName?.boolValue ?? false) ? entry.configuration.userName : EnvironmentManager.shared.env.selectedUserName
            contributions = EnvironmentManager.shared.env.userContributions.contributionsFor(name: userName ?? "")
        }
        if let userName = userName,
           let contributions = contributions
        {
            return (userName, contributions)
        } else {
            return nil
        }
    }
    
    var body : some View
    {
        if let pair = getUserAndContributions,
           let lastContribution : Contribution = pair.contributions.list.last
        {
            ZStack {
                Rectangle()
                    .foregroundColor(lastContribution.getColor(color: colorScheme))
                VStack {
                    Text("\(lastContribution.count)")
                        .font(Font.largeTitle.bold().smallCaps())
                        .foregroundColor(lastContribution.count > 0 ? Color.init(UIColor.systemBackground) : Color.init(UIColor.label))
                    Text(lastContribution.count <= 1 ? "title_x_commit" : "title_x_commits")
                        .font(Font.callout.bold().smallCaps())
                        .foregroundColor(lastContribution.count > 0 ? Color.init(UIColor.systemBackground) : Color.init(UIColor.secondaryLabel))
                }
            }
            .clipShape(ContainerRelativeShape())
            .padding()
            .if(entry.placeholder) { view in
                view.redacted(reason: .placeholder)
            }
        } else {
            Text("title_no_data")
                .font(Font.title.bold().smallCaps())
                .foregroundColor(Color.init(UIColor.label))
                .lineLimit(1)
                .minimumScaleFactor(0.1)
        }
    }
}

struct GitWidgetToday : Widget
{
    var body: some WidgetConfiguration
    {
        IntentConfiguration(kind: "widget.minimal.today",
                            intent: TodayConfigurationIntent.self,
                            provider: TodayStyleProvider()) { entry in
            TodayStyleWidget(entry: entry)
                .environmentObject(EnvironmentManager.shared.env)
        }
        .configurationDisplayName("title_widget_minimal_today")
        .description("desc_widget_minimal_today")
        .supportedFamilies([.systemSmall])
        .onBackgroundURLSessionEvents(matching: "widget.refresh") { (identifier, competion) in
            
        }
    }
}

struct GitWidgetToday_Previews: PreviewProvider
{
    
    static var previews: some View {
        
        TodayStyleWidget(
            entry: TodayStyleTimelineEntry(
                entryDate: Date(),
                configuration: TodayConfigurationIntent(),
                placeholder: false,
                preview: false)
        ).previewContext(WidgetPreviewContext(family: .systemSmall))
        .environmentObject(EnvironmentManager.shared.env)
    }
}
