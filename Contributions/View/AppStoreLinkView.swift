//
//  AppStoreLinkView.swift
//  Dynamic
//
//  Created by Fincher on 12/10/20.
//

import SwiftUI

struct AppStoreLinkView: View {
    
    var url : String
    var name : String
    var image : String
    var desc: String
    
    var body: some View {
        Link(destination: URL(string: url)!, label: {
            HStack(alignment: .center, spacing: 16) {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 9))
                    .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 0)
                VStack(alignment: .leading) {
                    Text(name)
                        .font(Font.subheadline.bold().smallCaps())
                        .foregroundColor(Color.init(UIColor.label))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(desc)
                        .font(Font.caption.smallCaps())
                        .foregroundColor(Color.init(UIColor.secondaryLabel))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        })
    }
}

struct AppStoreLinkView_Previews: PreviewProvider {
    static var previews: some View {
        AppStoreLinkView(url: "https", name: "EpochCore", image: "EpochCore", desc: "Space Simulator")
    }
}
