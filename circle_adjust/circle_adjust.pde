
int T1 = 32;
int T2 = 24;


PVector center;
int ring_size;
PVector arc1, arc2;
Ring outer, inner;

void setup()
{
  size(1000, 1000);
  
  center = new PVector(width/2, height/2);
  ring_size = width/2;
  
  // Ring(float Cx, float Cy, float rad, float thick )
  outer = new Ring(center.x, center.y,
                         ring_size-50, 40 );
  inner = new Ring(center.x, center.y,
                         ring_size/2, 40 );
  
  draw_all();
  
  // ** Eo setup
}




void draw()
{
  
  
}

void mousePressed(){
  outer.click(mouseX,mouseY);
  inner.click(mouseX,mouseY);
  //draw_all();
}

void mouseDragged(){
  outer.click(mouseX,mouseY);
  inner.click(mouseX,mouseY);
  draw_all();
}

void mouseReleased(){
  outer.release();
  inner.release();
  draw_all();
}

void keyPressed(){
  if(key==' '){
    outer.points=0;
    inner.points=0;
    draw_all();
  }
}


void draw_all(){
   background(0);
   outer.drw();
   inner.drw();
   //
}

class Ring
{
  PVector center;
  float radius, thickness, outer, inner;
  color filler;
  float begin, end;
  float diam;
  int points;
  
  Ring(float Cx, float Cy, float rad, float thick ){
    center = new PVector(Cx, Cy);
    radius = rad;
    thickness=thick;
    outer = rad+thick;
    inner = rad-thick;
    diam = 2*rad;
    
    float r = random(255);
    filler = color(r,0,255-r);
    
    begin = 0;
    end = 0;
    points=0;
  }
  
  void drw(){
    
    // ring col
      strokeWeight(thickness*2);      stroke(0);
      noFill();
    ellipse(center.x, center.y, diam, diam);
    
    // outlines
    strokeWeight(1); stroke(255); 
      noFill();
    ellipse(center.x,center.y, inner*2, inner*2);
    ellipse(center.x,center.y, outer*2, outer*2);
    
    // arc
    if(points==2){
      noFill();
      strokeWeight(thickness*2); 
      arc(center.x, center.y, diam,diam, begin, end );
    }
    
    if(true){
      // - draw debug dots
      PVector angB = PVector.add(center, PVector.fromAngle(begin).mult(radius) );
      PVector angE = PVector.add(center, PVector.fromAngle(end).mult(radius) );
      noStroke();  fill(180,0,0);
      ellipse( angB.x, angB.y, 20,20);
      noStroke();  fill(0,180,0);      
      ellipse( angE.x, angE.y, 20,20);
    }
  
  }
  boolean ringclick;
  float clickbegin;
  
  void click(float x, float y){
    PVector M = new PVector(x,y);
    PVector dist = PVector.sub(M, center );
    //println(dist.mag(), inner, outer);
    if(!ringclick){
      if(dist.mag()>=inner && dist.mag()<=outer ){
       ringclick = true; 
       clickbegin=dist.heading();
      }
    }
    if(ringclick){
      float angl = dist.heading();
      
      //println( angl );
      //println(angl, "\tB ", begin, "\tE", end );
      
      if(points==0){
        begin = angl;
        points++;
      }
      else if(points==1){
        // exchange begin and end if necessary
        if(angl>begin) {
          end = angl;
        }
        else {
          end = begin;
          begin = angl; 
        }
        points++;
      }
      else if(points==2){
        //println("dstncs:", abs(angl-begin), abs(angl-end) );
        
          // ON the ring
          float Bdiff = wrap(abs(angl-begin));  // diff to begin
          float Ediff = wrap(abs(angl-end));    // diff to end
          //println(angl, "--\t", Bdiff," - ", Ediff);
          println(angl, "--\t", begin," - ", end);
          if( Bdiff < 0.3 ) {
              // close to begin
              //begin = angl;
              begin += (angl-begin);
              println("M begin");
            }
            else if(Ediff <0.3 ) {
              // close to end
              //end = angl;
              end += (angl-end);
              println("M end");
            }
            else {
              // Drag
              //float rot = (angl-clickbegin);
              float rot = (angl-clickbegin);
              begin += rot;
              end   += rot;
              //println(angl);
              //println("M drag ", angl,"\t+",rot, "[ ",begin," > ", end, " ]" );
              clickbegin = angl;
            }
        
        
          // OFF the ring
          //if( abs(angl-begin) < abs(angl-end) ){
          //  begin = angl;
          //  println("M begin");
          //}
          //else {
          //  end = angl;
          //  println("M end");
          //}
        
        
         
      }
    }
    
      
  }
    
    void release(){
       if(ringclick){
         //if(points<2)   points++;
         ringclick=false;
       }
       //
    }
    
  
  
  // ** Eo class 
}

// circle angle wrap
float wrap(float x ){
  if(x> PI)
    x = TWO_PI-x;
  while(x>=TWO_PI)      x -= TWO_PI;
  while(x<=-TWO_PI)      x += TWO_PI;
  return x;
}
float wrap_A(float x, float max){
  return x;
}

// **   
