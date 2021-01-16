//
//  SupportAuthorView.swift
//  Contributions
//
//  Created by fincher on 1/10/21.
//

import SwiftUI

struct SupportAuthorView: View {
    
    @EnvironmentObject var environment: Env
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass : UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) var verticalSizeClass : UserInterfaceSizeClass?
    
    struct Tier : Hashable, Identifiable {
        var id: Int {
            hashValue
        }
        var iapId : String
    }
    
    @State var selectedTier: Tier?
    @State var availableTier = [
        Tier(iapId: IAPManager.IapIdentiferBuyCoffeeTier1),
        Tier(iapId: IAPManager.IapIdentiferBuyCoffeeTier2),
        Tier(iapId: IAPManager.IapIdentiferBuyCoffeeTier3)
    ]
    
    var items: some View {
        Group {
            ForEach(availableTier, id: \.self) { tier in
                if let product = IAPManager.shared.getProduct(identifer: tier.iapId)
                {
                    VStack {
                        Group {
                            Text("\(product.localizedTitle)")
                                .font(Font.headline.smallCaps())
                                .foregroundColor(Color.init(UIColor.label))
                                .font(Font.caption.smallCaps())
                            Text("\(product.localizedDescription)")
                                .font(Font.caption2.smallCaps())
                                .foregroundColor(Color.init(UIColor.tertiaryLabel))
                            Text("\(product.regularPrice)")
                                .font(Font.body.smallCaps())
                                .foregroundColor(Color.init(UIColor.secondaryLabel))
                        }
                        .if(selectedTier == tier) { view in
                            view.colorInvert()
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedTier == tier ? Color.accentColor : Color.init(UIColor.secondarySystemBackground))
                    .onTapGesture {
                        selectedTier = tier
                    }
                    .cornerRadius(8)
                }
            }
        }
    }
    
    var body: some View {
        ScrollView (.vertical, showsIndicators: true, content: {
            VStack {
                if horizontalSizeClass == .regular {
                    HStack(alignment: .top) {
                        items
                    }
                    .padding()
                } else {
                    VStack {
                        items
                    }
                    .padding()
                }
                
                Button(action: {
                    if let tier = selectedTier {
                        IAPManager.shared.buyIAP(product: IAPManager.shared.getProduct(identifer: tier.iapId)!)
                    }
                }, label: {
                    FilledButtonView(icon: "hands.clap.fill", text: "button_support", color: .accentColor, shadow: false, primary: true)
                        .padding()
                }).disabled(selectedTier == nil)
            }
        })
        .navigationTitle("title_support_author")
    }
}

struct SupportAuthorView_Previews: PreviewProvider {
    static var previews: some View {
        SupportAuthorView()
            .environmentObject(EnvironmentManager.shared.env)
    }
}
