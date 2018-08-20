



void setup(){
  size(1200,1000);
  background(0,120,30);
  noFill();
  stroke(255);
  strokeWeight(5);
  
  translate(0,20);
  translate(60,0);
  bezier(0,0,  800*0.55,0,   800, 800*0.45,   800, 800);
  
  noStroke();
  fill(120,30,0);
  //ellipse(0, 800,  1600, 1600);
  
  arc(0,800, 1600.0, 1600.0, 1.5*PI, TWO_PI);
  
}


void draw()
{
  //background(0);
  //bezier(0,0,  mouseX, mouseY, mouseX, mouseY,  800, 800);
   
}