uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359

vec3 cRed = vec3(169. / 255., 33. / 255., 33. / 255.);
vec3 cYellow = vec3(252. / 255., 195. / 255., 40. / 255.);
vec3 cBlue = vec3(2. / 255., 96. / 255., 157. / 255.);
vec3 cBackground = vec3(247. / 255., 240. / 255., 222. / 255.);
vec3 cBlack = vec3(0., 0., 0.);

float square(vec2 st, float width, float offsetX, float offsetY){
    st.x -=0.5 - offsetX;
    st.y -=0.5 - offsetY;
    float lineX = abs(st.x * 2.);
    float lineY = abs(st.y * 2.);
    float smoothSquare = max(lineX,lineY);
    return (1.0 - step(width , smoothSquare));
}


float squareStroke(vec2 st, float width , float offsetX, float offsetY, float stroke){
    st.x -=0.5 - offsetX;
    st.y -=0.5 - offsetY;

    float strength = step(width / 2. -  stroke, max(abs(st.x), abs(st.y)));
    return strength *= 1.0 - step(width / 2., max(abs(st.x), abs(st.y)));
}

void main()
{
    vec2 st = vUv;

    float redSquare = square(st, 0.4, 0.45, -0.31);
    float yellowSquare = square(st, 0.4, -0.52, -0.31);
    float blueSquare = square(st, 0.5, -0.3, 0.62);

    float squareStroke1 = squareStroke(st, 0.4, 0.43, -0.3, 0.025);
    float squareStroke2 = squareStroke(st, 0.4, -0.5, -0.305, 0.025);
    float squareStroke3 = squareStroke(st, 0.6, -0.35, 0.65, 0.025);
    float squareStroke4 = squareStroke(st, 1.1, 0., -0.65, 0.025);
    float squareStroke5 = squareStroke(st, 1.1, 0., -0.85, 0.025);
    float squareStroke6 = squareStroke(st, 1.1, -0.295, -0., 0.025);

    vec3 strokes = vec3(squareStroke2 + squareStroke1 + squareStroke3 + squareStroke4 + squareStroke5 + squareStroke6);

    float squares = redSquare + yellowSquare + blueSquare;
    vec3 background = (1. - squares) * cBackground;

    vec3 color = vec3(redSquare * cRed + yellowSquare * cYellow + blueSquare * cBlue) + background - strokes;

    gl_FragColor = vec4(color, 1.0);
}