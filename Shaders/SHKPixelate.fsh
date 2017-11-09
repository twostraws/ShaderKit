//
// Pixelates an image based on a strength provided by the user.
// Attribute: a_size, the size of the node.
// Uniform: u_strength, how large each pixel block should be. Ranges from 2 to 50 work best; try starting with 5.
//
// This works by dividing the image into groups based on the strength
// parameter passed in by the user, then reading a single pixel from that
// group and using it for the entire group.
//
// We get passed in the size of the node being transformed, e.g. 100x100.
// Our texture coordinates are specified as a range from 0 to 1, so if we
// divide 1 by our size we get 0.01x0.01 – the size of one pixel inside
// the texture. We can then multiply that by the user's strength parameter,
// e.g. 5, to get 0.05x0.05, which is the size of our pixelated effect.
//
// Once we have one pixelated size we can divide our texture coordinate by
// that number. For example, if we're reading (0.12, 0.12) we divide that by
// 0.05 to get 2.4. Now for the important part: we pass that number into floor()
// to round it down so that it always uses the pixel in the bottom-left corner
// for the entire group – that gives us 2.0. Finally, we multiply that back
// by our original pixelated size (0.05) to get (0.1, 0.1), and that's the
// texel we read from our texture rather than the original (0.12, 0.12).
//
// NOTE: Really this should algorithm should use round() rather than floor(),
// but GLSL does not have a round() function. A simple replacement is to use
// floor(some_number + 0.5) instead, which has the same effect as round().
// This is used in the code below.
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
    // figure out how big individual pixels are in texture space
    vec2 one_over_size = 1.0 / a_size;

    // now calculate the width of our pixelated effect by multiplying the provided density
    float pixel_x = u_strength * one_over_size.x;

    // and do the same for the pixel height
    float pixel_y = u_strength * one_over_size.y;

    // calculate the X pixel coordinate to read by dividing our original coordinate by the size
    // of one pixel, adding 0.5, then multiplying by the size of a pixel.
    float coord_x = pixel_x * floor(v_tex_coord.x / pixel_x + 0.5);

    // repeat for the Y pixel coordinate
    float coord_y = pixel_y * floor(v_tex_coord.y / pixel_y + 0.5);

    // read the new coordinate from our texture and send it back, , taking into
    // account node transparency
    gl_FragColor = texture2D(u_texture, vec2(coord_x, coord_y)) * v_color_mix.a;
}
