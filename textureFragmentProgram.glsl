uniform sampler2D colorTexture;
uniform sampler2D normalMap;

varying vec3 camera_space_pixel_pos;
varying mat3 tbn_matrix;

// Material shininess isn't given, so we treat set it to a constant
const float material_shininess = 0.2;

void main()
{    
    // Loads the material color from the color texture
    vec3 material_color = texture2D(colorTexture, gl_TexCoord[0].st).xyz;

    // Loads the normal from normal map texture RGB value
    vec3 normal = texture2D(normalMap, gl_TexCoord[0].st).rgb; // maybe 1 here or change the vertex shader to 0
    
    // Map normal components [0, 1] -> [-1, 1]
    normal = 2.0 * normal - 1.0;

    // Re-normalize normal vector
    normal = normalize(normal);

    // In camera space, the camera's position is centered at the origin
    // so the camera's direction is just the negative vertex position
    vec3 camera_direction = normalize(tbn_matrix * (- camera_space_pixel_pos));

    // TRY USING 0 FOR THE PIXEL_POS that would make line 30 light direction = remove camera_space_pixel_pos bc it equals 0

    // Gets the direction of the light source
    vec3 light_direction = normalize(tbn_matrix * (gl_LightSource[0].position - camera_space_pixel_pos));

    // No attenuation this time

    // Computes the diffuse reflection component
    float diffuse_factor = max(0.0, dot(normal, light_direction));
    vec3 diffuse_component = diffuse_factor * gl_LightSource[0].diffuse.xyz;

    // Computes the specular reflection component
    vec3 combined_direction = normalize(camera_direction + light_direction);
    float specular_factor = pow( 
        max(0.0, dot(normal, combined_direction)), material_shininess);
    vec3 specular_component = specular_factor * gl_LightSource[0].specular.xyz;
    
    // Combines ambient, diffuse, and specular reflection 
    // and fixes the rgb values btwn 0 and 1
    vec3 final_color = clamp(material_color + 
                             material_color * diffuse_component + 
                             material_color * specular_component,
                             0.0, 1.0);
    
    // Sets the color of the pixel to our computed color
    gl_FragColor = vec4(final_color, 1.0);
}


