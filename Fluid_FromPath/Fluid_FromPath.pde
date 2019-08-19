/**
 * 
 * Fluid on mouse drag & path boundary.
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
  
  PGraphics2D pg_obstacles;
  
  public void settings() {
    size(800, 800, P2D);
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
    fluid.param.dissipation_temperature = 0.69f;
    fluid.param.vorticity               = 0.10f;
    
    
    // adding data to the fluid simulation
    fluid.addCallback_FluiData(new  DwFluid2D.FluidData(){
      // PGraphics2D
      PShape path = new PShape();  
      float speed_factor = 5;
      
      public void update(DwFluid2D fluid) {
          if(mousePressed){
            // create Path
            
            float px     = mouseX;
            float py     = height-mouseY;
            float lx = pmouseX;
            float ly = height-pmouseY;
            float vx     = (mouseX - pmouseX);
            float vy     = (mouseY - pmouseY) *(-1);
            
            path.beginShape();
            path.vertex(px, py);
            path.endShape();
            
            
            fluid.addVelocity(px, py, 20, vx*speed_factor, vy*speed_factor);
            
            //fluid.addDensity (px, py, 20, 0.0f, 0.3f, 8.0f, 1.0f);
            //fluid.addDensity (px, py,  8, 0.4f, 0.4f, 0.4f, 1.0f);
            //fluid.addTemperature(px, py, 12, 1f);
            
            // Do velocity here, ONCE
            
            // * Eo pressed
          }
          
          for(int p=0; p<path.getVertexCount(); p++){
            // for point 
            PVector pvec = path.getVertex(p);
            //---addDensity( px,  py, radius, r, g, b, intensity )
            fluid.addDensity (pvec.x, pvec.y, 20, 0.0f, 0.3f, 8.0f, 1.0f);
            fluid.addDensity (pvec.x, pvec.y,  8, 0.4f, 0.4f, 0.4f, 1.0f);
            //fluid.addTemperature(pvec.x, pvec.y, 12, 5f);
          }
          
         // **   Eo update          
       }
      
    });
    
    // render-target
    pg_fluid = (PGraphics2D) createGraphics(width, height, P2D);
    
    pg_obstacles = (PGraphics2D) createGraphics(width, height, P2D);
    pg_obstacles.noSmooth();
    pg_obstacles.beginDraw();
    pg_obstacles.clear();
      pg_obstacles.noFill();  pg_obstacles.strokeWeight(20);  
      pg_obstacles.stroke(120,20,20);
    pg_obstacles.arc(width/2,height/3,  width/2, height/3, PI, TWO_PI);
    pg_obstacles.endDraw();
    fluid.addObstacles(pg_obstacles);
    
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
    image(pg_obstacles, 0,0);
    
  }