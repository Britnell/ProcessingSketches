/**
 * draw image strip for 8x32 neopixel matrix 
 *
 *   Arduino sketch for receiving = dotstar_serial_1.in
 *  -  
 */
// * My own colour selector
// *
// **  


import processing.serial.*;
import controlP5.*;


ControlP5 cp5;
ColorPicker cp;

Serial ardPort;  // Create object from Serial class
int val;      // Data received from the serial port

PVector canvasSize, canvasPos; 

String portName = "COM25";
int PIXEL_X = 32;
int PIXEL_Y = 8;
float PIXEL_W, PIXEL_H;

int send_period = 500;

int wheelPosX, wheelPosY, wheelSize;

color paintCol;

int send_index=0;
long last_send = 0;

int bars = 4;
Slider[] sliders = new Slider[bars];
float dimmer;

void setup()
{
  // * Canvas
  colorMode(RGB, 255, 255, 255);
  
  paintCol = color( 180, 0, 0 );

  size(1700, 700 );

  canvasSize = new PVector( 1600, 400 );
  canvasPos = new PVector( 0, 0 );
  wheelPosX = 20 + int(canvasSize.x) ;
  wheelPosY = 10;
  wheelSize = 350;

  PIXEL_W = canvasSize.x / PIXEL_X;
  PIXEL_H = canvasSize.y / PIXEL_Y;
  
  // * Colour sliders
  PVector sliderPos = new PVector(width/4, canvasPos.y + canvasSize.y +30);
  float bar_hei = 40;
  
  sliders[0] = new Slider( sliderPos.x, sliderPos.y +0            , width/2, bar_hei );
  sliders[1] = new Slider( sliderPos.x, sliderPos.y +1*1.5*bar_hei, width/2, bar_hei );
  sliders[2] = new Slider( sliderPos.x, sliderPos.y +2*1.5*bar_hei, width/2, bar_hei );
  sliders[3] = new Slider( sliderPos.x, sliderPos.y +3*1.5*bar_hei, width/2, bar_hei );
  sliders[0].name="R";
  sliders[1].name="G";
  sliders[2].name="B";
  sliders[3].name="dimm";
  sliders[0].barcol = color(180,0,0);
  sliders[1].barcol = color(0,180,0);
  sliders[2].barcol = color(0,0,180);
  sliders[3].barcol = color(100,100,100);
  sliders[0].val = red(paintCol);
  sliders[1].val = green(paintCol);
  sliders[2].val = blue(paintCol);
  sliders[3].val = 50;
  sliders[3].max = 100;
  dimmer = 0.5;
  // dimmer
  
  
  // * Serial

  print("Serial ports available: ");
    println( Serial.list() );
  //String portName = Serial.list()[0];
  print("opening serial : ");
  println( portName );
  ardPort = new Serial(this, portName, 115200);

  // * INit

  draw_grid();
  draw_sliders();
  col_rect();
  // ** Eo setup
}


void draw()
{
  // -
  


  // ** Eo draw
}

void draw_sliders(){
   for( int s=0; s<bars; s++)
     sliders[s].draw_slider(); 
}
void draw_grid()
{

  int frameS = 5;

  background(125); 
  //noFill();  
  stroke(255);  fill(0);
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
  
  float ry = map( Y, 
    canvasPos.y, canvasSize.y +canvasPos.y, 
    0, PIXEL_Y );
  
  //rx = constrain(rx, 0, PIXEL_X );
  //ry = constrain(ry, 0, PIXEL_Y );

  if( rx<0 || rx>PIXEL_X || ry<0 || ry > PIXEL_Y ){
    // ** Nothing
  }
  else 
  {
      int Rx = floor(rx);
      int Ry = floor(ry);  
    
      fill(paintCol);      noStroke();  
      rect( canvasPos.x +Rx* PIXEL_W, 
             canvasPos.y +Ry * PIXEL_H, 
              PIXEL_W, PIXEL_H );
              
      // * Send pixels
      if (millis()-last_send > send_period )
      {
        //println("Sending");    
        send_pixels();
        last_send = millis();
      }
  }
  
  
  // ** Eo draw pixel
}


