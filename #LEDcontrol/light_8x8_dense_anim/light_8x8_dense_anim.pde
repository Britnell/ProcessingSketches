/**
 * draw pixels in 8x8 grid & it sends to arduino serial.
 *   Arduino sketch for receiving = dotstar_serial_1.ino
 */

import processing.serial.*;
import controlP5.*;
ControlP5 cp5;
ColorPicker cp;

Serial ardPort;  // Create object from Serial class
int val;      // Data received from the serial port
String serialport = "COM29";  // COM29
float FPS = 10;
// C - for circle  ,  S - for Snake
char animation = 'S';
PVector canvasSize, canvasPos; 

int PIXEL_X = 8;
int PIXEL_Y = 8;
float PIXEL_W, PIXEL_H;

int wheelPosX, wheelPosY, wheelSize;

color paintCol;

Dot d1, d2;

void setup()
{
  // * Canvas
  frameRate(FPS);  // fps
  
  colorMode(RGB, 255, 255, 255);
  paintCol = color( 40, 0, 0 );
  
  size(1200, 600 );

  canvasSize = new PVector( 400,400 );
  canvasPos = new PVector( 0, 0 );
  wheelPosX = 410;
  wheelPosY = 10;
  wheelSize = 350;
  
  PIXEL_W = canvasSize.x / PIXEL_X;
  PIXEL_H = canvasSize.y / PIXEL_Y;
  
  // * Color wheel
  
  cp5 = new ControlP5( this );
  cp5.addColorWheel("c" , wheelPosX , wheelPosY , wheelSize ).setRGB(color(10,0,0));
  
  cp = cp5.addColorPicker("picker")
        .setPosition(wheelPosX, wheelPosY+wheelSize )
          .setColorValue(cp5.get(ColorWheel.class,"c").getRGB());
  //cp.setSize( wheelSize, wheelSize);
  //cp.setBarHeight(20);
  if(animation=='C'){
    d1 = new Dot(0,0,'r');
    d2 = new Dot(PIXEL_X-1, PIXEL_Y-1, 'l' );
  }
  else {
    d1 = new Dot(0,0,'r');
    d2 = new Dot(PIXEL_X/2, PIXEL_Y/2, 'l' );
  }
  
        //.setColorValue(color(255, 128, 0, 128));
  
  // * Serial
  
  print("Serial ports available: ");
    println( Serial.list() );
  //String portName = Serial.list()[0];
  String portName = serialport;
    print("opening serial : ");
    println( portName );
  ardPort = new Serial(this, portName, 115200);
  
  // * INit
  
  draw_grid();
  
  // ** Eo setup
}



class Dot
{
   PVector pos;
   char dir;
   
   Dot( int x, int y, char d){
     pos = new PVector(x,y);
     dir = d;
   }
   
    PVector animate()
    {
      switch(dir)
      {
        case 'r':
          if(pos.x<PIXEL_X-1)
            pos.x++;
          else{
            dir = 'd';
            pos.y++;
          }
          break;
        case 'd':
          if(pos.y<PIXEL_Y-1)
            pos.y++;
          else{
            dir='l';
            pos.x--;
          }
          break;
        case 'l':
          if(pos.x>0)
            pos.x--;
          else {
            dir = 'u';
            pos.y--;
          }
          break;
        case 'u':
          if(pos.y>0)
            pos.y--;
          else {
            dir='r';
            pos.x++;
          }
          break;
        
        // Eo switch
      }
      return pos;
      // Eo func
    }
    
    PVector animate_2()
    {
      if(dir=='r'){
         pos.x++;
         if(pos.x==PIXEL_X){
           pos.x--;
           dir='l';
           pos.y ++;
            if(pos.y==PIXEL_Y)
              pos.y = 0;
         }
      }
      else {
        pos.x--;
        if(pos.x<0){
          pos.x++;
          dir='r';
          pos.y ++;
          if(pos.y==PIXEL_Y)
            pos.y = 0;
          
        }
      }
      return pos;
      // Eo func
    }
    
    // ** Eo class
}

void draw()
{
  //paintCol
  color wheel = cp5.get(ColorWheel.class,"c").getRGB();
  color picker = cp.getColorValue();
  
  if(picker!=paintCol){
   paintCol = picker;
   cp5.get(ColorWheel.class,"c").setRGB(paintCol);
  }
  if(paintCol!=wheel) 
  {
    paintCol  = wheel;
    cp.setColorValue(paintCol );
  }
  
  // erase last
  erase_pixel_index(d1.pos.x,d1.pos.y);
  erase_pixel_index(d2.pos.x,d2.pos.y);
  
  // animate, step X,Y  vals
  if(animation=='C') {
    d1.animate();
    d2.animate();
  }
  else {
    d1.animate_2();
    d2.animate_2();
  }
  
  // draw new
  //println("Draw : ", aX, aY);
  draw_pixel_index(d1.pos.x, d1.pos.y, 0 );
  draw_pixel_index(d2.pos.x, d2.pos.y, 2 );
  
  // Send at the end of each frame
  send_pixels();
  
  // ** Eo draw
}

