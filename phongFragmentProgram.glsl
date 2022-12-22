varying vec3 camera_space_position;
varying vec3 camera_space_normal;

void main()
{    
    // Normalizes the interpolated caemra space normal
    // Since the normal gets interpolated, it may not be normalized anymore
    vec3 camera_space_normalized = normalize(camera_space_normal);

    // In camera space, the camera's position is centered at the origin
    // so the camera's direction is just the negative vertex position
    vec3 camera_direction = normalize(-1.0 * camera_space_position);

    // Defines color component sums for diffuse & specular light reflection
    vec3 diffuse_color_total = vec3(0.0, 0.0, 0.0);
    vec3 specular_color_total = vec3(0.0, 0.0, 0.0);

    for (int i = 0; i < gl_MaxLights; i++) {
        // Gets the position and direction of the light source
        vec3 light_position = gl_LightSource[i].position.xyz;
        vec3 light_direction = normalize( - camera_space_position);

        // Compute the attenutation factor
        float xDif = (camera_space_position[0] - light_position[0]);
        float yDif = (camera_space_position[1] - light_position[1]);
        float zDif = (camera_space_position[2] - light_position[2]);
        float distPointToLightSquared = xDif*xDif + yDif*yDif + zDif*zDif;
        float attenuation_factor = 1.0 / (1.0 + 
            gl_LightSource[i].quadraticAttenuation * distPointToLightSquared);

        // Computes the diffuse reflection component and adds it to the total
        float diffuse_factor = max(0.0, attenuation_factor * 
            dot(camera_space_normalized, light_direction));
        vec3 diffuse_component = diffuse_factor * gl_LightSource[i].diffuse.xyz;
        diffuse_color_total = diffuse_component + diffuse_color_total;

        // Computes the specular reflection component and adds it to the total
        vec3 combined_direction = normalize(camera_direction + light_direction);
        float specular_factor = pow( 
            max(0.0, dot(camera_space_normalized, combined_direction)), 
            gl_FrontMaterial.shininess);
        vec3 specular_component = attenuation_factor * specular_factor * 
            gl_LightSource[i].specular.xyz;
        specular_color_total = specular_component + specular_color_total;
    }
    
    // Combines ambient, diffuse, and specular reflection 
    // and fixes the rgb values btwn 0 and 1
    vec3 final_color = clamp(gl_FrontMaterial.ambient.xyz + 
                             gl_FrontMaterial.diffuse.xyz * diffuse_color_total + 
                             gl_FrontMaterial.specular.xyz * specular_color_total,
                             0.0, 1.0);
    
    // Sets the color of the pixel to our computed color
    gl_FragColor = vec4(final_color, 1.0);
}