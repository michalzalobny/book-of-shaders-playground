// Based on the art of code "The drive Home" video : https://www.youtube.com/watch?v=ewu5XrPRgxI

uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359
#define S(a, b, t) smoothstep(a, b, t)

struct ray { vec3 o, d; };

float N(float t){
    return fract(sin(t * 3456.0) * 6547.0);
}

vec4 N14(float t){ //Its name 14 becuase it takes 1 value and outputs 4
    return fract(sin(t * vec4(123.0, 1024.0, 3456.0, 9564.0)) * vec4(6547.0, 345.0, 8799.0, 1564.0));
}

ray GetRay( vec2 uv, vec3 camPos, vec3 lookat, float zoom) {
    ray a;
    a.o = camPos;
    vec3 f = normalize(lookat - a.o);
    vec3 r = normalize(cross(vec3(0.0, 1.0, 0.0), f));
    vec3 u = cross(f, r);
    vec3 c = a.o + f * zoom;
    vec3 i = c + uv.x * r + uv.y * u;
    a.d = normalize(i - a.o);

    return a;
}

vec3 ClosestPoint(ray r, vec3 p){
    return r.o + max(0.0, dot( p - r.o, r.d)) * r.d; //dot( p - r.o, r.d) projects rop vector toward direction vector in order to calculate the closest point
}

float DistRay(ray r, vec3 p){
    return length( p - ClosestPoint(r,p)); //We first find the closest point on the ray to the given point p and then get the length of distance between them
}

float Bokeh (ray r, vec3 p, float size, float blur){
    float d = DistRay(r, p);

    //Perceived size doesnt get smaller if the object is receds
    size*= length(p);

    float c = S(size, size * (1.0 - blur), d);

    c *= mix(0.6, 1.0, S(size * 0.8, size, d));

    return c;
}



vec3 TailLights (ray r, float t) {
    float w1 = 0.25;//Half the width of the car
    float w2 = w1 * 1.2;
    float m = 0.0; //mask
    t *= 0.25;    

    //it will loop 16 times
    for(float i = 0.0; i < 1.0; i +=0.0625){
        float n = N(i); //value from 0 to 1
        if( n > 0.5) continue; //continue will jump back at the beggining and skip the rest of the code in given loop

        //n goes from 0 to 0.5 here because of knock out
        float lane = step(0.25, n); //0 for left lane and 1.0 for right lane
        float ti = fract(t + i);
        float z = 100.0 - ti * 100.0;
        float fade = ti * ti * ti * ti * ti; //ti* ti* ti... smooths the curve, it still goes from 0 to 1 but in smoother fashion
        float focus = S(0.9, 1.0, ti);
        float size = mix(0.05, 0.03, focus);

        float laneShift = S(1.0, 0.96, ti);
        float x = 1.5 - lane * laneShift;

        float blink = step(0.0, sin(t*1000.0)) * 7.0 * lane * step(0.96, ti); // *lane so the cars on the right lane won't have the blinkers

        //Create two headlights (using 2 Bokeh for each for extra rectangular shape of headlight effect)
        m += Bokeh(r, vec3(x - w1 , 0.15, z), size, 0.1) * fade; 
        m += Bokeh(r, vec3(x + w1 , 0.15, z), size, 0.1) * fade; 

        m += Bokeh(r, vec3(x - w2 , 0.15, z), size, 0.1) * fade; 
        m += Bokeh(r, vec3(x + w2 , 0.15, z), size, 0.1) * fade * (1.0 + blink);

        //Add road reflections
        float ref = 0.0;
        ref += Bokeh(r, vec3(x - w2 , -0.15, z), size * 2.0, 1.0) * fade; 
        ref += Bokeh(r, vec3(x + w2 , -0.15, z), size * 2.0, 1.0) * fade * (1.0 + blink * 0.1);
        m += ref * focus; //only show reflection when in focus
    }

    return vec3(1.0, 0.1, 0.03) * m;
}

vec3 HeadLights (ray r, float t) {
    float w1 = 0.25;//Half the width of the car
    float w2 = w1 * 1.2;
    float m = 0.0; //mask
    t *= 2.0;

    //it will loop 32 times
    for(float i = 0.0; i < 1.0; i +=0.03125){
        float n = N(i); //will knock out random car from screen
        if( n > 0.1) continue; //continue will jump back at the beggining and skip the rest of the code in given loop
        float ti = fract(t + i);
        float z = 100.0 - ti * 100.0;
        float fade = ti * ti * ti * ti * ti; //ti* ti* ti... smooths the curve, it still goes from 0 to 1 but in smoother fashion
        float focus = S(0.8, 1.0, ti);
        float size = mix(0.05, 0.03, focus);

        //Create two headlights (using 2 Bokeh for each for extra rectangular shape of headlight effect)
        m += Bokeh(r, vec3(-1.0 - w1 , 0.15, z), size, 0.1) * fade; 
        m += Bokeh(r, vec3(-1.0 + w1 , 0.15, z), size, 0.1) * fade; 

        m += Bokeh(r, vec3(-1.0 - w2 , 0.15, z), size, 0.1) * fade; 
        m += Bokeh(r, vec3(-1.0 + w2 , 0.15, z), size, 0.1) * fade;

        //Add road reflections
        float ref = 0.0;
        ref += Bokeh(r, vec3(-1.0 - w2 , -0.15, z), size * 2.0, 1.0) * fade; 
        ref += Bokeh(r, vec3(-1.0 + w2 , -0.15, z), size * 2.0, 1.0) * fade;
        m += ref * focus; //only show reflection when in focus
    }

    return vec3(0.9, 0.9, 1.0) * m;
}

