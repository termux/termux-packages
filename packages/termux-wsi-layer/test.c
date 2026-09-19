/*
 * Copyright (c) 2012 Carsten Munk <carsten.munk@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#include <EGL/egl.h>
#include <GLES2/gl2.h>
#include <assert.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <X11/Xlib.h>

#include <unistd.h>

GLuint create_program(const char* pVertexSource, const char* pFragmentSource);

const char vertex_src [] =
"                                        \
attribute vec4        position;       \
varying mediump vec2  pos;            \
uniform vec4          offset;         \
\
void main()                           \
{                                     \
gl_Position = position + offset;   \
pos = position.xy;                 \
}                                     \
";

const char fragment_src [] =
"                                                      \
varying mediump vec2    pos;                        \
uniform mediump float   phase;                      \
\
void  main()                                        \
{                                                   \
gl_FragColor  =  vec4( 1., 0.9, 0.7, 1.0 ) *     \
cos( 30.*sqrt(pos.x*pos.x + 1.5*pos.y*pos.y)   \
+ atan(pos.y,pos.x) - phase );            \
}                                                   \
";

GLfloat norm_x    =  0.0f;
GLfloat norm_y    =  0.0f;
GLfloat offset_x  =  0.0f;
GLfloat offset_y  =  0.0f;
GLfloat p1_pos_x  =  0.0f;
GLfloat p1_pos_y  =  0.0f;

GLint phase_loc;
GLint offset_loc;
GLint position_loc;

const float vertexArray[] = {
    0.0f , 1.0f ,  0.0f,
    -1.0f, 0.0f ,  0.0f,
    0.0f , -1.0f,  0.0f,
    1.0f , 0.0f ,  0.0f,
    0.0f , 1.0f ,  0.0f
};

int main(int __unused argc, char __unused **argv) {
    EGLConfig ecfg;
    EGLint num_config;
    EGLint attr[] = {       // some attributes to set up our egl-interface
        EGL_BUFFER_SIZE, 32,
        EGL_RENDERABLE_TYPE,
        EGL_OPENGL_ES2_BIT,
        EGL_NONE
    };
    EGLint ctxattr[] = {
        EGL_CONTEXT_CLIENT_VERSION, 2,
        EGL_NONE
    };

    setenv("DISPLAY", ":0", 0);

    Display * dpy = XOpenDisplay(NULL);
    if (NULL == dpy) {
        dprintf(2, "Failed to initialize display");
        return EXIT_FAILURE;
    }

    Window root = DefaultRootWindow(dpy);
    if (None == root) {
        dprintf(2, "No root window found");
        XCloseDisplay(dpy);
        return EXIT_FAILURE;
    }

    const Window window = XCreateSimpleWindow(dpy, root, 0, 0, 480, 800, 0, 0, 0xffffffff);
    if (None == window) {
        fprintf(stderr, "Failed to create window");
        XCloseDisplay(dpy);
        return EXIT_FAILURE;
    }

    XMapWindow(dpy, window);

    EGLDisplay display = eglGetDisplay(dpy);
    assert(eglGetError() == EGL_SUCCESS);
    assert(display != EGL_NO_DISPLAY);

    EGLBoolean rv = eglInitialize(display, 0, 0);
    assert(eglGetError() == EGL_SUCCESS);
    assert(rv == EGL_TRUE);

    eglChooseConfig(display, attr, &ecfg, 1, &num_config);
    assert(eglGetError() == EGL_SUCCESS);
    assert(rv == EGL_TRUE);

    EGLSurface surface;
    if ((surface = eglCreateWindowSurface(display, ecfg, window, NULL)) == EGL_NO_SURFACE) {
        dprintf(2, "eglCreateWindowSurface failed, error 0x%X\n", eglGetError());
        abort();
    }

    EGLContext context = eglCreateContext(display, ecfg, EGL_NO_CONTEXT, ctxattr);
    assert(eglGetError() == EGL_SUCCESS);
    assert(context != EGL_NO_CONTEXT);

    if (eglMakeCurrent(display, surface, surface, context) != EGL_TRUE) {
        dprintf(2, "eglMakeCurrent failed, error 0x%X\n", eglGetError());
        abort();
    }

    const char *version = (const char *)glGetString(GL_VERSION);
    assert(version);
    printf("%s\n",version);

    GLuint shaderProgram = create_program(vertex_src, fragment_src);
    glUseProgram  ( shaderProgram );    // and select it for usage

    //// now get the locations (kind of handle) of the shaders variables
    position_loc  = glGetAttribLocation  ( shaderProgram , "position" );
    phase_loc     = glGetUniformLocation ( shaderProgram , "phase"    );
    offset_loc    = glGetUniformLocation ( shaderProgram , "offset"   );
    if ( position_loc < 0  ||  phase_loc < 0  ||  offset_loc < 0 ) {
        return EXIT_FAILURE;
    }

    //glViewport ( 0 , 0 , 800, 600); // commented out so it uses the initial window dimensions
    glClearColor ( 1.f, 1.f, 1.f, 1.f);    // background color
    float phase = 0;
    int frames = -1;
    if (argc == 2) {
        frames = (int) strtol(argv[1], NULL, 10);
    }
    if(frames < 0) {
        frames = 30 * 60;
    }

    for (int i = 0; i < frames; ++i) {
        if(i % 60 == 0) printf("frame:%i\n", i);
        glClear(GL_COLOR_BUFFER_BIT);
        glUniform1f ( phase_loc, phase );  // write the value of phase to the shaders phase
        phase  =  fmodf ( phase + 0.5f, 2.f * 3.141f );    // and update the local variable

        glUniform4f ( offset_loc,  offset_x, offset_y, 0.0f, 0.0f );

        glVertexAttribPointer ( position_loc, 3, GL_FLOAT, GL_FALSE, 0, vertexArray );
        glEnableVertexAttribArray ( position_loc );
        glDrawArrays ( GL_TRIANGLE_STRIP, 0, 5 );

        eglSwapBuffers (display, surface );  // get the rendered buffer to the screen
        assert(eglGetError() == EGL_SUCCESS);
    }

    printf("stop\n");

    return EXIT_SUCCESS;
}

GLuint load_shader(const GLenum shaderType, const char* pSource)
{
    GLuint shader = glCreateShader(shaderType);

    if (shader) {
        glShaderSource(shader, 1, &pSource, NULL);
        glCompileShader(shader);
        GLint compiled = 0;
        glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);

        if (!compiled) {
            GLint infoLen = 0;
            glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
            if (infoLen) {
                char* buf = (char*) malloc(infoLen);
                if (buf) {
                    glGetShaderInfoLog(shader, infoLen, NULL, buf);
                    fprintf(stderr, "Could not compile shader %d:\n%s\n",
                            shaderType, buf);
                    free(buf);
                }
                glDeleteShader(shader);
                shader = 0;
            }
        }
    } else {
        printf("Error, during shader creation: %i\n", glGetError());
    }

    return shader;
}

GLuint create_program(const char* pVertexSource, const char* pFragmentSource)
{
    GLuint vertexShader = load_shader(GL_VERTEX_SHADER, pVertexSource);
    if (!vertexShader) {
        printf("vertex shader not compiled\n");
        return 0;
    }

    GLuint pixelShader = load_shader(GL_FRAGMENT_SHADER, pFragmentSource);
    if (!pixelShader) {
        printf("frag shader not compiled\n");
        return 0;
    }

    GLuint program = glCreateProgram();
    if (program) {
        glAttachShader(program, vertexShader);
        glAttachShader(program, pixelShader);
        glLinkProgram(program);
        GLint linkStatus = GL_FALSE;

        glGetProgramiv(program, GL_LINK_STATUS, &linkStatus);
        if (linkStatus != GL_TRUE) {
            GLint bufLength = 0;
            glGetProgramiv(program, GL_INFO_LOG_LENGTH, &bufLength);
            if (bufLength) {
                char* buf = (char*) malloc(bufLength);
                if (buf) {
                    glGetProgramInfoLog(program, bufLength, NULL, buf);
                    fprintf(stderr, "Could not link program:\n%s\n", buf);
                    free(buf);
                }
            }
            glDeleteProgram(program);
            program = 0;
        }
    }

    return program;
}
