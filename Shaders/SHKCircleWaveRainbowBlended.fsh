//
// Renders a circular pulsating wave effect with fluctuating colors, blending with existing pixels
// Uniform: u_speed, how fast the wave should travel. Ranges from -2 to 2 work best, where negative numbers cause waves to come inwards; try starting with 1.
// Uniform: u_brightness, how bright the colors should be. Ranges from 0 to 5 work best; try starting with 0.5 and experiment.
// Uniform: u_strength, how intense the waves should be. Ranges from 0.02 to 5 work best; try starting with 2.
// Uniform: u_density, how large each wave should be. Ranges from 20 to 500 work best; try starting with 100.
// Uniform: u_center, a CGPoint representing the center of the gradient, where 0.5/0.5 is dead center
// Uniform: u_red, how much red to apply to the colors. Specify 0 to 1 to apply that amount of red, or use any negative number (e.g. -1) to have the amount of red fluctuate.
//
// This works by calculating what a color gradient would look like over the space of the node
// then calculating the pixel's distance from the center of the wave. From there we can calculate
// the brightness of the pixel by taking the cosine the wave density and speed to create a nice and
// smooth effect.
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
        // calculate how fast to change colors based on how much time has elapsed for this wave relative to its input speed
        float color_speed = u_time * u_speed;
        
        // calculate how fast to make the waves move significantly faster than the color changing; this is negative so the waves move outwards
        float wave_speed = -(color_speed * 10.0);

        // create RGB colors from the provided brightness
        vec3 brightness = vec3(u_brightness);
        
        // how far our pixel is from the center of the circle
        float pixel_distance = distance(v_tex_coord, u_center);
        
        // use the provided red color, or prepare to make it fluctuate
        float red_adjustment = u_red;
        
        // if they provided a negative red color then make it fluctuate instead
        if (u_red < 0.0) {
            // calculate the sine of the current time, which will give a value between -1 and 1
            float sine = sin(color_speed);
            
            // halve that sine and add 0.5, which will give a range of 0 to 1; this will be our R color
            red_adjustment = (0.5 * sine) + 0.5;
        }
        
        // create a gradient by combining our R color with G and B values calculated using our texture coordinate, then multiply the result by the provided brightness
        vec3 gradient_color = vec3(red_adjustment, v_tex_coord) * brightness;
        
        // calculate how much color to apply to this pixel by cubing its distance from the center
        float color_strength = pow(1.0 - pixel_distance, 3.0);
        
        // multiply by the user's input strength
        color_strength *= u_strength;
        
        // calculate the size of our wave by multiplying provided density with our distance from the center
        float wave_density = u_density * pixel_distance;
        
        // decide how dark this pixel should be as a range from -1 to 1 by adding the speed of the overall wave by the density of the current pixel
        float cosine = cos(wave_speed + wave_density);
        
        // halve that cosine and add 0.5, which will give a range of 0 to 1
        // this is our wave fluctuation, which causes waves to vary between colored and dark
        float cosine_adjustment = (0.5 * cosine) + 0.5;
        
        // calculate the brightness for this pixel by multiplying its color strength with the sum of the user's requested strength and our cosine adjustment
        float luma = color_strength * (u_strength + cosine_adjustment);

        // force the brightness to decay rapidly so we don't hit the edges of our sprite
        luma *= 1.0 - (pixel_distance * 2.0);
        luma = max(0.0, luma);

        // multiply our gradient color by brightness for RGB, and the brightness itself for A
        vec4 final_color = vec4(gradient_color * luma, luma);
        
        // multiply the final color by the actual alpha of this node, so users can make it fade in/out as needed
        gl_FragColor = mix(current_color, final_color, final_color.a) * current_color.a * v_color_mix.a;
    } else {
        // use the current (transparent) color
        gl_FragColor = current_color;
    }
}

