
float x=0;

void setup()
{
  size(800,600);
}

void draw()
{
  background(0);
  
  fill(100,0,0);
  ellipse(x,height/2,30,30);
  x++;
  if(x>width)  x=0;
}