//
//  ContentView.swift
//  ShaderKit
//
//  Created by Paul Hudson on 10/05/2023.
//

import SpriteKit
import SwiftUI

struct ContentView: View {
    @State private var scene: GameScene = {
        let newScene = GameScene()
        newScene.size = CGSize(width: 1024, height: 768)
        newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        newScene.scaleMode = .resizeFill
        return newScene
    }()

    @ToolbarContentBuilder var platformToolbar: some ToolbarContent {
        ToolbarItem(placement: .platformOptimizedLeading) {
            Button(action: scene.previousShader) {
                Label("Previous Shader", systemImage: "chevron.backward")
                    .labelStyle(.imageOnLeft)
            }
        }

        ToolbarItem(placement: .platformOptimizedTrailing) {
            Button(action: scene.nextShader) {
                Label("Next Shader", systemImage: "chevron.forward")
                    .labelStyle(.imageOnRight)
            }
        }
    }

    var body: some View {
        NavigationStack {
            SpriteView(scene: scene, preferredFramesPerSecond: 120, debugOptions: [.showsFPS, .showsNodeCount])
                .navigationTitle("ShaderKit Sandbox")
                .frame(minWidth: 550, minHeight: 350)
                .background(Color("Background"))
                .toolbar { platformToolbar }
                .tint(.white)
                #if os(iOS)
                // Force dark appearance so the light nav title always stands
                // out against the dark background
                .preferredColorScheme(.dark)
                #endif
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
