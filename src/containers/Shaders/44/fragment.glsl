//inspiration source: https://www.youtube.com/watch?v=bigjgiavOM0

uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

float circle( vec2 uv, float radius,  vec2 position, float blur){
    uv -= position; 
    float d = length(uv);
    return smoothstep(radius, radius - blur, d);
}

float smileyFace( vec2 uv, float size,  vec2 position, float blur, float angle){
    uv -= position; //translate coord system

    uv -= 0.5;
    uv = rotate2d(angle) * uv; //Rotate
    uv = uv / size; //scaling the coord system
    uv += 0.5;

    float strength = 0.0;
    strength += circle(uv, 0.35, vec2(0.5), blur);
    strength -= circle(uv, 0.08, vec2(0.4, 0.6), blur);
    strength -= circle(uv, 0.08, vec2(0.6, 0.6), blur);

    float mouth = clamp(circle(uv, 0.25, vec2(0.5), blur) - circle(uv, 0.28, vec2(0.5, 0.6), blur), 0.0, 1.0);
    strength -= mouth;
    return strength;
}

float band(float t, float start, float end, float blur){
    float step1 = smoothstep(start - blur, start + blur, t);
    float step2 = smoothstep(end + blur, end - blur, t);
    return step1 * step2;
}


float rect(vec2 uv, vec2 position, float width, float height, float blur){
    uv -= position;
    float band1 = band(uv.x, -width/2.0, width/2.0, blur);
    float band2 = band(uv.y, -height/2.0, height/2.0, blur);
    return band1 * band2;
}

void main()
{
    vec2 st = vUv;
    st *= 4.0;
    vec2 fPos = fract(st);
    vec2 iPos = floor(st);

    float isOdd = step(1.0, mod(iPos.y, 2.0));

    float speed = 3.0;
    float strength;
    vec3 col = vec3(0.0);
    col = vec3(1.0, 1.0, 0.0);
    float onOff = pow(sin(uTime * speed) * 0.5 + 0.5, 2.0);
    float onOffTime = step(0.5, (sin(uTime * 0.5 * speed - onOff) * 0.5 + 0.5));
    
    // strength += smileyFace(vUv, 0.3, vec2(0.3), 0.005);
    strength -= rect(fPos, vec2(0.5 * onOff, 0.5 ), 1.0  * onOff, 1.0, 0.001);
    strength += smileyFace(fPos, 1.0, vec2(0.), 0.005, PI * isOdd * onOffTime + PI * (1.-isOdd) * (1.-onOffTime));
    strength = clamp(strength, 0.0, 1.0);
    col *= strength;

    gl_FragColor = vec4(vec3(col), 1.0);
}