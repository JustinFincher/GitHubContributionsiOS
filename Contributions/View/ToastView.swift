//
//  ToastView.swift
//  Mapaper
//
//  Created by fincher on 12/27/20.
//

import SwiftUI

struct ToastView: View {
    @Environment(\.colorScheme) var colorScheme
    var image: String?
    var title: LocalizedStringKey
    var subtitle: LocalizedStringKey?
    
    var body: some View {
        HStack(spacing: 16) {
            if image != nil {
                Image(systemName: image!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .padding(.all, 4)
            }
            
            VStack(alignment: .center) {
                Text(title)
                    .lineLimit(1)
                    .font(Font.headline)
                
                if subtitle != nil {
                    Text(subtitle!)
                        .lineLimit(1)
                        .font(Font.system(.subheadline, design: .monospaced))
                        .foregroundColor(.secondary)
                }
            }
            .padding(image == nil ? .horizontal : .trailing)
        }
        .padding()
        .frame(height: 56)
        .background(Color(colorScheme == .dark ? UIColor.secondarySystemBackground : UIColor.systemBackground))
        .cornerRadius(28)
        .shadow(color: Color.black.opacity(0.16), radius: 12, x: 0, y: 8)
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            ToastView(image: "airpodspro", title: "AirPods Pro", subtitle: "Connected")
            ToastView(title: "Safari pasted from Notes")
            ToastView(image: "headphones", title: "AirPods Max", subtitle: "50%")
                .environment(\.colorScheme, .dark)
        }
    }
}
