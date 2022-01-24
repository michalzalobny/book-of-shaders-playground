#pragma glslify: cnoise = require('glsl-noise/classic/3d')
uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359


void main()
{
    vec3 colorEnd =vec3(0.0 / 255.0 , 43.0 / 255.0 , 61.0 / 255.0 );
    vec3 colorStart = vec3(0.0 / 255.0 , 200.0 / 255.0 , 156.0 / 255.0 );

    // Displace the UV
    vec2 displacedUv = vUv + cnoise(vec3(vUv * 5.0, uTime * 0.1));
    float strength;
    // Perlin noise
    strength += cnoise(vec3(displacedUv * 5.0, uTime * 0.2));

    // Outer glow
    float outerGlow = distance(vUv, vec2(0.5)) * 5.0 - 1.4;
    strength += outerGlow;

    // Apply cool step
    strength += step(- 0.2, strength) * 0.6;
    
    // Final color
    vec3 color = mix(colorStart, colorEnd, strength);
    gl_FragColor = vec4(color, 1.0);
}