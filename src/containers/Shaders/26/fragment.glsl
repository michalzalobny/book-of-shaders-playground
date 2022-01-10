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
    uv = rotate2d( uTime * -1.2) * uv;
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

float pulsingCircle(float width, vec2 st, vec2 position){
    float color;

    float innerCircle = circle(width, st ,position);

    float pulseFreq = uTime * 0.04;
    float maxRingWidth = 5.0 * width;

    float ring1Width = mod(pulseFreq, maxRingWidth) + width;
    float ring1Life = mix(1.0, 0.0, ring1Width / (maxRingWidth + width)); //Goes from 1 to 0 based on the ring width
    float ring1 = ring( ring1Width, width * 0.4 * ring1Life, position, st) * ring1Life;

    float ring2Width = mod(pulseFreq + 0.015, maxRingWidth) + width;
    float ring2Life = mix(1.0, 0.0, ring2Width / (maxRingWidth + width)); //Goes from 1 to 0 based on the ring width
    float ring2 = ring( ring2Width, width * 0.4 * ring2Life, position, st) * ring2Life;

    color += innerCircle;
    color += ring1;
    color += ring2;

    return color;
}

vec2 randomPos(float speed, float radius){
    float random = 0.5 * (sin(uTime*.2) + 1.0); //Goes from 0 to 1
    return vec2(sin(speed), cos(speed))* radius + 0.5  - 0.1 * random;
}

float semiCircle(float radius, vec2 st, vec2 position, float circlePercent, float rotation){
    float angle = customAngle(st, position, circlePercent, rotation);
    float ring1 = ring(radius, 0.001, position, st);
    return ring1 *  step(0.0001,angle);
}

void main(){
    vec3 color = vec3(0.,0.,0.);

    vec3 ring1 = ring(0.02, 0.001, vec2(0.5), vUv) * blue3;
    vec3 ring2 = ring(0.2, 0.001, vec2(0.5), vUv) * blue3;
    vec3 ring3 = ring(0.3, 0.001, vec2(0.5), vUv) * blue2;
    float movingL = movingLine(vUv, vec2(0.5), 0.4);
    float movingLStep = movingL * 2.5; //Used to highlight the red circles
    vec3 radar = movingL * blue3;

    vec2 redCirclePos = randomPos(uTime * 0.02, 0.3);
    vec3 redCircle = pulsingCircle(0.015, vUv, redCirclePos ) * vec3(movingLStep) * red;

    vec2 redCircle2Pos = randomPos(-uTime * 0.03 - 10., 0.3);
    vec3 redCircle2 = pulsingCircle(0.015, vUv, redCircle2Pos ) * vec3(movingLStep) * red;

    vec2 point1Pos = randomPos(uTime * 0.2 - 1.5, 0.2);
    vec3 point1 = circle(0.005, vUv, point1Pos ) * blue1;

    vec2 point2Pos = randomPos(uTime * 0.15 - 10.1, 0.25);
    vec3 point2 = circle(0.005, vUv, point2Pos ) * blue1;

    vec2 point3Pos = randomPos(-uTime * 0.21 - 4.1, 0.09);
    vec3 point3 = circle(0.005, vUv, point3Pos ) * blue1;

    vec2 point4Pos = randomPos(uTime * 0.358 - 6.1, 0.25);
    vec3 point4 = circle(0.005, vUv, point4Pos ) * blue1;

    vec2 point5Pos = randomPos(-uTime * 0.37 - 0.4, 0.12);
    vec3 point5 = circle(0.005, vUv, point5Pos ) * blue1;

    float semiTime = (0.5 * (sin(uTime* 1.) + 1.0));
    float maxPercent = 0.45;
    float minPercent = 0.25;
    float difference = maxPercent - minPercent;

    vec3 semiCircle1 = semiCircle(0.32, vUv, vec2(0.5), minPercent + difference * semiTime, minPercent * PI + PI * difference * semiTime)  * blue3;
    vec3 semiCircle2 = semiCircle(0.32, vUv, vec2(0.5), minPercent + difference * semiTime, PI + minPercent * PI + PI * difference * semiTime)  * blue3;

    semiTime = (0.5 * (sin(uTime * -1.2) + 1.0));
    maxPercent = 0.5;
    minPercent = 0.4;
    difference = maxPercent - minPercent;
    vec3 semiCircle3 = semiCircle(0.4, vUv, vec2(0.5), minPercent + difference * semiTime, -0.5 * PI + minPercent * PI + PI * difference * semiTime)  * blue2;
    vec3 semiCircle4 = semiCircle(0.4, vUv, vec2(0.5), minPercent + difference * semiTime, 0.5 * PI + minPercent * PI + PI * difference * semiTime)  * blue2;

    color += ring1;
    color += ring2;
    color += ring3;
    color += radar;

    color += redCircle;
    color += redCircle2;
    color += point1;
    color += point2;
    color += point3;
    color += point4;
    color += point5;

    color += semiCircle1;
    color += semiCircle2;
    color += semiCircle3;
    color += semiCircle4;

    gl_FragColor = vec4(color, 1.0);
}