/*
 *  SVG Export
 *      https://processing.org/reference/libraries/svg/index.html
 *
 */

import processing.svg.*;

void setup(){
  // 1 - No display
  //size(400,400,SVG,"test.svg");
  
  // 2 - Screen Display
  size(1000,1200);
  noLoop();
  
  // Eo setup
}


void draw()
{
  beginRecord(SVG, "test2.svg");
  
  // one sin
  float h = 40;
  noFill();  strokeWeight(2); stroke(0);
  
  int xRange = 40;
  //curve( p0, p1,p2, p3)
  int yPoints = 13;
  float yStep = height/yPoints;
  for( float x=-50; x<width+50; x+= 50)
  for( int y=3; y<yPoints; y++)
  {
    PVector p3 = new PVector( x+sin(y*yStep/180) *xRange , -yStep+y*yStep );
    PVector p2 = new PVector( x+sin((y-1)*yStep/180) *xRange , -yStep+(y-1)*yStep );
    PVector p1 = new PVector( x+sin((y-2)*yStep/180) *xRange , -yStep+(y-2)*yStep );
    PVector p0 = new PVector( x+sin((y-3)*yStep/180) *xRange , -yStep+(y-3)*yStep );
     
    curve(p3.x,p3.y,p2.x,p2.y,p1.x,p1.y,p0.x,p0.y);
    
    // Eo for
  }
  
  
  
  // 1 - No display    //exit();
  
  // 2 - Screen display
  endRecord();
}  