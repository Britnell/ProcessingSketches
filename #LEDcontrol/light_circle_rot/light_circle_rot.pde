/*
 * Control of RGB RIng module B with Neopixel RGB-W
 *      - turns linear slider to exponential LED val
 *      - two color vals for fade on outer ring
 */


import processing.serial.*;
Serial ardPort;

String portName = "COM30";
int frame_period = 300;
// G - for gradient
// D - for Dots
char animation = 'D';  

int bars = 17;
Slider[] sliders = new Slider[bars];

int bar_hei = 40;
int bar_gap = 4;

int first_bar_x = 50;
int first_bar_y = 20;

int r1=16;
int r2=6;
int r3=1;

void setup()
{
  size(1200, 1000);

  background(111);

  float yoff =first_bar_y;
  for ( int ba=0; ba<bars; ba++) {
    sliders[ba] = new Slider(first_bar_x, 
      yoff +ba*(bar_hei+bar_gap), 
      width*2/3, bar_hei);

    if (ba==3)      yoff += bar_hei;
    if (ba==7)      yoff += bar_hei;
    if (ba==11)      yoff += bar_hei;
    if (ba==15)      yoff += bar_hei;
    // Eo for
  }

  // * Serial

  print("Serial ports available: ");
  println( Serial.list() );
  //String portName = Serial.list()[0];
  print("opening serial : ");
  println( portName );
  ardPort = new Serial(this, portName, 115200);


  // * Rings setup  

  int b=0;

  // Ring 1
  sliders[b].name = "r1 red";
  sliders[b].barcol = color(180, 0, 0);   
  b++;
  sliders[b].name = "r1 green";
  sliders[b].barcol = color(0, 180, 0);   
  b++;
  sliders[b].name = "r1 blue";
  sliders[b].barcol = color(0, 0, 180);   
  b++;
  sliders[b].name = "r1 white";
  sliders[b].barcol = color(240);   
  b++;

  // Ring 1-B
  sliders[b].name = "r1-2 red";
  sliders[b].barcol = color(180, 0, 0);   
  b++;
  sliders[b].name = "r1-2 green";
  sliders[b].barcol = color(0, 180, 0);   
  b++;
  sliders[b].name = "r1-2 blue";
  sliders[b].barcol = color(0, 0, 180);   
  b++;
  sliders[b].name = "r1-2 white";
  sliders[b].barcol = color(240);   
  b++;

  // Ring 2
  sliders[b].name = " r2 red";
  sliders[b].barcol = color(180, 0, 0);   
  b++;
  sliders[b].name = " r2 green";
  sliders[b].barcol = color(0, 180, 0);   
  b++;
  sliders[b].name = " r2 blue";
  sliders[b].barcol = color(0, 0, 180);   
  b++;
  sliders[b].name = " r2 white";
  sliders[b].barcol = color(240);   
  b++;

  // Ring 3
  sliders[b].name = "  r3 red";
  sliders[b].barcol = color(180, 0, 0);   
  b++;
  sliders[b].name = "  r3 green";
  sliders[b].barcol = color(0, 180, 0);   
  b++;
  sliders[b].name = "  r3 blue";
  sliders[b].barcol = color(0, 0, 180);   
  b++;
  sliders[b].name = "  r3 white";
  sliders[b].barcol = color(240);   
  b++;

  //Speed
  sliders[b].name = "speed";
  sliders[b].min = 4;
  sliders[b].max = 300;
  sliders[b].val = 100;
  sliders[b].barcol = color(0, 160, 140);   
  b++;

  // draw
  for ( int ba=0; ba<bars; ba++) {
    sliders[ba].draw_slider();
  }

  draw_rings();

  // Eo *** setup
}


int ring_rot=r1/2;
long last_rot=0;
int rot_speed = 100;
void draw()
{
  if (millis()-last_rot>=rot_speed) {
    ring_rot++;
    if (ring_rot >=r1)      ring_rot = 0;
    send_ser_rgb();
    last_rot = millis();
  }

  // *** Eo draw
}


color get_col(int i) {
  color c = color( exponate(sliders[(i*4)+0].val), 
    exponate(sliders[(i*4)+1].val), 
    exponate(sliders[(i*4)+2].val)   );

  return c;
}

color get_col_linear(int i) {
  color c = color( sliders[(i*4)+0].val, 
                     sliders[(i*4)+1].val, 
                      sliders[(i*4)+2].val );

  return c;
}



void mousePressed()
{
  mouse_func( mouseX, mouseY); 

  // * Eo mousePressed
}

void mouseDragged()
{
  mouse_func( mouseX, mouseY); 

  // * Eo mousePressed
}

long last_frame=0;

void mouse_func( int x, int y)
{
  for ( int b=0; b<bars; b++)
  {
    // check vals
    if (sliders[b].check_slider(x, y)) {
      // something changed
      // send serial
       rot_speed = int(sliders[16].val); 
       //println("Speed is ", rot_speed );
       
      //if(millis()-last_frame>=frame_period) {
      if(false){
        // Only update after frame period
        send_ser_rgb();
        // redraw
        draw_rings();
        last_frame = millis();
        //
      }
    }

    // Send out vals here too

    // Eo for
  }
  // Eo func
}

void keyPressed()
{
  // clear rgb ring

  if (key==' ')
    clear_ser_rgb();

  if (key=='r') 
    send_ser_rgb();
}


