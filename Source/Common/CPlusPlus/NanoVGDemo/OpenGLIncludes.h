#ifndef OpenGLIncludes_H
#define OpenGLIncludes_H

#if OS_IOS
  #if defined(NANOVG_GLES3_IMPLEMENTATION)
    #include <OpenGLES/ES3/gl.h>
    #include <OpenGLES/ES3/glext.h>
  #else
    #include <OpenGLES/ES2/gl.h>
  #endif
#elif OS_MACOSX
  #if defined(NANOVG_GL3_IMPLEMENTATION)
    #include <OpenGL/gl3.h>
  #else
    #include <OpenGL/gl.h>
  #endif
#endif

#endif