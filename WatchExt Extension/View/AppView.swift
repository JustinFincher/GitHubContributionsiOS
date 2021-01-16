//
//  ContentView.swift
//  WatchExt Extension
//
//  Created by fincher on 1/9/21.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject var environment: Env
    
    var body: some View {
        Form {
            ForEach(0..<environment.userNames.count, id: \.self) { index in
                let userName = environment.userNames[index]
                NavigationLink(
                    destination: ProfileStatusView(userName: userName).environmentObject(environment),
                    label: {
                        HStack {
                            Text("\(userName)")
                            Spacer()
                            if userName == environment.selectedUserName
                            {
                                Image(systemName: "pin.circle.fill")
                            }
                        }
                    })
            }
        }
        .navigationTitle("title_profile")
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .environmentObject(EnvironmentManager.shared.env)
    }
}
