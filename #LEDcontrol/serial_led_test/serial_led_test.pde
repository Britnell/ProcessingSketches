/**
 * draw pixels and it sends to arduino
 *     TO DO
 *  - 
 */

//  **     file:///C:/Users/Thomas.Britnell/Documents/processing-3.5.3/modes/java/reference/libraries/serial/index.html



import processing.serial.*;

Serial ardPort;
int PIXELS = 12;

int hue = 0;

void rgb(){
  colorMode(RGB, 255, 255, 255);
}
void hsv(){
  colorMode(HSB, 360, 100, 100);
}

void setup()
{
  // * Canvas
  
  size(200, 200);
  
  ardPort = new Serial(this, "COM4", 115200);
  
  hsv();
  color c = color(120,100,100);
  
  background(c);
  
  rgb();
  
  
  // ** Eo setup
}




void draw()
{  
  if ( ardPort.available() > 0) {  // If data is available,
    //String msg = ardPort.readStringUntil(10);
    char ch = ardPort.readChar();
    print(ch);
  }
  //background(c);
  
  for(int x=0; x<PIXELS; x++){
    hsv();
    color c = color((hue+x*4)%360,100,100);
    rgb();
    int r = 128+int(red(c)/2);
    int g = 128+int(green(c)/2);
    int b = 128+int(blue(c)/2);
    //println(r,"\t",g,"\t",b);
    ardPort.write(r);
    ardPort.write(g);
    ardPort.write(b);
  }
  ardPort.write(13);
  
  hue += 6;
  if(hue >= 360)    hue = 0;
  
  //delay(1);
  
  // ** Eo draw
}


void mousePressed()
{
    
}


void mouseDragged()
{
    
}

void mouseReleased()
{
    
}