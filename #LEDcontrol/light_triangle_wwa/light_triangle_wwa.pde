/* 
 *  First triangle control gui,
 *    linear fade between all elements
 *   - issue, center not all are 100% (is this problem?)
 */

// * Serial
import processing.serial.*;
Serial ardPort;

String serialport = "COM31";
int ser_update = 100;
long ser_timer = 0;

PVector t1, t2, t3, cntr;
float t_rad = 300;
float side;
float v1,v2,v3;
float tv1, tv2, tv3;



void setup()
{
  // * Serial
  println("Serial ports available: ", Serial.list() );
  String portName = serialport;
    println("opening serial : ", portName );
  ardPort = new Serial(this, portName, 115200);

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
  
  if(v1!=tv1 || v2!=tv2 || v3!=tv3){
      //
      v1=tv1;  v2=tv2;  v3=tv3;
      
      // send out serial
      if(millis()-ser_timer>ser_update){
        ser_timer=millis();
        int r= int(map(v1,0,1,128,255));
        int g= int(map(v2,0,1,128,255));
        int b= int(map(v3,0,1,128,255));
        ardPort.write(r);
        ardPort.write(g);
        ardPort.write(b);
        ardPort.write(',');
        ardPort.write(10);
        println(r,"\t",g,"\t",b);
      }
      
      // redraw
      background(0);
      draw_vars(v1,v2,v3);
      draw_triangle();  
  }
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
  
  tv1=1-r1/side;
  tv2=1-r2/side;
  tv3=1-r3/side;
  
  // outside the triangle v_x goes minus
  if(tv1<0)  tv1=0;
  if(tv2<0)  tv2=0;
  if(tv3<0)  tv3=0;
  
  // on triangle border sum goes -> 0.9999
  if(tv1+tv2>=0.99)  tv3=0;
  if(tv1+tv3>=0.99)  tv2=0;
  if(tv2+tv3>=0.99)  tv1=0;
  
  //println( "t: ",v1,"\t",v2,"\t",v3,"\tS=",(v1+v2+v3)/side );
  
  //println( "t: ",v1,"\t",v2,"\t",v3,"\t12:",(v1+v2)   );
  
  // ** Eo function()
}

void draw_vars(float f1,float f2,float f3){
  float r;
  noStroke();  strokeWeight(4);
  float er = 60;  // empty radius
  
  r= map(f1,0,1, 0,t_rad);
    noStroke();  fill(180,100,0);  // Amber
    ellipse(t1.x,t1.y,r,r);
  noFill();  stroke(180,100,0);
    ellipse(t1.x,t1.y,er,er);
  r= map(f2,0,1, 0,t_rad);
    noStroke();  fill(180,180,240);  // Cool white
    ellipse(t2.x,t2.y,r,r);
  noFill();  stroke(180,180,240);
    ellipse(t2.x,t2.y,er,er);
  r= map(f3,0,1, 0,t_rad);
    noStroke();  fill(250,200,100);  // Warm white
    ellipse(t3.x,t3.y,r,r);
  noFill();  stroke(250,200,100);
    ellipse(t3.x,t3.y,er,er);
  
}


void clear_pixel(){
  ardPort.write(0);
  ardPort.write(0);
  ardPort.write(0);
  ardPort.write(',');
  ardPort.write(10);
}

void mousePressed()
{
  triangle_func(mouseX,mouseY);
}

void mouseDragged()
{
  triangle_func(mouseX,mouseY);
}

void keyPressed(){
  if(key==' ')
   clear_pixel();
}


void draw()
{
  
  
}
