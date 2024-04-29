#ifdef GL_ES
precision mediump float;
#endif

varying vec2 vTexCoord;
uniform sampler2D tex;
uniform vec2 normalRes;
uniform float millis;
uniform float beta;
uniform float h;
uniform float rate;

float random1 (vec2 st) {
    return fract(sin(millis + dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

float random2 (vec2 st) {
    return fract(sin(millis + millis + dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void main() {
  vec2 uv = vTexCoord;
  
  uv.y = 1.0 - uv.y;
  
  vec4 col = texture2D(tex, uv);
  float a = col.r;
  
  if (random1(uv) < rate) {
    float neighborsum = 0.0;
    neighborsum += texture2D(tex, vec2(uv.x + normalRes.x, uv.y + normalRes.y)).r;
    neighborsum += texture2D(tex, vec2(uv.x + normalRes.x, uv.y - normalRes.y)).r;
    neighborsum += texture2D(tex, vec2(uv.x - normalRes.x, uv.y + normalRes.y)).r;
    neighborsum += texture2D(tex, vec2(uv.x - normalRes.x, uv.y - normalRes.y)).r;
    neighborsum = 2. * neighborsum - 4.;
    
    float posWeight = exp(beta * neighborsum + h);
    float negWeight = exp(-beta * neighborsum - h);

    if (random2(uv) < posWeight / (posWeight + negWeight)) {
      a = 1.;
    } else {
      a = 0.;
    }
  }
  
  gl_FragColor = vec4(a, 0., 1.-a, 1.0);
}