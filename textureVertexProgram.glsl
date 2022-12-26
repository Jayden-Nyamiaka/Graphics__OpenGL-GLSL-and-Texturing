varying vec3 camera_space_pixel_pos;
varying vec3 surface_space_light_pos;

void main()
{
    // 0 is the color texture, 1 is the normal map
    gl_TexCoord[0] = gl_MultiTexCoord0;
    gl_TexCoord[1] = gl_MultiTexCoord1;

    // Saves the vertex's camera space position to be 
    // interpolated per pixel in the fragment shader
    camera_space_pixel_pos = (gl_ModelViewMatrix * gl_Vertex).xyz; //maybe use gl_Position

    // Assumes the world space tangent along the (+u) direction
    vec3 world_space_tangent = vec3(1.0, 0.0, 0.0);

    // TBN matrix converts from camera space to surface space (vecs in camera space)
    // First transforms the normal and tangent vecs from world space to camera space
    vec3 normal = normalize( gl_NormalMatrix * gl_Normal );
    vec3 tangent = normalize( gl_NormalMatrix * world_space_tangent ); // maybe no mutliplixation by normalMatrix
    vec3 bitangent = normalize( cross(normal, tangent) );
    mat3 tbn_matrix = mat3(tangent, bitangent, normal);

    surface_space_light_pos = tbn_matrix /*maybe * gl_ViewMatrix*/ * gl_LightSource[0].position.xyz;

    gl_Position = ftransform();
}
