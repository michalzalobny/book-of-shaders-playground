uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359
#define S(a, b, t) smoothstep(a, b, t)

struct ray { vec3 o, d; };

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

float N(float t){
    return fract(sin(t * 3456.0) * 6547.0);
}

vec3 HeadLights (ray r, float t) {
    float w1 = 0.25;//Half the width of the car
    float w2 = w1 * 1.2;
    float m = 0.0; //mask
    float s = 1.0 / 30.0; //0.1

    for(float i = 0.0; i < 1.0; i +=s){
        float n = N(i); //will knock out random car from screen
        if( n > .05) continue; //continue will jump back at the beggining and skip the rest of the code in given loop
        float ti = fract(t + i);
        float z = 100.0 - ti * 100.0;
        float fade = ti * ti * ti * ti * ti; //ti* ti* ti... smooths the curve, it still goes from 0 to 1 but in smoother fashion
        float focus = S(0.9, 1.0, ti);
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

vec3 StreetLights (ray r, float t){
    float side = step(r.d.x, 0.0); //If x is positive the side is 1.0
    r.d.x = abs(r.d.x);  //Whenever the X ray value is negative make it positive
    float m = 0.0; //mask
    float s = 1.0 / 10.0; //0.1
    for(float i = 0.0; i < 1.0; i +=s){
        float ti = fract(t + i + side * s *  0.5);
        vec3 p = vec3(2.0 , 2.0, 100.0 - ti * 100.0);
        m += Bokeh(r, p, 0.05, 0.1) * ti * ti * ti; //ti* ti*ti smooths the curve, it still goes from 0 to 1 but in smoother fashion
    }

    return vec3(1.0, 0.7, 0.1) * m;
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
    
    vec3 camPos = vec3(0.0, 0.2, 0.0);
    vec3 lookat = vec3(0.0, 0.2, 1.0);

    ray r = GetRay(uv, camPos, lookat, 2.0);
    
    float t = uTime * 0.1;
    vec3 col = StreetLights(r, t);
    col += HeadLights(r, t);

    
    gl_FragColor = vec4(col, 1.0);
}