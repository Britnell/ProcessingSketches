/*  
 *  analog version, - that wraps around nicely 
 *    - finding closest LED and lighting up
 *    - goes with arduino light_circular
 */

import processing.serial.*;
Serial ardPort;  // Create object from Serial class

String serialport = "COM18";
int NMPXL = 93;    // PIXELS to draw on

int sendPeriod = 50;
int rings = 6;
float rMax, rRad;
PVector cntr;
float lastLed = 0;
float idx=0;

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

void ring_mouse( float X, float Y , boolean chosering)
{
  PVector mo = new PVector(X,Y);
  PVector vec = PVector.sub(mo,cntr);
  
  if(chosering)
    mRing = get_ring( vec.mag() );
  
  if(true)
  {
    float ang = vec.heading() -HALF_PI ;
    if(ang<-PI)    ang = TWO_PI +ang +PI/50;
    
    //println( mRing, " : ", ang );
    float id=0;
    
    switch(mRing)
    {
      case 1:
        // 1 LEDs
        id = 92;
        break;
      case 2:
        // 8 LEDs
        id = (map(ang, -PI,PI, 84, 91 ));
        break;
      case 3:
        // 12 LEDs
        id = (map(ang, -PI,PI, 72, 83 ));
        break;
      case 4:
        // 16 LEDs
        id = (map(ang, -PI,PI, 56, 71 ));
        break;
      case 5:
        // 24 LEDs
        id = (map(ang, -PI,PI, 32, 55 ));
        break;
      case 6:
        // 32 LEDs
        id = (map(ang, -PI,PI, 0, 31 ));
        break;
      default:
        break;
    }
    idx = id;
    
    // id = round(id); // println( mRing, " : ", ang ," >> ", id);
    
    //if( mRing
    
  }
  
  // redraw
  //background(0);
  //draw_rings();
  
  //// pointer
  //strokeWeight(20); stroke(0,80,180);
  //point(X,Y);
  
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
  if( idx != lastLed ) {
    lastLed = (idx);
    //light_led(lastLed, color( 255, 50, 0) );
    light_led_neighb(idx, mRing, color( 255, 50, 0) );
    //println( mRing, " : ", ang ," >> ", id);
  }
  delay(6);
  // ** Eo draw
}


void light_led( int idx, color col )
{
   // loop thr pixel
   
    for( int p=0; p<NMPXL; p++){
      if(p==idx){
        // color pixel
        int r= int( red(col) /2+128 );
        int g= int( green(col) /2+128 );
        int b= int( blue(col) /2+128 );
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
      // Eo for - send each pixel
    }
    ardPort.write(10);
  
  // ** Eo func 
}


void light_led_neighb( float idx, int ring, color col )
{
  // idx 0 to 93
  
   // loop thr pixel
    int r, g, b;
    float wid = 1.8;
    int low=0;
    int hi=0;
    switch(ring)
    {
      case 1:
        low = 92; hi = 93;
        break;
      case 2:
        low = 84; hi = 92;
        break;
      case 3:
        low = 72; hi = 84;
        break;
      case 4:
        low = 56; hi = 72;
        break;
      case 5:
        low = 32; hi = 56;
        break;
      case 6:
        low = 0; hi = 32;
        break;
    }
    
    
    for( int p=0; p<low; p++) {
      // Off pixel
      ardPort.write(128);
      ardPort.write(128);
      ardPort.write(128);
      ardPort.write(',');
    }
    for( int p=low; p<hi; p++) {
      float dif = abs(p-idx);
      if(dif <= wid ) {
        //println( p, dif );
        dif = map(dif, 0,wid,  1,0 );
        r= int( red(col) *dif /2+128 );
        g= int( green(col) *dif /2+128 );
        b= int( blue(col) *dif /2+128 );
        ardPort.write(r);
        ardPort.write(g);
        ardPort.write(b);
        ardPort.write(',');
      }
      else if(dif > (hi-low)-wid ) { // for wrap around
        //println( p, dif );
        dif = (hi-low)-dif;
        dif = map(dif, 0,wid,  1,0 );
        r= int( red(col) *dif /2+128 );
        g= int( green(col) *dif /2+128 );
        b= int( blue(col) *dif /2+128 );
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
      // Eo for - send each pixel
    }
    for( int p=hi; p<93; p++) {
      // Off pixel
      ardPort.write(128);
      ardPort.write(128);
      ardPort.write(128);
      ardPort.write(',');
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
