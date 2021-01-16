//
//  FilledButtonView.swift
//  Dynamic
//
//  Created by Fincher on 12/11/20.
//

import SwiftUI

struct FilledButtonView: View
{
    @Namespace var namespace
    let icon : String
    let text : LocalizedStringKey
    let color : Color
    let shadow : Bool
    let primary : Bool
    
    var body: some View {
        HStack {
            if !icon.isEmpty {
                Image(systemName: icon)
            }
            if text != "" {
                Text(text)
                    .font(Font.callout.bold().smallCaps())
                    .multilineTextAlignment(.leading)
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(primary ? Color.init(UIColor.systemBackground) : color)
        .background(primary ? color : Color.init(UIColor.secondarySystemFill))
        .cornerRadius(8)
        .if(shadow) { view in
            view.shadow(color: color.opacity(0.5), radius: 8, x: 0.0, y: 0.0)
        }
    }
}

struct FilledButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FilledButtonView(icon: "repeat", text: "button_setup_automation", color: Color.accentColor, shadow: false, primary: true)
            .frame(width: 100, height: 100, alignment: .center)
    }
}
