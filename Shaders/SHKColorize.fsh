//
// Recolors a texture to a user color based on a strength value.
// Uniform: u_color, the SKColor to use. This is multiplied with the original, meaning that blacks remain black
// Uniform: u_strength, how much of the replacement color to apply. Specify a value between 0 (use original color) and 1 (use replacement color fully)
//
// This works by calculating the grayscale value for each texel then multiplying that
// by a color provided by the user. That is then blended with the original pixel color
// based on a strength provided by the user to provide variable recoloring.
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

void main( void ) {
    // find the current pixel color
    vec4 current_color = texture2D(u_texture, v_tex_coord);

    // if it's not transparent
    if (current_color.a > 0.0) {
        // these values correspond to how important each color is to the overall brightness
        vec3 gray_values = vec3(0.2125, 0.7154, 0.0721);

        // the dot() function multiples all the colors in our source color with all the values in
        // our gray_values conversion then sums them
        float gray = dot(current_color.rgb, gray_values);

        // calculate the new color by blending gray with the user's input color
        vec4 new_color = vec4(gray * u_color.rgb, current_color.a);

        // now blend that with the original color based on the strength uniform
        gl_FragColor = mix(current_color, new_color, u_strength) * v_color_mix.a;
    } else {
        // use the current (transparent) color
        gl_FragColor = current_color;
    }
}
