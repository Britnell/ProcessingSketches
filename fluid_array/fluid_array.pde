/**
 *   First direct adaptation from mutliple fluids Example 
 *    now to add my own sauce
 */




import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.fluid.DwFluid2D;

import processing.core.*;
import processing.opengl.PGraphics2D;

 
  // A setup of two independent Fluid Simulations.
  //
  // controls:
  //
  // LMB: add Velocity
  // MMB: add Density
  // RMB: add Temperature
  
  int viewport_w = 1280;
  int viewport_h = 720;
  int viewport_x = 230;
  int viewport_y = 0;
  
  int border = 50;
  

  FluidSystem fluidsystem1;
  FluidSystem fluidsystem2;
  
  public void settings() {
    size(viewport_w, viewport_h, P2D);
    smooth(4);
  }
  
  public void setup() {
    
    surface.setLocation(viewport_x, viewport_y);
      
    DwPixelFlow context = new DwPixelFlow(this);
    context.print();
    context.printGL();

    fluidsystem1 = new FluidSystem(0, context, (viewport_w-3*border)/2, viewport_h-2*border, 1);
    fluidsystem2 = new FluidSystem(1, context, (viewport_w-3*border)/2, viewport_h-2*border, 1);
    
    fluidsystem1.fluid.param.dissipation_velocity = 0.99f;
    
    frameRate(60);
  }
  
    

  public void draw() {
    
    fluidsystem1.setPosition(border, border);
    fluidsystem2.setPosition(border*2 + fluidsystem1.w, border);
   
    fluidsystem1.update();
    fluidsystem2.update();
    
    background(64);
    fluidsystem1.display();
    fluidsystem2.display();
    
    // info
    String txt_fps = String.format(getClass().getName()+ "   [size %d/%d]   [frame %d]   [fps %6.2f]", viewport_w, viewport_h, frameCount, frameRate);
    surface.setTitle(txt_fps);
  }
  
  
  