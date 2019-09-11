/**
 * draw pixels and it sends to arduino
 *     TO DO
 *  - 
 */

//  **     file:///C:/Users/Thomas.Britnell/Documents/processing-3.5.3/modes/java/reference/libraries/serial/index.html


import processing.serial.*;

Serial ardPort;  // Create object from Serial class
int val;      // Data received from the serial port

PVector canvasSize, canvasPos; 

int PIXEL_X = 8;
int PIXEL_Y = 8;
float PIXEL_W, PIXEL_H;

color paintCol;

void setup()
{
  // * Canvas
  
  size(800, 800);
  colorMode(RGB, 255, 255, 255);
  
  paintCol = color( 40, 0, 0 );
  
  canvasSize = new PVector( 600,600 );
  canvasPos = new PVector( 100, 100 );
  
  PIXEL_W = canvasSize.x / PIXEL_X;
  PIXEL_H = canvasSize.y / PIXEL_Y;
  
  // * Serial
  
  print("Serial ports available: ");
    println( Serial.list() );
  //String portName = Serial.list()[0];
  String portName = "COM4";
    print("opening serial : ");
    println( portName );
  ardPort = new Serial(this, portName, 115200);
  
  // * INit
  
  int frameS = 5;
  background(0);
  noFill();  stroke(255);  strokeWeight(frameS);
  rect(canvasPos.x-frameS, canvasPos.y-frameS, 
        canvasSize.x+frameS, canvasSize.y+frameS);
  
  // ** Eo setup
}



void draw()
{
  
  // ** Eo draw
}



void draw_pixel( int X, int Y )
{
  // just draw the right rect
  
  // find index
  
  float rx = map( X, 
             canvasPos.x, canvasSize.x +canvasPos.x ,
             0, PIXEL_X );
  rx = constrain(rx, 0, PIXEL_X );
  
  float ry = map( Y, 
             canvasPos.y, canvasSize.y +canvasPos.y ,
             0, PIXEL_Y );
  ry = constrain(ry, 0, PIXEL_Y );
  
  int Rx = floor(rx);
  int Ry = floor(ry);  
  
  fill(paintCol);  noStroke();  
  rect( canvasPos.x +Rx* PIXEL_W, 
         canvasPos.y +Ry * PIXEL_H,
         PIXEL_W, PIXEL_H );
  
  // ** Eo draw pixel
}


void mousePressed()
{
    draw_pixel(mouseX, mouseY);
}


void mouseDragged()
{
    draw_pixel(mouseX, mouseY);
}

void mouseReleased()
{
   send_pixels(); 
}

void send_pixels()
{
  for( float y=canvasPos.y+PIXEL_H/2; y<canvasPos.y+canvasSize.y;  y+=PIXEL_H )
  {
    
    for(float x=canvasPos.x+PIXEL_W/2; x<canvasPos.x+canvasSize.x;  x+=PIXEL_W )
    {
      // we on X and Y
      color c = get( int(x), int(y) );
        // Serial printout
      //println(x, y, red(c), green(c), blue(c) );
      
      // send over serial
      ardPort.write( int(red(c)));
      ardPort.write( int(green(c)));
      ardPort.write( int(blue(c)));
      
      // * For Y
    }
    // * for X    
  }
  // Send EOL
  ardPort.write(10);    // EOL char 10 or 13
  
  // Eo function  
}

void keyPressed()
{
  //if(key==){
  //  println("SPACEKEY");
  //}
  // EO keyPressed
}