//
//  UserStatusView.swift
//  WatchExt Extension
//
//  Created by fincher on 1/11/21.
//

import SwiftUI

struct ProfileStatusView: View {
    @State var userName : String
    @State var showHorizontal : Bool = false
    @EnvironmentObject var environment: Env
    @State var contributions : Contributions?
    var body: some View {
        Group {
            if let contributions = contributions {
                GeometryReader(content: { geometry in
                    ScrollView(.vertical, showsIndicators: true, content: {
                        VStack {
                            HStack {
                                GitHubAvatarImageView(userName: userName, shadow: false)
                                    .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2, alignment: .center)
                                Text("title_\(String(contributions.commitsCount))_commits_in_\(String(contributions.list.count))_days")
                                    .font(.caption)
                            }
                            .padding(.top)
                            .padding(.horizontal)
                            ContributionsView(
                                selfSizing: false,
                                showMonthSymbol: false,
                                showWeekSymbol: true,
                                shortSymbol: true,
                                reverseOrder: false,
                                showHorizontal: $showHorizontal
                            ).frame(width: geometry.size.width, alignment: .center)
                            .aspectRatio(0.5, contentMode: .fit)
                            Text("title_stats_updated_\(contributions.updated, style: .relative)_ago")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                    })
                })
                .environment(\.contributions, contributions)
                .environmentObject(environment)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .onAppear(perform: {
            contributions = environment.userContributions.contributionsFor(name: userName)
        })
        .onDisappear(perform: {
            contributions = nil
        })
        .animation(.easeInOut)
        .transition(.slide)
        .navigationTitle(userName)
    }
}

struct ProfileStatusView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileStatusView(userName: "JustinFincher")
            .environmentObject(EnvironmentManager.shared.env)
    }
}
