//
//  OtherAppsView.swift
//  Contributions
//
//  Created by fincher on 1/11/21.
//

import SwiftUI

struct OtherAppsView: View {
    
    @EnvironmentObject var environment: Env
    
    var body: some View {
        Form {
            Section {
                AppStoreLinkView(url: "https://apps.apple.com/us/app/age-clock/id1152838744", name: "Age Clock", image: "AgeClock", desc: "Age Widget & Watch Apps")
                    .padding(.vertical)
                AppStoreLinkView(url: "https://apps.apple.com/us/app/mapaper/id1546487705", name: "Mapaper", image: "Mapaper", desc: "Dynamic Wallpaper via Shortcuts")
                    .padding(.vertical)
                AppStoreLinkView(url: "https://apps.apple.com/us/app/shader-node/id1460562911", name: "Shader Node", image: "ShaderNode", desc: "WWDC 20 Scholarship Winner")
                    .padding(.vertical)
                AppStoreLinkView(url: "https://apps.apple.com/us/app/epoch-core/id1177530091", name: "EpochCore", image: "EpochCore", desc: "Space Simulator")
                    .padding(.vertical)
            }
            
            Button(action: {
                UIApplication.shared.open(URL.init(string: "https://apps.apple.com/developer/haotian-zheng/id981803173")!, options: [:], completionHandler: nil)
            }, label: {
                HStack {
                    Image(systemName: "eyes.inverse")
                    Text("button_view_all")
                        .font(Font.body.bold().smallCaps())
                }
            })
        }
        .navigationTitle("title_other_apps")
    }
}

struct OtherAppsView_Previews: PreviewProvider {
    static var previews: some View {
        OtherAppsView().environmentObject(EnvironmentManager.shared.env)
    }
}
