//
//  GitWidgetDefault3D.swift
//  Contributions
//
//  Created by fincher on 10/19/20.
//

import WidgetKit
import SwiftUI
import Intents

struct Default3DStyleProvider : IntentTimelineProvider
{
    func placeholder(in context: Context) -> Default3DStyleTimelineEntry {
        Default3DStyleTimelineEntry(
            entryDate: Date(),
            configuration: Default3DConfigurationIntent(),
            placeholder: true)
    }

    func getSnapshot(for configuration: Default3DConfigurationIntent, in context: Context, completion: @escaping (Default3DStyleTimelineEntry) -> ())
    {
        let currentDate = Date()
        let entry = Default3DStyleTimelineEntry(
            entryDate: currentDate,
            configuration: configuration,
            placeholder: false
        )
        completion(entry)
    }

    func getTimeline(for configuration: Default3DConfigurationIntent, in context: Context, completion: @escaping (Timeline<Default3DStyleTimelineEntry>) -> ())
    {
        var entries: [Default3DStyleTimelineEntry] = []
        
        let currentDate = Date()
        for times in 0 ..< 12 {
            let entryDate = Calendar.autoupdatingCurrent.date(byAdding: .minute, value: times * 30, to: currentDate)!
            let entry = Default3DStyleTimelineEntry(
                entryDate: entryDate,
                configuration: configuration,
                placeholder: false
            )
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}


struct Default3DStyleTimelineEntry: TimelineEntry
{
    let date: Date
    let configuration: Default3DConfigurationIntent
    let placeholder: Bool
    
    init(entryDate: Date, configuration: Default3DConfigurationIntent, placeholder: Bool) {
        self.date = entryDate
        self.configuration = configuration
        self.placeholder = placeholder
    }
}

struct Default3DStyleWidget: View
{
    var entry: Default3DStyleProvider.Entry
    @Environment(\.widgetFamily) var family

    
    var body : some View
    {
        Text("No Data")
    }
}

struct GitWidgetDefault3D : Widget
{
    var body: some WidgetConfiguration
    {
            IntentConfiguration(kind: "widget.default.3D",
                                intent: Default3DConfigurationIntent.self,
                                provider: Default3DStyleProvider()) { entry in
                Default3DStyleWidget(entry: entry)
            }
            .configurationDisplayName("Default (3D)")
            .description("Widgets to display your github contributions graph")
            .supportedFamilies([.systemLarge,.systemMedium,.systemSmall])
            .onBackgroundURLSessionEvents(matching: "widget.refresh") { (identifier, competion) in
                
            }
    }
}

struct GitWidgetDefault3D_Previews: PreviewProvider
{

    static var previews: some View {

        Default3DStyleWidget(
            entry: Default3DStyleTimelineEntry(
                entryDate: Date(),
                configuration: Default3DConfigurationIntent(),
                placeholder: false)
        ).previewContext(WidgetPreviewContext(family: .systemSmall))


        Default3DStyleWidget(
            entry: Default3DStyleTimelineEntry(
                entryDate: Date(),
                configuration: Default3DConfigurationIntent(),
                placeholder: false)
        ).previewContext(WidgetPreviewContext(family: .systemMedium))


        Default3DStyleWidget(
            entry: Default3DStyleTimelineEntry(
                entryDate: Date(),
                configuration: Default3DConfigurationIntent(),
                placeholder: false)
        ).previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
