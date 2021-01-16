//
//  AboutView.swift
//  Contributions
//
//  Created by fincher on 1/7/21.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var environment: Env

    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass : UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) var verticalSizeClass : UserInterfaceSizeClass?
    
    var body: some View {
        NavigationView {
//            ZStack {
//                Color.init(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
//                ScrollView(.vertical, showsIndicators: true, content: {
//                    scrollContent
//                        .transition(.opacity)
//                        .animation(.easeInOut)
//                })
//            }
            Form {
                
                // header
                Button(action: {
                    UIApplication.shared.open(URL.init(string: "https://apps.apple.com/us/app/contributions-for-github/id1153432612")!, options: [:], completionHandler: nil)
                }, label: {
                    VStack (alignment: .center, spacing: 0) {
                        Image("Icon")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .mask(RoundedRectangle(cornerRadius: 24))
                            .shadow(color: .init(UIColor.quaternaryLabel), radius: 8, x: 0, y: 2)
                            .frame(height: 100)
                            .padding()
                        Text("app_name")
                            .font(Font.callout.smallCaps().bold())
                            .padding(.bottom, 2)
                            .foregroundColor(Color.init(UIColor.label))
                        Text("desc_app_name")
                            .frame(maxWidth: .infinity)
                            .font(Font.caption.bold().smallCaps())
                            .foregroundColor(Color.init(UIColor.secondaryLabel))
                        Text("title_version_\(Bundle.main.versionString ?? "null")_(\(Bundle.main.buildString ?? "null"))")
                            .frame(maxWidth: .infinity)
                            .font(Font.caption2.bold().smallCaps())
                            .foregroundColor(Color.init(UIColor.tertiaryLabel))
                    }.padding(.vertical, 4)
                })
                
                // permission
                if !environment.permissionsAllGranted
                {
                    Section(header: Text("title_permission")) {
                        if !environment.notificationPermissionGranted {
                            Button(action: {
                                NotificationManager.shared.requestPermission()
                            }, label: {
                                HStack {
                                    Image(systemName: "app.badge.fill")
                                    Text("button_grant_notification_permission")
                                        .font(Font.body.bold().smallCaps())
                                }
                            })
                        }
                    }
                }
                
                // notification
                Section(header: Text("title_notification")) {
                    HStack {
                        Image(systemName: "bolt.horizontal.fill")
                        Toggle("toggle_notification_when_background_refresh", isOn: $environment.postBackgroundRefreshNotification)
                            .font(Font.body.bold().smallCaps())
                            .disabled(!environment.notificationPermissionGranted)
                    }
                    .opacity(environment.notificationPermissionGranted ? 1.0 : 0.3)
                }
                
                // theme
                // dont have time for theme and HSL color mix, maybe when I have time later in March
//                Section(header: Text("title_theme")) {
//                    NavigationLink(
//                        destination: ThemeConfigView(),
//                        label: {
//                            HStack {
//                                Image(systemName: "wand.and.stars")
//                                Text("button_config_theme")
//                                    .font(Font.body.bold().smallCaps())
//                            }
//                        })
//                }
                
                // support
                Section(header: Text("title_support_author")) {
                    if environment.canUseIAP {
                        NavigationLink(
                            destination: SupportAuthorView(),
                            label: {
                                HStack {
                                    Image(systemName: "gift.fill")
                                    Text("button_buy_me_a_coffee")
                                        .font(Font.body.bold().smallCaps())
                                }
                            })
                    }
                    
                    Button(action: {
                        UIApplication.shared.open(URL.init(string: "https://github.com/JustinFincher/GitHubContributionsiOS")!, options: [:], completionHandler: nil)
                    }, label: {
                        HStack {
                            Image(systemName: "star.circle.fill")
                            Text("button_star_on_github")
                                .font(Font.body.bold().smallCaps())
                        }
                    })
                }
                
                // misc
                Section(header: Text("title_misc")) {
                    NavigationLink(
                        destination: OtherAppsView(),
                        label: {
                            HStack {
                                Image(systemName: "guitars.fill")
                                Text("button_other_apps")
                                    .font(Font.body.bold().smallCaps())
                            }
                        })
                    #if DEBUG
                    NavigationLink(
                        destination: EnvDebugView(),
                        label: {
                            HStack {
                                Image(systemName: "dpad.fill")
                                Text("button_view_debug")
                                    .font(Font.body.bold().smallCaps())
                            }
                        })
                    #endif
                }
                
                Section {
                    ZStack {
                        Text("title_author_footnote")
                            .padding()
                            .multilineTextAlignment(.center)
                            .font(Font.system(.caption2, design: .monospaced))
                            .foregroundColor(Color.init(UIColor.secondaryLabel))
                            .contextMenu(ContextMenu(menuItems: {
                                Button(action: {
                                    UIApplication.shared.open(URL(string: "http://fincher.im")!, options: [:], completionHandler: nil)
                                }, label: {
                                    Text("title_who_is_he")
                                })
                            }))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .transition(.opacity)
            .animation(.easeInOut)
            .navigationTitle("title_settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(EnvironmentManager.shared.env)
    }
}
