/**
 * 
 * PixelFlow | Copyright (C) 2016 Thomas Diewald - http://thomasdiewald.com
 * 
 *    add inks, find outline, and stop drawing after some time
 *    # add random velocities
 */


  // **    Fluids
  
import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.fluid.DwFluid2D;

import processing.core.*;
import processing.opengl.PGraphics2D;
  
  //   ** Variables
  float random_speed = 80;
  float random_prob = 0.05f;
  
  // fluid simulation
  DwFluid2D fluid;
  
  // render targets
  PGraphics2D pg_fluid;
  PGraphics2D pg_obstacles;
  PGraphics2D pg_outline;
  int[] prints = new int[1000];
  int print_L = 0;
  
    // **    OpenCV
  
  import gab.opencv.*;
  OpenCV opencv;
  PImage canvas, dst;
  ArrayList<Contour> contours;
  ArrayList<PVector> boundary;
  

  public void settings() {
    size(800, 800, P2D);
    for(int x=0;x<1000;x++)
      prints[x] = 10;
  }
  
  public void setup() {
    
    // library context
    DwPixelFlow context = new DwPixelFlow(this);
    context.print();
    context.printGL();
    
    // fluid simulation
    fluid = new DwFluid2D(context, width, height, 1);
    
    // some fluid parameters
    // how quickly mixing slows down
    // 0.99 forever moving
    fluid.param.dissipation_velocity = 0.5;   
    fluid.param.dissipation_density  = 0.99;  // how quickly disappears
    fluid.param.dissipation_temperature = 0.69f;
    fluid.param.vorticity               = 0.0f;  // how fine the edges break down and almost fractal
    
    
    // adding data to the fluid simulation
    fluid.addCallback_FluiData(new  DwFluid2D.FluidData(){
      // PGraphics2D
      PShape path = new PShape();  
      float speed_factor = 6;
      
      public void update(DwFluid2D fluid) {
          if(mousePressed){
            // create Path
            
            float px     = mouseX;
            float py     = height-mouseY;
            float lx = pmouseX;
            float ly = height-pmouseY;
            float vx     = (mouseX - pmouseX);
            float vy     = (mouseY - pmouseY) *(-1);
            println("\n\nVel : \t", vx, vy );
            
            path.beginShape();
            path.vertex(px, py);
            path.endShape();
            prints[print_L] = 0;
            print_L++;
            
            fluid.addVelocity(px, py, 20, vx*speed_factor, vy*speed_factor);
            
            fluid.addDensity (px, py, 20, 0.4f, 0.4f, 0.4f, 1.0f);
            fluid.addDensity (px, py, 16, 0.0f, 0.2f, 0.99f, 1.0f);
            
            //fluid.addTemperature(px, py, 12, 1f);
            
            // Do velocity here, ONCE
            
            // * Eo pressed
          }
          
          for(int p=0; p<path.getVertexCount(); p++)
          if(prints[p]<10) {
            prints[p]++;
            // for point 
            PVector pvec = path.getVertex(p);
            //---addDensity( px,  py, radius, r, g, b, intensity )
            fluid.addDensity (pvec.x, pvec.y, 20, 0.4f, 0.4f, 0.4f, 1.0f);
            fluid.addDensity (pvec.x, pvec.y, 16, 0.0f, 0.2f, 0.99f, 1.0f);
            //fluid.addTemperature(pvec.x, pvec.y, 12, 5f);
          }
          
          if(random(1)<random_prob) {
            float rx = random(width/4, 3*width/4); 
            float ry = random(height/4, 3*height/4);
            float rs = 60;
            float ra = random(TWO_PI);
            float rvx = random_speed*sin(ra);
            float rvy = random_speed*cos(ra);
            println("RANDOM:\n", rx, ry, "/", rs," :: ", rvx, rvy );
            fluid.addVelocity( rx, ry, rs, rvx, rvy );
          }
         // **   Eo update          
       }
      
    });
    
    // render-target
    pg_fluid = (PGraphics2D) createGraphics(width, height, P2D);
    
    pg_outline = (PGraphics2D) createGraphics(width, height, P2D);
    
    pg_obstacles = (PGraphics2D) createGraphics(width, height, P2D);
    pg_obstacles.noSmooth();
    pg_obstacles.beginDraw();
    pg_obstacles.clear();
      pg_obstacles.noFill();  pg_obstacles.strokeWeight(20);  
      pg_obstacles.stroke(120,20,20);
    //pg_obstacles.arc(width/2,height/3,  width/2, height/3, PI, TWO_PI);
    pg_obstacles.ellipse(width/2,height/2,  width/1, height/1 );
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
    
      // * render fluid stuff
    fluid.renderFluidTextures(pg_fluid, 0);
    
      // * Contrours      
    canvas = createImage(width, height, RGB);
    //canvas.loadPixels();
    //canvas.pixels = pg_fluid.pixels;
    canvas = pg_fluid;
    opencv = new OpenCV(this, canvas);
    opencv.gray();
    opencv.threshold(10);
    
    //dst = opencv.getOutput();
    contours = opencv.findContours();
    
    pg_outline = (PGraphics2D) createGraphics(width, height, P2D);
    pg_outline.beginDraw();
    for (Contour contour : contours) {
      boundary = contour.getPoints();
      for(PVector punkt : boundary){
        pg_outline.stroke(140, 40, 0);    pg_outline.strokeWeight(1);
          pg_outline.point(punkt.x, punkt.y);
      }
      // Eo for contour
    }
    pg_outline.endDraw();
    
          // *  display
    image(pg_obstacles, 0,0);
    image(pg_fluid, 0, 0);
    //image(pg_outline, 0,0);
    
    // **  Eo draw()
}

//      **