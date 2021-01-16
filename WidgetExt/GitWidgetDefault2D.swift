//
//  GitWidgetDefault2D.swift
//  Contributions
//
//  Created by fincher on 10/19/20.
//

import WidgetKit
import SwiftUI
import Intents

class Default2DConfigurationIntentHandler: INExtension, Default2DConfigurationIntentHandling {
    func provideUserNameOptionsCollection(for intent: Default2DConfigurationIntent, with completion: @escaping (INObjectCollection<NSString>?, Error?) -> Void) {
        
        completion(INObjectCollection(items: EnvironmentManager.shared.env.userNames.map({ s -> NSString in
            s as NSString
        })), nil)
    }
}

struct Default2DStyleProvider : IntentTimelineProvider
{
    func placeholder(in context: Context) -> Default2DStyleTimelineEntry {
        Default2DStyleTimelineEntry(
            entryDate: Date(),
            configuration: Default2DConfigurationIntent(),
            placeholder: true,
            preview: context.isPreview)
    }

    func getSnapshot(for configuration: Default2DConfigurationIntent, in context: Context, completion: @escaping (Default2DStyleTimelineEntry) -> ())
    {
        let currentDate = Date()
        let entry = Default2DStyleTimelineEntry(
            entryDate: currentDate,
            configuration: configuration,
            placeholder: false,
            preview: context.isPreview
        )
        completion(entry)
    }

    func getTimeline(for configuration: Default2DConfigurationIntent, in context: Context, completion: @escaping (Timeline<Default2DStyleTimelineEntry>) -> ())
    {
        var entries: [Default2DStyleTimelineEntry] = []
        let currentDate = Date()
        for times in 0 ..< 2 {
            let minutes = times * 15;
            let entryDate = Calendar.autoupdatingCurrent.date(byAdding: .minute, value: minutes, to: currentDate)!
            let entry = Default2DStyleTimelineEntry(
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


struct Default2DStyleTimelineEntry: TimelineEntry {
    let date: Date
    let configuration: Default2DConfigurationIntent
    let placeholder: Bool
    let preview: Bool
    var relevance: TimelineEntryRelevance? {
        let score = Float(((300.0 - abs(date.timeIntervalSinceNow)) / 300.0).clamped(to: 0...1) * 100.0)
        return TimelineEntryRelevance.init(score: score, duration: 600)
    }
    
    init(entryDate: Date, configuration: Default2DConfigurationIntent, placeholder: Bool, preview: Bool) {
        self.date = entryDate
        self.configuration = configuration
        self.placeholder = placeholder
        self.preview = preview
    }
}

struct Default2DStyleWidget: View
{
    var entry: Default2DStyleProvider.Entry
    @EnvironmentObject var environment: Env
    @Environment(\.widgetFamily) var family : WidgetFamily
    @State var showHorizontal : Bool = true
    
    func getViewSmall(environment: Env, userName: String, contributions: Contributions) -> some View {
        VStack(alignment: .center, spacing: 8) {
            HStack {
                Image("app_logo_bw")
                    .resizable()
                    .foregroundColor(Color.green)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 12)
                Text("\(userName)")
                    .font(Font.caption.bold().smallCaps())
                    .foregroundColor(Color.init(UIColor.secondaryLabel))
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                Spacer()
            }
            ContributionsView(
                selfSizing: false,
                showMonthSymbol: false,
                showWeekSymbol: false,
                showHorizontal: $showHorizontal
            )
            .environment(\.contributions, contributions)
        }
        .padding()
    }
    
    func getViewMedium(environment: Env, userName: String, contributions: Contributions) -> some View {
        VStack(alignment: .center, spacing: nil) {
            HStack(alignment: .top, spacing: nil) {
                ContributionsView(
                    selfSizing: false,
                    showMonthSymbol: false,
                    showWeekSymbol: false,
                    showHorizontal: $showHorizontal
                )
                .environment(\.contributions, contributions)
                Image("app_logo_bw")
                    .resizable()
                    .foregroundColor(Color.green)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 24)
                    .padding(.leading, 2)
            }
            HStack {
                Text("title_\(String(contributions.commitsCount))_commits_in_\(String(contributions.list.count))_days_updated_\(contributions.updated, style: .relative)_ago")
                    .font(Font.caption2.smallCaps())
                    .foregroundColor(Color.init(UIColor.tertiaryLabel))
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .padding(.bottom, 12)
    }
    
    func getViewLarge(environment: Env, userName: String, contributions: Contributions) -> some View {
        GeometryReader(content: { geometry in
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment:.leading) {
                        Text("\(userName)")
                            .font(Font.title.bold().smallCaps())
                            .foregroundColor(Color.init(UIColor.label))
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                        Text("title_stats_updated_\(contributions.updated, style: .relative)_ago")
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .font(Font.caption2.bold().smallCaps())
                            .foregroundColor(Color.init(UIColor.tertiaryLabel))
                    }
                    Spacer()
                    Image("app_logo_bw")
                        .resizable()
                        .foregroundColor(Color.green)
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 28)
                }
                ContributionsView(
                    selfSizing: false,
                    showMonthSymbol: false,
                    showWeekSymbol: false,
                    showHorizontal: $showHorizontal
                )
                .frame(width: geometry.size.width, alignment: .center)
                .aspectRatio(5, contentMode: .fit)
                .environment(\.contributions, contributions)
                
                HStack {
                    Text("\(contributions.commitsCount)")
                        .lineLimit(1)
                        .font(Font.title.bold().smallCaps())
                        .foregroundColor(Color.init(UIColor.secondaryLabel))
                    Spacer()
                    Text("title_x_commits")
                        .lineLimit(1)
                        .font(Font.title.bold().smallCaps())
                        .foregroundColor(Color.init(UIColor.tertiaryLabel))
                }
                
                HStack {
                    Text("\(contributions.commitsAverage, specifier: "%.2f")")
                        .lineLimit(1)
                        .font(Font.title.bold().smallCaps())
                        .foregroundColor(Color.init(UIColor.secondaryLabel))
                    Spacer()
                    Text("title_x_averge")
                        .lineLimit(1)
                        .font(Font.title.bold().smallCaps())
                        .foregroundColor(Color.init(UIColor.tertiaryLabel))
                }
                
                HStack {
                    Text("\(contributions.commitsMostInADay)")
                        .lineLimit(1)
                        .font(Font.title.bold().smallCaps())
                        .foregroundColor(Color.init(UIColor.secondaryLabel))
                    Spacer()
                    Text("title_x_most")
                        .lineLimit(1)
                        .font(Font.title.bold().smallCaps())
                        .foregroundColor(Color.init(UIColor.tertiaryLabel))
                }
                
                HStack {
                    Text("\(contributions.longestStreak)")
                        .lineLimit(1)
                        .font(Font.title.bold().smallCaps())
                        .foregroundColor(Color.init(UIColor.secondaryLabel))
                    Spacer()
                    Text("title_x_longest_streak")
                        .lineLimit(1)
                        .font(Font.title.bold().smallCaps())
                        .foregroundColor(Color.init(UIColor.tertiaryLabel))
                }
                
                HStack {
                    Text("\(contributions.currentStreak)")
                        .lineLimit(1)
                        .font(Font.title.bold().smallCaps())
                        .foregroundColor(Color.init(UIColor.secondaryLabel))
                    Spacer()
                    Text("title_x_current_streak")
                        .lineLimit(1)
                        .font(Font.title.bold().smallCaps())
                        .foregroundColor(Color.init(UIColor.tertiaryLabel))
                }
            }
        }).padding()
    }
    
