

float p1x = 1000;
float p1y = 200;

float p2x = 200;
float p2y = 600;

float b1x = 0;
float b1y = 0;

void setup(){
  size(1200,800);
  
}


void draw()
{
  background(0);
  stroke(255);
  strokeWeight(5);
  noFill();
  bezier(p1x, p1y,  b1x, b1y,   b1x, b1y,  p2x, p2y);
  b1x += 1;
  b1y += 1;
  
}