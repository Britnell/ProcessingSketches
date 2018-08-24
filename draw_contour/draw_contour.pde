
/* http://atduskgreg.github.io/opencv-processing/reference/
*
*/

import gab.opencv.*;
OpenCV opencv;
PImage canvas, dst;
ArrayList<Contour> contours;
ArrayList<PVector> boundary;

float growSize = 3;
float growPercent = 0.01;
float gray = 180;

// **      PGraphics
// draw onto pgraphics only

void setup(){
   
   size(800,800);
   background(0);
   frameRate(60);
   
   //background(255);
    ellipseMode(CENTER);   
    rectMode(CENTER);
}


void draw(){
  Morph();  
}



void mousePressed(){
  noFill(); strokeWeight(25);  stroke(gray);
  line(pmouseX, pmouseY,   mouseX, mouseY);
}

void mouseDragged(){
            // * EllipseDraw
          //noStroke();    fill(99);
          //ellipseMode(CENTER);
          //ellipse(mouseX, mouseY, 20,20);
  noFill(); strokeWeight(25);  stroke(gray);
  line(pmouseX, pmouseY,   mouseX, mouseY);
}

void mouseReleased(){
   Morph(); 
}

void Morph(){
  
  loadPixels();
  canvas = createImage(width, height, RGB );
  canvas.loadPixels();
  canvas.pixels = pixels;
  background(0);
  image(canvas,0,0);
  
  
  opencv = new OpenCV(this, canvas);
  opencv.gray();
  opencv.threshold(90);
  
  dst = opencv.getOutput();
  //image(dst,0,0);
  
  contours = opencv.findContours();
  println("found " + contours.size() + " contours");
  
  for (Contour contour : contours) {
    //stroke(140, 40, 0);    strokeWeight(4);
    //contour.draw();
    
    boundary = contour.getPoints();
    //noStroke();    fill(200);
    //ellipseMode(CENTER);
    for(PVector punkt : boundary){
      stroke(gray);    //stroke(180,0,0);    
      strokeWeight(growSize);      
      if(random(1)<growPercent) {
        //ellipse(punkt.x, punkt.y, growSize, growSize);
        //rect(punkt.x, punkt.y, growSize, growSize);
        point(punkt.x, punkt.y);
      }
    }
    // Eo for contour
  } 
}



// ** End