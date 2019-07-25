/* 
 *  First triangle control gui,
 *    linear fade between all elements
 *   - issue, center not all are 100% (is this problem?)
 *   - when on one side, should be slider between those elements, 3rd is 0 (but 0.2)
  */

PVector t1, t2, t3, cntr;
float t_rad = 300;
float side;
float v1,v2,v3;

void setup()
{
  size(1000,660);
  
  cntr = new PVector(width/2, height/2);
  
  t1 = PVector.fromAngle(TWO_PI);
    t2 = PVector.fromAngle(TWO_PI/3);
    t3 = PVector.fromAngle(2*TWO_PI/3);
  t1.mult(t_rad);
    t2.mult(t_rad);
    t3.mult(t_rad);
  t1.add(cntr);
    t2.add(cntr);
    t3.add(cntr);
  
  background(0);
  draw_triangle();
  side = PVector.sub(t1,t2).mag();
  v1=0;v2=0;v3=0;
  
  // * Eo setup
}


void triangle_func(float x, float y)
{
  // update vars
  triangle_click(x,y);
  
  // redraw
  background(0);
  draw_vars(v1,v2,v3);
  draw_triangle();  
}


void draw_triangle(){
  noFill();  stroke(255);  strokeWeight(6);
  triangle(t1.x,t1.y, t2.x,t2.y, t3.x,t3.y); 
}


void triangle_click(float x, float y)
{
  //
  float r1, r2, r3;
  PVector mse = new PVector(x,y);
  r1 = PVector.sub(mse,t1).mag();
  r2 = PVector.sub(mse,t2).mag();
  r3 = PVector.sub(mse,t3).mag();
  
  v1=1-r1/side;
  v2=1-r2/side;
  v3=1-r3/side;
  
  // outside the triangle v_x goes minus
  if(v1<0)  v1=0;
  if(v2<0)  v2=0;
  if(v3<0)  v3=0;
  
  // on triangle border sum goes -> 0.9999
  if(v1+v2>=0.99)  v3=0;
  if(v1+v3>=0.99)  v2=0;
  if(v2+v3>=0.99)  v1=0;
  
  //println( "t: ",v1,"\t",v2,"\t",v3,"\tS=",(v1+v2+v3)/side );
  println( "t: ",v1,"\t",v2,"\t",v3,"\t12:",(v1+v2)   );
  
  
  // ** Eo function()
}

void draw_vars(float f1,float f2,float f3){
  float r;
  noStroke();
  
  r= map(f1,0,1, 0,t_rad);
    fill(120,0,40);
    ellipse(t1.x,t1.y,r,r);
  r= map(f2,0,1, 0,t_rad);
    fill(40,120,0);
    ellipse(t2.x,t2.y,r,r);
  r= map(f3,0,1, 0,t_rad);
    fill(0,40,120);
    ellipse(t3.x,t3.y,r,r);
}



void mousePressed()
{
  triangle_func(mouseX,mouseY);
}

void mouseDragged()
{
  triangle_func(mouseX,mouseY);
}

void draw()
{
  
  
}