void draw_grid()
{
  
  int frameS = 5;
  
  background(0);
  noFill();  stroke(255);  strokeWeight(frameS);
  rect(canvasPos.x-frameS, canvasPos.y-frameS, 
        canvasSize.x+frameS, canvasSize.y+frameS);
  
  stroke(255);    strokeWeight(2);
  for( float y=canvasPos.y; y<canvasPos.y+canvasSize.y;  y+=PIXEL_H )
  {
    line(canvasPos.x, canvasPos.y +y,  
          canvasPos.x+canvasSize.x, canvasPos.y+y );
  }
  for(float x=canvasPos.x; x<canvasPos.x+canvasSize.x;  x+=PIXEL_W )
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
             canvasPos.x, canvasSize.x +canvasPos.x ,
             0, PIXEL_X );
  rx = constrain(rx, 0, PIXEL_X );
  
  float ry = map( Y, 
             canvasPos.y, canvasSize.y +canvasPos.y ,
             0, PIXEL_Y );
  ry = constrain(ry, 0, PIXEL_Y );
  
  int Rx = floor(rx);
  int Ry = floor(ry);  
  
  // fixed paint - fill(paintCol);
  //println(cp5.get(ColorWheel.class,"c").getRGB());
  fill(cp5.get(ColorWheel.class,"c").getRGB());
  
  noStroke();  
  rect( canvasPos.x +Rx* PIXEL_W, 
         canvasPos.y +Ry * PIXEL_H,
         PIXEL_W, PIXEL_H );
  
  // ** Eo draw pixel
}

void draw_pixel_index( float X, float Y, int Cadj )
{
  // just draw the right rect
  
  // find index
  
  //float rx = map( X, 
  //           canvasPos.x, canvasSize.x +canvasPos.x ,
  //           0, PIXEL_X );
  //rx = constrain(rx, 0, PIXEL_X );
  float rx = X;
  
  //float ry = map( Y, 
  //           canvasPos.y, canvasSize.y +canvasPos.y ,
  //           0, PIXEL_Y );
  //ry = constrain(ry, 0, PIXEL_Y );
  float ry = Y;
  
  int Rx = floor(rx);
  int Ry = floor(ry);  
  
  // fixed paint - fill(paintCol);
  //println(cp5.get(ColorWheel.class,"c").getRGB());
  color C = cp5.get(ColorWheel.class,"c").getRGB();
  //C = color( red(C)+red(Cadj), green(C)+green(Cadj), blue(C)+blue(Cadj) );
  if(Cadj%3==0){
    C = color( red(C), green(C), blue(C) );
  }
  else if(Cadj%3==1){
    C = color( blue(C), red(C), green(C) ); 
  }
  else {  //if(Cadj%3==2)
    C = color( green(C), blue(C), red(C) ); 
  }
 
  fill(C);
  
  noStroke();  
  rect( canvasPos.x +Rx* PIXEL_W, 
         canvasPos.y +Ry * PIXEL_H,
         PIXEL_W, PIXEL_H );
  
  // ** Eo draw pixel
}

void erase_pixel_index( float X, float Y )
{
  // just draw the right rect
  
  // find index
  
  //float rx = map( X, 
  //           canvasPos.x, canvasSize.x +canvasPos.x ,
  //           0, PIXEL_X );
  //rx = constrain(rx, 0, PIXEL_X );
  float rx = X;
  
  //float ry = map( Y, 
  //           canvasPos.y, canvasSize.y +canvasPos.y ,
  //           0, PIXEL_Y );
  //ry = constrain(ry, 0, PIXEL_Y );
  float ry = Y;
  
  int Rx = floor(rx);
  int Ry = floor(ry);  
  
  // fixed paint - fill(paintCol);
  //println(cp5.get(ColorWheel.class,"c").getRGB());
  //fill(cp5.get(ColorWheel.class,"c").getRGB());
  fill(0);
  
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
      ardPort.write( int(red(c)/2+128 ));
      ardPort.write( int(green(c)/2+128 ));
      ardPort.write( int(blue(c)/2+128 ));
      ardPort.write(',');
      // * For Y
    }
    // * for X    
  }
  // Send EOL
  ardPort.write(10);    // EOL char 10 or 13
  
  // Eo function  
}

void clear_pixels()
{
  for( float y=canvasPos.y+PIXEL_H/2; y<canvasPos.y+canvasSize.y;  y+=PIXEL_H )
  {
    
    for(float x=canvasPos.x+PIXEL_W/2; x<canvasPos.x+canvasSize.x;  x+=PIXEL_W )
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
