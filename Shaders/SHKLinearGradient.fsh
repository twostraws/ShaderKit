//
// Creates a linear gradient over the node. Either the start or the end color can be translucent to let original pixel colors come through.
// Uniform: u_first_color, the SKColor to use at the top of the gradient
// Uniform: u_second_color, the SKColor to use at the bottom of the gradient
//
// This works by blending the first color with the second based on how far up the pixel is from
// the bottom of the texture. That's then blended with the original pixel color based on how
// opaque the replacement color is, so that we can fade out to clear if needed.
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
    // get the color of the current pixel
    vec4 current_color = texture2D(u_texture, v_tex_coord);

    // if the current color is not transparent
    if (current_color.a > 0.0) {
        // mix the first color with the second color by however far we are from the bottom,
        // multiplying by this pixel's alpha (to avoid a hard edge) and also
        // multiplying by the node alpha so we can fade in or out
        vec4 new_color = mix(u_second_color, u_first_color, v_tex_coord.y);
        gl_FragColor = vec4(mix(current_color, new_color, new_color.a)) * current_color.a * v_color_mix.a;
    } else {
        // use the current (transparent) color
        gl_FragColor = current_color;
    }
}
