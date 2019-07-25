/**
 * Read data from serial. next create a grafica plot
 *
 */


import processing.serial.*;
import grafica.*;

    // * Funcitonal
Serial myPort;  // Create object from Serial class
GPlot tempPlot, humiPlot;

  // specs
int margin = 20;
int tempVals = 90;



void setup() 
{
  size(2000, 3000 );
  background(255);           
  
    // * init grafica
  
  // * TEMPERATURE
  
  tempPlot = new GPlot(this);
    // size
  tempPlot.setPos(margin,margin);
  tempPlot.setOuterDim(width-4*margin, height/2 -2*margin);
  tempPlot.setAllFontProperties("SansSerif", 100, 30);
    // label
  tempPlot.setTitleText("Ambient indoor Temperature");
  //tempPlot.getXAxis().setAxisLabelText("time");
  tempPlot.getYAxis().setAxisLabelText("Temperatire [ in Degree C] ");
  tempPlot.startHistograms(GPlot.VERTICAL);
  tempPlot.setYLim(15, 35);
  tempPlot.setXLim( 0,tempVals);
  
  
  for(int t=0; t<tempVals-5; t++){
    tempPlot.addPoint( t, 23);
  }
  x=tempVals-5;
  
  
  
  // * HUMIDITY
  
  humiPlot = new GPlot(this);
    // size
  humiPlot.setPos(margin,height/2+margin);
  humiPlot.setOuterDim(width-4*margin, height/2 -2*margin);
  humiPlot.setAllFontProperties("SansSerif", 100, 30);
    // label
  humiPlot.setTitleText("Ambient indoor Humidity");
  //tempPlot.getXAxis().setAxisLabelText("time");
  humiPlot.getYAxis().setAxisLabelText("relative humidity [ in % ] ");
  humiPlot.setYLim( 0, 99);
  humiPlot.setXLim( 0, tempVals);
  
  
  // * Init Serial
  print("Serial available: ");    println( Serial.list() );
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  
  // *   Eo setup
}


String strT, strH ;
int tmp, hum;

int Ltmp = 0;
int Lhum = 0;

int x=0;
int tempWindow=0;
void draw()
{
  // - 
  
  if ( myPort.available() > 0) {  // If data is available,
    
    //val = myPort.read();         // read it and store it in val
    
    strT = myPort.readStringUntil('.');
    strH = myPort.readStringUntil('%');
    
    if( strT!=null && strH!=null ){
        tmp = str_to_int(strT.substring(0,2) );
        hum = str_to_int(strH.substring(0,2) );
        
        //-
        println( tmp , "C - ", hum , "%" );
        
        tempPlot.addPoint( x , tmp );
        humiPlot.addPoint( x, hum );
            x++;
            
        if(x-tempWindow>tempVals){
          tempWindow+=1;
          tempPlot.setXLim( tempWindow, x );
          humiPlot.setXLim( tempWindow, x );
          
          //println("x is ", x, " window is ", tempWindow);
          //tempPlot.moveHorizontalAxesLim( 1 ); 
        }
        
        
        // **  Eo frame
        
          // only draw after change!
        //tempPlot.defaultDraw();
        tempPlot.beginDraw();
        tempPlot.drawBackground();
        tempPlot.drawBox();
        tempPlot.drawXAxis();
        tempPlot.drawYAxis();
        tempPlot.drawTitle();
        tempPlot.drawHistograms();
        tempPlot.endDraw();
        // humidity
        humiPlot.defaultDraw();
  
          // update
        Ltmp = tmp;
        Lhum = hum;
        
        // * Eo if !=null
    }
    
    
    // Eo serial.available
  }
  
  
  // Draw
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
     // check for unexpected chars....lin.charAt(l) 
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