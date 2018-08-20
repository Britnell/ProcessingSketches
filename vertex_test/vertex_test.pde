
PShape sh1;
PShape tri;

void setup()
{
  size(1200,800);
  background(0);
  
  // shape1
  sh1 = createShape();
  sh1.beginShape();
  sh1.vertex(10,10);
  sh1.vertex(10,80);
  sh1.vertex(80,80);
  sh1.vertex(80,10);
  sh1.endShape();
  
  tri = createShape();
  tri.beginShape(TRIANGLE_STRIP);
  tri.vertex(0,0);
  tri.vertex(10,0);
  tri.vertex(10,15);
  tri.vertex(50,5);
  tri.vertex(65,40);
  tri.vertex(70,2);
  tri.vertex(83, 60);
  tri.endShape();
  
  // draw
  shape(sh1, width/2, height/2);
  shape(tri, 30, 400);
  // Eo setup
}


void draw()
{
 
  
}