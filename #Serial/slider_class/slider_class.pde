



int bars = 12;
Slider[] sliders = new Slider[bars];

int bar_hei = 40;
int bar_gap = 4;

int first_bar_x = 20;
int first_bar_y = 20;

void setup()
{
  size(1200,800);
  
  background(111);
  
  for( int ba=0; ba<bars; ba++){
    sliders[ba] = new Slider(first_bar_x,
                            first_bar_y +ba*(bar_hei+bar_gap),
                             width/2, bar_hei);              
  }
   
  
  
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
  
  // *** Eo draw
}


color get_col(int i){
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
  
  
void mouse_func( int x, int y)
{
  for( int b=0; b<bars; b++)
  {
    // check vals
    if(sliders[b].check_slider(x, y)){
      // something changed
      draw_rings();
    }
    
    // Send out vals here too
    
    // Eo for
  }
  // Eo func
}


void draw_rings()
{
  color c;
  
  // Ring 1
  c= get_col(0);
    noFill();  stroke(c);  strokeWeight(20);
  ellipse( width -160, height/2, 200, 200);
  // white ring
    noFill();  stroke(sliders[3].val);  strokeWeight(10);
  ellipse( width -160, height/2, 225, 225);
  
  // Ring 2
  c= get_col(1);
    noFill();  stroke(c);  strokeWeight(25);
  ellipse( width -160, height/2, 120, 120);
  // white ring
    noFill();  stroke(sliders[7].val);  strokeWeight(15);
  ellipse( width -160, height/2, 147, 147);
  
  // Ring 3
  c= get_col(2);
    fill(c);  noStroke();
  ellipse( width -160, height/2, 80, 80);
  // white ring
    noFill();  stroke(sliders[11].val);  strokeWeight(15);
  ellipse( width -160, height/2, 70, 70);
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
     max = 255;
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
        val = map(mx, xpos, xpos+wid, 0,max);
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
