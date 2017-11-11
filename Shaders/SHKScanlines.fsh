//
// Applies an interlacing effect where horizontal lines of original color are separated by lines of another color
// Attribute: a_size, the size of the node.
// Uniform: u_width, the (vertical) width of the scanlines.
// Uniform: u_brightness, brightness of scanlines effect. Specify 0 (black) up to 1 (bright & satturated). 0.5 is normal.
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
    
    // Pixelate first
    
    // figure out how big individual pixels are in texture space
    vec2 one_over_size = 1.0 / a_size;
    
    // now calculate the width of our pixelated effect by multiplying the provided density
    float pixel_x = u_width * one_over_size.x;
    
    // and do the same for the pixel height
    float pixel_y = u_width * one_over_size.y;
    
    // calculate the X pixel coordinate to read by dividing our original coordinate by the size
    // of one pixel, adding 0.5, then multiplying by the size of a pixel.
    float coord_x = pixel_x * floor(v_tex_coord.x / pixel_x + 0.5);
    
    // repeat for the Y pixel coordinate
    float coord_y = pixel_y * floor(v_tex_coord.y / pixel_y + 0.5);
    
    // read the new coordinate from our texture and send it back, , taking into
    // account node transparency
    vec4 current_color = texture2D(u_texture, vec2(coord_x, coord_y)) * v_color_mix.a;
    
    // then add scanlines
    
    // if the current color is not transparent
    if (current_color.a > 0.0) {
        // find this pixel's position in the texture
        float this_pixel = a_size[1] * v_tex_coord.y;

        // calculate the force of the scanline at this point
        // modulo of the pixel position against the scanline size, modified by brightness
        float f = min(max((mod(this_pixel, u_width) / u_width) + ((u_brightness * 2.0) - 1), 0.3), 1.0);

        // scale the pixel color towards black using brightness
        // multiply by original alpha
        gl_FragColor = vec4(mix(vec4(0, 0, 0, v_color_mix.a), current_color, f));
    } else {
        // use the current (transparent) color
        gl_FragColor = vec4(0, 0, 0, 0);
    }
    
}

