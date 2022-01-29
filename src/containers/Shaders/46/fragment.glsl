// Inspiration : https://www.youtube.com/watch?v=vlD_KOrzGDc
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

vec4 Eye(vec2 uv, float side, vec2 m, float smile){
    uv -= 0.5;
    float d = length(uv);
    uv.x *= side;

    vec4 irisCol = vec4(.3, .5,1.,1.);
    vec4 col = mix(vec4(1.), irisCol, S(.1 , .7, d) * 0.5);
    col.a = S(0.5, .48, d);

    col.rgb *= 1. - S(.45, .5, d) * 0.5 * sat(-uv.y - uv.x * side);
    d = length(uv - m * 0.2);
    col.rgb = mix(col.rgb, vec3(0.), S(.3, .28, d)); //iris outline


    irisCol.rgb *= 1. + S(.3, .05, d); 
    float irisMask = S(.28, .25, d);
    col.rgb = mix(col.rgb, irisCol.rgb, irisMask);
    d = length(uv - m * 0.25);
    float pupileSize = mix(.35, .15, smile);
    float pupilMask = S(pupileSize, pupileSize * 0.86, d);
    pupilMask *= irisMask;
    col.rgb = mix(col.rgb, vec3(0.), pupilMask);

    float t = uTime * 3.;
    vec2 offs = vec2(sin(t+uv.y*25.), sin(t+uv.x*25.));
    offs *= .01*(1.-smile);
    
    uv += offs;

    float highlight = S(.1 , .09, length(uv - vec2(-0.15, .15)));
    highlight += S(.07 , .05, length(uv + vec2(-0.08, .08)));
    col.rgb = mix( col.rgb, vec3(1.), highlight);

    
    return col;
}

vec4 Brow(vec2 uv, float smile) {
    float offs = mix(.15, 0., smile);
    uv.y += offs;
    float y = uv.y;
    uv.y += uv.x * mix(0.5 , .8 ,(1.-smile)) - mix(.1,.3, (1.-smile));
    uv.x -= mix(.1,0.1, (1.-smile));
    uv -= .5;
    vec4 col = vec4(0.);
    float blur = .1;

    float d1 = length(uv);
    float s1 = S(.45, .45 - blur, d1);
    float d2 = length(uv-vec2(.1, -.2) * .7);
    float s2 = S(.5, .5 - blur, d2);
    float browMask = sat(s1-s2);

    float colMask = remap01(.7, .8, y) * .75;
    colMask *= S(.6, .9, browMask);
    colMask *= smile;
    vec4 browCol = mix(vec4(.0, .0, .0, 1.), vec4(.4, .9, .0, 1.), colMask); 

    uv.y += .15 - offs * 0.75;
    blur += mix(.0, .1, smile);
    d1 = length(uv);
    s1 = S(.45, .45 - blur, d1);
    d2 = length(uv-vec2(.1, -.2) * .7);
    s2 = S(.5, .5 - blur, d2);

    float shadowMask = sat(s1-s2)
    col = mix(col, vec4(0.,0.,0.,1.), S(.0, .7, shadowMask)*0.6);
    
    col = mix(col, browCol, S(.2, .4, browMask));

    return col;
}

vec4 Mouth(vec2 uv, float smile){
    uv -= 0.5;
    vec4 col = vec4(.5, .18, .05, .1);

    uv.y *= 1.5;
    uv.y -= uv.x * uv.x * 2.0 * smile;
    uv.x *= mix(2.5 , 1.,smile);

  

    vec2 tUv = uv;
    float d = length(uv);
    col.a = S(.5, .48, d);

    vec3 toothCol = vec3(1.) * S(.6, .35 ,d);
    float td = length(tUv - vec2(0., 0.6));
    col.rgb = mix(col.rgb, toothCol, S(.4, .37,td));

    td = length(uv + vec2(0.,0.5));
    col.rgb = mix(col.rgb, vec3(1., .5, .5), S(.5, .2,td));

    return col;
}

vec4 Head(vec2 uv){
    vec4 col = vec4(0.219, 0.729, 0.09, .1);

    float d = length(uv);

    col.a = S(0.5, 0.49,d);

    //Shade before outline
    float edgeShade = remap01( .3, 0.5, d);
    edgeShade *= edgeShade;
    col.rgb *= 1.0 - edgeShade * 0.5;

    //Outline
    col.rgb = mix(col.rgb, vec3(0.2, 0.55, 0.11), S(.47, .48, d));

    float highlight = S(.41 , .405, d);
    highlight *= remap(.41, -.1, 0.75, 0., uv.y);
    highlight *= S(.18, .19, length(uv - vec2(.21, .08)));
    col.rgb = mix(col.rgb, vec3(1.), highlight);



    d = length( uv - vec2(.25,-0.2));
    float cheek = S(.2, .01, d) * 0.4;
    cheek *= S(.17, .16, d);
    col.rgb = mix(col.rgb, vec3(0.2, 0.55, 0.11), cheek);

    return col;
}

vec4 Smiley(vec2 uv){
    vec2 m;
    m.x = uMouse.x  / uCanvasRes.x;
    m.y = (uCanvasRes.y -  uMouse.y)  / uCanvasRes.y;
  

    //Disort uv 
    uv -= vec2(m - 0.5) * (0.25 - dot(uv, uv));

    //Move the center
    m.x -= 0.5;

    float smile = clamp(m.y, 0.0, 1.0);

    vec4 col = vec4(0.0);

    float side = sign(uv.x);
    uv.x = abs(uv.x);

    vec4 head = Head(uv);
    col = mix(col, head, head.a);

    vec4 eye= Eye(within(uv, vec4( .03, -.1, .37, .25)), side, m, smile);
    col = mix(col, eye, eye.a);

    vec4 mouth= Mouth(within(uv, vec4( -.3, -.4, .3, -.1)), smile);
    col = mix(col, mouth, mouth.a);

    vec4 brow= Brow(within(uv, vec4(.03, .2, .4, .45)), smile);
    col = mix(col, brow, brow.a);

    return col;
}

void main()
{
    vec2 uv = vUv;
    uv -= 0.5;
    
    gl_FragColor = Smiley(uv);
}