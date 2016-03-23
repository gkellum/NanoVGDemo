// generated cplusplus-objc-protocols.h
//  pure Objective-C, cannot contain any C++

#ifndef H_CXX_OBJC_PROTOCOLS
#define H_CXX_OBJC_PROTOCOLS

#import <Foundation/Foundation.h>




// Objective-C proxy protocols for each classes

@protocol NanoVGOpenGLDemo_protocol
- (instancetype)init;
- (void)mouseMoved:(float)mouseX mouseY:(float)mouseY;
- (void)newOpenGLContextCreated:(int)windowWidth windowHeight:(int)windowHeight;
- (void)openGLContextClosing;
- (void)renderOpenGL;
- (void)setContentScaleFactor:(float)contentScaleFactor;
- (void)setWindowSize:(int)windowWidth windowHeight:(int)windowHeight;
- (void)touchDown:(float)mouseX mouseY:(float)mouseY;
- (void)touchDrag:(float)mouseX mouseY:(float)mouseY distanceFromDragStartX:(float)distanceFromDragStartX distanceFromDragStartY:(float)distanceFromDragStartY;

@end

#endif
