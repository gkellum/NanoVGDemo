// generated cplusplus-objc-proxies.mm

#import "cplusplus-objc-proxies.h"
#include <string>
#include <vector>
#include <map>
#include <cassert>


namespace swift_converter
{
}

//********************************
// NanoVGOpenGLDemo
//********************************

// C-style

class NanoVGOpenGLDemo_subclass;
void NanoVGOpenGLDemo_subclass_delete( NanoVGOpenGLDemo_subclass *i_this );
NanoVGOpenGLDemo_subclass *NanoVGOpenGLDemo_subclass_new( id<NanoVGOpenGLDemo_protocol> i_link );
void NanoVGOpenGLDemo_subclass_mouseMoved( NanoVGOpenGLDemo_subclass *i_this, float mouseX, float mouseY );
void NanoVGOpenGLDemo_subclass_newOpenGLContextCreated( NanoVGOpenGLDemo_subclass *i_this, int windowWidth, int windowHeight );
void NanoVGOpenGLDemo_subclass_openGLContextClosing( NanoVGOpenGLDemo_subclass *i_this );
void NanoVGOpenGLDemo_subclass_renderOpenGL( NanoVGOpenGLDemo_subclass *i_this );
void NanoVGOpenGLDemo_subclass_setContentScaleFactor( NanoVGOpenGLDemo_subclass *i_this, float contentScaleFactor );
void NanoVGOpenGLDemo_subclass_setWindowSize( NanoVGOpenGLDemo_subclass *i_this, int windowWidth, int windowHeight );
void NanoVGOpenGLDemo_subclass_touchDown( NanoVGOpenGLDemo_subclass *i_this, float mouseX, float mouseY );
void NanoVGOpenGLDemo_subclass_touchDrag( NanoVGOpenGLDemo_subclass *i_this, float mouseX, float mouseY, float distanceFromDragStartX, float distanceFromDragStartY );

// Objective-C proxy

#define _this ((NanoVGOpenGLDemo_subclass *)_ptr)

@implementation NanoVGOpenGLDemo

- (void)dealloc
{
  NanoVGOpenGLDemo_subclass_delete( _this );
#if !__has_feature(objc_arc)
  [super dealloc];
#endif
}
- (instancetype)init
{
  self = [super init];
  if ( self )
    _ptr = NanoVGOpenGLDemo_subclass_new( self );
  return self;
}

- (void)mouseMoved:(float)mouseX mouseY:(float)mouseY
{
  assert( _this != nullptr );
  NanoVGOpenGLDemo_subclass_mouseMoved( _this, mouseX, mouseY );
}

- (void)newOpenGLContextCreated:(int)windowWidth windowHeight:(int)windowHeight
{
  assert( _this != nullptr );
  NanoVGOpenGLDemo_subclass_newOpenGLContextCreated( _this, windowWidth, windowHeight );
}

- (void)openGLContextClosing
{
  assert( _this != nullptr );
  NanoVGOpenGLDemo_subclass_openGLContextClosing( _this );
}

- (void)renderOpenGL
{
  assert( _this != nullptr );
  NanoVGOpenGLDemo_subclass_renderOpenGL( _this );
}

- (void)setContentScaleFactor:(float)contentScaleFactor
{
  assert( _this != nullptr );
  NanoVGOpenGLDemo_subclass_setContentScaleFactor( _this, contentScaleFactor );
}

- (void)setWindowSize:(int)windowWidth windowHeight:(int)windowHeight
{
  assert( _this != nullptr );
  NanoVGOpenGLDemo_subclass_setWindowSize( _this, windowWidth, windowHeight );
}

- (void)touchDown:(float)mouseX mouseY:(float)mouseY
{
  assert( _this != nullptr );
  NanoVGOpenGLDemo_subclass_touchDown( _this, mouseX, mouseY );
}

- (void)touchDrag:(float)mouseX mouseY:(float)mouseY distanceFromDragStartX:(float)distanceFromDragStartX distanceFromDragStartY:(float)distanceFromDragStartY
{
  assert( _this != nullptr );
  NanoVGOpenGLDemo_subclass_touchDrag( _this, mouseX, mouseY, distanceFromDragStartX, distanceFromDragStartY );
}


@end

#undef _this

