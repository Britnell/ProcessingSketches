/**
 * 
 * PixelFlow | Copyright (C) 2016 Thomas Diewald - http://thomasdiewald.com
 * 
 * A Processing/Java library for high performance GPU-Computing (GLSL).
 * MIT License: https://opensource.org/licenses/MIT
 * 
 */


import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.fluid.DwFluid2D;

import processing.core.*;
import processing.opengl.PGraphics2D;


  // Hello World Example for fluid simulations.
  //
  // Controls:
  // LMB/MMB/RMB: add density + Velocity
  //
  
  
  
  // fluid simulation
  DwFluid2D fluid;
  
  // render targets
  PGraphics2D pg_fluid;
  
  public void settings() {
    size(100, 200, P2D);
  }
  
  public void setup() {
    
    // library context
    DwPixelFlow context = new DwPixelFlow(this);
    context.print();
    context.printGL();
    
    // fluid simulation
    fluid = new DwFluid2D(context, width, height, 1);
    
    // some fluid parameters
    fluid.param.dissipation_velocity = 0.99;   // how quickly mixing slows down
    fluid.param.dissipation_density  = 0.99;  // how quickly disappears

    // adding data to the fluid simulation
    fluid.addCallback_FluiData(new  DwFluid2D.FluidData(){
      public void update(DwFluid2D fluid) {
        if(mousePressed){
          float px     = mouseX;
          float py     = height-mouseY;
          float lx = pmouseX;
          float ly = height-pmouseY;
          float vx     = (mouseX - pmouseX);
          float vy     = (mouseY - pmouseY) *(-1);
          
          float speed_factor = 3;
          float dense = 1.5f;
          float steps = 3.0f;
          
          
          float X=lx;
          float Y=ly;
          float Sx = steps;
          float Sy = steps;
          if( lx>px)  Sx *= -1;
          if( ly>py)  Sy *= -1;
          println("last: ", lx, ly, "\t + ", Sx, Sy, "\t to ", px, py);
          
          while( abs(X-px)+abs(Y-py) >2*steps){
            //---addDensity( px,  py, radius, r, g, b, intensity )
            fluid.addDensity (X, Y,  steps, 1.0f, 1.0f, 1.0f, dense);
            fluid.addDensity (X, Y, 20, 0.0f, 0.4f, 1.0f, 1.0f);
            fluid.addVelocity(X, Y, 2*steps, vx*speed_factor, vy*speed_factor);
            if(abs(X-px)>=steps)   X += Sx;  
            if(abs(Y-py)>=steps)   Y += Sy;
            println("P:\t",X,Y, "\tTo: ", px, py);
          }
            // * Example
          //fluid.addVelocity(px, py, 14, vx*speed_factor, vy*speed_factor);
          //fluid.addDensity (px, py, 20, 0.0f, 0.4f, 1.0f, 1.0f);
          //fluid.addDensity (px, py,  8, 1.0f, 1.0f, 1.0f, 1.0f);          
       }
      }
    });
   
    // render-target
    pg_fluid = (PGraphics2D) createGraphics(width, height, P2D);
    
    frameRate(60);
  }
  

  public void draw() {    
    // update simulation
    fluid.update();
    
    // clear render target
    pg_fluid.beginDraw();
    pg_fluid.background(0);
    pg_fluid.endDraw();

    // render fluid stuff
    fluid.renderFluidTextures(pg_fluid, 0);

    // display
    image(pg_fluid, 0, 0);
  }