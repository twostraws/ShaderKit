//
//  ViewController.swift
//  ShaderKit
//
//  Created by Paul Hudson on 08/11/2017.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    @IBAction func changeShader(_ sender: NSSegmentedControl) {
        guard let view = view as? SKView else { return }
        guard let scene = view.scene as? GameScene else { return }

        if sender.selectedSegment == 0 {
            scene.previousShader()
        } else {
            scene.nextShader()
        }
    }

    override func mouseDown(with event: NSEvent) {
        guard let view = view as? SKView else { return }
        guard let scene = view.scene as? GameScene else { return }
        scene.toggleAlpha()
    }
}

