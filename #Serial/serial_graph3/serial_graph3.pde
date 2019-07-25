  /**
 * 
 * Read data as raw bytes from the serial port 
 *   converts to integer
 *   plots data, and dy/dx, 
 *   takes averages over X values  + avrg dy/dx
 */


import processing.serial.*;

// * Variables

int xStep = 1;
int gsrMin = 10;
int gsrMax = 90;
int diffScale = 5;
int graphs = 2;
int avrg_len = 4;
int timelapsefactor = 2;


// * Funcitonal
Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int x = 0;
float GSRlast=0;
float GSRdiff_last = 0;
int graphStep = 0;
int a = 0;
int ser_last =0;


void setup() 
{
  //size(2000, 1200);
  size(1200,800);
  graphStep = height/graphs;
  
  background(255);             // Set background to white
  println("Serial available: ", Serial.list().toString() );
  println("connecting to Serial ", Serial.list()[1]);
  String portName = Serial.list()[1];
  //myPort = new Serial(this, portName, 115200);
  myPort = new Serial(this, portName, 9600);
  
}


float peak_sum = 0;
int peak_len = 0;
int last_val = 0;
//float last_peak = 0;

float graph(float val, int graph){
  return map(val, gsrMin, gsrMax+20, graph*graphStep,(graph+1)*graphStep);
}


void draw()
{
  if ( myPort.available() > 0) {  // If data is available,
    int graph=0;
    
    int ser_val = myPort.read();
    float GSRav = averaging(ser_val);
    float GSRdiff = (GSRav -GSRlast);
    
       //    **        Print
    
    
    
      //    **         Peaks
    //print( " int  ", ser_val );
    //  print("\t\tavrg  ", GSRav);
    //  print("\t\tdiff  ", GSRdiff);
    //  println("\t\t peak:\t", peak_sum,"\t\t / length _ ", peak_len );
      
        
    //peak_detect(GSRdiff);
    if(GSRdiff<=0) {
      peak_sum -= GSRdiff;
      peak_len++;
    }
    else {
      if(peak_sum > 1.0) {
          print( " int  ", ser_val );
            print("\t\tavrg  ", GSRav);
            print("\t\tdiff  ", GSRdiff);
            println("\t\t peak:\t", peak_sum,"\t\t / length _ ", peak_len );
        //peak_sum = -peak_sum;
        
          // ** draw peak markers
        //fill(40,180,40);    noStroke();
        stroke(80,180,40);    noFill();    strokeWeight(2);
        
        line( x-2, graph(GSRav,graph),
                x-2, graph(GSRav+peak_sum, graph) );
        textSize(20);      fill(80,180,40); 
        text( peak_sum ,x-45, graph(GSRav+peak_sum, graph)+30 );
        
        //line( x-2, map(GSRav, gsrMin, gsrMax+20, graph*graphStep,(graph+1)*graphStep),
        //        x-2, map(GSRav+peak_sum, gsrMin, gsrMax+20, graph*graphStep,(graph+1)*graphStep) );
        //rect(x-peak_len, map(GSRav+peak_sum, gsrMin, gsrMax, graph*graphStep,(graph+1)*graphStep  ),         
        // peak_len, map(peak_sum, gsrMin, gsrMax, graph*graphStep,(graph+1)*graphStep  ) );
        
      }
      
      peak_sum = 0;
      peak_len = 0;
    }
    
    
    
    
        //     ****   Graph
    
    
              // * gsr
              
      strokeWeight(xStep);
      // * Serial
      stroke(180,80,80);          
    //point( x, map(ser_val, gsrMin, gsrMax, graph*graphStep,(graph+1)*graphStep  ));
    line( x, map(ser_val, gsrMin, gsrMax+20, graph*graphStep,(graph+1)*graphStep  ),
           x-1, map(ser_last, gsrMin, gsrMax+20, graph*graphStep,(graph+1)*graphStep  ) );
      // * Average
      stroke(10,40,120);
    //point( x, map(GSRav, gsrMin, gsrMax, graph*graphStep,(graph+1)*graphStep  ));
    line( x, map(GSRav, gsrMin, gsrMax+20, graph*graphStep,(graph+1)*graphStep  ),
           x-1, map(GSRlast, gsrMin, gsrMax+20, graph*graphStep,(graph+1)*graphStep  ));
      
      //graph++;
      // ** diff peak tracking
      
      stroke(80,0,80);    strokeWeight(4);  noFill();
    line(x, (graph+1.0)*graphStep, x, ((graph+1.0)*graphStep) -10*peak_sum);
    
      graph++;
      // * Diff
      // * avrg diff
      stroke(80,0,80);    
    
      strokeWeight(xStep);
    //point( x, map(GSRdiff, -diffScale, diffScale, graph*graphStep,(graph+1)*graphStep  ));
    //line( x, map(GSRdiff, -diffScale, diffScale, (graph+0.5)*graphStep,(graph+1)*graphStep  ),
    //       x-1, map(GSRdiff_last, -diffScale, diffScale, (graph+0.5)*graphStep,(graph+1)*graphStep  ));
    //point( x, map(GSRdiff, -diffScale, diffScale, graph*graphStep,(graph+1)*graphStep  ));
    line( x, map(GSRdiff, -diffScale, diffScale, graph*graphStep,(graph+1)*graphStep  ),
           x-1, map(GSRdiff_last, -diffScale, diffScale, graph*graphStep,(graph+1)*graphStep  ));
           
    
      // * overdraw line
      stroke(255);    strokeWeight(xStep+2);
    line( x+xStep, 0, x+xStep, height);
      // * marker line
      stroke(80,40,40);    strokeWeight(xStep/2);
    line( x+2*xStep, 0, x+2*xStep, height);
    
      // * divider line 
      stroke(0,90,140);  strokeWeight(2);
    for( int l=0; l<graphs; l++) {
      line(0,l*graphStep, width, l*graphStep);
    }
      // * Text
    if( x<200){
       textSize(30);    fill(0,40,120);
       text("GSR & avrg", 35, 0 +30);
       text("peaksize", 35, 1*graphStep +30);
       //text("AVRG", 35, 2*graphStep +30);
       //text(" _diff", 35, 3*graphStep +30);
    }
        
      // **  Eo frame  
    x+=xStep;
    if(x>=width)    x=0;
    GSRlast = GSRav;
    ser_last = ser_val;
    GSRdiff_last = GSRdiff;
    
    //println();
  }
  
  // Draw
}



      //      **
      //      ***      Functions
      //     **
      
      
