//
//  GitHubAvatarImageView.swift
//  Contributions
//
//  Created by fincher on 1/7/21.
//

import SwiftUI
import Kingfisher

struct GitHubAvatarImageView: View {
    @State var userName : String?
    @State var add : Bool? = false
    @State var imageLoaded : Bool = false
    @State var border : Bool = false
    @State var offline : Bool = false
    @State var shadow : Bool = true
    
    var avatarURL: URL? {
        if let userName = userName, !userName.isEmpty
        {
            return URL.init(string: "https://github.com/\(userName).png")
        } else {
            return nil
        }
    }
    
    var backgroundColor: Color {
        #if !os(watchOS)
        return Color.init(UIColor.systemFill)
        #else
        return Color.gray
        #endif
    }
    
    var body: some View {
        GeometryReader (content: { geometry in
            if let url = avatarURL
            {
                Circle()
                    .foregroundColor(backgroundColor)
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        KFImage(url, isLoaded: $imageLoaded)
                            .resizable()
                            .cancelOnDisappear(true)
                            .cacheOriginalImage()
                            .renderingMode(.original)
                            .onProgress { receivedSize, totalSize in  }
                            .onSuccess { result in  }
                            .onFailure { error in }
                            .placeholder({
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            })
                            .waitForCache()
                            .loadDiskFileSynchronously(offline)
                            .onlyFromCache(offline)
                            .mask(Circle())
                            .padding(.all, border ? geometry.size.width * 0.07 : 0)
                            .id("avatar")
                    )
                    .shadow(color: Color.black.opacity(shadow ? 0.12 : 0), radius: 12, x: 0, y: 0)
            } else if (add ?? false) {
                Circle()
                    .foregroundColor(backgroundColor)
                    .aspectRatio(contentMode: .fit)
                    .shadow(color: Color.black.opacity(shadow ? 0.12 : 0), radius: 12, x: 0, y: 0)
                    .overlay(Image(systemName: "plus"))
            } else {
                Circle()
                    .foregroundColor(backgroundColor)
                    .aspectRatio(contentMode: .fit)
                    .shadow(color: Color.black.opacity(shadow ? 0.12 : 0), radius: 12, x: 0, y: 0)
            }
        }).aspectRatio(1, contentMode: .fit)
    }
}

struct GitHubAvatarImageView_Previews: PreviewProvider {
    static var previews: some View {
        GitHubAvatarImageView(userName: "2")
            .frame(width: 100, height: 100, alignment: .center)
        GitHubAvatarImageView(add: true)
            .frame(width: 100, height: 100, alignment: .center)
    }
}
