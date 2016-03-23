//
//  GameViewController.swift
//  RainbowLab-OSX
//
//  Created by Greg Kellum on 3/4/16.
//  Copyright (c) 2016 Sound Fantasy LLC. All rights reserved.
//

import SceneKit
import QuartzCore

class GameViewController: NSOpenGLView 
{    
    var program: NanoVGOpenGLDemo? = nil;
    private var repaintTimer: NSTimer!
    private var mouseDownPoint: (x: Float, y: Float)?
    private var displayLink: CVDisplayLinkRef?

    required init?(coder: NSCoder) 
    {
        //  Allow the super class to initialize it's properties (phase 1 initialization)
        super.init(coder: coder)

        setupGestureTracking()

        setupOpenGL()
    }

    deinit 
    {
        //When the view gets destroyed, we don't want to keep the link going.
        CVDisplayLinkStop(displayLink!)
    }

    func setupGestureTracking()
    {
        let trackingArea = NSTrackingArea(rect:self.frame,
                                          options:[ 
                                                    NSTrackingAreaOptions.MouseEnteredAndExited,
                                                    NSTrackingAreaOptions.MouseMoved,
                                                    NSTrackingAreaOptions.ActiveInKeyWindow,
                                                    NSTrackingAreaOptions.EnabledDuringMouseDrag, 
                                                    NSTrackingAreaOptions.CursorUpdate, 
                                                    NSTrackingAreaOptions.InVisibleRect, 
                                                    NSTrackingAreaOptions.AssumeInside 
                                                  ],
                                          owner:self,
                                          userInfo:nil)
        addTrackingArea(trackingArea)
    }

    func setupOpenGL()
    {
        //  Some OpenGL setup
        //  NSOpenGLPixelFormatAttribute is a typealias for UInt32 in Swift, but the individual
        //  attributes are Int's.  We have initialize them as Int32's to fit them into an array
        //  of NSOpenGLPixelFormatAttributes
        let attrs: [NSOpenGLPixelFormatAttribute] = [
            UInt32(NSOpenGLPFAMultisample),
            UInt32(NSOpenGLPFASampleBuffers), 
            UInt32(1),
            UInt32(NSOpenGLPFASamples),
            UInt32(4),
            UInt32(NSOpenGLPFAAccelerated),            //  Use accelerated renderers
            UInt32(NSOpenGLPFAClosestPolicy),
            UInt32(NSOpenGLPFAOpenGLProfile),
            UInt32(NSOpenGLProfileVersion3_2Core),
            UInt32(NSOpenGLPFAColorSize), UInt32(24),
            UInt32(NSOpenGLPFAAlphaSize), UInt32(8),
            UInt32(NSOpenGLPFADepthSize), UInt32(24),
            UInt32(NSOpenGLPFAStencilSize), UInt32(8),
            UInt32(NSOpenGLPFADoubleBuffer),
            UInt32(0)                                  //  C API's expect to end with 0
        ]

        //  Create a pixel format using our attributes
        guard let pixelFormat = NSOpenGLPixelFormat(attributes: attrs) else {
            Swift.print("pixelFormat could not be constructed")
            return
        }
        self.pixelFormat = pixelFormat

        //  Create a context with our pixel format (we have no other context, so nil)
        guard let context = NSOpenGLContext(format: pixelFormat, shareContext: nil) else {
            Swift.print("context could not be constructed")
            return
        }
        self.openGLContext = context

        //  Tell the view how often we are swaping the buffers, 1 indicates we are using the 60Hz refresh rate (i.e. 60 fps)
        self.openGLContext?.setValues([1], forParameter: .GLCPSwapInterval)
    }

    override func reshape() 
    {
        let frame = self.frame

        // Swift.print("reshape called with dimensions (\(frame.size.width), \(frame.size.height))");

        // Update the viewport.
        program?.setWindowSize(Int32(frame.size.width), windowHeight:Int32(frame.size.height));
    }

    override func prepareOpenGL() 
    {
        //  Allow the superclass to perform it's tasks
        super.prepareOpenGL()
        
        //  Setup OpenGL
        program = NanoVGOpenGLDemo()
        program?.newOpenGLContextCreated(Int32(frame.size.width), windowHeight:Int32(frame.size.height))

        // Swift.print("Window created with size (\(frame.size.width), \(frame.size.height))");
        
        setUpDisplayLink();
    }

