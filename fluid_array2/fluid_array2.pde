/**
 *   adaptation from mutliple fluids Example 
 *     get fluid2 contour and use as obstacle on fluid1
 */


    // ** Fluids

import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.fluid.DwFluid2D;

import processing.core.*;
import processing.opengl.PGraphics2D;

FluidSystem fluidsystem1;
FluidSystem fluidsystem2;


    // **    OpenCV
  
import gab.opencv.*;
OpenCV opencv;

  public void settings() {
    size(800, 800, P2D);
    smooth(4);
  }
  
  public void setup() {
    
    
      
    DwPixelFlow context = new DwPixelFlow(this);
    context.print();
    context.printGL();

    fluidsystem1 = new FluidSystem(0, context, width/2, height, 1);
    fluidsystem2 = new FluidSystem(1, context, width/2, height, 1);
    
    fluidsystem1.fluid.param.dissipation_velocity = 0.99f;
    
    frameRate(60);
  }
  
    

  public void draw() {
    
    fluidsystem1.setPosition(0,0);
    fluidsystem2.setPosition(width/2, 0);
   
    fluidsystem1.update();
    fluidsystem2.update();
    
      // ** get contour from System 2
    
    PImage canvas = createImage(width/2 ,height, RGB);
    canvas = fluidsystem2.getPG_Fluid();
    opencv = new OpenCV(this, canvas);
    opencv.gray();
    opencv.threshold(10);
    //PImage outline_image = opencv.getOutput();
    ArrayList<Contour> contours = opencv.findContours();
    // draw out points onto Proc Graphic
    PGraphics2D outline_graph = (PGraphics2D) createGraphics(width, height, P2D);    
    outline_graph.beginDraw();
    outline_graph.noStroke();    outline_graph.fill(111);
    outline_graph.ellipse(mouseX, mouseY-100, 40,40);
    //for (Contour contour : contours) {
    //  ArrayList<PVector> boundary = contour.getPoints();
    //  for(PVector punkt : boundary){
    //    outline_graph.stroke(140, 40, 0);    outline_graph.strokeWeight(1);
    //      outline_graph.point(punkt.x, punkt.y);
    //  }
    //  // Eo for contour
    //}
    outline_graph.endDraw();
    fluidsystem1.setObstacle(outline_graph);
    
        // **    Drawing
        
    background(64);
    fluidsystem2.display();
    fluidsystem1.display();
    //image(outline_graph, width/2, 0);
    // ** Eo draw
  }
  
  
  