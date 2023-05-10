//
//  Helpers.swift
//  ShaderKit
//
//  Created by Paul Hudson on 10/05/2023.
//
//  Note: This file contains helper code specifically for this
//  sample project, and is *not* needed to use ShaderKit in
//  your own projects.
//

import SwiftUI

extension ToolbarItemPlacement {
    #if os(iOS)
    // Forcing leading and trailing looks great on iOS…
    static var platformOptimizedLeading = Self.navigationBarLeading
    static var platformOptimizedTrailing = Self.navigationBarTrailing
    #else
    // …but automatic placement looks much better on macOS.
    static var platformOptimizedLeading = Self.automatic
    static var platformOptimizedTrailing = Self.automatic
    #endif
}

struct FlippableLabelStyle: LabelStyle {
    var iconOnRight: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if iconOnRight {
                configuration.title
                configuration.icon
            } else {
                configuration.icon
                configuration.title
            }
        }
    }
}

extension LabelStyle where Self == FlippableLabelStyle {
    static var imageOnLeft: FlippableLabelStyle { .init(iconOnRight: false) }
    static var imageOnRight: FlippableLabelStyle { .init(iconOnRight: true) }
}
