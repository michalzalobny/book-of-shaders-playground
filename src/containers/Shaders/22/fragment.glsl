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
    vec2 st = vUv;
    //Re-map vUv, so its 0 at the center and 1 or -1 on the edges
    st = st * 2. -1.;

    float d = length( max(abs(st) - 0.5* change , 0.) );
    
    //returns the fractional part of x. This is calculated as x - floor(x)
    float dField = step(0.5,fract(d*10.0 * change));

    gl_FragColor = vec4(vec3(dField), 1.0);
}