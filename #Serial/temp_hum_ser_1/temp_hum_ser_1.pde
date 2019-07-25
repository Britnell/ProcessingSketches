/**
 * Simple Read
 * 
 * Read (string) data from the serial port 
 *   converts to integer
 *   plots data, and dy/dx, 
 *   takes averages over X values  + avrg dy/dx 
 */


import processing.serial.*;

// * Variables

int xStep = 4;
int gsrMin = 200;
int gsrMax = 500;
int graphs = 4;
int avrg_len = 20;

// * Funcitonal
Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int x = 0;
int lastGsr=0;
float lastAvrg=0;
int graphStep = 0;

void setup() 
{
  size(2000, 1200);
  graphStep = height/graphs;
  
  background(255);             // Set background to white
  print("Serial available: ");
  println( Serial.list() );
  
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  
}


String strT, strH ;
int tmp, hum;

int Ltmp = 0;
int Lhum = 0;

void draw()
{
  if ( myPort.available() > 0) {  // If data is available,
    
    //val = myPort.read();         // read it and store it in val
    
    //String str = myPort.readString();
    //print( "\nstr: ", str );
    
    strT = myPort.readStringUntil('.');
    strH = myPort.readStringUntil('%');
    
    if( strT!=null && strH!=null ){
        tmp = str_to_int(strT.substring(0,2) );
        hum = str_to_int(strH.substring(0,2) );
        
        //-
        println( tmp , "C - ", hum , "%" );
          
          // * Temp
          stroke(0,40,120);      strokeWeight(xStep);    
        point( x, map(tmp, 15, 50, 0,500  ));
        
          // * humidit
          stroke(120,40,0);
        point( x, map(hum, 0, 100, 500, 1000  ));
        
        stroke(0,40,120);    fill(255);         rect(30, 0, 300, 80 );
        
            textSize(30);    fill(0,40,120);
        text("Temperature : "+str(tmp) +" C", 35, 0 +30);
        
        stroke(0,40,120);  fill(255);         rect(30, 500, 300, 80 );
        
            textSize(30);    fill(0,40,120);
        text("Humidity : " +str(hum) +" %"  , 35, 500 +30);

        // **  Eo frame
        
        x+=xStep;
          if(x>=width)    x=0;
        
        Ltmp = tmp;
        Lhum = hum;
        
        // * Eo if
    }
    
    
  }
  // Draw
}



    // ** 
int[] avrg_array = new int[avrg_len];
int avrg_i = 0;

float averaging( int v){
  float average = 0;
  avrg_array[avrg_i] = v;
  // cyclical array index
  avrg_i++;
  if(avrg_i>=avrg_len)    avrg_i = 0;
  // calc avrg
  for(int i=0; i<avrg_len; i++){
    average += avrg_array[i];
  }
  average /= avrg_len;
  return average;
}



int str_to_int( String lin) {
   int num =0;
   int LE = lin.length();
   int minus = 0;
   if( int(lin.charAt(LE-1)) == 10)
     minus++;
   if( int(lin.charAt(LE-2)) == 13)
     minus++;
   LE -= minus;
   
   //print("str: ", lin);
   //println("\tLE: ", LE);
   
   for(int l=0; l<LE; l++) 
   {
      //println(l,":", (lin.charAt(l)) , int(lin.charAt(l)) );
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

//  *   Eo file