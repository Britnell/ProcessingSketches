/*  
 *  analog version, - that wraps around nicely 
 *    - finding closest LED and lighting up
 *    - goes with arduino light_circular
 */

import processing.serial.*;
Serial ardPort;  // Create object from Serial class

String serialport = "COM18";
int NMPXL = 93;    // PIXELS to draw on


float wid = 1.8;
float rig = 0.8;

int rings = 6;
float rMax, rRad;
PVector cntr;
float lastLed = 0;
float lastAng = 0;
float idx=0;
float mag = 0;
float ang = 0;

void draw_rings()
{
  noFill();   stroke(255);   strokeWeight(6);
  
  for( int r=1; r<=rings; r++)
  {
    ellipse( width/2, height/2, r*rRad, r*rRad ); 
  }
  
  // ** Eo func
}

int wrap(float X, float max)
{
  //float ret = (X);
  while(X>=max)  X -= max;
  while(X<0) X += max;
  return int(X);
}


int get_ring( float mag )
{
  int ring=-1;
  for(int v=rings; v>0; v--) 
  {
     if( mag <=v*rRad/2 )
     {
       ring = v;
     }
     // Eo for
  }
  //println("RIng : ", moRing);
  if( ring==-1)  ring = 6;
  
  return ring;
}

int mRing = 0;

float angle_on_ring( float ang, int mRing)
{
  float id = 0;
  
  switch(mRing)
  {
    case 1:
      // 1 LEDs
      id = 0;
      break;
    case 2:
      // 8 LEDs
      id = (map(ang, -PI,PI, 0, 7 ));
      break;
    case 3:
      // 12 LEDs
      id = (map(ang, -PI,PI, 0, 11 ));
      break;
    case 4:
      // 16 LEDs
      id = (map(ang, -PI,PI, 0, 15 ));
      break;
    case 5:
      // 24 LEDs
      id = (map(ang, -PI,PI, 0, 23 ));
      break;
    case 6:
      // 32 LEDs
      id = (map(ang, -PI,PI, 0, 31 ));
      break;
    default:
      break;
  }
  
   return id;
}

void ring_mouse( float X, float Y , boolean chosering)
{
  PVector mo = new PVector(X,Y);
  PVector vec = PVector.sub(mo,cntr);
  mag = vec.mag();
  
  if(chosering)    mRing = get_ring( mag );
  
  ang = vec.heading() -HALF_PI ;
  if(ang<-PI)    ang = TWO_PI +ang +PI/50;
  
  //   ***   update ring & angle & mag 
  
  // ** Eo func 
}



void setup()
{
    size( 1000, 1000);
    
    rMax = height-20;
    rRad = rMax / 6;
    cntr = new PVector(width/2, height/2);
    
    background(0);
    draw_rings();
    
    //stroke(0); fill(0); textSize(80);
    //text("TEST",width/2,height/2,80);
    
    println("Serial ports available: ", Serial.list() );
    //String portName = Serial.list()[0];
    String portName = serialport;
      println("opening serial : ", portName );
    ardPort = new Serial(this, portName, 115200);
    
    // **  Eo setup
}


void draw()
{
  // --
  
  //if( abs(idx-lastLed)>0. ) {
  //if( idx != lastLed ) {
  if( ang != lastAng ) {
    // angle
    lastAng = ang;
    //idx = angle_on_ring( ang, mRing);
    
    light_rings( ang, mag );
    
    // ang & mag
    // mRing & idx
    
    // idx = angle mapped onto num of LED's 
    
    // on Change
    lastLed = (idx);  
    
    //light_led(lastLed, color( 255, 50, 0) );    //light_led_neighb(idx, mRing, color( 255, 50, 0) );    //draw_ring( mRing, idx );    //println( mRing, " : ", ang ," >> ", id);
  }
  delay(6);
  // ** Eo draw
}

// draw led from diff, with color, ring len, ring dimm
void draw_led( float dif, color col, int len, float dimm )
{
  int r,g,b;
  
  if(dif <= wid ) {
        //println( p, dif );
        dif = map(dif, 0,wid,  1,0 );
        r= int( red(col) *dif *dimm /2+128 );
        g= int( green(col) *dif *dimm /2+128 );
        b= int( blue(col) *dif *dimm /2+128 );
        ardPort.write(r);
        ardPort.write(g);
        ardPort.write(b);
        ardPort.write(',');
      }
      else if(dif > (len)-wid ) { // for wrap around
        //println( p, dif );
        dif = (len)-dif;
        dif = map(dif, 0,wid,  1,0 );
        r= int( red(col) *dif *dimm /2+128 );
        g= int( green(col) *dif *dimm /2+128 );
        b= int( blue(col) *dif *dimm /2+128 );
        ardPort.write(r);
        ardPort.write(g);
        ardPort.write(b);
        ardPort.write(',');
      }
      else {
        // Off pixel
        ardPort.write(128);
        ardPort.write(128);
        ardPort.write(128);
        ardPort.write(',');
      }
      
   // ** Eo func     
}

int ringleds( int ring)
{
  if(ring==1)
    return 1;
  else if(ring==2)
        return 8;
  else if(ring==3)
    return 12;
  else if(ring==4)
    return 16;
  else if(ring==5)
    return 24;
  else //if(ring==6)
    return 32;
}


color col = color( 0, 160, 255 );

void light_rings( float A, float M )
{
  // idx 0 to 93
  
  // idx = angle_on_ring( ang, mRing);
  //println( "\n lets draw : ", A, M );
  
  float magIdx = 0.55 + (mag) /( rRad/2 );
  //println(" mag_anal : ", magIdx );
  
   // loop thr pixel
      
    //for( int r=1; r<=6; r++ )
    for( int r=6; r>0; r-- )
    {
      // for each ring
      int len = ringleds(r);
      
      float dim = map( abs(magIdx- r ),  0,rig,  1,0 );
      //float dim = expon_second( abs(magIdx- r ),  0,rig,  1,0, 0.1 );
      
        dim = constrain( dim, 0,1);
        //if(dim > 0.5 )  dim = 1.0;
      
      //println(r, " : ", abs(magIdx- r ) );
      //println( r, " : ", dim );
      
      for( int l=0; l<len; l++)
      {
        // for each LED on this ring
        
        // get analog index
        idx = angle_on_ring( A , r);
        
        //println(" led diff : ", l, idx );
        
        float dif = abs(l-idx);  // diff from ang idx to led  
        // draw from diff
        draw_led( dif, col, len, dim );
        
        // * Eo for each LED
      }
     
      // * Eo for each Ring
    }
    
    ardPort.write(10);
  // ** Eo func
  
}

void mousePressed()
{
  ring_mouse( mouseX, mouseY, true );
    
 // ** Eo mouse pressed 
}


void mouseDragged()
{
  ring_mouse( mouseX, mouseY, false );
 // ** Eo mouse pressed 
} 

void mouseReleased()
{
  
   // **    Mouse Released 
}

void keyPressed()
{
  
}


// FActor : 
  // 0=SQU
  // +0.05 moves towards linear 
  // 0.1 close to Squ 
  // 0.2 feels nearly like half
  // 0.25 IS HALF
  // 0.20
  // 0.3 closer to linear
    
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
