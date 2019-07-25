/*
 * Control of RGB RIng module B with Neopixel RGB-W
 *  
 *      - turns linear slider to exponential LED val
 */


import processing.serial.*;
Serial ardPort;

String portName = "COM18";
int frame_period = 100;

int bars = 12;
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
  size(1200,800);
  
  background(111);
  
  float yoff =first_bar_y;
  for( int ba=0; ba<bars; ba++){
    sliders[ba] = new Slider(first_bar_x,
                            yoff +ba*(bar_hei+bar_gap),
                             width*2/3, bar_hei);
    
    if(ba==3)      yoff += bar_hei;
    if(ba==7)      yoff += bar_hei;
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
    sliders[b].barcol = color(180,0,0);   b++;
  sliders[b].name = "r1 green";
    sliders[b].barcol = color(0,180,0);   b++;
  sliders[b].name = "r1 blue";
    sliders[b].barcol = color(0,0,180);   b++;
  sliders[b].name = "r1 white";
    sliders[b].barcol = color(240);   b++;
  
  // Ring 2
  sliders[b].name = " r2 red";
    sliders[b].barcol = color(180,0,0);   b++;
  sliders[b].name = " r2 green";
    sliders[b].barcol = color(0,180,0);   b++;
  sliders[b].name = " r2 blue";
    sliders[b].barcol = color(0,0,180);   b++;
  sliders[b].name = " r2 white";
    sliders[b].barcol = color(240);   b++;
  
  // Ring 3
  sliders[b].name = "  r3 red";
    sliders[b].barcol = color(180,0,0);   b++;
  sliders[b].name = "  r3 green";
    sliders[b].barcol = color(0,180,0);   b++;
  sliders[b].name = "  r3 blue";
    sliders[b].barcol = color(0,0,180);   b++;
  sliders[b].name = "  r3 white";
    sliders[b].barcol = color(240);   b++;
  
  // draw
  for( int ba=0; ba<bars; ba++){
    sliders[ba].draw_slider();    
  }
  
  draw_rings();
  
  // Eo *** setup 
}


void draw()
{
  while(ardPort.available()>0){
    print(ardPort.read(), ',' );
  }
  // *** Eo draw
}


color get_col(int i){
  color c = color( exponate(sliders[(i*4)+0].val), 
                    exponate(sliders[(i*4)+1].val), 
                     exponate(sliders[(i*4)+2].val)   );
  
  return c;
}

color get_col_linear(int i){
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
  for( int b=0; b<bars; b++)
  {
    // check vals
    if(sliders[b].check_slider(x, y)){
      // something changed
      // send serial
      if(millis()-last_frame>=frame_period){
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
  
  if(key==' ')
    clear_ser_rgb();
    
  if(key=='r') 
    send_ser_rgb();
  
}


void draw_rings()
{
  color c;    float white;
  
  // Ring 1
  c= get_col(0);
    noFill();  stroke(c);  strokeWeight(20);
  ellipse( width -160, height/2, 200, 200);
  // white ring
  white = exponate(sliders[3].val);
    noFill();  stroke(white);  strokeWeight(10);
  ellipse( width -160, height/2, 225, 225);
  
  // Ring 2
  c= get_col(1);
    noFill();  stroke(c);  strokeWeight(25);
  ellipse( width -160, height/2, 120, 120);
  // white ring
  white = exponate(sliders[7].val);
    noFill();  stroke(white);  strokeWeight(15);
  ellipse( width -160, height/2, 147, 147);
  
  // Ring 3
  c= get_col(2);
    fill(c);  noStroke();
  ellipse( width -160, height/2, 80, 80);
  // white ring
  white = exponate(sliders[11].val);
    noFill();  stroke(white);  strokeWeight(15);
  ellipse( width -160, height/2, 70, 70);
}

void send_ser_rgb()
{
  for( int i=0;i<r1;i++)
  {
    ardPort.write( int(exponate(sliders[0].val)));
    ardPort.write( int(exponate(sliders[1].val)));
    ardPort.write( int(exponate(sliders[2].val)));
    ardPort.write( int(exponate(sliders[3].val)));
  }
  for( int i=0;i<r3;i++)
  {
    ardPort.write( int(exponate(sliders[8].val)));
    ardPort.write( int(exponate(sliders[9].val)));
    ardPort.write( int(exponate(sliders[10].val)));
    ardPort.write( int(exponate(sliders[11].val)));
  }
  for( int i=0;i<r2;i++)
  {
    ardPort.write( int(exponate(sliders[4].val)));
    ardPort.write( int(exponate(sliders[5].val)));
    ardPort.write( int(exponate(sliders[6].val)));
    ardPort.write( int(exponate(sliders[7].val)));
  }
  
  ardPort.write(10);
  // Eo funct
}

void clear_ser_rgb()
{
  // Clear serial
  int tot = r1+r2+r3;
  for( int i=0; i<tot ;i++)
  {
    ardPort.write(0);
    ardPort.write(0);
    ardPort.write(0);
    ardPort.write(0);
  }
  ardPort.write(10);
  
  // clear data and draw
  for( int b=0; b<bars ;b++){
    // clear val
    sliders[b].val =0;
    // redraw
    sliders[b].draw_slider();
  }
  draw_rings();
  
  // Eo funct
}

float exponate( float x){
  return ( 0.0255 *x *x );
}


class Slider {
  float xpos, ypos;
  float wid, hei;
  float val, max;
  color barcol;
  String name;
  
  Slider(float x, float y, float w, float h ){
     xpos = x;
     ypos = y;
     wid = w;
     hei = h;
     
     val = 0;
     max = 100;
     name="";
     
     barcol = color(random(255),random(255),random(255));
     
     //-
  }
  
  boolean check_slider(int mx, int my){
    // check val
    boolean changed = false;
    
    if( mx >xpos && mx <xpos+wid)
      if( my >ypos && my < ypos+hei ){
        // adjust
        val = (map(mx, xpos, xpos+wid, 0,100));
        //println(val);
        // Redraw
        draw_slider();
        changed = true;
      }
    return changed;
  }
  
  void draw_slider(){
      noStroke();  fill(0);
    rect(xpos, ypos, wid, hei );
      noStroke();  fill(barcol);
    rect(xpos, ypos+2, map(val, 0,max, 0, wid), hei-4 );
      textSize(hei-4);   fill(barcol);
    text( name, xpos+wid+5, ypos+hei );
  }
  
  // ** Eo class
}
