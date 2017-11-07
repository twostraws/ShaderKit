//
// Renders a checkerboard with user-defined row/column count and colors
// Uniform: u_rows, how many rows to generate. Should be at least 1.
// Uniform: u_cols, how many columns to generate. Should be at least 1.
// Uniform: u_first_color, an SKColor to use for half of the squares.
// Uniform: u_second_color, an SKColor to use for the other half of the squares.
//
// This works using modulus to calculate whether each pixel is in an odd or even
// row/column, and if one of those is true (but only one) then we draw the first color,
// otherwise we draw the second.
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

    if (current_color.a > 0.0) {
        // figure out whether we are an even column
        bool x = mod(u_cols * v_tex_coord.x, 2.0) < 1.0;

        // figure out whether we are an even row
        bool y = mod(u_rows * v_tex_coord.y, 2.0) < 1.0;

        // iff one of these is true
        if ((x == true && y == false) || (x == false && y == true)) {
            // use the first color
            gl_FragColor = u_first_color * current_color.a * v_color_mix.a;
        } else {
            // use the second color
            gl_FragColor = u_second_color * current_color.a * v_color_mix.a;
        }
    } else {
        // use the current (transparent) color
        gl_FragColor = current_color * v_color_mix.a;
    }
}
