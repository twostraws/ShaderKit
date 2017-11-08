//
// Simulates an infrared camera by coloring brighter objects red and darker objects blue.
//
// This works by calculating the brightness of the current color, then creating a new
// a new color based on that brightness. If the brightness is lower than 0.5 on a scale of
// 0 to 1, the new color is a mix of blue and yellow based; if the brightness is 0.5 or
// higher, the new color is a mix of yellow and red.
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
    vec4 current_color = texture2D(u_texture, v_tex_coord);

    // if it's not transparent
    if (current_color.a > 0.0) {
        // create three colors: blue (cold), yellow (medium), and hot (red)
        vec3 cold = vec3(0.0, 0.0, 1.0);
        vec3 medium = vec3(1.0, 1.0, 0.0);
        vec3 hot = vec3(1.0, 0.0, 0.0);

        // these values correspond to how important each color is to the overall brightness
        vec3 gray_values = vec3(0.2125, 0.7154, 0.0721);

        // the dot() function multiples all the colors in our source color with all the values in our gray_values conversion
        // then sums them; this then gets put into a new vec3 color as its RGB values
        float luma = dot(current_color.rgb, gray_values);

        // declare the color we're going to use
        vec3 new_color;

        // if we have brightness of lower than 0.5
        if (luma < 0.5) {
            // create a mix of blue and yellow; luma / 0.5 means this will be a range from 0 to 1
            new_color = mix(cold, medium, luma / 0.5);
        } else {
            // create a mix of yellow and red; (luma - 0.5) / 0.5 means this will be a range of 0 to 1
            new_color = mix(medium, hot, (luma - 0.5) / 0.5);
        }

        // create the final color, multiplying by this pixel's alpha (to avoid a hard edge) and also
        // multiplying by the node alpha so we can fade in or out
        gl_FragColor = vec4(new_color, current_color.a) * current_color.a * v_color_mix.a;
    } else {
        // use the current (transparent) color
        gl_FragColor = current_color;
    }
}



