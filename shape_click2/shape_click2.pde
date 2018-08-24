/**
 *  Draw a line with mouse 
      and it will create a line shape with width from it
 */

PShape sh;
PVector last;
PShape dual;

int shi = 0;
PShape grow;

boolean morph = false;
PVector center;



void setup() 
{
  frameRate(5);
  
  size(800, 800);
  center = new PVector(width/2, height/2);
  
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
  
  if(morph){
    int subj = int(random(1,dual.getVertexCount()));
    PVector point = dual.getVertex(subj);
    
  }
  // Eo draw
}


void mouseClicked(){
  
}



void mousePressed(){
  last = new PVector(mouseX, mouseY);
  
  //
}

void mouseDragged(){
  
  // only after set distance
  
  if(abs(mouseX-pmouseX)+abs(mouseY-pmouseY)>6)
  {
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
}


void mouseReleased(){
  PVector mos, step, vec;
  
  int count = sh.getVertexCount();
  
  
  dual.beginShape();
  
    // LEFT SIDE
  last = sh.getVertex(0);
  
  // add first point
  dual.vertex(last.x, last.y);
  
  
  for(int v=1; v<count ;v++){
    mos = sh.getVertex(v);
    step = PVector.sub(mos, last);
    step.normalize();  step.mult(20);
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
    step.normalize();  step.mult(20);
    
    if(v==count-2){
      // last point L
      vec = PVector.add(mos, step.rotate(-HALF_PI));
        dual.vertex(vec.x, vec.y );
      // end point
      vec = PVector.add(mos, step.rotate(-HALF_PI));
        dual.vertex(vec.x, vec.y );
      // last point R
      vec = PVector.add(mos, step.rotate(-HALF_PI));
        dual.vertex(vec.x, vec.y );
      
    }
    else {
      vec = PVector.add(mos, step.rotate(HALF_PI));
      dual.vertex(vec.x, vec.y );
    }
    
    //
    last = mos;
    //-
  }
  
  dual.endShape();
  
  // now grow
  //morph = true;
  
  //
}


// ******** STep all

void shift_all(){
      for(int v=0; v<dual.getVertexCount(); v++){
        PVector next = dual.getVertex(v);
        PVector dir = PVector.sub(next, center);
          dir.normalize();
          dir.mult(random(-3,9));
          dir.rotate( random(-PI,PI)/2);
        next.add(dir);
        dual.setVertex(v,next);
        // Eo for 
      }
      //
      noStroke();  fill(255,80);
        rect(0,0,width,height);
      shape(sh);
}


// *