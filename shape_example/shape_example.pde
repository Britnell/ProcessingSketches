/**
 * Simple Read
 * 
 * Read data from the serial port and change the color of a rectangle
 * when a switch connected to a Wiring or Arduino board is pressed and released.
 * This example works with the Wiring / Arduino program that follows below.
 */

PShape sh;

void setup() 
{
  size(800, 800);
  
  background(255);
  
  fill(0);   textSize(100);
  text("BRAIN",120,120);
  
  sh = createShape();
  sh.beginShape();
  sh.fill(111);  //sh.noFill();
  sh.noStroke();
  int frame = 200;
  sh.vertex(frame, frame);
  sh.vertex(width-frame, frame);
  sh.vertex(width-frame, height-frame);
  sh.vertex(frame, height-frame);
  sh.endShape(CLOSE);
  shape(sh,0,0);
  
  println( "childs", sh.getVertexCount() );    
  for( int v=0; v<sh.getVertexCount(); v++){
    PVector vec = sh.getVertex(v);
    println("vx: ", vec);
  }
  // setup
}

void draw()
{
  
  
}