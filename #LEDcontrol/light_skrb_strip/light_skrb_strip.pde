

import processing.serial.*;
Serial ardPort;  // Create object from Serial class

String serialport = "COM8";
int NMPXL = 72;    // PIXELS to draw on
int ser_drag_dist = 4;
int STRIP_LEN = 72;  // LEDs on strip & max length to send

int [] blue = new int [STRIP_LEN];
int [] red = new int [STRIP_LEN];
int [] green = new int [STRIP_LEN];

int canvasL, canvasR, canvasT, canvasB, canvasW, canvasH;
int canvasMin, canvasMax;
char col_state = 'b';

color cBlue = color(0,0,220);
color cRed = color(220,0,0);
color cGreen = color(0,220,0);

void setup()
{
    size( 1500, 600 );
    
    // * canvas
    
    canvasL = 10;  // Left
    canvasT = 10;  // Top
    
    canvasW = 1200;  // Widt
    canvasH = 500;  // heig
    
    canvasMin = -5;
    canvasMax = 260;
    
      canvasB = canvasT+canvasH;
      canvasR = canvasL+canvasW;
    
    // * Data init
    
    blue = empty_array(STRIP_LEN);
    red = empty_array(STRIP_LEN);
    green = empty_array(STRIP_LEN);
    
    // * Draw
    
    all_draws();
    
    // * Serial
    
    println("Serial ports available: ", Serial.list() );
    //String portName = Serial.list()[0];
    String portName = serialport;
      println("opening serial : ", portName );
    ardPort = new Serial(this, portName, 115200);

    // **  Eo setup
}

int mobex, mobey;  // mouse (drag) beginn

void mousePressed()
{
  if(col_state=='r' || col_state=='g' || col_state=='b' )
    curve_mouse_func(mouseX, mouseY);
    
  else if(col_state=='x'){
    //mobex = mouseX;  // this saves mouse X
    PVector curvePos = map_curve_pos(mouseX, mouseY);
    mobex = int(curvePos.x);
    this_drag = 0;
    //mobey = mouseY;
  }
    
 // ** Eo mouse pressed 
}

int drag_dist = 0;
int this_drag = 0;

void mouseDragged()
{
  if(col_state=='r' || col_state=='g' || col_state=='b' )
    curve_mouse_func(mouseX, mouseY);
  
  else if(col_state=='x'){
    PVector curvePos = map_curve_pos( mouseX, mouseY );
    //drag_curve(int(curvePos.x), mobex );
    int new_dist = int(curvePos.x) - mobex;
    if( abs(new_dist-this_drag) >= ser_drag_dist )
    {
      this_drag = new_dist;
      ardPort.write(10);
      send_rgb_vals();
      //println(" # drag dist = ", this_drag );
    }
    
  }
 // ** Eo mouse pressed 
} 

void mouseReleased()
{
   // * Send over serial
  send_rgb_vals();
  
  if(col_state=='x'){
    drag_dist += this_drag; 
    this_drag = 0;
  }
   // **    Mouse Released 
}

long stopwatch = 0;

void draw()
{
  // * get re-send char from arudino
  if(ardPort.available()>0){
    char c = char(ardPort.read());
    
    if( c=='r'){
      // r char to re-send rgb serial values
      println("#R");
      //send_rgb_vals(); 
    }
    else
      print(c);
  }
  //if( millis() -stopwatch > 400 ){
  //  send_rgb_vals();
  //  stopwatch = millis();
  //}
  // ** Eo draw
}

void keyPressed()
{
  if(key=='r')
    col_state = 'r';
   
  else if(key=='b')
    col_state = 'b';
  
  else if(key=='g')
    col_state = 'g';
  
  else if(key=='x')
    col_state = 'x';
  
  else if(key==' '){
    // clear
    blue = empty_array(STRIP_LEN);
    red = empty_array(STRIP_LEN);
    green = empty_array(STRIP_LEN);
    // redraw & send
    re_draw_curves();
    send_rgb_vals();
  }
  else {
    send_rgb_vals();
  }
  draw_colsel();
}


void drag_curve( int mouse_x, int begin_x )
{
  
  int [] newRed = new int[NMPXL];
  int [] newGreen = new int[NMPXL];
  int [] newBlue = new int[NMPXL];
  
   for( int a=0; a<NMPXL; a++){
     newRed[a] = red[ wrap_index(a+begin_x, NMPXL) ];
     newGreen[a] = green[ wrap_index(a+begin_x, NMPXL) ];
     newBlue[a] = blue[ wrap_index(a+begin_x, NMPXL) ];     
   }  
  
  red = newRed;
  green = newGreen;
  blue = newBlue;
  
  // ** Eo func
}
int wrap_index( int id, int wrap_len )
{
  while(id<0){
    id+= wrap_len;
  }
  while(id>=wrap_len){
    id -= wrap_len;
  }
 return id; 
}


