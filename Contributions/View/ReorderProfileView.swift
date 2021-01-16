//
//  ReorderProfileView.swift
//  Contributions
//
//  Created by fincher on 1/8/21.
//

import SwiftUI

struct ReorderProfileView: View {
    
    @EnvironmentObject var environment: Env
    @State var isEditMode: EditMode = .inactive
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<environment.userNames.count, id: \.self) { index in
                    let userName = environment.userNames[index]
                    Text("\(userName)")
                }
                .onMove(perform: { (source, dest) in
                    environment.userNames.move(fromOffsets: source, toOffset: dest)
                })
                .onDelete { offset in
                    environment.userNames.remove(atOffsets: offset)
                }
            }
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("button_cancel")
            }))
            .environment(\.editMode, self.$isEditMode)
            .navigationTitle("title_reorder")
        }
        .environmentObject(EnvironmentManager.shared.env)
    }
}

struct ReorderProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ReorderProfileView()
            .environmentObject(EnvironmentManager.shared.env)
    }
}