    func setUpDisplayLink()
    {
        //  The callback function is called everytime CVDisplayLink says its time to get a new frame.
        func displayLinkOutputCallback(displayLink: CVDisplayLink, 
                                       _ inNow: UnsafePointer<CVTimeStamp>, 
                                       _ inOutputTime: UnsafePointer<CVTimeStamp>, 
                                       _ flagsIn: CVOptionFlags, 
                                       _ flagsOut: UnsafeMutablePointer<CVOptionFlags>, 
                                       _ displayLinkContext: UnsafeMutablePointer<Void>) -> CVReturn 
        {

            /*  The displayLinkContext is CVDisplayLink's parameter definition of the view in which we are working.
                In order to access the methods of a given view we need to specify what kind of view it is as right
                now the UnsafeMutablePointer<Void> just means we have a pointer to "something".  To cast the pointer
                such that the compiler at runtime can access the methods associated with our SwiftOpenGLView, we use
                an unsafeBitCast.  The definition of which states, "Returns the the bits of x, interpreted as having
                type U."  We may then call any of that view's methods.  Here we call drawView() which we draw a
                frame for rendering.  */
            unsafeBitCast(displayLinkContext, GameViewController.self).renderOpenGL()

            //  We are going to assume that everything went well for this mock up, and pass success as the CVReturn
            return kCVReturnSuccess
        }

        //  Grab the a link to the active displays, set the callback defined above, and start the link.
        /*  An alternative to a nested function is a global function or a closure passed as the argument--a local function 
            (i.e. a function defined within the class) is NOT allowed. */
        //  The UnsafeMutablePointer<Void>(unsafeAddressOf(self)) passes a pointer to the instance of our class.
        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        CVDisplayLinkSetOutputCallback(displayLink!, 
                                       displayLinkOutputCallback, 
                                       UnsafeMutablePointer<Void>(unsafeAddressOf(self)))
        CVDisplayLinkStart(displayLink!)
    }

    func transformY(y: Float) -> Float
    {
        return Float(self.frame.height) - y - 1;
    }

    func translatePoint(theEvent: NSEvent) -> (x: Float, y: Float)
    {
        return (x:Float(theEvent.locationInWindow.x),
                y:transformY(Float(theEvent.locationInWindow.y)));
    }

    override func mouseDown(theEvent: NSEvent)
    {
        mouseDownPoint = translatePoint(theEvent)
        if let mousePosition = mouseDownPoint
        {
            program?.touchDown(mousePosition.x,
                               mouseY:mousePosition.y);
        }
    }

    override func mouseDragged(theEvent: NSEvent)
    {
        let mousePosition = translatePoint(theEvent)
        if let unwrappedmouseDownPoint = mouseDownPoint
        {
            let dragDistanceX = mousePosition.x - unwrappedmouseDownPoint.x
            let dragDistanceY = mousePosition.y - unwrappedmouseDownPoint.y
            program?.touchDrag(mousePosition.x,
                               mouseY:mousePosition.y,
                               distanceFromDragStartX:dragDistanceX,
                               distanceFromDragStartY:dragDistanceY);
        }
    }

    override func mouseUp(theEvent: NSEvent)
    {
        //program?.touchUp();
    }

    override func mouseMoved(theEvent: NSEvent)
    {
        let mousePosition = translatePoint(theEvent)
        // Swift.print("mouseMoved \(mousePosition.x) \(mousePosition.y)");
        if let mouseDownPoint = mouseDownPoint
        {
            let dragDistanceX = mousePosition.x - mouseDownPoint.x
            let dragDistanceY = mousePosition.y - mouseDownPoint.y
            program?.mouseMoved(mousePosition.x,
                                mouseY:mousePosition.y);
        }
    }

    override func drawRect(dirtyRect: NSRect) 
    {
        super.drawRect(dirtyRect)

        renderOpenGL()
    }

        //  Method called to render a new frame with an OpenGL pipeline
    func renderOpenGL() 
    {
        guard let context = self.openGLContext else 
        {
            Swift.print("An error occurred acquiring the OpenGL context!")
            return
        }

        //  Tell OpenGL this is the context we want to draw into and lock the focus.
        context.makeCurrentContext()
        CGLLockContext(context.CGLContextObj)

        // Drawing code here.
        program?.renderOpenGL()

        //  Flushing sends the context to be used for display, then we can unlock the focus.
        CGLFlushDrawable(context.CGLContextObj)

        CGLUnlockContext(context.CGLContextObj)
    }
}
