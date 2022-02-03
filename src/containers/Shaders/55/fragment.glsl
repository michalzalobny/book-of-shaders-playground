//Voronoi effect based on art of code video : https://www.youtube.com/watch?v=l-07BXzNdPw

uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359

vec2 N22 (vec2 p){
    vec3 a = fract(p.xyx * vec3(123.34, 234.34, 345.65));
    a+= dot(a,a+34.45);
    return fract(vec2(a.x*a.y, a.y*a.z));
}

void main()
{
    vec2 uv = vUv;
    uv -= 0.5;
    uv *= 2.0;

    float m = 0.0;
    float t = uTime * 0.5;

    float minDist = 100.0;
    float cellIndex = 0.0;

    vec3 col = vec3(cellIndex/50.0);
    
    //Naive approach
    if(false){
    for(float i =0.0; i<50.0; i++){
            vec2 n = N22(vec2(i));
            vec2 p = sin(n*t);

            float d = length(uv - p);
            m += smoothstep(0.02, 0.01, d);

            if(d < minDist){
                minDist = d;
                cellIndex = i;
            }
        }
    //quicker approach
    }else{
        uv*= 3.0;
        vec2 gv = fract(uv) - 0.5;//grid uv
        vec2 id = floor(uv);
        vec2 cid = vec2(0.0);//cell id

        for(float y = -1.0; y <= 1.0; y++){
            for(float x = -1.0; x <= 1.0; x++){
                vec2 offs = vec2(x,y);
                vec2 n = N22(id + offs);
                vec2 p = offs + sin(n*t) * 0.5;
                p-=gv;
                float ed = length(p); //euclidian distance
                float md = abs(p.x) + abs(p.y); //Manhattan distance
                float d = mix(ed, md, sin(uTime * 3.0)*0.5 + 0.5);
    
                if(d < minDist){
                    minDist = d;
                    cid = id + offs;
                }
            }
        }
        col = vec3(minDist);
    }

    gl_FragColor = vec4(col, 1.0);
}