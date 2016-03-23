//
//  GameViewController.swift
//  TestGame
//
//  Created by Greg Kellum on 12/27/15.
//  Copyright © 2015 Sound Fantasy LLC. All rights reserved.
//

import GLKit
import OpenGLES

class GameViewController: GLKViewController {
    
    var context: EAGLContext? = nil
    var program: NanoVGOpenGLDemo? = nil;
    private var mouseDownPoint: (x: Float, y: Float)?

    deinit {
        self.tearDownGL()
        
        if EAGLContext.currentContext() === self.context {
            EAGLContext.setCurrentContext(nil)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return false
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle 
    {
        //LightContent
        return UIStatusBarStyle.LightContent
    }

    override func viewDidLoad() 
    {
        super.viewDidLoad()
        
        self.context = EAGLContext(API: .OpenGLES2)
        
        if !(self.context != nil) {
            print("Failed to create ES context")
        }
        
        let view = self.view as! GLKView
        view.context = self.context!
        view.drawableDepthFormat = .Format16
        view.drawableStencilFormat = GLKViewDrawableStencilFormat.Format8
        view.drawableColorFormat = GLKViewDrawableColorFormat.RGBA8888

        // Uncomment this to disable retina display level resolution
        // and to improve GPU performance.
        // view.contentScaleFactor = 1.0

        self.setupGL()
    }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()

        //print("Updating window size to (\(view.frame.size.width), \(view.frame.size.height))")

        program?.setWindowSize(Int32(view.frame.size.width),
                               windowHeight:Int32(view.frame.size.height))
        program?.setContentScaleFactor(Float(view.contentScaleFactor));
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        if self.isViewLoaded() && (self.view.window != nil) {
            self.view = nil
            
            self.tearDownGL()
            
            if EAGLContext.currentContext() === self.context {
                EAGLContext.setCurrentContext(nil)
            }
            self.context = nil
        }
    }
    
    func setupGL() {
        EAGLContext.setCurrentContext(self.context)

        program = NanoVGOpenGLDemo()
        program?.newOpenGLContextCreated(Int32(view.frame.size.width),
                                         windowHeight:Int32(view.frame.size.height))
    }
    
    func tearDownGL() {
        EAGLContext.setCurrentContext(self.context)
        
        program?.openGLContextClosing()
    }
    
    // MARK: - GLKView and GLKViewController delegate methods
    override func glkView(view: GLKView, drawInRect rect: CGRect)
    {
        program?.renderOpenGL()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) 
    {
        if let touch = touches.first 
        {
            let currentPoint = touch.locationInView(self.view)
            // do something with your currentPoint
            mouseDownPoint = (Float(currentPoint.x), Float(currentPoint.y))
            program?.touchDown(Float(currentPoint.x),
                               mouseY:Float(currentPoint.y));
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) 
    {
        if let touch = touches.first 
        {
            let currentPoint = touch.locationInView(self.view)
            if let mouseDownPoint = mouseDownPoint
            {
                let dragDistanceX = Float(currentPoint.x) - mouseDownPoint.x
                let dragDistanceY = Float(currentPoint.y) - mouseDownPoint.y
                program?.touchDrag(Float(currentPoint.x),
                                   mouseY:Float(currentPoint.y),
                                   distanceFromDragStartX:dragDistanceX,
                                   distanceFromDragStartY:dragDistanceY);
            }
        }
    }
}