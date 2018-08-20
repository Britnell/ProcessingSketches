// Example by Tom Igoe

import processing.serial.*;

// The serial port:
Serial mbed;       

int step = 2;
int x = 1;


void setup()
{
  // List all the available serial ports:
  size(1920, 500);
  background(255);
  stroke(0);
  strokeWeight(step);
  
  printArray(Serial.list());
  
  // Open the port you are using at the rate you want:
  mbed = new Serial(this, Serial.list()[0], 115200);
} 


void draw()
{
  int N;
  
  // Send a capital A out the serial port:
  while (mbed.available() > 0) {
    // Byte / char
    //int inByte = mbed.read();
    //println(inByte);
    
    String inBuffer = mbed.readStringUntil('\n'); 
    //mbed.readString();
    
    if (inBuffer != null) {
      //print(inBuffer);  print(" ");
      N = str_to_int(inBuffer);
      //println(N);
      strokeWeight(4);
      stroke(255);
      line(x,0,x,height);
      
      strokeWeight(step);
      stroke(0);
      line(x, map(N, 0, 65600,  0,height), x,height); 
      
      strokeWeight(1);
      stroke(190,0,0);
      line(x+step, 0, x+step,height); 
      x += step;
      
      if(x>= width)
        x = 1;
    }
    
      
    // Eo while
  }
  
  //printArray( mbed.read() );
  // Eo draw
}

int str_to_int( String buff)
{
  int res = 0;
  //println( buff.length() );
  int L = buff.length();
  
  for(int x=0; x<buff.length(); x++)
  {
    if(buff.charAt(x) != '\n')
    {
      //print( (buff.charAt(x) ) );    print(" ");
      //print( int(buff.charAt(x) ) - 48 );  print(" ");
      
      res += pow( 10, (L-x-2) ) * (int(buff.charAt(x) ) - 48); 
      //println(res);
    }
  }
  return res;
}

//