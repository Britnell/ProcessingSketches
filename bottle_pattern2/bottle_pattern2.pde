/*
 *  SVG Export
 *      https://processing.org/reference/libraries/svg/index.html
 *
 */
 
// 23.8 diam :: 16 cm
// 7.9 :: 16
//395 :: 80
import processing.svg.*;

void setup() {
  // 1 - No display
  size(400,400,SVG,"test.svg");

  // 2 - Screen Display
  //size(600, 800, P2D);  // 395
  background(0,20,80);
  noFill(); stroke(255);
  rect( (width-395)/2,0, 395,height);
  noLoop();

  // Eo setup
}


void draw()
{
  
  //beginRecord(SVG, "test2.svg");

  // one sin

  
  float yStep = 100;
  //for(float y=height; y>0; y-= yStep)
  int y=0;
  float yPos, xStep;
  
  float xBeg = (width-396)/2;
  
  //    **    Row 0
  yPos = height -yStep; 
  xStep = width/6;
  for( int x=0; x<6; x++){
    float xPos = xBeg +x*xStep +100;
    PShape leaf = makeLeaf(40,80);
    shape(leaf, xPos, yPos);
  }
  //    **    Row 1
  yPos = height -2*yStep; 
  for( int x=0; x<12; x++){
    float xPos = x*xStep+xStep/2;
    PShape leaf = makeLeaf(30,60);
    shape(leaf, xPos, yPos);
  }
  //    **    Row 2
  yPos = height -2.7*yStep; 
  for( int x=0; x<12; x++){
    float xPos = x*xStep+xStep/6;
    PShape leaf = makeLeaf(16,36);
    leaf.rotate(PI/8);
    shape(leaf, xPos, yPos);
  }
  //    **    Row 3
  yPos = height -3.4*yStep;
  xStep *= 2;
  for( int x=0; x<12; x++){
    float xPos = x*xStep+xStep/4;
    PShape leaf = makeLeaf(25,50);
    leaf.rotate(-PI*2/9);
    shape(leaf, xPos, yPos);
  }
  //    **    Row 4 
  yPos = height -4.0*yStep; 
  for( int x=0; x<12; x++){
    float xPos = x*xStep-xStep/3.6;
    PShape leaf = makeLeaf(30,70);
    shape(leaf, xPos, yPos);
  }
  
  
  
  //leaf.rotate(y*PI/6);
  //shape(leaf, xPos+xStep/2, yPos);
  

  // 1 - No display    //exit();  
  // 2 - Screen display
  endRecord();
}  

PShape makeLeaf(float w, float h)
{
  PShape sh = createShape();
  sh.beginShape();
  sh.noFill();
  sh.strokeWeight(1);
  sh.stroke(255);
  sh.vertex(0, -h);
  sh.bezierVertex( w, 0, w, 0, 0, h );
  sh.bezierVertex( -w, 0, -w, 0, 0, -h );
  sh.endShape();
  return sh;
}