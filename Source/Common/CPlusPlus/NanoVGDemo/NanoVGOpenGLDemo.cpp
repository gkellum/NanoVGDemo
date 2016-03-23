#include "NanoVGOpenGLDemo.h"

#include "OpenGLIncludes.h"
#include "nanovg.h"
#include "nanovg_gl.h"
#include "demo.h"
#include "perf.h"
#include <chrono>

class NanoVGOpenGLDemo::Impl
{
public:
    Impl()
      : windowWidth(0)
      , windowHeight(0)
      , contentScaleFactor(1)
      , mouseX(0)
      , mouseY(0)
      , startTimeOfProcess( std::chrono::system_clock::now() )
      , timeOfLastRender(0)
    {
    }

    void newOpenGLContextCreated(int windowWidth, int windowHeight)
    {
        this->windowWidth = windowWidth;
        this->windowHeight = windowHeight;

        initGraph(&framesPerSecondGraph, GRAPH_RENDER_FPS, "Frame Time");

        vg = createNVGcontext();

        if (vg == NULL) {
            printf("Could not init nanovg.\n");
            return;
        }

        if (loadDemoData(vg, &data) == -1)
            return;
    }

    NVGcontext* createNVGcontext()
    {
        #if defined(NANOVG_GLES3_IMPLEMENTATION)
        {
            return nvgCreateGLES3(NVG_ANTIALIAS | NVG_STENCIL_STROKES | NVG_DEBUG);
        }
        #elif defined(NANOVG_GLES2_IMPLEMENTATION)
        {
            return nvgCreateGLES2(NVG_ANTIALIAS | NVG_STENCIL_STROKES | NVG_DEBUG);
        }
        #elif defined(NANOVG_GL3_IMPLEMENTATION)
        {
            #if defined(DEMO_MSAA)
            {
                return nvgCreateGL3(NVG_STENCIL_STROKES | NVG_DEBUG);
            }
            #else
            {
                return nvgCreateGL3(NVG_ANTIALIAS | NVG_STENCIL_STROKES | NVG_DEBUG);
            }
            #endif
        }
        #elif defined(NANOVG_GL2_IMPLEMENTATION)
        {
            #if defined(DEMO_MSAA)
            {
                return nvgCreateGL2(NVG_STENCIL_STROKES | NVG_DEBUG);
            }
            #else
            {
                return nvgCreateGL2(NVG_ANTIALIAS | NVG_STENCIL_STROKES | NVG_DEBUG);
            }
            #endif
        }
        #else
        {
            return nvgCreateGL3(NVG_STENCIL_STROKES | NVG_DEBUG);
        }
        #endif
    }

    void deleteNVGcontext()
    {
        #if defined(NANOVG_GLES3_IMPLEMENTATION)
        {
            nvgDeleteGLES3(vg);
        }
        #elif defined(NANOVG_GLES2_IMPLEMENTATION)
        {
            nvgDeleteGLES2(vg);
        }
        #elif defined(NANOVG_GL3_IMPLEMENTATION)
        {
            nvgDeleteGL3(vg);
        }
        #elif defined(NANOVG_GL2_IMPLEMENTATION)
        {
            nvgDeleteGL2(vg);
        }
        #else
        {
            nvgDeleteGL3(vg);
        }
        #endif
    }

    void setWindowSize(int windowWidth, int windowHeight)
    {
        this->windowWidth = windowWidth;
        this->windowHeight = windowHeight;
    }

    void setContentScaleFactor(float contentScaleFactor)
    {
        this->contentScaleFactor = contentScaleFactor;
    }

    void openGLContextClosing()
    {
        freeDemoData(vg, &data);

        deleteNVGcontext();
    }

    void touchDown(float mouseX,
                   float mouseY)
    {
        this->mouseX = mouseX;
        this->mouseY = mouseY;
    }

    void touchDrag(float mouseX,
                   float mouseY,
                   float distanceFromDragStartX,
                   float distanceFromDragStartY)
    {
        this->mouseX = mouseX;
        this->mouseY = mouseY;
    }

    void mouseMoved(float mouseX,
                    float mouseY)
    {
        this->mouseX = mouseX;
        this->mouseY = mouseY;
    }

    void renderOpenGL()
    {
        std::chrono::system_clock::time_point now = std::chrono::system_clock::now();
        double currentTimeInSeconds = std::chrono::duration<double>(now - startTimeOfProcess).count();
        // printf("Current time %f\n", currentTimeInSeconds);

        double timeElapsed = currentTimeInSeconds - timeOfLastRender;
        timeOfLastRender = currentTimeInSeconds;
        updateGraph(&framesPerSecondGraph, timeElapsed);

        // Update and render
        glViewport(0, 0, windowWidth * contentScaleFactor, windowHeight * contentScaleFactor);
        glClearColor(0.3f, 0.3f, 0.32f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT|GL_STENCIL_BUFFER_BIT);

        // Calculate pixel ration for hi-dpi devices.
        //pxRatio = (float)fbWidth / (float)winWidth;
        float pxRatio = 1.0f;
        nvgBeginFrame(vg, windowWidth * contentScaleFactor, windowHeight * contentScaleFactor, pxRatio);

        int blowup = false;
        nvgScale(vg, contentScaleFactor, contentScaleFactor);
        renderDemo(vg, 
                   mouseX, 
                   mouseY, 
                   windowWidth, 
                   windowHeight, 
                   currentTimeInSeconds, 
                   blowup, 
                   &data);

        renderGraph(vg, 5,5, &framesPerSecondGraph);

        nvgEndFrame(vg);
    }

    PerfGraph framesPerSecondGraph;
    DemoData data;
    NVGcontext* vg;
    int windowWidth;
    int windowHeight;
    float contentScaleFactor;
    float mouseX;
    float mouseY;
    std::chrono::system_clock::time_point startTimeOfProcess;
    double timeOfLastRender;
};

NanoVGOpenGLDemo::NanoVGOpenGLDemo()
  : impl(new Impl())
{
}

NanoVGOpenGLDemo::~NanoVGOpenGLDemo()
{
    delete impl;
}

void NanoVGOpenGLDemo::newOpenGLContextCreated(int windowWidth, int windowHeight)
{
    impl->newOpenGLContextCreated(windowWidth, windowHeight);
}

void NanoVGOpenGLDemo::setContentScaleFactor(float contentScaleFactor)
{
    impl->setContentScaleFactor(contentScaleFactor);
}

void NanoVGOpenGLDemo::setWindowSize(int windowWidth, int windowHeight)
{
    impl->setWindowSize(windowWidth, windowHeight);
}

void NanoVGOpenGLDemo::openGLContextClosing()
{
    impl->openGLContextClosing();
}

void NanoVGOpenGLDemo::touchDown(float mouseX,
                                 float mouseY)
{
    impl->touchDown(mouseX, mouseY);
}

void NanoVGOpenGLDemo::touchDrag(float mouseX,
                                 float mouseY,
                                 float distanceFromDragStartX,
                                 float distanceFromDragStartY)
{
    impl->touchDrag(mouseX, mouseY, distanceFromDragStartX, distanceFromDragStartY);
}

void NanoVGOpenGLDemo::mouseMoved(float mouseX,
                                  float mouseY)
{
    impl->mouseMoved(mouseX, mouseY);
}

void NanoVGOpenGLDemo::renderOpenGL()
{
    impl->renderOpenGL();
}
