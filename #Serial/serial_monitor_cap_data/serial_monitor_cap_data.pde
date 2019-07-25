/**
 * Simple Read
 * 
 * Read data from the serial port and change the color of a rectangle
 * when a switch connected to a Wiring or Arduino board is pressed and released.
 * This example works with the Wiring / Arduino program that follows below.
 * 
 */


import processing.serial.*;

Serial myPort;  // Create object from Serial class

int [] filter = new int[8];
color filter_c = color( 10,180,40);

int [] base = new int [8];
color base_c = color( 100,100,20);
int [] diff = new int[8];


int peak_th = 5;
int neighb_th = 3;

int direction = 0;
float smooth;
float debounce = 0.3;

int new_touch = 1;


void setup() 
{
  size(1200, 800);
  frameRate(600);
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  print("Serial available: ");
  println( Serial.list() );
  
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 230400);
  
}

void draw()
{
  // ###  Read Serial data 
  // #
  if ( myPort.available() > 0) {  // If data is available,
    
    // read line
    String sis = myPort.readStringUntil('\n');
    
    if(sis != null) {
      
      // --- evaluate serial line
      // into global array
      //check_line(sis);
      check_line_hash(sis);
    }
    
    //-- Eo serial data
  }
  
  
  // ### draw
  // #  
  background(255);
  graph_array(filter, 60, 10, 300, filter_c);
  //graph_array(base, 300, 350, 600, base_c );
  
  
  //--prox rect( 0, 620,  prox, 100 );
  
  //graph_array(diff, 10, 620, 800, color(0,0,0) );
  
  // Eo draw
}


void check_line_hash( String lin) {
  int[] ray;
    
  // check beginning char #
  if( lin.charAt(0)=='#') {
    println(lin);
    
    filter = line_array( lin.substring(1), 12 );
    
   
   // Eo if #
  }
  else if( lin.charAt(0)==':') {
    println(lin);
    
    filter = line_array( lin.substring(1), 12 );
    
   
   // Eo if #
  }
  //
}

void check_line( String lin) {
  int[] ray;
    
  // check beginning char #
  if( lin.charAt(0)=='#') {
    char id = lin.charAt(1);
    
    //print( "b_", lin.substring(3) );
    if( id == 'f' ) {
      
      // filter
      println(lin);
      
      filter = line_array( lin.substring(3), 8 );
      
    }
    else if( id == 'b' ) {
          // baseline
          print(lin); 
          base = line_array( lin.substring(3), 8 ); 
        }
     else if( id == 't' ) {
         println(lin);
     }
    /* else if( id == 'p' ) {

       int intz = line_array( lin.substring(3), 1)[0];
       println( "_p:", intz );
       
       prox = map( intz , 0, 5, 0, width );
        
       //prox = map( 
    }    */
   
   // Eo if #
  }
  else {
    // touched line
    //println(lin);
    
  }
  //
}


void graph_array( int[] ray, float scal, int startY, int endY, color Cc ) 
{
   int LE = ray.length;
   float W = width / LE;
   float H = endY - startY;
   
   for(int i=0; i< LE; i++)
   {
     //println( "i",i,"r",ray[i]);
     float m = map( float(ray[i]), 0, scal, 0, H);
     
     noStroke();
     fill(Cc);
     rect( i*W, endY-m, W,  m ); 
   }
  
}


// array from serial line
int[] line_array( String lin, int len) {
  int[] ray = new int[len];
  
  int i=0;
  int comma;
  String sub;
  
  for( int x=0; x<len; x++) {
    
    comma = lin.indexOf(',', i);
    if( comma > 0 ) {
      ray[x] = str_to_int(lin.substring(i, comma));
    }
    else {
      ray[x] = 0;
    }
    //println("#", sub, ":", tt+1);
    
    i = comma+1;     
  } // Eo for
  
  return ray;
  // Eo line_array
}

int wrap_12( int X) {
 if( X >= 12)
   X -= 12;
 else if( X < 0)
  X += 12; 
 
 return X;
}


int str_to_int( String lin) {
   int num =0;
   int LE = lin.length();
   
   for(int l=0; l<LE; l++) 
   {
      
      num += char_to_int( lin.charAt(l) ) * pow(10, LE-1-l );
      // Eo for
   }
   return num;
  // Eo func
}


int char_to_int( char A) {
  int num =0;
  
  switch(A) {
    case '0':
      num = 0;
      break;
    case '1':
      num = 1;
      break;
    case '2':
      num = 2;
      break;
    case '3':
      num = 3;
      break;
    case '4':
      num = 4;
      break;
    case '5':
      num = 5;
      break;
    case '6':
      num = 6;
      break;
    case '7':
      num = 7;
      break;
    case '8':
      num = 8;
      break;
    case '9':
      num = 9;
      break;
  }
  return num;
  // Eo func 
}
