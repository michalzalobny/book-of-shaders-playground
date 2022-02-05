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
    m*= S(1.2, 0.8, length(a-b)); //Fade out the line if its too far away
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

void main()
{
    vec2 uv = vUv;  
    float m = 0.0;
    uv*=5.0;

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


    float t = uTime * 4.0;
    for(int i = 0; i < 9; i++){
        m+= Line(gv, p[4], p[i]); //p[4] is the middle cell we are drawing lines from

        vec2 j = (p[i] - gv) * 20.0;
        float sparkle = 1.0 / dot(j,j); //Its 1.0 over the length(j) * length(j) to make the fall of quicker
        m+= sparkle * (sin(t + p[i].x *10.0 + p[i].y)*0.5 + 0.5);
    }

    //We need to draw a few more lines to prevent from gaps
    m+= Line(gv, p[1], p[3]);
    m+= Line(gv, p[1], p[5]);
    m+= Line(gv, p[5], p[7]);
    m+= Line(gv, p[3], p[7]);

    vec3 col = vec3(m);

    // if(gv.x > 0.46 || gv.y > 0.46) col = vec3(1.0, 0.0, 0.0); //grid for the debug

    gl_FragColor = vec4(col, 1.0);
}