vec3 EnvLights (ray r, float t){
    float side = step(r.d.x, 0.0); //If x is positive the side is 1.0
    r.d.x = abs(r.d.x);  //Whenever the X ray value is negative make it positive
    vec3 c = vec3(0.0);
    for(float i = 0.0; i < 1.0; i +=0.1){
        float ti = fract(t + i + side * 0.1 *  0.5);

        vec4 n = N14(i + side * 100.0);
        float fade = ti * ti * ti;
        float occlusion = sin(ti * 2.0 * PI * 10.0 * i) * 0.5 + 0.5;
        fade = occlusion;
        float x = mix(2.5, 10.0, n.x);
        float y = mix(0.1, 1.5, n.y);

        vec3 p = vec3(x , y, 50.0 - ti * 50.0);
        vec3 col = n.wzy;
        c += Bokeh(r, p, 0.05, 0.1) * fade * col * 0.6; 
    }

    return c;
}

vec3 StreetLights (ray r, float t){
    float side = step(r.d.x, 0.0); //If x is positive the side is 1.0
    r.d.x = abs(r.d.x);  //Whenever the X ray value is negative make it positive
    float m = 0.0; //mask
    //it will loop 10 times
    for(float i = 0.0; i < 1.0; i +=0.1){
        float ti = fract(t + i + side * 0.1 *  0.5);
        vec3 p = vec3(2.0 , 2.0, 100.0 - ti * 100.0);
        m += Bokeh(r, p, 0.05, 0.1) * ti * ti * ti; //ti* ti*ti smooths the curve, it still goes from 0 to 1 but in smoother fashion
    }

    return vec3(1.0, 0.7, 0.1) * m;
}

vec2 Rain(vec2 uv, float t){
    t *= 40.0;
    vec2 a = vec2(3.0, 1.0);//aspect ratio
    vec2 st = uv * a;
    vec2 id = floor(st);
    st.y += t * 0.22;
    float n = fract(sin(id.x * 716.34) * 768.32);
    st.y += n; //offsets by random number in the given field 
    uv.y +=n;
    id = floor(st); //recalculate id because of shifting
    st = fract(st) - 0.5;
    t += fract(sin(id.x * 76.34 + id.y * 1453.7) * 768.32) * 2.0 * PI; 

    float y = -sin(t + sin(t + sin(t) * 0.5)) * 0.43;
    vec2 p1 = vec2(0.0, y);

    vec2 o1 = (st - p1)/a;
    float d = length(o1);
    float m1 = S(0.07, 0.0, d);

    vec2 o2 = (fract(uv * a.x * vec2(1.0, 2.0)) - 0.5) /  vec2(1.0, 2.0);
    d = length(o2);

    float m2 = S(0.3 * (0.5 - st.y), 0.0, d) * S( -.1, .1, st.y - p1.y);

    // if(st.x> .48 || st.y > .49) m1 = 1.0;
    


    return vec2(m1 * o1 * 30.0 + m2 * o2 * 10.0);
}

void main()
{
    vec2 uv = vUv;
    uv -= 0.5;

    //mouse
    vec2 m;
    m.x = uMouse.x  / uCanvasRes.x;
    m.y = (uCanvasRes.y -  uMouse.y)  / uCanvasRes.y;
    //Move the center
    m.x -= 0.5;
    
    vec3 camPos = vec3(0.5, 0.2, 0.0);
    vec3 lookat = vec3(0.5, 0.2, 1.0);

    float t = uTime * 0.05;

    vec2 rainDistort = Rain(uv * 5.0, t) * 0.5;
    rainDistort += Rain(uv * 7.0, t) * 0.5;


    //Distort the view a little
    uv.x += sin(uv.y * 70.0) * 0.005;
    uv.y += sin(uv.x * 170.0) * 0.002;

    ray r = GetRay(uv - rainDistort * 0.4, camPos, lookat, 2.0);
    
    vec3 col = StreetLights(r, t);
    col += HeadLights(r, t);
    col += TailLights(r, t);
    col += EnvLights(r, t);
    col += (r.d.y + 0.25) * vec3(0.2, 0.1, 0.5); //Add sky

    gl_FragColor = vec4(col, 1.0);
}