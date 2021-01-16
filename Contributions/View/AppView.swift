//
//  AppView.swift
//  Contributions
//
//  Created by fincher on 1/7/21.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject var environment: Env
    @State var showNewVersionSheet : Bool = false
   
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            TabView(selection: $environment.selectedTabIndex)
            {
                OverviewView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("title_overview")
                    }.tag(0)
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("title_settings")
                    }.tag(1)
                #if DEBUG
                #endif
            }
            .accentColor(environment.accentColor)
            .onAppear(perform: {
                if let build = Bundle.main.buildString,
                   let version = Bundle.main.versionString,
                   (environment.currentBuild != build || environment.currentVersion != version)
                {
                    environment.currentBuild = build
                    environment.currentVersion = version
                }
                if environment.currentFeatureMark != ContributionsAppInfo.featureMark
                {
                    environment.currentFeatureMark = ContributionsAppInfo.featureMark
                    showNewVersionSheet = true
                }
            })
            .sheet(isPresented: $showNewVersionSheet, content: {
                WhatsNewView()
            })
            
            ZStack {
                environment.globalView
                    .opacity(environment.showGlobalView ? 1 : 0)
                    .offset(x: 0, y: environment.showGlobalView ? 0 : -100)
                    .allowsHitTesting(environment.showGlobalView)
            }.animation(.easeInOut)
            .transition(.slide)
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .environmentObject(EnvironmentManager.shared.env)
    }
}
