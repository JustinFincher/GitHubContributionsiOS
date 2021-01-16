//
//  VisualEffectView.swift
//  Contributions
//
//  Created by fincher on 1/7/21.
//

import SwiftUI
import UIKit

struct VisualEffectView: UIViewRepresentable
{
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }
    
    func updateUIView(_ blurView: UIVisualEffectView, context: UIViewRepresentableContext<VisualEffectView>) {}
}

struct VisualEffectView_Previews: PreviewProvider {
    static var previews: some View {
        VisualEffectView()
    }
}
