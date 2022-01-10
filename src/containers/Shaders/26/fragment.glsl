uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359
#define blue1 vec3(0.74,0.95,1.00);
#define blue2 vec3(0.87,0.98,1.00);
#define blue3 vec3(0.35,0.76,0.83);
#define blue4 vec3(0.953,0.969,0.89);
#define red   vec3(1.00,0.08,0.007);


mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

mat2 scale(vec2 _scale){
    return mat2(_scale.x,0.0,
                0.0,_scale.y);
}

float circle(float width, vec2 st, vec2 position){
    return 1. - step(0.5, distance(vUv, position) + .5 - 1. * width);
}

float ring(float width, float strokeWidth, vec2 position, vec2 st){
    return 1.0 - step(strokeWidth, abs(distance(st, position) - (width - strokeWidth)));
}

float random(vec2 st){
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float customAngle(vec2 st, vec2 position, float circlePercent, float rotation){
    //Translate uvs just to apply the rotation, then reset to default
    st -= vec2(0.5);
    st = rotate2d(rotation) * st;
    st += vec2(0.5);

    st -= position;
    float angle = atan(st.x, st.y); //The values of atan(x,y) go from -PI to PI
    angle += PI; 
    angle = angle * 0.5 / PI; // goes from 0 to 1;
    float a = clamp(mix(0. , 1. , angle * 1. / circlePercent), 0.0, 1.0); //Draws the angle
    float b = step(circlePercent, angle); //Cut out the color after the angle is finished
    return a - b;
}


float movingLine(vec2 uv, vec2 center, float radius){
    float lineWidth = 0.0025;
    float glowStrength = 0.8;

    //Translate uvs just to apply the rotation, then reset to default
    uv -= vec2(0.5);
    uv = rotate2d( uTime * -1. * 2.) * uv;
    uv += vec2(0.5);

    //Limit the radar rendering with negative space
    float outerCircle = 1. - circle(radius, uv, vec2(0.5));
    float outerSquare = 1. - step(0.5 , uv.x) * step(0.5 - lineWidth , uv.y);
    float negativeSpace = outerCircle + outerSquare;

    float line = step(0.5 , uv.x) * step(0.5 - lineWidth , uv.y) * step(0.5 - lineWidth ,1.- uv.y);
    float angle = customAngle(uv, vec2(0.5), 0.25, PI);
    float strength = clamp(angle * glowStrength + line, 0.0, 1.0);
    return clamp(strength - negativeSpace, 0., 1.);
}

void main(){
    vec3 color = vec3(0.,0.,0.);

    vec3 ring1 = ring(0.02, 0.001, vec2(0.5), vUv) * blue3;
    vec3 ring2 = ring(0.2, 0.001, vec2(0.5), vUv) * blue3;
    vec3 ring3 = ring(0.3, 0.001, vec2(0.5), vUv) * blue2;
    vec3 ring4 = ring(0.4, 0.002, vec2(0.5), vUv) * blue2;
    float movingL = movingLine(vUv, vec2(0.5), 0.4);
    vec3 radar = movingL * blue3;

    float randPos = floor(uTime* 2.);
    float rad = 0.4;

    vec3 redCircle = circle(0.02, vUv, vec2(sin(randPos  + 1.5)*rad + 0.5, cos(randPos + 1.5 )*rad + 0.5) ) * red ;

    color += ring1;
    color += ring2;
    color += ring3;
    color += ring4;
    color += radar;
    color += redCircle;

    gl_FragColor = vec4(color, 1.0);
}