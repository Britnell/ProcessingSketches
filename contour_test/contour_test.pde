
/* http://atduskgreg.github.io/opencv-processing/reference/
*
*/

import gab.opencv.*;
OpenCV opencv;
PImage canvas, dst;
ArrayList<Contour> contours;


void setup(){
   
   size(800,800);
   background(0);
   //frameRate(1);
   
   //background(255);
   
     
}


void draw(){
  
  //
  
  
  
  // Eo draw
}

void mouseDragged(){
  // EllipseDraw
  //noStroke();    fill(99);
  //ellipseMode(CENTER);
  //ellipse(mouseX, mouseY, 20,20);
  noFill(); strokeWeight(25);  stroke(111);
  line(pmouseX, pmouseY,   mouseX, mouseY);
}

void mouseReleased(){
  loadPixels();
  canvas = createImage(width, height, RGB );
  canvas.loadPixels();
  canvas.pixels = pixels;
  background(0);
  image(canvas,0,0);
  
  
  opencv = new OpenCV(this, canvas);
  opencv.gray();
  opencv.threshold(70);
  
  dst = opencv.getOutput();
  //image(dst,0,0);
  
  contours = opencv.findContours();
  println("found " + contours.size() + " contours");
  
  for (Contour contour : contours) {
    stroke(140, 40, 0);    strokeWeight(4);
    contour.draw();
    
  }
  
}