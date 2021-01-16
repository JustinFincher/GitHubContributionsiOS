//
//  AddUserView.swift
//  Contributions
//
//  Created by fincher on 1/8/21.
//

import SwiftUI

struct AddUserView: View {
    
    @EnvironmentObject var environment: Env
    @State var userName : String = ""
    @Environment(\.presentationMode) var presentationMode
    
    func submit() -> Void {
        let u = userName.gitHubComplaintUserName()
        if !environment.userNames.contains(u) {
            environment.userNames.append(u)
        }
        environment.selectedUserName = u
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true, content: {
                VStack {
                    TextField("desc_type_user_name", text: $userName) { editing in } onCommit: {
                        submit()
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .padding(.vertical)

                    Button(action: {
                        submit()
                    }, label: {
                        FilledButtonView(icon: "plus", text: "button_add", color: Color.accentColor, shadow: false, primary: true)
                    }).disabled(userName.isEmpty)
                }
                .padding()
                .navigationTitle("title_add_user")
                .navigationBarItems(trailing: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("button_cancel")
                }))
            })
        }
        .environmentObject(EnvironmentManager.shared.env)
    }
}

struct AddUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserView()
            .environmentObject(EnvironmentManager.shared.env)
    }
}