void draw_rings()
{
  color c;    
  float white;

  // Ring 1
  c= get_col(0);
  noFill();  
  stroke(c);  
  strokeWeight(20);
  ellipse( width -160, height/2, 200, 200);
  // Ring 1-ARC
  c= get_col(1);
  noFill();  
  stroke(c);  
  strokeWeight(20);
  arc( width -160, height/2, 200, 200, 0, PI );

  // white ring
  white = exponate(sliders[3].val);
  noFill();  
  stroke(white);  
  strokeWeight(10);
  ellipse( width -160, height/2, 225, 225);


  // Ring 2
  c= get_col(2);
  noFill();  
  stroke(c);  
  strokeWeight(25);
  ellipse( width -160, height/2, 120, 120);
  // white ring
  white = exponate(sliders[11].val);
  noFill();  
  stroke(white);  
  strokeWeight(15);
  ellipse( width -160, height/2, 147, 147);

  // Ring 3
  c= get_col(3);
  fill(c);  
  noStroke();
  ellipse( width -160, height/2, 80, 80);
  // white ring
  white = exponate(sliders[15].val);
  noFill();  
  stroke(white);  
  strokeWeight(15);
  ellipse( width -160, height/2, 70, 70);
  
  //--
}


int ring_fadeA( int i) {
  //ring_rot = r1/2;
  int x = (i-ring_rot);
  if (x>r1/2)      x = ( i - ring_rot -r1 );
  if (x<-r1/2)      x = (i - ring_rot +r1 );
  //if(x>r1/2)  x-=r1/2;
  //print(x, ", ");
  return abs(x);
}

void send_ser_rgb()
{
  float v1, v2, v3, v4;
  int opp = (ring_rot-(r1/2));
  if(opp<0) opp += r1;
  //if(opp>=r1)  opp -= r1;
  for ( int i=0; i<r1; i++)
  {
    // ** fade sliders nicely  
    if(animation=='G'){
      v1 = ( 2.5* ( map( ring_fadeA(i), 0, r1/2, sliders[0].val, sliders[4].val)) );
      v2 = ( 2.5* ( map( ring_fadeA(i), 0, r1/2, sliders[1].val, sliders[5].val) ) );
      v3 = ( 2.5* ( map( ring_fadeA(i), 0, r1/2, sliders[2].val, sliders[6].val) ) );
      v4 = ( 2.5* ( map( ring_fadeA(i), 0, r1/2, sliders[3].val, sliders[7].val) ) );
    }
    else
    // if(animation=='D')
    if(i==ring_rot){
      v1 = sliders[0].val;
      v2 = sliders[1].val;
      v3 = sliders[2].val;
      v4 = sliders[3].val;
    }
    else if(i== opp ){
      v1 = sliders[4].val;
      v2 = sliders[5].val;
      v3 = sliders[6].val;
      v4 = sliders[7].val;
    }
    else {
      v1 = 0;
      v2 = 0;
      v3 = 0;
      v4 = 0;
    }
    
    //println(i, v1, v4);//println(i, v1);  println(i, v2);  println(i, v3);  println(i, v4);
    
    v1 = (v1/2)+128;
    v2 = (v2/2)+128;
    v3 = (v3/2)+128;
    v4 = (v4/2)+128;
    
    ardPort.write( int(v1) );
    ardPort.write( int(v2) ); 
    ardPort.write( int(v3) ); 
    ardPort.write( int(v4) );
    
  }
  //println();
  for ( int i=0; i<r3; i++)
  {
    ardPort.write( int(exponate(sliders[12].val)));
    ardPort.write( int(exponate(sliders[13].val)));
    ardPort.write( int(exponate(sliders[14].val)));
    ardPort.write( int(exponate(sliders[15].val)));
  }
  for ( int i=0; i<r2; i++)
  {
    ardPort.write( int(exponate(sliders[8].val)));
    ardPort.write( int(exponate(sliders[9].val)));
    ardPort.write( int(exponate(sliders[10].val)));
    ardPort.write( int(exponate(sliders[11].val)));
  }

  ardPort.write(10);
  // Eo funct
}

void send_ser_old()
{
  for ( int i=0; i<r1; i++)
  {
    ardPort.write( int(exponate(sliders[0].val)));
    ardPort.write( int(exponate(sliders[1].val)));
    ardPort.write( int(exponate(sliders[2].val)));
    ardPort.write( int(exponate(sliders[3].val)));
  }
  for ( int i=0; i<r3; i++)
  {
    ardPort.write( int(exponate(sliders[12].val)));
    ardPort.write( int(exponate(sliders[13].val)));
    ardPort.write( int(exponate(sliders[14].val)));
    ardPort.write( int(exponate(sliders[15].val)));
  }
  for ( int i=0; i<r2; i++)
  {
    ardPort.write( int(exponate(sliders[8].val)));
    ardPort.write( int(exponate(sliders[9].val)));
    ardPort.write( int(exponate(sliders[10].val)));
    ardPort.write( int(exponate(sliders[11].val)));
  }

  ardPort.write(10);
  // Eo funct
}

void clear_ser_rgb()
{
  // Clear serial
  int tot = r1+r2+r3;
  for ( int i=0; i<tot; i++)
  {
    ardPort.write(128);
    ardPort.write(128);
    ardPort.write(128);
    ardPort.write(128);
  }
  ardPort.write(10);

  // clear data and draw
  for ( int b=0; b<bars; b++) {
    // clear val
    sliders[b].val =0;
    // redraw
    sliders[b].draw_slider();
  }
  draw_rings();

  // Eo funct
}

float exponate( float x) {
  return ( 0.0255 *x *x );
}


class Slider {
  float xpos, ypos;
  float wid, hei;
  float val, min, max;
  color barcol;
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

  boolean check_slider(int mx, int my) {
    // check val
    boolean changed = false;

    if ( mx >xpos && mx <xpos+wid)
      if ( my >ypos && my < ypos+hei ) {
        // adjust
        val = (map(mx, xpos, xpos+wid, min, max));
        //println(val);
        // Redraw
        draw_slider();
        changed = true;
      }
    return changed;
  }

  void draw_slider() {
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
