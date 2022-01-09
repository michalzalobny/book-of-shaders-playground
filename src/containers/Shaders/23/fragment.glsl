uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359




void main()
{
    float change = (sin(uTime *2.) + 1.) / 2.;
    change = smoothstep( 0., 1., change);
    change *= change;

    vec2 st = vUv;
    
    // drawing shapes using polar coordinates
    vec3 color = vec3(0.0);
    vec2 pos = st - vec2(0.5 );

    float r = length(pos)*2.0;
    float a = atan(pos.y,pos.x);

    float f = smoothstep(-.5,1., cos(a*10.))*0.2+0.5;

    color = vec3( 1.-smoothstep(f,f,r) );

    gl_FragColor = vec4(vec3(color), 1.0);
}