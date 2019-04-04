//
// MIT License
//
// Copyright (c) 2019 Paul Hudson
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

import Foundation
import SpriteKit

extension SKAttributeValue {

    /**
     Convenience initializer to create an attribute value from a CGSize.
     - Parameter size: The input size; this is usually your node's size.
    */
    public convenience init(size: CGSize) {
        let size = vector_float2(Float(size.width), Float(size.height))
        self.init(vectorFloat2: size)
    }
}

extension SKShader {
    /**
     Convience initializer to create a shader from a filename by way of a string.
     Although this approach is less efficient than loading directly from disk, it enables
     shader errors to be printed in the Xcode console.

     - Parameter filename: A filename in your bundle, including extension.
     - Parameter uniforms: An array of SKUniforms to apply to the shader. Defaults to nil.
     - Parameter attributes: An array of SKAttributes to apply to the shader. Defaults to nil.
    */
    convenience init(fromFile filename: String, uniforms: [SKUniform]? = nil, attributes: [SKAttribute]? = nil) {
        // it is a fatal error to attempt to load a missing or corrupted shader
        guard let path = Bundle.main.path(forResource: filename, ofType: "fsh") else {
            fatalError("Unable to find shader \(filename).fsh in bundle")
        }

        guard let source = try? String(contentsOfFile: path) else {
            fatalError("Unable to load shader \(filename).fsh")
        }

        // if we were sent any uniforms then apply them immediately
        if let uniforms = uniforms {
            self.init(source: source as String, uniforms: uniforms)
        } else {
            self.init(source: source as String)
        }

        // if we were sent any attributes then apply those too
        if let attributes = attributes {
            self.attributes = attributes
        }
    }
}

extension SKUniform {
    /**
    Convenience initializer to create an SKUniform from an SKColor.
    - Parameter name: The name of the uniform inside the shader, e.g. u_color.
    - Parameter color: The SKColor to set.
    */
    public convenience init(name: String, color: SKColor) {
        #if os(macOS)
            guard let converted = color.usingColorSpace(.deviceRGB) else {
                fatalError("Attempted to use a color that is not expressible in RGB.")
            }

            let colors = vector_float4([Float(converted.redComponent), Float(converted.greenComponent), Float(converted.blueComponent), Float(converted.alphaComponent)])
        #else
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0

            color.getRed(&r, green: &g, blue: &b, alpha: &a)
            let colors = vector_float4([Float(r), Float(g), Float(b), Float(a)])
        #endif

        self.init(name: name, vectorFloat4: colors)
    }

    /**
     Convenience initializer to create an SKUniform from a CGSize.
     - Parameter name: The name of the uniform inside the shader, e.g. u_size.
     - Parameter color: The CGSize to set.
     */
    public convenience init(name: String, size: CGSize) {
        let size = vector_float2(Float(size.width), Float(size.height))
        self.init(name: name, vectorFloat2: size)
    }

    /**
     Convenience initializer to create an SKUniform from a CGPoint.
     - Parameter name: The name of the uniform inside the shader, e.g. u_center.
     - Parameter color: The CGPoint to set.
     */
    public convenience init(name: String, point: CGPoint) {
        let point = vector_float2(Float(point.x), Float(point.y))
        self.init(name: name, vectorFloat2: point)
    }
}
