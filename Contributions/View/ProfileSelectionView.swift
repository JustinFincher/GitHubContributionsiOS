//
//  ProfileSelection.swift
//  Contributions
//
//  Created by fincher on 1/7/21.
//

import SwiftUI
import Combine

struct ProfileSelectionView: View {
    
    enum ActiveSheet : Identifiable {
        var id: Int {hashValue}
        case addUser, reorderUser
    }
    
    @State var activeSheet: ActiveSheet?
    
    @EnvironmentObject var environment: Env
    @Environment(\.horizontalSizeClass) var horizontalSizeClass : UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) var verticalSizeClass : UserInterfaceSizeClass?
    
    struct ViewOffsetKey: PreferenceKey {
        typealias Value = CGFloat
        static var defaultValue = CGFloat.zero
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value += nextValue()
        }
    }
    
    init(vertical : Bool) {
        self.init()
        self.vertical = vertical
    }
    
    init() {
        let detector = CurrentValueSubject<CGFloat, Never>(0)
        self.scrollPublisher = detector
                    .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
                    .dropFirst()
                    .eraseToAnyPublisher()
        self.scrollDetector = detector
    }
    
    let scrollDetector: CurrentValueSubject<CGFloat, Never>
    let scrollPublisher: AnyPublisher<CGFloat, Never>
    
    var vertical : Bool = false
    
    let gradientStops = [
        Gradient.Stop(color: Color.black.opacity(0.1), location: 0),
        Gradient.Stop(color: Color.black, location: 0.45),
        Gradient.Stop(color: Color.black, location: 0.55),
        Gradient.Stop(color: Color.black.opacity(0.1), location: 1)
    ]
    
    var userListView: some View {
        Group {
            ForEach(0..<environment.userNames.count, id: \.self) { index in
                let userName = environment.userNames[index]
                Button(action: {
                    environment.selectedUserName = userName
                }, label: {
                    GitHubAvatarImageView(userName: userName)
                        .padding(vertical ? .vertical : .horizontal, 8)
                        .id("profile_\(userName)")
                })
                .contextMenu(ContextMenu(menuItems: {
                    Button { activeSheet = .reorderUser } label: { HStack {
                        Image(systemName: "fiberchannel")
                        Text("button_reorder")
                    } }
                    Divider()
                    Button { environment.userNames.removeAll { n -> Bool in
                        n == userName
                    } } label: { HStack {
                        Image(systemName: "trash")
                        Text("button_delete")
                    } }
                }))
            }
            Button(action: { activeSheet = .addUser }, label: {
                GitHubAvatarImageView(add: true)
                    .padding(vertical ? .vertical : .horizontal, 8)
                    .id("profile_")
            })
        }
    }
    
    var body: some View {
        GeometryReader(content: { outProxy in
            ScrollView (vertical ? .vertical : .horizontal, showsIndicators: false, content: {
                ScrollViewReader(content: { reader in
                    Group {
                        if vertical
                        {
                            VStack(alignment: .center, spacing: nil) {
                                userListView
                            }
                        } else
                        {
                            HStack(alignment: .center, spacing: nil) {
                                userListView
                            }
                        }
                    }.animation(.easeInOut)
                    .transition(.slide)
                    .padding(vertical ? .vertical : .horizontal, vertical ? outProxy.size.height / 2.0 : outProxy.size.width / 2.0)
                    .padding(vertical ? .horizontal : .vertical)
                    .background(GeometryReader { InnerProxy in
                        Color.clear
                            .preference(key: ViewOffsetKey.self,
                                        value: vertical ?
                                            -InnerProxy.frame(in: .named("scroll")).origin.y
                                            : -InnerProxy.frame(in: .named("scroll")).origin.x)
                            .onReceive(scrollPublisher) { scrollPos in
                                print("\(scrollPos)")
                                let max = environment.userNames.count
                                let targetFloat : CGFloat = CGFloat(max)
                                    * scrollPos
                                    / (vertical ? (InnerProxy.size.height - outProxy.size.height) : (InnerProxy.size.width - outProxy.size.width))
                                let target : Int = Int(targetFloat.rounded())
                                    .clamped(to: 0...max)
                                let targetUser : String = target < environment.userNames.count ? environment.userNames[target] : ""
                                environment.selectedUserName = targetUser
                                withAnimation {
                                    reader.scrollTo("profile_\(targetUser)", anchor: .center)
                                }
                                print("Move to: \(targetFloat) \(target) \(targetUser)")
                            }
                            .onChange(of: environment.selectedUserName, perform: { value in
                                withAnimation {
                                    reader.scrollTo("profile_\(value)", anchor: .center)
                                }
                            })
                            .onAppear(perform: {
                                reader.scrollTo("profile_\(environment.selectedUserName)", anchor: .center)
                            })
                    })
                    .onPreferenceChange(ViewOffsetKey.self) { o in
                        scrollDetector.send(o)
                    }
                })
            })
            .coordinateSpace(name: "scroll")
            .mask(LinearGradient(
                    gradient: Gradient(
                        stops: gradientStops
                    ),
                startPoint: vertical ? .top : .leading, endPoint: vertical ? .bottom : .trailing
            ))
        })
        .edgesIgnoringSafeArea(vertical ? .vertical :.horizontal)
        .sheet(item: $activeSheet, content: { item in
            switch item {
            case .addUser:
                AddUserView()
            case .reorderUser:
                ReorderProfileView()
            }
        })
    }
}

struct ProfileSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSelectionView()
            .environmentObject(EnvironmentManager.shared.env)
    }
}
