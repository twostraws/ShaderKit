//
// Colors all clear pixels in the node.
// Uniform: u_color, the SKColor to use.
//
// This works by scanning the alpha value of the current pixel. If it's not transparent
// then we color it using whatever was passed in by the user, otherwise we just pass
// back the original color.
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

void main() {
    // find the current pixel color
    vec4 current_color = SKDefaultShading();

    // if it's not transparent
    if (current_color.a > 0.0) {
        // use the input color, multiplying by this pixel's alpha (to avoid a hard edge) and also
        // multiplying by the node alpha so we can fade in or out
        gl_FragColor = u_color * current_color.a * v_color_mix.a;
    } else {
        // use the current (non-transparent) color
        gl_FragColor = current_color;
    }
}

