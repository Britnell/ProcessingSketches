/* 
 *  First triangle control gui,
 *    linear fade between all elements
 *   - issue, center not all are 100% (is this problem?)
  */

// * Serial
import processing.serial.*;
Serial ardPort;
String serialport = "COM4";
int ser_update = 100;
long ser_timer = 0;

PVector t1, t2, t3, cntr;
float t_rad = 300;
float side;
float v1,v2,v3;
float tv1, tv2, tv3;

float dimm = 0.1;

int Dedge = 40;
int Dwid = 50;
int Dhei = 580;

void draw_dimmer(){
     fill(10,0,0);
     strokeWeight(3);  stroke(111);
   rect(Dedge, Dedge, Dwid, Dhei);
   
   //float dimpos = Dedge+Dhei-map(dimm,0,1,0,Dhei); // y pos
   float dimbar = map(dimm,0,1,0,Dhei);
   float dimpos = Dedge+Dhei-dimbar;
     noStroke();  //fill(0,60,60);
   fill(map(dimm,0,1,50,250) );
   rect(Dedge, dimpos,  Dwid, dimbar);
}

void dimm_click(int y){
  dimm = constrain( map(y, Dedge, Dedge+Dhei, 1,0), 0.01, 1 ); 
}

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
  
  draw_dimmer();
  
  // * Eo setup
}

void send_ser_vals(){
  
  if(millis()-ser_timer>ser_update){
        ser_timer=millis();
        //int r= int((map(v1,0,1,128,255)*dimm) );
        //int g= int((map(v2,0,1,128,255)*dimm) );
        //int b= int((map(v3,0,1,128,255)*dimm) );
        int r= int((v1*255*dimm) /2+128 );
        int g= int((v2*255*dimm) /2+128 );
        int b= int((v3*255*dimm) /2+128 );
        ardPort.write(r);
        ardPort.write(g);
        ardPort.write(b);
        ardPort.write(',');
        ardPort.write(10);
        //println(r,"\t",g,"\t",b);
      }
      
}


void triangle_func(float x, float y)
{
  // update vars
  if(mouseX<Dedge+Dwid+20){
    // DImmer click 
    dimm_click(mouseY);
    send_ser_vals();
    draw_dimmer();
  }
  else {
    triangle_click(x,y);
  }
  
  if(v1!=tv1 || v2!=tv2 || v3!=tv3){
      //
      v1=tv1;  v2=tv2;  v3=tv3;
      
      // send out serial
      send_ser_vals();
      
      // redraw
      background(0);
      draw_vars(v1,v2,v3);
      draw_triangle();  
      draw_dimmer();
  }
}


void draw_triangle(){
  noFill();  stroke(255);  strokeWeight(6);
  triangle(t1.x,t1.y, t2.x,t2.y, t3.x,t3.y);
  textSize(40); fill(160,100,0);
  text("natural", t1.x+20, t1.y+10 );
  text("white", t2.x-30, t2.y+40 );
  text("warm", t3.x-30, t3.y-20 );
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
  
  if(tv1>0.91){
   tv2=0;    tv3=0;  }
  else if(tv2>0.91){
   tv1=0;    tv3=0;  }
  else if(tv3>0.91){
   tv1=0;    tv2=0;  }
  //println( "t: ",tv1,"\t",tv2,"\t",tv3);
  
  //println( "t: ",v1,"\t",v2,"\t",v3,"\tS=",(v1+v2+v3)/side );
  //println( "t: ",v1,"\t",v2,"\t",v3,"\t12:",(v1+v2)   );
  
  // ** Eo function()
}

void draw_vars(float f1,float f2,float f3){
  float r;
  noStroke(); strokeWeight(4);
  float er = 80;
  
  r= map(f1,0,1, 0,t_rad);
    noStroke();  fill(230,210,160);  // natural white
    ellipse(t1.x,t1.y,r,r);
  noFill(); stroke(230,210,160);
    ellipse(t1.x,t1.y,er,er);
  r= map(f2,0,1, 0,t_rad);
    noStroke();  fill(250);  // plain white
    ellipse(t2.x,t2.y,r,r);
  noFill(); stroke(250);
    ellipse(t2.x,t2.y,er,er);
  r= map(f3,0,1, 0,t_rad);
    noStroke();  fill(250,200,100);  // warm white
    ellipse(t3.x,t3.y,r,r);
  noFill(); stroke(250,200,100);
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
   clear_pixel();
}


void draw()
{
  
  
}
