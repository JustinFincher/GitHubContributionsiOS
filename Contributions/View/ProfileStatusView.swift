//
//  ProfileStatusView.swift
//  Contributions
//
//  Created by fincher on 1/7/21.
//

import SwiftUI

struct ProfileStatusView: View {
    
    enum ActiveSheet : Identifiable, Hashable {
        var id: Int {hashValue}
        case sharePoster(image: UIImage)
    }
    @State var activeSheet: ActiveSheet?
    
    @State private var showMoreSheet = false
    @State private var showHorizontalGraph = false
    @EnvironmentObject var environment: Env
    @Binding var userName : String
    @State var updating : Bool = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass : UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) var verticalSizeClass : UserInterfaceSizeClass?
    
    var body: some View {
        Group {
            if userName.isEmpty {
                VStack {
                    
                }
            } else if let contributions = environment.userContributions.contributionsFor(name: userName) {
                VStack (alignment: .center, spacing: 0, content: {
                    Text("title_\(String(contributions.commitsCount))_commits_in_\(String(contributions.list.count))_days_updated_\(contributions.updated, style: .relative)_ago")
                        .font(Font.caption.smallCaps())
                        .foregroundColor(Color.init(UIColor.secondaryLabel))
                        .padding()
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Group {
                        if horizontalSizeClass == UserInterfaceSizeClass.compact {
                            VStack {
                                operations
                            }
                        } else {
                            HStack {
                                operations
                            }
                        }
                    }.padding(.horizontal)
                    .padding(.bottom)
                
                    GroupBox {
                        Button(action: {
                            showHorizontalGraph.toggle()
                        }, label: {
                            HStack{
                                Text("title_graph")
                                    .font(Font.callout.bold().smallCaps())
                                Spacer()
                                Image(systemName: "chevron.compact.right").rotationEffect(.init(degrees: showHorizontalGraph ? 0 : 90))
                            }.contentShape(Rectangle())
                        }).padding(.horizontal)
                        
                        ContributionsView(reverseOrder: false, showHorizontal: $showHorizontalGraph)
                            .padding(.top, 6)
                            .environment(\.contributions, contributions)
                    }
                    .groupBoxStyle(ListCardGroupBoxStyle(outline: true))
                })
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                    .onChange(of: environment.selectedUserName, perform: { value in
                        ContributionsManager.shared.update(userName: userName) { (success, contributions) in
                            
                        }
                    })
                    .onAppear(perform: {
                        ContributionsManager.shared.update(userName: userName) { (success, contributions) in
                            
                        }
                    })
            }
        }
    }
    
    var operations : some View {
        Group {
            Button(action: {
                updating = true
                ContributionsManager.shared.update(userName: userName) { (success, contributions) in
                    updating = false
                    environment.showView(view: AnyView(ToastView(title: success ? "title_updated" : "title_update_failed")), forTime: .seconds(1))
                }
            }, label: {
                FilledButtonView(icon: updating ? "ellipsis" : "arrow.triangle.2.circlepath", text: updating ? "button_refreshing" : "button_refresh", color: Color.accentColor, shadow: false, primary: true)
            }).disabled(updating)
            .contextMenu(ContextMenu(menuItems: {
                Button(action: {
                    environment.showView(view: AnyView(ToastView(image: "arrow.triangle.2.circlepath", title: "title_updating")), forTime: .seconds(3))
                    ContributionsManager.shared.updateAll {_ in 
                    }
                }, label: {
                    HStack {
                        Text("title_update_all")
                        Image(systemName: "infinity")
                    }
                })
            }))
            
            Button(action: {
                showMoreSheet.toggle()
            }, label: {
                FilledButtonView(icon: "ellipsis", text: "button_more", color: Color.accentColor, shadow: false, primary: false)
            })
            .actionSheet(isPresented: $showMoreSheet) {
                ActionSheet(title: Text("title_more"), message: nil, buttons: [
                    .default(Text("button_share"), action: {
                        if let contributions = EnvironmentManager.shared.env.userContributions.contributionsFor(name: userName)
                        {
                            activeSheet = .sharePoster(image: ProfilePosterView(userName: $userName, contributions: Binding<Contributions>(get: { return contributions }, set: { _ in })).asImage())
                        }
                    }),
//                    .default(Text("button_ar_view"), action: {
//                        
//                    }),
                    .cancel()
                ])
            }
            .sheet(item: $activeSheet, content: { item in
                switch item {
                case .sharePoster(let image):
                    ActivityViewController(activityItems: [image])
                }
            })
        }
    }
}


//struct ProfileStatusView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileStatusView(userName: Binding<String>(get: { "JustinFincher" }, set: { _ in
//
//        }), userContributions: Binding<Contributions?>(get: { EnvironmentManager.shared.env.userContributions.contributionsFor(name: "JustinFincher") }, set: { _ in
//
//        })).environmentObject(EnvironmentManager.shared.env)
//    }
//}
