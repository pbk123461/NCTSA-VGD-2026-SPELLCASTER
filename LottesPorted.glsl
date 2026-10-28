#version 300 es
#ifdef GL_ES
precision mediump float;
#endif
// *** WARNING: DO NOT CHANGE THE CODE ABOVE *** //
// For more information on using shaders in Gandi IDE, please visit: https://getgandi.com/blog/glsl-in-gandi-ide

//============================================================== 
//      [CRTS] PUBLIC DOMAIN CRT-STYLED SCALAR - 20180120b
//
//                      by Timothy Lottes
//             https://www.shadertoy.com/view/MtSfRK
//               Adapted for Gandi IDE
//
// CRT shader with scanlines, screen curvature, and shadow mask
// All parameters are hardcoded - no external uniforms needed
//==============================================================

// *** DEFAULT VARIABLES *** //
uniform bool byp;
in vec2 vUv;
out vec4 fragColor;
uniform sampler2D tDiffuse;

//==============================================================
// HARDCODED PARAMETERS - Adjust these values directly in code
//==============================================================
#define HARD_SCAN -12.0
#define HARD_PIX -4.0
#define WARP_X 0.0
#define WARP_Y 0.0
#define MASK_DARK 0.6
#define MASK_LIGHT 1.4
#define BRIGHT_BOOST 1.05
#define SHAPE 2.0

//==============================================================
// HELPER FUNCTIONS
//==============================================================

// sRGB to Linear
vec3 ToLinear(vec3 c) {
    return mix(c / 12.92, 
               pow((c + 0.055) / 1.055, vec3(2.4)),
               step(vec3(0.04045), c));
}

// Linear to sRGB
vec3 ToSrgb(vec3 c) {
    return mix(c * 12.92,
               1.055 * pow(c, vec3(1.0/2.4)) - 0.055,
               step(vec3(0.0031308), c));
}

// Fetch texel with offset
vec3 Fetch(vec2 pos, vec2 off) {
    vec2 res = vec2(textureSize(tDiffuse, 0));
    pos = (floor(pos * res + off) + 0.5) / res;
    if(max(abs(pos.x - 0.5), abs(pos.y - 0.5)) > 0.5) return vec3(0.0);
    return ToLinear(BRIGHT_BOOST * texture(tDiffuse, pos).rgb);
}

// Distance to nearest texel
vec2 Dist(vec2 pos) {
    return -(fract(pos * vec2(textureSize(tDiffuse, 0))) - 0.5);
}

// 1D Gaussian
float Gaus(float pos, float scale) {
    return exp2(scale * pow(abs(pos), SHAPE));
}

// 3-tap horizontal filter
vec3 Horz3(vec2 pos, float off) {
    vec3 b = Fetch(pos, vec2(-1.0, off));
    vec3 c = Fetch(pos, vec2( 0.0, off));
    vec3 d = Fetch(pos, vec2( 1.0, off));
    float dst = Dist(pos).x;
    float wb = Gaus(dst - 1.0, HARD_PIX);
    float wc = Gaus(dst, HARD_PIX);
    float wd = Gaus(dst + 1.0, HARD_PIX);
    return (b*wb + c*wc + d*wd) / (wb + wc + wd);
}

// 5-tap horizontal filter
vec3 Horz5(vec2 pos, float off) {
    vec3 a = Fetch(pos, vec2(-2.0, off));
    vec3 b = Fetch(pos, vec2(-1.0, off));
    vec3 c = Fetch(pos, vec2( 0.0, off));
    vec3 d = Fetch(pos, vec2( 1.0, off));
    vec3 e = Fetch(pos, vec2( 2.0, off));
    float dst = Dist(pos).x;
    float wa = Gaus(dst - 2.0, HARD_PIX);
    float wb = Gaus(dst - 1.0, HARD_PIX);
    float wc = Gaus(dst, HARD_PIX);
    float wd = Gaus(dst + 1.0, HARD_PIX);
    float we = Gaus(dst + 2.0, HARD_PIX);
    return (a*wa + b*wb + c*wc + d*wd + e*we) / (wa + wb + wc + wd + we);
}

// Scanline weight
float Scan(vec2 pos, float off) {
    return Gaus(Dist(pos).y + off, HARD_SCAN);
}

// Tri-sample pattern with scanlines
vec3 Tri(vec2 pos) {
    vec3 a = Horz3(pos, -1.0);
    vec3 b = Horz5(pos,  0.0);
    vec3 c = Horz3(pos,  1.0);
    float wa = Scan(pos, -1.0);
    float wb = Scan(pos,  0.0);
    float wc = Scan(pos,  1.0);
    return a*wa + b*wb + c*wc;
}

// Screen warp
vec2 Warp(vec2 pos) {
    pos = pos * 2.0 - 1.0;
    pos *= vec2(1.0 + (pos.y*pos.y) * WARP_X,
                1.0 + (pos.x*pos.x) * WARP_Y);
    return pos * 0.5 + 0.5;
}

// Shadow mask
vec3 Mask(vec2 pos) {
    vec3 mask = vec3(MASK_DARK);
    pos.x = fract(pos.x / 6.0);
    if(pos.x < 0.333) mask.r = MASK_LIGHT;
    else if(pos.x < 0.666) mask.g = MASK_LIGHT;
    else mask.b = MASK_LIGHT;
    return mask;
}

//==============================================================
// MAIN
//==============================================================
void main() {
    if (!byp) {
        vec2 pos = Warp(vUv);
        vec3 col = Tri(pos);
        col *= Mask(floor(pos * vec2(textureSize(tDiffuse, 0))));
        vec2 vin = (pos - 0.5) * 2.0;
        col *= 1.0 - dot(vin, vin) * 0.2;
        fragColor = vec4(ToSrgb(col), 1.0);
    } else {
        fragColor = texture(tDiffuse, vUv);
    }
}
