//https://thebookofshaders.com/12/

uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359

vec2 random2(vec2 st){
    st = vec2( dot(st,vec2(127.1,311.7)),
            dot(st,vec2(269.5,183.3)) );
    return fract(sin(st)*43758.5453123);
}

void main()
{
    float onOff = 0.5*(sin(uTime) + 1.0);
    float m_dist = 1.0;

    vec2 st = vUv;

    st *= 3.0 ;

    vec2 i_st = floor(st);
    vec2 f_st = fract(st);

    for (int y= -1; y <= 1; y++) {
        for (int x= -1; x <= 1; x++) {
            // Neighbor place in the grid
            vec2 neighbor = vec2(float(x),float(y));
            vec2 point = random2(i_st + neighbor );

            vec2 diff = neighbor* onOff + point - f_st ;

            // Distance to the point
            float dist = length(diff );

            // Keep the closer distance
            m_dist = min(m_dist, dist);
        }
    }

    float color =  m_dist;

    gl_FragColor = vec4(vec3(color), 1.0);
}