varying vec2 vUv;
varying float vFresnel;

#define uFresnelOffset 0.4
#define uFresnelPower 0.5
#define uFresnelScale 2.0

void main()
{
    //Default settings
    vec4 modelPosition = modelMatrix * vec4(position, 1.0);
    vec4 viewPosition = viewMatrix * modelPosition;
    
    //Fresnel computation
    vec3 viewDirection = normalize(modelPosition.xyz - cameraPosition);
    vec3 worldNormal = normalize(mat3(modelMatrix[0].xyz, modelMatrix[1].xyz, modelMatrix[2].xyz) * normal);
    float fresnel = uFresnelOffset + uFresnelScale * (1.0 + dot(viewDirection, worldNormal));
    fresnel = pow(fresnel, uFresnelPower);

    gl_Position = projectionMatrix * viewPosition;

    vFresnel = fresnel;
    vUv = uv;
}