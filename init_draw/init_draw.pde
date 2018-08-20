// HSB

color black, white, grey, red, blue,green;


void setup()
{
  colorMode(HSB, 360,100,100);
  
  // size() sets gobal vars width & height
  size(400,400);
  
  black = color(0,0,0);
  white = color(0,0,100);
  grey = color(0,0,50);
  
  background(grey);
  
  point(width/3,height/3);
  point(width/3,height*2/3);
  point(width*2/3,height/3);
  point(width*2/3,height*2/3);
  
  strokeWeight(3);
}


void draw()
{
  
  stroke(map(mouseY,0,height,0,360), 70,70);
  line(width/2,height/2, mouseX, mouseY);
  
  // opacity, 255=100%,   0=0% 
  //background(c_back);
}