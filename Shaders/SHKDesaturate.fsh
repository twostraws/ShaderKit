//
// Desaturates the colors in a texture.
// Uniform: u_strength, the amount to desaturate.  Specify 0 (no desaturation) to 1 (full desaturation).
//
// This works by calculating the grayscale color for a given pixel, then mixing that
// with the original color based on the strength provided by the user.
//
// Calculating the relative luminance of a color – i.e., how bright it is – isn't as simple
// as adding its RGB values and dividing by three, because human eyes are more sensitive to
// green and red than they are to blue. That is, a fully green color appears brighter
// than a fully blue color.
//
// So, to calculate the correct luminance for each pixel we use a precise weighting:
// R is weighted at 0.2125, G at 0.7154, and B at 0.0721. This totals 1.
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
    float strength = clamp(u_strength, 0.0, 1.0);

    // find the current pixel color
    vec4 current_color = SKDefaultShading();

    // these values correspond to how important each color is to the overall brightness
    vec3 gray_values = vec3(0.2125, 0.7154, 0.0721);

    // the dot() function multiples all the colors in our source color with all the values in our
    // gray_values conversion then sums them; this then gets put into a new vec3 color as its RGB values
    vec3 desaturated = vec3(dot(current_color.rgb, gray_values));

    // if the user requested full desaturation
    if (strength == 1.0) {
        // just show the desaturated version
        gl_FragColor = vec4(desaturated, current_color.a) * v_color_mix.a;
    } else {
        // blend the original and desaturated by whatever 1 - strength was passed in
        gl_FragColor = vec4(mix(current_color.rgb, desaturated, strength), current_color.a) * v_color_mix.a;
    }
}


