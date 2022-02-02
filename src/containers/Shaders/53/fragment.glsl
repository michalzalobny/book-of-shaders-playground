//Based on the art of code video : https://www.youtube.com/watch?v=dXyPOLf2MbU

uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359
#define S(a, b, t) smoothstep(a, b, t)
#define HEART_COLOR vec3(0.79, 0.41, 0.98)

//smooth max function
float smax(float a, float b, float k){ 
    float h = clamp((b-a)/k + 0.5, 0.0, 1.0);
    return mix(a,b,h) + h*(1.0 - h) * k * 0.5;
}

float Heart(vec2 uv, float b){
    float r = 0.2; //radius
    b *= r;//blur
    uv.x *= 0.7;
    uv.y -= smax(sqrt(abs(uv.x)) * 0.5, b, 0.1); //shape circle
    uv.y += 0.1 + b * 0.5;
    float d = length(uv);

    return S(r+b, r-b -0.001, d);
}

void main()
{
    //mouse
    vec2 m;
    m.x = uMouse.x  / uCanvasRes.x;
    m.y = (uCanvasRes.y -  uMouse.y)  / uCanvasRes.y;
    //Move the center
    m.x -= 0.5;

    vec2 uv = vUv;
    uv -= 0.5;
    vec3 col = vec3(0.0);

    float c = Heart(uv, m.y);

    col = vec3(c * HEART_COLOR);

    gl_FragColor = vec4(col, 1.0);
}