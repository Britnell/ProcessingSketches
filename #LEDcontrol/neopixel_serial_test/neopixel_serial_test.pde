

import processing.serial.*;
Serial ardPort;  // Create object from Serial class

String serialport = "COM30";
int NMPXL = 93;    // PIXELS to draw on

int sendPeriod = 50;

void setup()
{
    size( 600, 400);
    
    //
    background(255);
    
    stroke(0); fill(0); textSize(80);
    text("TEST",width/2,height/2,80);
    
    
    println("Serial ports available: ", Serial.list() );
    //String portName = Serial.list()[0];
    String portName = serialport;
      println("opening serial : ", portName );
    ardPort = new Serial(this, portName, 115200);
    
    // **  Eo setup
}


void draw()
{
  //--
  for( int i=0; i<NMPXL; i++){
    for( int p=0; p<NMPXL; p++){
      if(p==i){
        // color pixel
        int r= int((0) /2+128 );
        int g= int((250) /2+128 );
        int b= int((160) /2+128 );
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
    delay(3);  //1ms CRASHES, 2ms skips , 3ms seems min
    //Eo for - each light pixel
  }
  
  // ** Eo draw
}


void mousePressed()
{
  
    
 // ** Eo mouse pressed 
}


void mouseDragged()
{
  
 // ** Eo mouse pressed 
} 

void mouseReleased()
{
  
   // **    Mouse Released 
}

void keyPressed()
{
  
}
