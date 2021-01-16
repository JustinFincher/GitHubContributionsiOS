//
//  ActivityViewController.swift
//  Contributions
//
//  Created by fincher on 1/11/21.
//

import SwiftUI

struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}

struct ActivityViewController_Previews: PreviewProvider {
    static var previews: some View {
        ActivityViewController(activityItems: [])
    }
}
