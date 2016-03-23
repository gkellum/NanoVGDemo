// generated cxx-subclasses.mm

#import "cplusplus-objc-protocols.h"
#include "cplusplus-Bridging-Header.h"

template<typename T>
struct LinkSaver
{
  T saved, &link;
  LinkSaver( T &i_link ) : saved( i_link ), link( i_link ) { link = nil; }
  ~LinkSaver() { link = saved; }
};

// the wrapping sub-classes

class NanoVGOpenGLDemo_subclass : public NanoVGOpenGLDemo
{
public:
  id<NanoVGOpenGLDemo_protocol> _link;

  NanoVGOpenGLDemo_subclass( id<NanoVGOpenGLDemo_protocol> i_link )
   : NanoVGOpenGLDemo( ),
    _link( i_link ){}








};


// the c implementations

void NanoVGOpenGLDemo_subclass_delete( NanoVGOpenGLDemo_subclass *i_this )
{
  delete i_this;
}

NanoVGOpenGLDemo_subclass *NanoVGOpenGLDemo_subclass_new( id<NanoVGOpenGLDemo_protocol> i_link )
{
  return new NanoVGOpenGLDemo_subclass( i_link );
}

void NanoVGOpenGLDemo_subclass_mouseMoved( NanoVGOpenGLDemo_subclass *i_this, float mouseX, float mouseY )
{
  i_this->mouseMoved( mouseX, mouseY );
}

void NanoVGOpenGLDemo_subclass_newOpenGLContextCreated( NanoVGOpenGLDemo_subclass *i_this, int windowWidth, int windowHeight )
{
  i_this->newOpenGLContextCreated( windowWidth, windowHeight );
}

void NanoVGOpenGLDemo_subclass_openGLContextClosing( NanoVGOpenGLDemo_subclass *i_this )
{
  i_this->openGLContextClosing( );
}

void NanoVGOpenGLDemo_subclass_renderOpenGL( NanoVGOpenGLDemo_subclass *i_this )
{
  i_this->renderOpenGL( );
}

void NanoVGOpenGLDemo_subclass_setContentScaleFactor( NanoVGOpenGLDemo_subclass *i_this, float contentScaleFactor )
{
  i_this->setContentScaleFactor( contentScaleFactor );
}

void NanoVGOpenGLDemo_subclass_setWindowSize( NanoVGOpenGLDemo_subclass *i_this, int windowWidth, int windowHeight )
{
  i_this->setWindowSize( windowWidth, windowHeight );
}

void NanoVGOpenGLDemo_subclass_touchDown( NanoVGOpenGLDemo_subclass *i_this, float mouseX, float mouseY )
{
  i_this->touchDown( mouseX, mouseY );
}

void NanoVGOpenGLDemo_subclass_touchDrag( NanoVGOpenGLDemo_subclass *i_this, float mouseX, float mouseY, float distanceFromDragStartX, float distanceFromDragStartY )
{
  i_this->touchDrag( mouseX, mouseY, distanceFromDragStartX, distanceFromDragStartY );
}