    var getUserAndContributions: (userName: String, contributions: Contributions)? {
        var userName : String?
        var contributions : Contributions?
        if entry.preview || entry.placeholder {
            let sample = environment.userContributions.generateSampleData()
            userName = sample.0
            contributions = sample.1
        } else {
            userName = ((entry.configuration.customUserName?.boolValue ?? false) && entry.configuration.userName != nil) ? entry.configuration.userName : EnvironmentManager.shared.env.selectedUserName
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
        if let pair = getUserAndContributions
        {
            Group {
                if family == WidgetFamily.systemSmall {
                    getViewSmall(environment: environment, userName: pair.userName, contributions: pair.contributions)
                } else if family == WidgetFamily.systemMedium {
                    getViewMedium(environment: environment, userName: pair.userName, contributions: pair.contributions)
                } else if family == WidgetFamily.systemLarge {
                    getViewLarge(environment: environment, userName: pair.userName, contributions: pair.contributions)
                }
            }
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

struct GitWidgetDefault2D : Widget
{
    var body: some WidgetConfiguration
    {
        IntentConfiguration(kind: "widget.default.2D",
                            intent: Default2DConfigurationIntent.self,
                            provider: Default2DStyleProvider()) { entry in
            Default2DStyleWidget(entry: entry)
                .environmentObject(EnvironmentManager.shared.env)
        }
        .configurationDisplayName("title_widget_default_2d")
        .description("desc_widget_default_2d")
        .supportedFamilies([.systemLarge,.systemMedium,.systemSmall])
        .onBackgroundURLSessionEvents(matching: "widget.refresh") { (identifier, competion) in
            
        }
    }
}

struct GitWidgetDefault2D_Previews: PreviewProvider
{
    
    static var previews: some View {
        
        Default2DStyleWidget(
            entry: Default2DStyleTimelineEntry(
                entryDate: Date(),
                configuration: Default2DConfigurationIntent(),
                placeholder: false,
                preview: true)
        ).previewContext(WidgetPreviewContext(family: .systemSmall))
        .environmentObject(EnvironmentManager.shared.env)
        
        
        Default2DStyleWidget(
            entry: Default2DStyleTimelineEntry(
                entryDate: Date(),
                configuration: Default2DConfigurationIntent(),
                placeholder: false,
                preview: false)
        ).previewContext(WidgetPreviewContext(family: .systemMedium))
        .environmentObject(EnvironmentManager.shared.env)
        
        
        Default2DStyleWidget(
            entry: Default2DStyleTimelineEntry(
                entryDate: Date(),
                configuration: Default2DConfigurationIntent(),
                placeholder: false,
                preview: true)
        ).previewContext(WidgetPreviewContext(family: .systemLarge))
        .environmentObject(EnvironmentManager.shared.env)
    }
}
