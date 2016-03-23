#ifndef NanoVGOpenGLDemo_H
#define NanoVGOpenGLDemo_H

#define swift __attribute__((annotate("swift")))

class swift NanoVGOpenGLDemo
{
public:
    NanoVGOpenGLDemo();
    virtual ~NanoVGOpenGLDemo();

    void newOpenGLContextCreated(int windowWidth, int windowHeight);

    void setContentScaleFactor(float contentScaleFactor);
    void setWindowSize(int windowWidth, int windowHeight);

    void openGLContextClosing();

    void touchDown(float mouseX,
                   float mouseY);

    void touchDrag(float mouseX,
                   float mouseY,
                   float distanceFromDragStartX,
                   float distanceFromDragStartY);

    void mouseMoved(float mouseX,
                    float mouseY);

    void renderOpenGL();

private:
    class Impl;
    Impl* impl;
};

#endif
