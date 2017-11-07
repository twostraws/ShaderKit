//
// Creates fixed multi-colored noise.
//
// This works using a simple (but brilliant!) and well-known trick: if you
// calculate the dot product of a texture coordinate with a vec2 containing
// two numbers that are unlikely to repeat, then calculate the sine of that
// and multiply it by a large number, you'll end up with what looks more or
// less like random numbers in the fraction digits – i.e., everything after
// the decimal place.
//
// This is perfect for our needs: those numbers will already range from 0 to
// 0.99999... so we can use that for our color value by calling it once for each
// of the RGB components.
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

float random(float offset, vec2 tex_coord) {
    // pick two numbers that are unlikely to repeat
    vec2 non_repeating = vec2(12.9898, 78.233);

    // multiply our texture coordinates by the non-repeating numbers, then add them together
    float sum = dot(tex_coord, non_repeating);

    // calculate the sine of our sum to get a range between -1 and 1
    float sine = sin(sum);

    // multiply the sine by a big, non-repeating number so that even a small change will result in a big color jump
    float huge_number = sine * 43758.5453 * offset;

    // get just the numbers after the decimal point
    float fraction = fract(huge_number);

    // send the result back to the caller
    return fraction;
}

void main() {
    // find the current pixel color
    vec4 current_color = SKDefaultShading();

    // if it's not transparent
    if (current_color.a > 0.0) {
        // make a color where the RGB values are different random numbers and A is 1; multiply by the node alpha so we can fade in or out
        gl_FragColor = vec4(random(1.23, v_tex_coord), random(5.67, v_tex_coord), random(8.90, v_tex_coord), 1) * current_color.a * v_color_mix.a;
    } else {
        // use the (transparent) color
        gl_FragColor = current_color;
    }
}

