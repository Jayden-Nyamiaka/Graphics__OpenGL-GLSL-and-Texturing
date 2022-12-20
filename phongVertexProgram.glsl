varying vec3 camera_space_position;
varying vec3 camera_space_normal;

void main()
{
    camera_space_position = gl_ModelViewMatrix * gl_Vertex;
    camera_space_normal = gl_NormalMatrix * gl_Normal;
    gl_Position = ftransform();
}
