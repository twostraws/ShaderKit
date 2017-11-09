//
// Creates a grid of multi-colored flashing lights.
// Uniform: u_density, how many rows and columns to create. A range of 1 to 50 works well; try starting with 8.
// Uniform: u_speed, how fast to make the lights vary their color. Higher values cause lights to flash faster and vary in color more. A range of 1 to 20 works well; try starting with 3.
// Uniform: u_group_size, how many lights to place in each group. A range of 1 to 8 works well depending on your density; starting with 1.
// Uniform: u_brightness, how bright to make the lights. A range of 0.2 to 10 works well; try starting with 3.
//
// This works by creating a grid of colors by chunking the texture according to the density from the user.
// Each chunk is then assigned a random color variance using the same sine trick documented in
// SHKStaticGrayNoise, which makes it fluctuate differently from other chunks around it.
//
// We then calculate the color for each chunk by taking a base color and adjusting it based on the
// random color variance we just calculated, so that each chunk displays a different color. This is done
// using sin() so we get a smooth color modulation.
//
// Finally, we pulsate each chunk so that it glows up and down, with black space between each chunk to create
// delineated a light effect. The black space is created using another call to sin() so that the color
// ramps from 0 to 1 then back down again.
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

#define M_PI 3.1415926535897932384626433832795

void main() {
    // get the color of the current pixel
    vec4 current_color = SKDefaultShading();

    // if it's not transparent
    if (current_color.a > 0.0) {
        // STEP 1: split the grid up into groups based on user input
        vec2 point = v_tex_coord * u_density;

        // STEP 2: Calculate the color variance for each group
        // pick two numbers that are unlikely to repeat
        vec2 non_repeating = vec2(12.9898, 78.233);

        // assign this pixel to a group number
        vec2 group_number = floor(point);

        // multiply our group number by the non-repeating numbers, then add them together
        float sum = dot(group_number, non_repeating);

        // calculate the sine of our sum to get a range between -1 and 1
        float sine = sin(sum);

        // multiply the sine by a big, non-repeating number so that even a small change will result in a big color jump
        float huge_number = sine * 43758.5453;

        // calculate the sine of our time and our huge number and map it to the range 0-1
        float variance = (0.5 * sin(u_time + huge_number)) + 0.5;

        // adust the color variance by the provided speed
        float accelerated_variance = u_speed * variance;


        // STEP 3: Calculate the final color for this group
        // select a base color to work from
        vec3 base_color = vec3(3.0, 1.5, 0.0);

        // apply our variation to the base color, factoring in time
        vec3 varied_color = base_color + accelerated_variance + u_time;

        // calculate the sine of our varied color so it has the range -1 to 1
        vec3 varied_color_sine = sin(varied_color);

        // adjust the sine to lie in the range 0 to 1
        vec3 color = (0.5 * varied_color_sine) + 0.5;


        // STEP 4: Now we know the color, calculate the color pulse
        // Start by moving down and left a little to create black lines at insersection points
        vec2 group_size = M_PI * 2.0 * u_group_size * (point - (0.25 / u_group_size));

        // calculate the sine of our group size, then adjust it to lie in the range 0 to 1
        vec2 group_sine = (0.5 * sin(group_size)) + 0.5;

        // use the sine to calculate a pulsating value between 0 and 1, making our group fluctuate together
        vec2 pulse = smoothstep(0.0, 1.0, group_sine);

        // calculate the final color by combining the pulse strength and user brightness with the color for this square
        gl_FragColor = vec4(color * (pulse.x * pulse.y * u_brightness), 1.0) * v_color_mix.a;
    } else {
        gl_FragColor = current_color;
    }
}
