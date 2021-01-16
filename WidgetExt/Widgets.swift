//
//  Widgets.swift
//  Contributions
//
//  Created by fincher on 10/19/20.
//


import Foundation
import WidgetKit
import SwiftUI
import Intents

@main
struct Widgets: WidgetBundle
{
    @WidgetBundleBuilder
    var body: some Widget
    {
        GitWidgetDefault2D()
        GitWidgetToday()
//        GitWidgetDefault3D()
    }
}
