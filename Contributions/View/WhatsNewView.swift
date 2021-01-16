//
//  WhatsNewView.swift
//  Dynamic
//
//  Created by Fincher on 12/11/20.
//

import SwiftUI

struct WhatsNewView: View {
    
    @EnvironmentObject var environment: Env
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                ScrollView(.vertical, showsIndicators: true, content: {
                    VStack {
                        Text("title_new_in_app")
                            .font(Font.largeTitle.bold())
                            .padding(.top, 32)
                            .padding(.bottom, 8)
                        Text("version \(Bundle.main.versionString ?? "null") (\(Bundle.main.buildString ?? "null"))")
                            .font(Font.caption2.bold().smallCaps())
                            .foregroundColor(Color.init(UIColor.tertiaryLabel))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal)
                            .padding(.bottom, 16)
                        
                        Group {
                            HStack {
                                Image(systemName: "wand.and.rays")
                                    .frame(width: 60, height: 60, alignment: .center)
                                    .font(.largeTitle)
                                    .padding()
                                Text("title_whats_new_new_ui")
                                    .font(Font.callout.smallCaps())
                                    .foregroundColor(Color.init(UIColor.secondaryLabel))
                                Spacer()
                            }
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .cornerRadius(16)
                            
                            HStack {
                                Image(systemName: "rectangle.3.offgrid.fill")
                                    .frame(width: 60, height: 60, alignment: .center)
                                    .font(.largeTitle)
                                    .padding()
                                Text("title_whats_new_new_widget")
                                    .font(Font.callout.smallCaps())
                                    .foregroundColor(Color.init(UIColor.secondaryLabel))
                                Spacer()
                            }
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .cornerRadius(16)
                            
                            HStack {
                                Image(systemName: "person.crop.circle.fill.badge.plus")
                                    .frame(width: 60, height: 60, alignment: .center)
                                    .font(.largeTitle)
                                    .padding()
                                Text("title_whats_new_multi_user")
                                    .font(Font.callout.smallCaps())
                                    .foregroundColor(Color.init(UIColor.secondaryLabel))
                                Spacer()
                            }
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .cornerRadius(16)
                            
                            HStack {
                                Image(systemName: "minus.plus.batteryblock.fill")
                                    .frame(width: 60, height: 60, alignment: .center)
                                    .font(.largeTitle)
                                    .padding()
                                Text("title_whats_new_work_in_progress")
                                    .font(Font.callout.smallCaps())
                                    .foregroundColor(Color.init(UIColor.secondaryLabel))
                                Spacer()
                            }
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .cornerRadius(16)
                        }.padding(.vertical, 4)
                    }
                })
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    FilledButtonView(icon: "", text: "button_next", color: .accentColor, shadow: false, primary: true)
                })
            }
            .padding()
        }
    }
}

struct WhatsNewView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WhatsNewView()
                .environmentObject(EnvironmentManager.shared.env)
            WhatsNewView()
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
                .environmentObject(EnvironmentManager.shared.env)
        }
    }
}