void mousePressed()
{
  draw_pixel(mouseX, mouseY);
  mouse_func( mouseX, mouseY); 
  
  // * Eo mousePressed
}

void mouseDragged( )
{
  draw_pixel(mouseX, mouseY);
  mouse_func( mouseX, mouseY); 
  
  // * Eo mousePressed
}

void mouseReleased()
{
  send_pixels();
}


long last_frame=0;
void col_rect(){
  int Rsize = 130;
  fill(paintCol);  noStroke();
  rect( 40, height-40-Rsize,Rsize,Rsize );
}
void mouse_func( int x, int y)
{
  // Check bars for clicks and adjust colour
  for ( int b=0; b<bars; b++)
  {
    // check vals
    if (sliders[0].check_slider(x, y)) {
      paintCol = color(sliders[0].val,sliders[1].val,sliders[2].val);
      col_rect();
    } 
    else if (sliders[1].check_slider(x, y)) {
      paintCol = color(sliders[0].val,sliders[1].val,sliders[2].val);
      col_rect();
    }
    else if (sliders[2].check_slider(x, y)) {
      paintCol = color(sliders[0].val,sliders[1].val,sliders[2].val);
      col_rect();
    }
    else if (sliders[3].check_slider(x, y)) {
      dimmer = sliders[3].val/100;
      //col_rect();
      //send_pixels();
    }
    
    // Eo for
  }
  // Eo func
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
        //println( int(red(c)/2+128), int(green(c)/2+128), int(blue(c)/2+128) );
        
        ardPort.write( int(red(c)*dimmer /2+128));
        ardPort.write( int(green(c)*dimmer /2+128));
        ardPort.write( int(blue(c)*dimmer /2+128));
        ardPort.write(',');
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
        ardPort.write( int(red(c)*dimmer /2+128));
        ardPort.write( int(green(c)*dimmer /2+128));
        ardPort.write( int(blue(c)*dimmer /2+128));
        ardPort.write(',');
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
      ardPort.write(',');
    }
  }
  ardPort.write(10);
  // Eo func
}

void keyPressed()
{
  // clear on any keyboard press
  if(key==' '){
      clear_pixels();
      // redraw screen
      draw_grid();
      draw_sliders();
      col_rect();
  }
  else if(key=='r'){
     send_pixels(); 
  }
  else if(key=='c'){
     paintCol = color(0,0,0);
     sliders[0].val = 0;
     sliders[1].val = 0;
     sliders[2].val = 0;
     draw_sliders();
      col_rect();
  }
  // EO keyPressed
}


class Slider {
  float xpos, ypos;
  float wid, hei;
  float val, min, max;
  color barcol;
  String name;

  Slider(float x, float y, float w, float h ) {
    xpos = x;
    ypos = y;
    wid = w;
    hei = h;

    val = 0;
    min = 0;
    max = 255;
    name="";

    barcol = color(random(255), random(255), random(255));

    //-
  }
  
  // * checks for clicks and redraws if necessary
  boolean check_slider(int mx, int my) {
    // check val
    boolean changed = false;

    if ( mx >xpos && mx <xpos+wid)
      if ( my >ypos && my < ypos+hei ) {
        // adjust
        val = (map(mx, xpos, xpos+wid, min, max));
        //println(val);
        // Redraw
        draw_slider();
        changed = true;
      }
    return changed;
  }

  void draw_slider() {
    noStroke();  
    fill(0);
    rect(xpos, ypos, wid, hei );
    noStroke();  
    fill(barcol);
    rect(xpos, ypos+2, map(val, min, max, 0, wid), hei-4 );
    textSize(hei-4);   
    fill(barcol);
    text( name, xpos+wid+5, ypos+hei );
  }

  // ** Eo class
}
