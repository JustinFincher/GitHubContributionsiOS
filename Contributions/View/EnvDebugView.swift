//
//  EnvDebugView.swift
//  Contributions
//
//  Created by fincher on 1/11/21.
//

import SwiftUI

struct EnvDebugView: View {
    
    @EnvironmentObject var environment: Env
    
    var body: some View {
        Form {
            Section(header: Text("Data")) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Background Fetch Date")
                        .font(Font.subheadline.bold().smallCaps())
                        .foregroundColor(.init(UIColor.label))
                    Text("\(environment.backgroundFetchTriggeredDate)")
                        .font(.caption)
                        .foregroundColor(.init(UIColor.secondaryLabel))
                }
            }
            
            Section(header: Text("Notification")) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Permission")
                        .font(Font.subheadline.bold().smallCaps())
                        .foregroundColor(.init(UIColor.label))
                    Text("\(environment.notificationPermissionGranted ? "Granted" : "Not Granted")")
                        .font(.caption)
                        .foregroundColor(.init(UIColor.secondaryLabel))
                }
                
                Button(action: {
                    ContributionsManager.shared.backgroundFetchAll {}
                }, label: {
                    Text("Background Refresh")
                        .font(Font.subheadline.bold().smallCaps())
                })
            }
            
            Section(header: Text("GitHub")) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Longest Streak")
                        .font(Font.subheadline.bold().smallCaps())
                        .foregroundColor(.init(UIColor.label))
                    Text("\(environment.userContributions.contributionsFor(name: environment.selectedUserName)?.longestStreak ?? 0)")
                        .font(.caption)
                        .foregroundColor(.init(UIColor.secondaryLabel))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Current Streak")
                        .font(Font.subheadline.bold().smallCaps())
                        .foregroundColor(.init(UIColor.label))
                    Text("\(environment.userContributions.contributionsFor(name: environment.selectedUserName)?.currentStreak ?? 0)")
                        .font(.caption)
                        .foregroundColor(.init(UIColor.secondaryLabel))
                }
            }
        }
        .navigationTitle("title_debug")
    }
}

struct EnvDebugView_Previews: PreviewProvider {
    static var previews: some View {
        EnvDebugView().environmentObject(EnvironmentManager.shared.env)
    }
}
