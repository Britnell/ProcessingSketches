/**
 * Simple Read
 * 
 * Read data from the serial port and change the color of a rectangle
 * when a switch connected to a Wiring or Arduino board is pressed and released.
 * This example works with the Wiring / Arduino program that follows below.
 */

PShape sh;
PVector last;
PShape dual;

int shi = 0;
PShape grow;


void setup() 
{
  size(800, 800);
  
  background(255);
  
  fill(0);   textSize(100);
  text("BRAIN",120,120);
  
  sh = createShape();
  sh.beginShape();
  sh.noFill();    // sh.fill(111);  
  sh.stroke(0,0,111);    sh.strokeWeight(5);
  
  dual = createShape();
  dual.beginShape();
  dual.noStroke();  dual.fill(111);
  
  
  // setup
}

void draw()
{
  //
  background(255);
  shape(sh);
  shape(dual);
  
}


void mouseClicked(){
  
}



void mousePressed(){
  last = new PVector(mouseX, mouseY);
  
  //
}

void mouseDragged(){
  // ##### instead of dual, add L and R to separate shapes, then combine on release
  
  // vertex
  sh.beginShape();
  sh.vertex(mouseX, mouseY);
  // step
  PVector mos = new PVector(mouseX, mouseY);
  PVector step = PVector.sub(mos, last);
  
  PVector v = PVector.add(mos, step.rotate(HALF_PI));
  //dual.vertex(v.x, v.y );
  v = PVector.add(mos, step.rotate(PI));
  //dual.vertex(v.x, v.y );
  // * Admin
  last = mos;
  
  sh.endShape();
  
  // * Draw
  //background(255);
  //shape(sh);
  //shape(dual);
  
}

void mouseReleased(){
  PVector mos, step, vec;
  
  int count = sh.getVertexCount();
  
  
  dual.beginShape();
  
  
    // LEFT SIDE
  last = sh.getVertex(0);
  
  for(int v=1; v<count ;v++){
    mos = sh.getVertex(v);
    step = PVector.sub(mos, last);
    vec = PVector.add(mos, step.rotate(HALF_PI));
    dual.vertex(vec.x, vec.y );
    //
    last = mos;
    //-
  }
  
    // RIGHT SIDE
  //last = sh.getVertex(count-1);  // is already
  
  for(int v=count-2; v>=0;v--) {
    mos = sh.getVertex(v);
    step = PVector.sub(mos, last);
    vec = PVector.add(mos, step.rotate(HALF_PI));
    dual.vertex(vec.x, vec.y );
    if(v==count-2){
      vec = PVector.add(mos, step.rotate(PI));
      dual.vertex(vec.x, vec.y );       
    }
    //
    last = mos;
    //-
  }
  
  dual.endShape();
  
  
  //
}

// *