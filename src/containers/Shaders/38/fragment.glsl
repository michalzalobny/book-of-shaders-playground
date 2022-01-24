#pragma glslify: noise = require('glsl-noise/classic/2d')
uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359
#define NUM_OCTAVES 5


float fbm ( in vec2 _st) {
    float v = 0.0 ;
    float a = 0.5;
    vec2 shift = vec2(100.0) ;
    // Rotate to reduce axial bias
    mat2 rot = mat2(cos(0.5), sin(0.5),
                    -sin(0.5), cos(0.50));
    for (int i = 0; i < NUM_OCTAVES; ++i) {
        v += a * noise(_st);
        _st = rot * _st * 2.0 + shift ;
        a *= 0.5 ;
    }
    return v;
}

float pattern( in vec2 p, out vec2 q, out vec2 r )
{
    p -= vec2(0.5);
    float time = 0.5 * (sin(uTime * 0.8) + 1.0);

    q.x = fbm( p  + vec2(0.0,0.0) ) ;
    q.y = fbm( p  + vec2(5.2,1.3) ) ;

    r.x = fbm( p  + 4.0*q + vec2(1.7,9.2));
    r.y = fbm( p  * time + 4.0*q  + vec2(8.3,2.8) );//

    return fbm( p + 4.0*r );
}

void main()
{
    vec3 gold = vec3(242.0 / 255.0 , 178.0 / 255.0 , 58.0 / 255.0 );
    vec3 lightBlue = vec3(83.0 / 255.0 , 227.0 / 255.0 , 252.0 / 255.0 ) ;
    vec3 blue = vec3(9.0 / 255.0 , 100.0 / 255.0 , 156.0 / 255.0 );
    vec3 darkBlue = vec3(7.0 / 255.0 , 33.0 / 255.0 , 60.0 / 255.0 );
    vec3 white = vec3(255.0 / 255.0 , 255.0 / 255.0 , 255.0 / 255.0 );

    vec2 st = vUv;
    vec2 q;
    vec2 r;
    float f = pattern(st, q, r );
    vec3 color;
    
    color = mix(blue,gold,clamp((f*f)*4.5,0.0,1.0));
    color = mix(color, darkBlue,clamp(length(q),0.0,1.0));
    color = mix(color,lightBlue,clamp(length(r.x),0.0,1.0));

    gl_FragColor = vec4(color,1.0);
}