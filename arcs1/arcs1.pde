


void setup()
{
  size(1200,800);
  
}

int x1 = 600;
int y1 = 400;

float rads = 0;

void draw()
{
  background(0);
  stroke(255);
  fill(60);
  
  rads += 0.005;
  if(rads >= 2*PI)
    rads = 0;
    
  arc(x1, y1, mouseX, mouseY, rads, 2*PI);
}