int peak_detect(float val){
    // actually since my graphs are inverted its a trough detect
    if(val<=0) {
      peak_sum += val;
      peak_len++;
    }
    else {
      
      println("\t\t peak:\t", peak_sum,"\t\t / length _ ", peak_len );
      peak_sum = 0;
      peak_len = 0;
      return int(-peak_sum);
    }
    
    return 0;  
}

int TL_s = timelapsefactor;
int TL_i = 0;
int TL_x = 0;
float TL_sum = 0;
float TL_last = 0;

float TL_diff = 0;
float TL_diffL = 0;
float avrgLine_last =0;
float diffLine_last = 0;

void timelapse( int v){
  TL_sum += v;
  TL_i++;
  
  if(TL_i==TL_s){
    // average
    TL_sum /= TL_s;  
    TL_diff = TL_sum -TL_last;  // dy/dx
    
    // draw now
    
      // * avrg
    //println("TL : ", TL_x, "S= ", TL_sum);
      float plotVal = map( TL_sum, gsrMin, gsrMax, 2*graphStep,(3)*graphStep );
      stroke(20,0,0);  strokeWeight(1);
    //point( TL_x, map( TL_sum, gsrMin, gsrMax, 2*graphStep,(3)*graphStep ));
    line( TL_x, plotVal,
          TL_x-1, avrgLine_last );
      // * difference
      stroke(100,40,0);  strokeWeight(1);
      float plotDiff = map( TL_diff, -20, 20, 3*graphStep,4*graphStep );
    line( TL_x, plotDiff,
          TL_x-1, diffLine_last );
    
      // OVerdraw
      stroke(255); strokeWeight(2);
    line(TL_x+4, 2*graphStep, TL_x+4, height);
    // OVerdraw
      stroke(120,40,0); strokeWeight(1);
    line(TL_x+5, 2*graphStep, TL_x+5, height);
    
    // Reset
    TL_x++;    if(TL_x>=width)    TL_x=-4;
    TL_i=0;
    avrgLine_last = plotVal;
    diffLine_last = plotDiff;
    TL_diffL = plotDiff;
    TL_last = TL_sum;
    TL_sum = 0;    
  }
  // Eo timelapse
}




    // ** 
int[] avrg_array = new int[avrg_len];
int avrg_i = 0;
int avrg_ful= 0;

float averaging( int v){
  float average = 0;
  // put in array
  avrg_array[avrg_i] = v;
  // cyclical array index
  avrg_i++;
  if(avrg_i>=avrg_len) {    avrg_i = 0;    avrg_ful=1;    }
  
  // calc avrg
  if(avrg_ful==0) {
    for(int i=0; i<avrg_i; i++){
      average += avrg_array[i];
    }
    average /= avrg_i;
    //return 0;
  }
  else  {
    for(int i=0; i<avrg_len; i++){
      average += avrg_array[i];
    }
    average /= avrg_len;
  }
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
   print("str: ", lin);
   println("\tLE: ", LE);
   
   for(int l=0; l<LE; l++) 
   {
      println(l,":", (lin.charAt(l)) , int(lin.charAt(l)) );
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