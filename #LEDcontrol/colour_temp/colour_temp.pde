import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

import processing.serial.*;

// ** Serial
Serial ardPort;  // Create object from Serial class

String serialport = "COM25";
int NMPXL = 32;   // PIXELS to draw on
int STRIP_X = 8;
int STRIP_LEN = 256;

//
//   Colur temp from
//     http://www.vendian.org/mncharity/dir3/blackbody/UnstableURLs/bbr_color.html
//
//   separate-by-comma
//     https://delim.co/#
//

// from 1000 to 15000
int temp_R[] = { 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,254,252,250,247,245,243,241,239,238,236,234,233,231,229,228,227,225,224,223,221,220,219,218,217,216,215,214,213,212,211,210,209,208,207,207,206,205,204,204,203,202,202,201,200,200,199,198,198,197,197,196,196,195,195,194,194,193,193,192,192,191,191,190,190,190,189,189,188,188,188,187,187,187,186,186,186,185,185,185,184,184,184,184,183 };
int temp_G[] = { 51,69,82,93,102,111,118,124,130,135,141,146,152,157,162,166,170,174,178,182,185,189,192,195,198,201,203,206,208,211,213,215,217,219,221,223,225,226,228,229,231,232,234,235,237,238,239,240,241,243,244,245,246,247,248,249,249,250,248,247,245,244,243,241,240,239,238,237,236,234,233,233,232,231,230,229,228,227,226,226,225,224,223,223,222,221,221,220,220,219,218,218,217,217,216,216,215,215,214,214,213,213,212,212,212,211,211,210,210,210,209,209,208,208,208,207,207,207,206,206,206,206,205,205,205,204,204,204,204,203,203,203,203,202,202,202,202,201,201,201,201 };
int temp_B[] = { 0,0,0,0,0,0,0,0,0,0,11,29,41,51,60,69,77,84,91,98,105,111,118,124,130,135,141,146,151,156,161,166,171,175,180,184,188,192,196,200,204,208,211,215,218,222,225,228,231,234,237,240,243,245,248,251,253,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 };

Slider temp;
color sky;


float expon(float x, float x1, float x2, float y1, float y2 ){
 // exponential mode : 
 //   Y = M * X^2 + C
 //
 float M = (y2-y1) / ( (x2-x1)*(x2-x1) ) ; // calc gradient factor
 float y = M * (x-x1)*(x-x1) +y1;
 return y;
}

float expon_second(float x, float x1, float x2, float y1, float y2, float FA ){
 // exponential mode : 
 //   Y = A * X^2 + B * X + C
 //   1: C + Y1
 float C = y1;
 float B = FA;
 float A = (  (y2-y1) - (B*(x2-x1))  )  /  (  (x2-x1)*(x2-x1)  )   ;
 A = abs(A);
   float thisX = (x-x1);
 float y = A * thisX *thisX + B * thisX +C;
 return y;
}

public void setup()
{
  size(1600,600);
  
  temp = new Slider( 50, 200,   width*2/3, 50 );
  temp.name = "Colour temp.";
  temp.barcol = color(255,51,0);
  temp.min = 1000;
  temp.max = 15000;
  temp.val = 1000;
  temp.draw_slider();
  
  sky = color(255,51,0);
  
    // ** Eo setup
}


void send_to_strip(color col )
{
  float SOF = 0.1;
  // 3k turns pink > lower blue
  // 2k is yellow isntead of orange > lower Green
  float SOB = 0.008;
  float SOG = 0.008;
  float SOR = 0.06;
  
  println( "\nCOL : [", red(col), green(col), blue(col) );
  println( "EXP : [", expon_second(red(col),0,255,0,255,SOR),
                       expon_second(green(col),0,255,0,255,SOG),
                        expon_second(blue(col),0,255,0,255,SOB) );
  
  for( int i=0; i<1; i++)  // 0 to 32
  {
    for( int x=0; x<STRIP_X; x++){
      //ardPort.write( int(red(col)) );  // -this_drag-drag_dist
      //ardPort.write( int(green(col)) );
      //ardPort.write( int(blue(col)) );
      //ardPort.write( int( expon(red(col),0,255,0,255) ) );  // -this_drag-drag_dist
      //ardPort.write( int( expon(green(col),0,255,0,255) ) );
      //ardPort.write( int( expon(blue(col),0,255,0,255) ) );
      ardPort.write( int( expon_second(red(col),0,255,0,255,SOR) ) );  // -this_drag-drag_dist
      ardPort.write( int( expon_second(green(col),0,255,0,255,SOG) ) );
      ardPort.write( int( expon_second(blue(col),0,255,0,255,SOB) ) );
      ardPort.write( ',' );  
    }
    //println( red[i], " -> ", red[i]/2+128 );
    //println( red[i], green[i], blue[i], " + drag dist ", drag_dist );
    //println( i,  red[i], green[i], blue[i] );
    
  }
  ardPort.write(10);
  
  // Eo funct
}


public void color_click(int x, int y){
  
  
   if(temp.check_slider(x,y,false)){
     background(sky);
     
     // temp.val = 1000 to 15000 in +100 's
     int indx = int( (temp.val-1000)/100 ); // 0 to 14000
     sky = color( temp_R[indx], temp_G[indx], temp_B[indx] );
     //print( " Temp = ", temp.val, "\tCol : ", sky );
     println( " Temp = ", temp.val );
     println( "COL : [", red(sky), green(sky), blue(sky) );
     //send_to_strip( sky );
     
     background(sky);
     temp.draw_slider();
     
     //print("\t x:", indx );
     
     println();
     //sky = color(  );
   }
   
}


public void draw()
{  
  
}


public void mousePressed()
{
  color_click(mouseX,mouseY);
}

public void mouseDragged()
{
  color_click(mouseX,mouseY);
}


//   ***     Slider



class Slider {
  float xpos, ypos;
  float wid, hei;
  float val, min, max;
  int barcol;
  String name;

  Slider(float x, float y, float w, float h ) {
    xpos = x;
    ypos = y;
    wid = w;
    hei = h;

    val = 0;
    min = 0;
    max = 100;
    name="";

    barcol = color(random(255), random(255), random(255));

    //-
  }

  public boolean check_slider(int mx, int my, boolean redraw) {
    // check val
    boolean changed = false;

    if ( mx >xpos && mx <xpos+wid)
      if ( my >ypos && my < ypos+hei ) {
        // adjust
        val = (map(mx, xpos, xpos+wid, min, max));
        //println(val);
        // Redraw
        if(redraw)
          draw_slider();
        changed = true;
      }
    return changed;
  }

  public void draw_slider() {
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

 
