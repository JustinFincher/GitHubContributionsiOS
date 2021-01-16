//
//  ProfilePosterView.swift
//  Contributions
//
//  Created by fincher on 1/11/21.
//

import SwiftUI

struct ProfilePosterView: View {
    @EnvironmentObject var environment: Env
    @Binding var userName : String
    @Binding var contributions : Contributions
    @State var showHorizontalGraph : Bool = true

    var body: some View {
        GeometryReader(content: { geometry in
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment:.leading) {
                        Text("\(userName)")
                            .font(Font.largeTitle.bold().smallCaps())
                            .foregroundColor(Color.init(UIColor.label))
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                        Text("title_\(String(contributions.commitsCount))_commits_in_\(String(contributions.list.count))_days")
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .font(Font.callout.bold().smallCaps())
                            .foregroundColor(Color.init(UIColor.tertiaryLabel))
                    }
                    Spacer()
                    Image("app_logo_bw")
                        .resizable()
                        .foregroundColor(Color.green)
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: geometry.size.width * 0.08)
                }
                ContributionsView(
                    selfSizing: false,
                    showMonthSymbol: false,
                    showWeekSymbol: false,
                    reverseOrder: true,
                    showHorizontal: $showHorizontalGraph
                )
                .frame(width: geometry.size.width, height: geometry.size.width / 7, alignment: .center)
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
                
                HStack {
                    Spacer()
                    Text("title_generated_from_contributions")
                        .lineLimit(1)
                        .font(Font.caption2.smallCaps())
                        .foregroundColor(Color.init(UIColor.quaternaryLabel))
                }
                .padding(.top, 4)
            }
        }).padding()
        .frame(width: 500, height: 370, alignment: .center)
    }
}

struct ProfilePosterView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePosterView( userName: Binding<String>(get: { return EnvironmentManager.shared.env.selectedUserName }, set: { _ in }), contributions: Binding<Contributions>(get: { return EnvironmentManager.shared.env.userContributions.contributionsFor(name: EnvironmentManager.shared.env.selectedUserName)!}, set: { _ in }))
            .previewLayout(.fixed(width: 500, height: 370))
    }
}
