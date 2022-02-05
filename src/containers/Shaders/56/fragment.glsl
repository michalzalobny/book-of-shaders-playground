//Based on : https://www.youtube.com/watch?v=3CycKKJiwis

uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359
#define S(a, b, t) smoothstep(a, b, t)

//Draws the distance from p to the line between points a and b
float DistLine(vec2 p, vec2 a, vec2 b){
    vec2 pa = a-p;
    vec2 ba = a-b;
    float t = clamp(dot(pa,ba)/dot(ba,ba), 0.0, 1.0); //Projects vector pa to ba and scales the output so that its between 0 and 1
    return length(pa-ba*t);
}

float Line(vec2 p, vec2 a, vec2 b){
    float d = DistLine(p, a, b);
    float m = S(0.03, 0.01, d);
    float d2 = length(a-b);
    m*= S(1.2, 0.8, d2); //Fade out the line if its too far away
    return m;
}

float N21(vec2 p){
    p = fract(p*vec2(233.34, 851.73));
    p += dot(p, p + 23.45);
    return fract(p.x * p.y);
}

vec2 N22(vec2 p){
    float n = N21(p);
    return vec2(n, N21(p+n));
}

vec2 GetPos(vec2 id, vec2 offset){
    // vec2 n = N22(id);
    // //By multiplying frequency by a random number we get a random move 
    // float x = sin(uTime * n.x);
    // float y = cos(uTime * n.y);
    // return vec2(x,y) * 0.5 * 0.7;

    //OR, same result: 
    vec2 n = N22(id + offset) * uTime;
    return offset + sin(n) * 0.5 * 0.7;
}

float Layer(vec2 uv){
    float m = 0.0;
    vec2 gv = fract(uv) - 0.5; //grid uv - It will go from -0.5 to 0.5
    vec2 id = floor(uv);

    vec2 p[9];//Array of vector2's

    int i = 0; //index
    for(float y = -1.0; y <= 1.0; y++){
        for(float x = -1.0; x <= 1.0; x++){
            p[i] = GetPos(id, vec2(x,y));
            i++;
        }
    }


    float t = uTime * 5.0;
    for(int i = 0; i < 9; i++){
        m+= Line(gv, p[4], p[i]); //p[4] is the middle cell we are drawing lines from

        vec2 j = (p[i] - gv) * 15.0;
        float sparkle = 1.0 / dot(j,j); //Its 1.0 over the length(j) * length(j) to make the fall of quicker
        float dim = S(0.0, 1.0, sparkle);
        sparkle = mix(0.0, sparkle, dim);
        m+= sparkle * (sin(t + p[i].x * 15.0) *0.5 + 0.5);
    }

    //We need to draw a few more lines to prevent from gaps
    m+= Line(gv, p[1], p[3]);
    m+= Line(gv, p[1], p[5]);
    m+= Line(gv, p[5], p[7]);
    m+= Line(gv, p[3], p[7]);

    return m;
}

void main()
{
    //mouse
    vec2 mouse;
    mouse.x = uMouse.x  / uCanvasRes.x;
    mouse.y = (uCanvasRes.y -  uMouse.y)  / uCanvasRes.y;
    //Move the center
    mouse.x -= 0.5;

    vec2 uv = vUv;  
    uv -= 0.5;
    float gradient = uv.y;
    float m = 0.0;
    float t = (uTime + 125.0) * 0.1;

    float s=  sin(t);
    float c = cos(t);
    mat2 rot = mat2(c, -s, s, c);

    uv *= rot;
    mouse *= rot;

    for(float i = 0.0; i <= 1.0; i+= 0.25){
        float z = fract(i+t);
        float size = mix(8.0, 0.5, z);
        float fade = S(0.0, 0.5, z) * S(1.0, 0.8, z);
        m += Layer(uv * size + i*20.0 - mouse)* fade;
    }

    
    vec3 base = sin(t * 5.0 * vec3(0.345, 0.456, 0.657)) * 0.4 + 0.6; //sin with vector3 generates vector3 with 3 sines
    vec3 col = m * base;
    col -= gradient * base;

    // if(gv.x > 0.46 || gv.y > 0.46) col = vec3(1.0, 0.0, 0.0); //grid for the debug

    gl_FragColor = vec4(col, 1.0);
}