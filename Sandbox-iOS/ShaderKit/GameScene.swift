//
// MIT License
//
// Copyright (c) 2017 Paul Hudson
// https://www.github.com/twostraws/ShaderKit
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene {
    typealias ShaderExample = (title: String, shader: SKShader)
    var shaders = [ShaderExample]()
    var currentShader = 0

    let title = SKLabelNode(fontNamed: "AvenirNext-Regular")
    let testNode1 = SKSpriteNode(imageNamed: "swift")
    let testNode2 = SKSpriteNode(imageNamed: "city")

    override func didMove(to view: SKView) {
        backgroundColor = .darkGray

        title.position.y = 100
        title.text = "Shader Name Here"
        addChild(title)

        testNode1.position = CGPoint(x: -150, y: -50)
        addChild(testNode1)

        testNode2.position = CGPoint(x: 150, y: -50)
        addChild(testNode2)
        shaders.append(("No Shader", createPassthrough()))
        shaders.append(("Checkerboard", createCheckerboard()))
        shaders.append(("Circle Wave", createCircleWave()))
        shaders.append(("Circle Wave (Blended)", createCircleWaveBlended()))
        shaders.append(("Circle Wave Rainbow", createCircleWaveRainbow()))
        shaders.append(("Circle Wave Rainbow (Blended)", createCircleWaveRainbowBlended()))
        shaders.append(("Color Alpha", createColorAlpha()))
        shaders.append(("Color Non-Alpha", createColorNonAlpha()))
        shaders.append(("Color Invert", createColorInvert()))
        shaders.append(("Colorize", createColorize()))
        shaders.append(("Desaturate", createDesaturate()))
        shaders.append(("Emboss (Color)", createColorEmboss()))
        shaders.append(("Emboss (Gray)", createGrayEmboss()))
        shaders.append(("Infrared", createInfrared()))
        shaders.append(("Interlace", createInterlace()))
        shaders.append(("Light Grid", createLightGrid()))
        shaders.append(("Linear Gradient", createLinearGradient()))
        shaders.append(("Pixelate", createPixelate()))
        shaders.append(("Scanlines", createScanlines()))
        shaders.append(("Static Gray Noise", createStaticGrayNoise()))
        shaders.append(("Static Rainbow Noise", createStaticRainbowNoise()))
        shaders.append(("Dynamic Gray Noise", createDynamicGrayNoise()))
        shaders.append(("Dynamic Rainbow Noise", createDynamicRainbowNoise()))
        shaders.append(("Radial Gradient", createRadialGradient()))
        shaders.append(("Screen", createScreen()))
        shaders.append(("Water", createWater()))
        loadShader()

        testNode1.setValue(SKAttributeValue(size: testNode1.size), forAttribute: "a_size")
        testNode2.setValue(SKAttributeValue(size: testNode2.size), forAttribute: "a_size")
    }

    func loadShader() {
        let example = shaders[currentShader]
        title.text = example.title

        testNode1.shader = example.shader
        testNode2.shader = example.shader
    }

    func createCheckerboard() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_rows", float: 12),
            SKUniform(name: "u_cols", float: 12),
            SKUniform(name: "u_first_color", color: .white),
            SKUniform(name: "u_second_color", color: .black)
        ]

        return SKShader(fromFile: "SHKCheckerboard", uniforms: uniforms)
    }

    func createCircleWave() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_speed", float: 1),
            SKUniform(name: "u_brightness", float: 0.5),
            SKUniform(name: "u_strength", float: 2),
            SKUniform(name: "u_density", float: 100),
            SKUniform(name: "u_center", point: CGPoint(x: 0.68, y: 0.33)),
            SKUniform(name: "u_color", color: SKColor(red: 0, green: 0.5, blue: 0, alpha: 1))
        ]

        return SKShader(fromFile: "SHKCircleWave", uniforms: uniforms)
    }

    func createCircleWaveBlended() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_speed", float: 1),
            SKUniform(name: "u_brightness", float: 0.5),
            SKUniform(name: "u_strength", float: 2),
            SKUniform(name: "u_density", float: 100),
            SKUniform(name: "u_center", point: CGPoint(x: 0.68, y: 0.33)),
            SKUniform(name: "u_color", color: SKColor(red: 0, green: 0.5, blue: 0, alpha: 1))
        ]

        return SKShader(fromFile: "SHKCircleWaveBlended", uniforms: uniforms)
    }

    func createCircleWaveRainbow() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_speed", float: 1),
            SKUniform(name: "u_brightness", float: 0.5),
            SKUniform(name: "u_strength", float: 2),
            SKUniform(name: "u_density", float: 100),
            SKUniform(name: "u_center", point: CGPoint(x: 0.68, y: 0.33)),
            SKUniform(name: "u_red", float: -1)
        ]

        return SKShader(fromFile: "SHKCircleWaveRainbow", uniforms: uniforms)
    }

    func createCircleWaveRainbowBlended() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_speed", float: 1),
            SKUniform(name: "u_brightness", float: 0.5),
            SKUniform(name: "u_strength", float: 2),
            SKUniform(name: "u_density", float: 100),
            SKUniform(name: "u_center", point: CGPoint(x: 0.68, y: 0.33)),
            SKUniform(name: "u_red", float: -1)
        ]

        return SKShader(fromFile: "SHKCircleWaveRainbowBlended", uniforms: uniforms)
    }

    func createColorAlpha() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_color", color: .green)
        ]

        return SKShader(fromFile: "SHKColorAlpha", uniforms: uniforms)
    }

    func createColorEmboss() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_strength", float: 1)
        ]

        let attributes = [
            SKAttribute(name: "a_size", type: .vectorFloat2)
        ]

        return SKShader(fromFile: "SHKEmbossColor", uniforms: uniforms, attributes: attributes)
    }

    func createColorInvert() -> SKShader {
        return SKShader(fromFile: "SHKColorInvert")
    }

    func createColorNonAlpha() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_color", color: .yellow)
        ]

        return SKShader(fromFile: "SHKColorNonAlpha", uniforms: uniforms)
    }

    func createColorize() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_color", color: .green),
            SKUniform(name: "u_strength", float: 1)
        ]

        return SKShader(fromFile: "SHKColorize", uniforms: uniforms)
    }

    func createDesaturate() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_strength", float: 0.5)
        ]

        return SKShader(fromFile: "SHKDesaturate", uniforms: uniforms)
    }

    func createDynamicGrayNoise() -> SKShader {
        return SKShader(fromFile: "SHKDynamicGrayNoise")
    }

    func createDynamicRainbowNoise() -> SKShader {
        return SKShader(fromFile: "SHKDynamicRainbowNoise")
    }

    func createGrayEmboss() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_strength", float: 1)
        ]

        let attributes = [
            SKAttribute(name: "a_size", type: .vectorFloat2)
        ]

        return SKShader(fromFile: "SHKEmbossGray", uniforms: uniforms, attributes: attributes)
    }

    func createInfrared() -> SKShader {
        return SKShader(fromFile: "SHKInfrared")
    }

    func createInterlace() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_width", float: 2),
            SKUniform(name: "u_color", color: .black),
            SKUniform(name: "u_strength", float: 0.35),
        ]

        let attributes = [
            SKAttribute(name: "a_size", type: .vectorFloat2)
        ]

        return SKShader(fromFile: "SHKInterlace", uniforms: uniforms, attributes: attributes)
    }

    func createLightGrid() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_density", float: 8),
            SKUniform(name: "u_speed", float: 3),
            SKUniform(name: "u_group_size", float: 2),
            SKUniform(name: "u_brightness", float: 3),
        ]

        return SKShader(fromFile: "SHKLightGrid", uniforms: uniforms)
    }

    func createLinearGradient() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_first_color", color: .blue),
            SKUniform(name: "u_second_color", color: .clear)
        ]

        return SKShader(fromFile: "SHKLinearGradient", uniforms: uniforms)
    }

    func createPassthrough() -> SKShader {
        return SKShader(fromFile: "SHKPassthrough")
    }

    func createPixelate() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_strength", float: 8),
        ]

        let attributes = [
            SKAttribute(name: "a_size", type: .vectorFloat2)
        ]

        return SKShader(fromFile: "SHKPixelate", uniforms: uniforms, attributes: attributes)
    }

    func createRadialGradient() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_first_color", color: .clear),
            SKUniform(name: "u_second_color", color: .darkGray),
            SKUniform(name: "u_center", point: CGPoint(x: 0.75, y: 0.25))
        ]

        return SKShader(fromFile: "SHKRadialGradient", uniforms: uniforms)
    }
    
    func createScanlines() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_width", float: 4),
            SKUniform(name: "u_brightness", float: 0.5),
            ]
        
        let attributes = [
            SKAttribute(name: "a_size", type: .vectorFloat2)
        ]
        
        return SKShader(fromFile: "SHKScanlines", uniforms: uniforms, attributes: attributes)
    }

    func createScreen() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_width", float: 2),
            SKUniform(name: "u_color", color: .clear),
            SKUniform(name: "u_strength", float: 1),
        ]

        let attributes = [
            SKAttribute(name: "a_size", type: .vectorFloat2)
        ]

        return SKShader(fromFile: "SHKScreen", uniforms: uniforms, attributes: attributes)
    }

    func createStaticGrayNoise() -> SKShader {
        return SKShader(fromFile: "SHKStaticGrayNoise")
    }

    func createStaticRainbowNoise() -> SKShader {
        return SKShader(fromFile: "SHKStaticRainbowNoise")
    }

    func createWater() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_speed", float: 3),
            SKUniform(name: "u_strength", float: 2.5),
            SKUniform(name: "u_frequency", float: 10)
        ]

        return SKShader(fromFile: "SHKWater", uniforms: uniforms)
    }

    func previousShader() {
        currentShader -= 1

        if currentShader == -1 {
            currentShader = shaders.count - 1
        }

        loadShader()
    }

    func nextShader() {
        currentShader += 1

        if currentShader == shaders.count {
            currentShader = 0
        }

        loadShader()
    }

    func toggleAlpha() {
        let action: SKAction

        if testNode1.alpha <= 0.5 {
            action = SKAction.fadeIn(withDuration: 2)
        } else {
            action = SKAction.fadeOut(withDuration: 2)
        }

        testNode1.removeAllActions()
        testNode2.removeAllActions()

        testNode1.run(action)
        testNode2.run(action)
    }

    #if os(macOS)
    override func mouseDown(with event: NSEvent) {
        toggleAlpha()
    }
    #endif
}