void send_rgb_vals()
{
  for( int i=0; i<STRIP_LEN; i++)
  {
    //println( red[i], " -> ", red[i]/2+128 );
    //println( red[i], green[i], blue[i], " + drag dist ", drag_dist );
    //println( i,  red[i], green[i], blue[i] );
    ardPort.write( red[   wrap_index(i-this_drag-drag_dist, STRIP_LEN) ]/2 +128 );  // -this_drag-drag_dist
    ardPort.write( green[ wrap_index(i-this_drag-drag_dist, STRIP_LEN) ]/2 +128 );
    ardPort.write( blue[  wrap_index(i-this_drag-drag_dist, STRIP_LEN) ]/2 +128 );
    ardPort.write( ',' );
  }
  ardPort.write(10);
  
  // Eo funct
}


void curve_mouse_func(int X, int Y)
{
  //
  PVector curvePos = map_curve_pos(X, Y);
  if( curvePos.x >=0 && curvePos.x < NMPXL )
  {
    
    if(col_state=='b')
      adjust_curve( blue, int(curvePos.x), int(curvePos.y) );
    else if(col_state=='r')
      adjust_curve( red, int(curvePos.x), int(curvePos.y) );
    else if(col_state=='g')
      adjust_curve( green, int(curvePos.x), int(curvePos.y) );
        
    //all_draws();
    re_draw_curves();
    
  } 
  // Eo func
}


void adjust_curve( int [] ray, int x, int y )
{
  ray[x] = y;  
  // * Eo funct
}


PVector map_curve_pos( int mX, int mY )
{
  float cx, cy;
  cx = map( mX,  canvasL, canvasR,  0, NMPXL );
    //cx = constrain( cx, 0, NMPXL );
    cx = floor(cx);
  cy = map( mY, canvasB, canvasT, canvasMin, canvasMax );
    cy = constrain( cy, 0, 255 );
    cy = floor(cy);
  
  return new PVector(cx, cy);
  // * Eo funct
}


void all_draws()
{
  background(66);
  draw_canvas();
  re_draw_curves();    //draw_array(blue, NMPXL);
  draw_colsel();  
}

void re_draw_curves()
{
  draw_canvas();
  draw_array(blue, NMPXL , cBlue );
  draw_array(red, NMPXL, cRed );
  draw_array(green, NMPXL, cGreen );
}


void draw_colsel()
{
  int corX = canvasR + 10;
  int corY = 10;
  
  if(col_state=='b')
    fill(0,0,220);
  else if(col_state=='r')
    fill(220,0,0);
  else if(col_state=='g')
    fill(0,220,0);
    
  noStroke();
  rect( corX, corY, width-10-corX, width-10-corX );
  //  
}



void draw_array( int[] ray, int len , color col )
{
    float cXstep = canvasW / NMPXL;
    float cX = canvasL +cXstep/2;  // canvas X
    float y;  
    
  stroke(col); strokeWeight(2);
  // - draw line graph
  for( int a=0; a<len; a++)
  {
    y = map( ray[a], canvasMin, canvasMax, canvasB, canvasT );
    line( cX, canvasB, cX, y );
    //println(a,"[", ray[a],"]", " Y: ", y );
    cX += cXstep;
  }
  
  // - draw curve
  stroke(col); strokeWeight(7);
    float last_y;
    y = map( ray[0], canvasMin, canvasMax, canvasB, canvasT );
    last_y = y;
    cX = canvasL +cXstep/2;  // canvas X
    cX += cXstep;
  for( int a=1; a<len; a++)
  {
    y = map( ray[a], canvasMin, canvasMax, canvasB, canvasT );
    line(cX-cXstep, last_y, cX, y);
    
    // curve( cp1, p1, p2, cp2 )
    //curve( a-1, last_y, a, y, 
    last_y = y;  
    cX += cXstep;
  }
  
  // Eo funct
}


void draw_canvas()
{
  fill(0);  stroke(255);  strokeWeight(4);
  rect( canvasL, canvasT, canvasW, canvasH );
  
}

//    #####          Functions



int[] empty_array( int len )
{
  int[] ray = new int [len];
  for( int i=0; i<len; i++){
    ray[i]=0;
  }  
  return ray;
  // Eo func
}
