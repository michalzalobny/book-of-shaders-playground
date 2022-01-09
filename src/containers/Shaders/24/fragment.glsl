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
    
    vec3 color = vec3(0.0);
    float d = 0.0;

    // Remap the space to -1. to 1.
    st = st *2.-1.;

    // Number of sides of your shape
    int N = 3;

    // Angle and radius from the current pixel
    float a = atan(st.x,st.y)+ PI  * change; //PI controls the rotation of shape 
    float r = 2. * PI/float(N);

    // Shaping function that modulate the distance
    d = cos(floor(.5+a/r)*r-a)*length(st);

    color = vec3(1.0-smoothstep(.4,.41,d));
    // color = vec3(d);

    gl_FragColor = vec4(color,1.0);
}