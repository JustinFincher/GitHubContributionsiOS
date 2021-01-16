//
//  OverviewView.swift
//  Contributions
//
//  Created by fincher on 1/7/21.
//

import Accelerate
import SwiftUI

struct OverviewView: View {
    
    @Namespace var namespace
    @Environment(\.horizontalSizeClass) var horizontalSizeClass : UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) var verticalSizeClass : UserInterfaceSizeClass?
    @EnvironmentObject var environment: Env
    
    
    
    var body: some View {
        NavigationView {
            if horizontalSizeClass == UserInterfaceSizeClass.regular
            {
                HStack(alignment: .center, spacing: 0) {
                    Text("\(environment.selectedUserName.isEmpty ? NSLocalizedString("title_add_user", comment: "") : environment.selectedUserName)")
                        .font(Font.callout.smallCaps().bold())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding()
                    ProfileSelectionView(vertical: true)
                }
                .navigationTitle("title_profile")
                ScrollView(.vertical, showsIndicators: true, content: {
                    ProfileStatusView(userName: $environment.selectedUserName)
                })
                .navigationTitle("title_contributions")
            }
            else {
                ScrollView(.vertical, showsIndicators: true, content: {
                    VStack(alignment: .center, spacing: 0) {
                        ProfileSelectionView(vertical: false)
                            .padding(.top, 12)
                            .frame(height: 120, alignment: .center)
                        Text("\(environment.selectedUserName.isEmpty ? NSLocalizedString("title_add_user", comment: "") : environment.selectedUserName)")
                            .font(Font.callout.smallCaps().bold())
                            .padding(.bottom, 8)
                        Divider()
                        ProfileStatusView(userName: $environment.selectedUserName)
                    }
                })
                .navigationTitle("title_overview")
            }
        }
        .transition(.opacity)
        .animation(.easeInOut)
    }
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewView()
            .previewDevice("iPad Air (4th generation)")
            .environmentObject(EnvironmentManager.shared.env)
    }
}
