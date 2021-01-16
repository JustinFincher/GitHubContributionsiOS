//
//  CardGroupBoxStyle.swift
//  Dynamic
//
//  Created by Fincher on 12/9/20.
//

import Foundation
import SwiftUI

struct ListCardGroupBoxStyle: GroupBoxStyle {
    var outline: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            configuration.label
            configuration.content
        }
        .padding(.vertical)
        .background(Color.init(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .if(outline, transform: { view in
            view.overlay (
                RoundedRectangle(cornerRadius: 12).stroke(Color.init(UIColor.label).opacity(0.1), lineWidth: 2)
            )
        })
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
