//https://en.wikipedia.org/wiki/Truchet_tiles
//Truchet tiles

uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359


vec2 rotate2D(vec2 _st, float _angle){
    _st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle)) * _st;
    _st += 0.5;
    return _st;
}

vec2 zoom(vec2 st, float zoom){
    st *= zoom;
    return fract(st);
}

float box(vec2 st, vec2 center, float width, float smoothEdges){
    vec2 stCenter = st - center;
    //Converts 1 width to a width of the whole st
    width *= 0.5;
    float xEdges = smoothstep(-width, -(width-smoothEdges) ,stCenter.x) - smoothstep(width-smoothEdges, width ,stCenter.x);
    float yEdges = smoothstep(-width, -(width-smoothEdges) ,stCenter.y) - smoothstep(width-smoothEdges, width ,stCenter.y);
    return xEdges * yEdges;
}

vec2 rotateTilePattern(vec2 _st){

    //  Scale the coordinate system by 2x2
    _st *= 2.0;

    //  Give each cell an index number
    //  according to its position
    float index = 0.0;
    index += step(1., mod(_st.x,2.0));
    index += step(1., mod(_st.y,2.0))*2.0;

    //      |
    //  2   |   3
    //      |
    //--------------
    //      |
    //  0   |   1
    //      |

    // Make each cell between 0.0 - 1.0
    _st = fract(_st);

    // Rotate each cell according to the index
    if(index == 1.0){
        //  Rotate cell 1 by 90 degrees
        _st = rotate2D(_st,PI*0.5);
    } else if(index == 2.0){
        //  Rotate cell 2 by -90 degrees
        _st = rotate2D(_st,PI*-0.5);
    } else if(index == 3.0){
        //  Rotate cell 3 by 180 degrees
        _st = rotate2D(_st,PI);
    }

    return _st;
}

void main()
{
    vec2 st = vUv;
    st = rotate2D(st,PI*uTime*-0.15);
    st = zoom(st, 4.0);

    st = rotate2D(st,PI*uTime*0.15);
    st = rotateTilePattern(st);

    gl_FragColor = vec4(vec3(step(st.x,st.y)),1.0);
}