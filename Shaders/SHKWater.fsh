//
// Warps a textured node to create a water rippling effect.
// NOTE: This must be applied to something that has a texture.
// Uniform: u_speed, how many fast to make the water ripple. Ranges from 0.5 to 10 work best; try starting with 3.
// Uniform: u_strength, how pronounced the rippling effect should be. Ranges from 1 to 5 work best; try starting with 3.
// Uniform: u_frequency, how often ripples should be created. Ranges from 5 to 25 work best; try starting with 10.
//
// This works by using a nearby pixel color rather than the original pixel color. Which neighbour is
// chosen depends on the algorithm: we pass the original coordinate, speed, and frequency
// into the sin() and cos() functions to get different numbers between -1 and 1, then multiply
// that by the user's strength parameter to see how far the neighbour pixel should be.
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
    // bring both speed and strength into the kinds of ranges we need for this effect
    float speed = u_time * u_speed * 0.05;
    float strength = u_strength / 100.0;

    // take a copy of the current texture coordinate so we can modify it
    vec2 coord = v_tex_coord;

    // offset the coordinate by a small amount in each direction, based on wave frequency and wave strength
    coord.x += sin((coord.x + speed) * u_frequency) * strength;
    coord.y += cos((coord.y + speed) * u_frequency) * strength;

    // use the color at the offset location for our new pixel color
    gl_FragColor = texture2D(u_texture, coord) * v_color_mix.a;
}
