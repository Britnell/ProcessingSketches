

void setup(){

  size(1200,800);
}

void draw()
{
  frameRate(50);
  noStroke();
  fill(0,30);
  rect(0,0,width, height);
  
  stroke(250);
  fill(250);
  ellipse(mouseX, mouseY,20,20);
  
}