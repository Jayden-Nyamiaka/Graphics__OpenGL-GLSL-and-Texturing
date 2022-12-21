varying vec3 camera_space_position;
varying vec3 camera_space_normal;

void main()
{    
    // In camera space, the camera's position is centered at the origin
    // so the camera's direction is just the negative vertex position
    vec3 camera_direction = normalize(-1.0 * camera_space_position);

    // Defines Color Component Sums for Diffuse & Specular Light Reflection
    vec3 diffuse_color_total = vec3(0.0, 0.0, 0.0);
    vec3 specular_color_total = vec3(0.0, 0.0, 0.0);

    for (int i = 0; i < gl_MaxLights; i++) {
        // Get the position and direction of the light source in camera space
        vec3 light_position = (gl_ModelViewMatrix * gl_LightSource[i].position).xyz;
        vec3 light_direction = normalize(light_position - camera_space_position);

        // Compute the Attenutation Factor
        float xDif = (camera_space_position[0] - light_position[0]);
        float yDif = (camera_space_position[1] - light_position[1]);
        float zDif = (camera_space_position[2] - light_position[2]);
        float distPointToLightSquared = xDif*xDif + yDif*yDif + zDif*zDif;
        float attenuation_factor = 1.0 / (1.0 + gl_LightSource[i].constantAttenuation +
            gl_LightSource[i].linearAttenuation * sqrt(distPointToLightSquared) + 
            gl_LightSource[i].quadraticAttenuation * distPointToLightSquared);

        // Computes Diffuse Reflection Component and Adds it to Total
        float diffuse_factor = max(0.0, attenuation_factor * 
            dot(camera_space_normal, light_direction));
        vec3 diffuse_component = diffuse_factor * gl_LightSource[i].diffuse.xyz;
        diffuse_color_total = diffuse_component + diffuse_color_total;

        // Computes Specular Reflection Component and Adds it to Total
        vec3 combined_direction = normalize(camera_direction + light_direction);
        float specular_factor = pow( 
            max(0.0, dot(camera_space_normal, combined_direction)), 
            gl_FrontMaterial.shininess);
        vec3 specular_component = attenuation_factor * specular_factor * 
            gl_LightSource[i].specular.xyz;
        specular_color_total = specular_component + specular_color_total;
    }
    
    // Calculates each color combining ambient, diffuse, and specular reflection
    float final_red = min(1.0, gl_FrontMaterial.ambient[0] + 
                               gl_FrontMaterial.diffuse[0] * diffuse_color_total[0] + 
                               gl_FrontMaterial.specular[0] * specular_color_total[0]);
    float final_green = min(1.0, gl_FrontMaterial.ambient[1] + 
                                 gl_FrontMaterial.diffuse[1] * diffuse_color_total[1] + 
                                 gl_FrontMaterial.specular[1] * specular_color_total[1]);
    float final_blue = min(1.0, gl_FrontMaterial.ambient[2] + 
                                gl_FrontMaterial.diffuse[2] * diffuse_color_total[2] + 
                                gl_FrontMaterial.specular[2] * specular_color_total[2]);
    
    // Sets the color of the pixel to our computed component colors
    gl_FragColor = vec4(final_red, final_green, final_blue, 1.0);
}