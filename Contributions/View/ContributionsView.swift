//
//  ContributionsView.swift
//  Contributions
//
//  Created by fincher on 1/9/21.
//

import SwiftUI

struct ContributionsView: View {
    
    @Namespace var namespace
    @EnvironmentObject var environment: Env
    @Environment(\.contributions) var contributions : Contributions
    @Environment(\.colorScheme) var colorScheme
    
    @State var selfSizing : Bool = true
    @State var showMonthSymbol : Bool = true
    @State var showWeekSymbol : Bool = true
    @State var shortSymbol : Bool = false
    @State var reverseOrder : Bool = true
    @Binding var showHorizontal : Bool
    
    var getGridItems: [GridItem] {
        var items = Array.init(repeating: GridItem(
            selfSizing ?
                (showHorizontal ? .fixed(28) : .flexible(minimum: 24, maximum: 64)) :
                .flexible(minimum: 8, maximum: .infinity),
            spacing: 0
        ), count: 7)
        if showMonthSymbol {
            items.append(GridItem((selfSizing && showHorizontal) ? .fixed(32) : .flexible()))
        }
        return items
    }
    
    func getContributions(weekCount : Int = .max) -> [[Contribution]] {
        var arr : [[Contribution]] = Array(contributions.twoDListFillingWeekDays.prefix(weekCount))
        if reverseOrder
        {
            arr = arr.reversed()
        }
        return arr
    }
    
    var gridItemOutlineColor: Color {
        #if !os(watchOS)
        return Color.init(UIColor.label)
        #else
        return Color.white
        #endif
    }
    var monthTextColor: Color {
        #if !os(watchOS)
        return Color.init(UIColor.secondaryLabel)
        #else
        return Color.white.opacity(0.7)
        #endif
    }
    
    func getDayItems(weekCount : Int = .max) -> some View {
        Group {
            if showWeekSymbol {
                ForEach((0...6), id: \.self) { i in
                    Text(shortSymbol ?
                            DateFormatter().veryShortWeekdaySymbols[i] : DateFormatter().shortWeekdaySymbols[i])
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                        .font(Font.caption.bold().smallCaps())
                        .matchedGeometryEffect(id: "weekday_\(i)", in: namespace)
                }
            }
            if showMonthSymbol {
                #if os(watchOS)
                Text("")
                    .matchedGeometryEffect(id: "month", in: namespace)
                    .frame(maxWidth: .infinity, maxHeight:.infinity, alignment: .trailing)
                #else
                Text("title_month")
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .matchedGeometryEffect(id: "month", in: namespace)
                    .font(Font.caption.bold().smallCaps())
                    .frame(maxWidth: .infinity, maxHeight:.infinity, alignment: .trailing)
                #endif
            }
            
            ForEach(getContributions(weekCount: weekCount), id: \.self) { week in
                ForEach(week.reversed(), id: \.self) { day in
                    GeometryReader(content: { geometry in
                        Rectangle()
                            .foregroundColor(day.getColor(color: colorScheme))
                            .cornerRadius(geometry.size.width / 6.0)
                            .overlay(
                                RoundedRectangle(cornerRadius: geometry.size.width / 6.0).stroke(gridItemOutlineColor.opacity(0.1), lineWidth: geometry.size.width / 20.0).padding(.all, geometry.size.width / 40.0)
                            )
                            .padding(.all, geometry.size.width / 10.0)
                            .matchedGeometryEffect(id: day, in: namespace)
                            .contextMenu(ContextMenu(menuItems: {
                                Text("\(day.date.dateString)")
                                Divider()
                                Text("\(day.count)")
                            }))
                    })
                    .aspectRatio(1, contentMode: .fit)
                }
                
                if showMonthSymbol,
                   let firstContribution = week.first,
                   let firstDay = firstContribution.date
                {
                    Text("\(shortSymbol ? firstDay.veryShortMonthString : firstDay.shortMonthString)")
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                        .font(Font.caption2.bold().smallCaps())
                        .foregroundColor(monthTextColor)
                        .frame(maxWidth: .infinity, maxHeight:.infinity, alignment: .trailing)
                        .rotationEffect(Angle.degrees(showHorizontal ? 60 : 0))
                }
            }
        }
    }
    
    var body: some View {
        if selfSizing
        {
            ZStack {
                if showHorizontal {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: getGridItems, alignment: .center, spacing: 0, pinnedViews: [], content: {
                            getDayItems()
                        })
                        .padding()
                    }
                } else {
                    LazyVGrid(columns: getGridItems, alignment: .center, spacing: 0, pinnedViews: [], content: {
                        getDayItems()
                    })
                    .padding()
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .global)
                    .onEnded { value in
                        let horizontalAmount = value.translation.width as CGFloat
                        let verticalAmount = value.translation.height as CGFloat
                        if showHorizontal {
                            showMonthSymbol = true
                        } else if (abs(horizontalAmount) > abs(verticalAmount)) {
                            showMonthSymbol = horizontalAmount < 0
                        }
                    }
            )
        } else {
            GeometryReader { geometry in
                if showHorizontal {
                    LazyHGrid(rows: getGridItems, alignment: .center, spacing: 0, pinnedViews: [], content: {
                        getDayItems(weekCount: Int(round(Float(geometry.size.width) / Float(geometry.size.height) * 7)))
                    }).frame(alignment: .center)
                } else {
                    LazyVGrid(columns: getGridItems, alignment: .center, spacing: 0, pinnedViews: [], content: {
                        getDayItems(weekCount: Int(round(Float(geometry.size.height) / Float(geometry.size.width) * 7)))
                    })
                    .padding()
                }
            }
        }
    }
}

struct ContributionsView_Previews: PreviewProvider {
    static var previews: some View {
        ContributionsView(showHorizontal: Binding<Bool>(get: { return false }, set: { _ in }))
    }
}
