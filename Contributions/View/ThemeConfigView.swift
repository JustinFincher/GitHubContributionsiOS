//
//  ThemeConfigView.swift
//  Contributions
//
//  Created by fincher on 1/10/21.
//

import SwiftUI

struct ThemeConfigView: View {
    
    @EnvironmentObject var environment: Env
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
//            Section(header: Text("title_color")) {
//                ScrollView(.horizontal, showsIndicators: false, content: {
//                    HStack {
//                        ForEach(environment.availableThemeHexStrings, id: \.self) { str in
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 9)
//                                    .frame(width: 80, height: 80, alignment: .center)
//                                    .onTapGesture {
//                                        environment.themeHexString = str
//                                    }
//                                    .foregroundColor(Color.init(str.hexStringToUIColor()))
//                                if environment.themeHexString == str
//                                {
//                                    Image(systemName: "checkmark.circle")
//                                }
//                            }
//                        }
//                    }
//                    .padding()
//                }).listRowInsets(EdgeInsets())
//            }
//            
//            Section(header: Text("title_misc")) {
//                HStack {
//                    Image(systemName: "link")
//                    Toggle("title_ui_follow_theme", isOn: $environment.controlFollowTheme)
//                        .font(Font.body.bold().smallCaps())
//                }
//            }
        }
        .navigationTitle("title_theme")
    }
}

struct ThemeConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeConfigView()
            .environmentObject(EnvironmentManager.shared.env)
    }
}
