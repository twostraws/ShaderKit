//
// Applies an interlacing effect where horizontal lines of original color are separated by lines of another color
// Attribute: a_size, the size of the node.
// Uniform: u_width, the vertical width of the scanlines in pixels. float (e.g. 4).
// Uniform: u_brightness, brightness of scanlines effect. Specify 0 (black) up to 1 (bright & saturated). float (e.g. 0.75)
// Uniform: u_color, blend color of scanlines. color (e.g. .white)
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
    
    // 1. Pixelate vertically
    
    // figure out how big individual pixels are in texture space
    vec2 one_over_size = 1.0 / a_size;
    
    // and do the same for the pixel height
    float pixel_y = u_width * one_over_size.y;
    
    // calculate the Y pixel coordinate to read by dividing our original coordinate by the size
    // of one scanline, then multiplying by the size of a pixel.
    float coord_y = pixel_y * floor(v_tex_coord.y / pixel_y);
    
    // read the new coordinate from our texture and send it back, , taking into
    // account node transparency
    vec4 pixel_color = texture2D(u_texture, vec2(v_tex_coord.x, coord_y)) * v_color_mix.a;

    // 2. Now add scanlines
    
    // if the current color is not transparent
    if (pixel_color.a > 0.0) {
        // find this pixel's position in the texture
        float this_pixel = a_size[1] * v_tex_coord.y;

        // calculate the force of the scanline at this point
        // modulo of the pixel position against the scanline size dictates strength of line
        float scanlineForce = (mod(this_pixel, u_width) / u_width);
        float scanlineBrightness = (u_brightness * 2.0) - 1.0;
        
        // factor in brightness level and a little saturation (clamp output level between 0.3 and 1.0)
        scanlineForce = min(max(scanlineForce + scanlineBrightness, 0.3), 1.0);

        // interpolate the pixel color from black to input color using brightness factor
        vec4 scanlineColor = pixel_color * u_color;
        gl_FragColor = vec4(mix(vec4(0, 0, 0, v_color_mix.a), scanlineColor, scanlineForce));
    } else {
        // use the current (transparent) color
        gl_FragColor = vec4(0, 0, 0, 0);
    }

}

