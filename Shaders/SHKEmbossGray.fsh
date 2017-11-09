//
// Creates a grayscale emboss effect for the node.
// Attribute: a_size, the size of the node.
// Uniform: u_strength, how much embossing to apply. Ranges from 0 to 1 work best; try starting with 1.
//
// This works in several steps. First, we need to find the size of one pixel in the image,
// so we are able to read other nearby pixels.
//
// Second, we create our base new color as a middle gray: RGB 0.5, with A 1.0.
//
// Third, we read values diagonally up and to the right, then down and to the left, to see
// what's nearby, and add or subtract them from our gray color. How far we move diagonally
// depends on the strength the user provided.
//
// Fourth, we average the new color's RGB values to create a flat gray color ignoring luminescence,
// then use that average for the RGB value of our pixel.
//
// If you're not sure how this works, imagine a pixel on the top edge of a sprite. Above it has nothing,
// so nothing gets added to the base gray color. Below it has a pixel of the same color, so that color
// gets subtracted from the base gray color to make it black. The same is true in reverse of pixels on
// the bottom edge: they have nothing below so nothing is subtracted, but they have a pixel above so
// that gets added, making it a bright color.
//
// As for pixels in the middle, they'll get embossed based on the pixels either side of them. If a red pixel
// is surrounded by a sea of other red pixels, then red will get added from above then subtracted in equal
// measure from below, so the final color will be the original mid-gray.
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
        // find the size of one pixel by reading the input size
        vec2 pixel_size = 1.0 / a_size;

        // assume our new color is middle gray (R: 0.5, G: 0.5, B: 0.5, A: 1)
        vec4 new_color = vec4(vec3(0.5), 1);

        // move up one pixel diagonally and read the current color, multiply it by the input strength, then add it to our pixel color
        new_color += texture2D(u_texture, v_tex_coord + pixel_size) * u_strength;

        // move down one pixel diagonally and read the current color, multiply it by the input strength, then subtract it to our pixel color
        new_color -= texture2D(u_texture, v_tex_coord - pixel_size) * u_strength;

        // sum the RGB values for our new color
        float combined = new_color.r + new_color.g + new_color.b;

        // divide that sum by 3 to give us an average, and use that for the RGB values of our color
        new_color.rgb = vec3(combined / 3.0);

        // use that new color, with an alpha of 1, for our pixel color, multiplying by this pixel's alpha
        // (to avoid a hard edge) and also multiplying by the alpha for this node
        gl_FragColor = vec4(new_color.rgb, 1) * current_color.a * v_color_mix.a;
    } else {
        // use the current (transparent) color
        gl_FragColor = current_color;
    }
}
