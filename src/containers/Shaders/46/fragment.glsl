uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying float vFresnel;
varying vec2 vUv;

#define PI 3.14159265359
#define S(a,b,t) smoothstep(a,b,t) //Macro : Every time we type in S with 3 parameters the shader will switch it to smoothstep(a,b,c)
#define sat(x) clamp(x, 0., 1.);

float remap01 (float a, float b, float t){ //if t = a returns 0, if t = b returns 1, if t is half way then return 0.5 etc.
    return sat((t-a) / (b-a));
}

float remap(float a, float b, float c, float d, float t){ // if t = a returns c, if t = b returns d, if t half way through a and b returns half way between c and d etc.
    return sat(remap01(a, b, t) * (d-c) + c);
}

vec2 within (vec2 uv, vec4 rect){
    return (uv-rect.xy) / (rect.zw - rect.xy);
}

vec4 Eye(vec2 uv){
    uv -= 0.5;
    float d = length(uv);

    vec4 irisCol = vec4(.3, .5,1.,1.);
    vec4 col = mix(vec4(1.), irisCol, S(.1 , .7, d) * 0.5);


    col.rgb *= 1. - S(.45, .5, d) * 0.5 * sat(-uv.y - uv.x);
    col.rgb = mix(col.rgb, vec3(0.), S(.3, .28, d)); //iris outline
    irisCol.rgb *= 1. + S(.3, .05, d); 
    col.rgb = mix(col.rgb, irisCol.rgb, S(.28, .25, d));
    col.rgb = mix(col.rgb, vec3(0.), S(.15, .14, d));

    float highlight = S(.1 , .09, length(uv - vec2(-0.15, .15)));
    highlight += S(.07 , .05, length(uv + vec2(-0.08, .08)));
    col.rgb = mix( col.rgb, vec3(1.), highlight);

    col.a = S(0.5, .48, d);
    return col;
}

vec4 Mouth(vec2 uv){
    uv -= 0.5;
    vec4 col = vec4(.5, .18, .05, .1);

    uv.y *= 1.5;
    uv.y -= uv.x * uv.x * 2.0;
    
    float d = length(uv);

    col.a = S(.5, .48, d);

    vec3 toothCol = vec3(1.) * S(.6, .35 ,d);
    float td = length(uv - vec2(0., 0.6));
    col.rgb = mix(col.rgb, toothCol, S(.4, .37,td));

    td = length(uv + vec2(0.,0.5));
    col.rgb = mix(col.rgb, vec3(1., .5, .5), S(.5, .2,td));

    return col;
}

vec4 Head(vec2 uv){
    vec4 col = vec4(0.9, 0.65, 0.1, 1.0);

    float d = length(uv);

    col.a = S(0.5, 0.49,d);

    //Shade before outline
    float edgeShade = remap01( .3, 0.5, d);
    edgeShade *= edgeShade;
    col.rgb *= 1.0 - edgeShade * 0.5;

    //Outline
    col.rgb = mix(col.rgb, vec3(0.6, 0.3, 0.1), S(.47, .48, d));

    float highlight = S(.41 , .405, d);
    highlight *= remap(.41, -.1, 0.75, 0., uv.y);
    col.rgb = mix(col.rgb, vec3(1.), highlight);

    

    d = length( uv - vec2(.25,-0.2));
    float cheek = S(.2, .01, d) * 0.4;
    cheek *= S(.17, .16, d);
    col.rgb = mix(col.rgb, vec3(1., .1, .1), cheek);

    return col;
}

vec4 Smiley(vec2 uv){
    vec4 col = vec4(0.0);
    uv.x = abs(uv.x);

    vec4 head = Head(uv);
    col = mix(col, head, head.a);

    vec4 eye= Eye(within(uv, vec4( .03, -.1, .37, .25)));
    col = mix(col, eye, eye.a);

    vec4 mouth= Mouth(within(uv, vec4( -.3, -.4, .3, -.1)));
    col = mix(col, mouth, mouth.a);

    return col;
}

void main()
{
    vec2 uv = vUv;
    uv -= 0.5;
    
    gl_FragColor = Smiley(uv);
}