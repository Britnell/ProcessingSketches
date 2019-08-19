/**
 * draw image strip for 8x32 neopixel matrix 
 *
 *   Arduino sketch for receiving = dotstar_serial_1.in
 *  -  
 */

//  **     file:///C:/Users/Thomas.Britnell/Documents/processing-3.5.3/modes/java/reference/libraries/serial/index.html


import processing.serial.*;
import controlP5.*;


ControlP5 cp5;
ColorPicker cp;

Serial ardPort;  // Create object from Serial class
int val;      // Data received from the serial port

PVector canvasSize, canvasPos; 

String portName = "COM21";
int PIXEL_X = 32;
int PIXEL_Y = 8;
float PIXEL_W, PIXEL_H;

int send_period = 600;

int wheelPosX, wheelPosY, wheelSize;

color paintCol;

int send_index=0;
long last_send = 0;

void setup()
{
  
  // * Canvas
  
  colorMode(RGB, 255, 255, 255);
  paintCol = color( 40, 0, 0 );

  size(2000, 600 );

  canvasSize = new PVector( 1600, 400 );
  canvasPos = new PVector( 0, 0 );
  wheelPosX = 20 + int(canvasSize.x) ;
  wheelPosY = 10;
  wheelSize = 350;

  PIXEL_W = canvasSize.x / PIXEL_X;
  PIXEL_H = canvasSize.y / PIXEL_Y;

  // * Color wheel

  cp5 = new ControlP5( this );
  cp5.addColorWheel("c", wheelPosX, wheelPosY, wheelSize ).setRGB(color(10, 0, 0));

  cp = cp5.addColorPicker("picker")
    .setPosition(wheelPosX, wheelPosY+wheelSize )
    .setColorValue(cp5.get(ColorWheel.class, "c").getRGB());
  //cp.setSize( wheelSize, wheelSize);
  //cp.setBarHeight(20);

  //.setColorValue(color(255, 128, 0, 128));

  // * Serial

  print("Serial ports available: ");
  println( Serial.list() );
  //String portName = Serial.list()[0];
  print("opening serial : ");
  println( portName );
  ardPort = new Serial(this, portName, 115200);

  // * INit

  draw_grid();

  // ** Eo setup
}



void draw()
{
  // sync color selectors

  color wheel = cp5.get(ColorWheel.class, "c").getRGB();
  color picker = cp.getColorValue();

  if (picker!=paintCol) {
    paintCol = picker;
    cp5.get(ColorWheel.class, "c").setRGB(paintCol);
  }
  if (paintCol!=wheel) 
  {
    paintCol  = wheel;
    cp.setColorValue(paintCol );
  }

  // * Send pixels
  if (millis()-last_send > send_period )
  {
    //println("Sending");    
    send_pixels();

    send_index++;
    if (send_index==PIXEL_X)  send_index=0;

    last_send += send_period;
  }


  // ** Eo draw
}

void draw_grid()
{

  int frameS = 5;

  background(0);
  noFill();  
  stroke(255);  
  strokeWeight(frameS);
  rect(canvasPos.x-frameS, canvasPos.y-frameS, 
    canvasSize.x+frameS, canvasSize.y+frameS);

  stroke(255);    
  strokeWeight(2);
  for ( float y=canvasPos.y; y<canvasPos.y+canvasSize.y; y+=PIXEL_H )
  {
    line(canvasPos.x, canvasPos.y +y, 
      canvasPos.x+canvasSize.x, canvasPos.y+y );
  }
  for (float x=canvasPos.x; x<canvasPos.x+canvasSize.x; x+=PIXEL_W )
  {
    line(canvasPos.x +x, canvasPos.y, 
      canvasPos.x +x, canvasPos.y+canvasSize.y );
  }

  // Eo func
}


void draw_pixel( int X, int Y )
{
  // just draw the right rect

  // find index

  float rx = map( X, 
    canvasPos.x, canvasSize.x +canvasPos.x, 
    0, PIXEL_X );
  rx = constrain(rx, 0, PIXEL_X );

  float ry = map( Y, 
    canvasPos.y, canvasSize.y +canvasPos.y, 
    0, PIXEL_Y );
  ry = constrain(ry, 0, PIXEL_Y );

  int Rx = floor(rx);
  int Ry = floor(ry);  

  // fixed paint - fill(paintCol);
  //println(cp5.get(ColorWheel.class,"c").getRGB());
  fill(cp5.get(ColorWheel.class, "c").getRGB());

  noStroke();  
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
  //send_pixels();
}

void send_pixels()
{
  float xStart = canvasPos.x +PIXEL_W/2;
  float yStart = canvasPos.y +PIXEL_H/2;

  for ( int x=0; x<PIXEL_X; x++)
  {
    if (x%2==0)    
    {
      //EVEN - DOWN
      for ( int y=0; y<PIXEL_Y; y++)
      {
        float xSample = xStart + x*PIXEL_W;
        float ySample = yStart + y*PIXEL_H;
        //if(xSample>=canvasPos.x+canvasSize.x)    xSample -= canvasSize.x;
        color c = get( int(xSample), int(ySample) );
        ardPort.write( int(red(c)));
        ardPort.write( int(green(c)));
        ardPort.write( int(blue(c)));
        // for y
      }
    } else
    {
      // UNEVEN - UP
      for ( int y=7; y>=0; y--)
      {
        float xSample = xStart + x*PIXEL_W;
        float ySample = yStart + y*PIXEL_H;
        //if(xSample>=canvasPos.x+canvasSize.x)    xSample -= canvasSize.x;
        color c = get( int(xSample), int(ySample) );
        ardPort.write( int(red(c)));
        ardPort.write( int(green(c)));
        ardPort.write( int(blue(c)));
        // for y
      }
    }
    // * for X
  }
  // Send EOL
  ardPort.write(10);    // EOL char 10 or 13

  // Eo function
}

void clear_pixels()
{
  for ( float y=canvasPos.y+PIXEL_H/2; y<canvasPos.y+canvasSize.y; y+=PIXEL_H )
  {

    for (float x=canvasPos.x+PIXEL_W/2; x<canvasPos.x+canvasSize.x; x+=PIXEL_W )
    {
      ardPort.write(0);
      ardPort.write(0);
      ardPort.write(0);
    }
  }
  ardPort.write(10);
  // Eo func
}

void keyPressed()
{
  // clear on any keyboard press
  clear_pixels();

  // redraw screen
  draw_grid();

  // EO keyPressed
}
