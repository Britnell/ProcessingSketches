

PShape shi;


void setup()
{
  size(1200,800);
  float w2 = width/2;
  float h2 = height/2;
  
  shi = createShape();
  
  shi.beginShape(TRIANGLE_STRIP);
  //shi.fill(255);
  //shi.stroke(255);
  shi.vertex( w2-80, h2-30);
  shi.vertex( w2+80, h2-30);
  shi.vertex( w2, h2+80);
  //shi.endShape();
}

void draw()
{
  // needed for mouse
  
}

void mouseMoved()
{
  background(0);
  
  shape(shi);
  
  for(int i=0; i<shi.getVertexCount(); i++)
  {
    PVector vec = shi.getVertex(i);
    stroke(10,50,80);
    line(vec.x, vec.y, mouseX, mouseY);    
  }
  
}


//