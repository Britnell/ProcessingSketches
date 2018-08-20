// Lines fillowing mouse to figure out how to detect closest edges and vertexes

PShape shi;
int vi = 0;
int drawing;

void setup()
{
  size(800, 800);

  shi = createShape();
  shi.beginShape(TRIANGLE_STRIP);
  vi = 0;
  drawing = 1;

  shi.vertex(width/2, height/2);
  shi.endShape();
}

void draw()
{
  // needed for mouse
  //background(0);
  //shape(shi);
}

void mouseClicked()
{
  /*for (int i=0; i<shi.getVertexCount(); i++)  {
    PVector vec = shi.getVertex(i);      println("i: ", i, " - ", vec.x, ", ", vec.y);
  }*/
  
  if (drawing==1) {
    PVector temp = new PVector( mouseX, mouseY);
    //shi.setVertex(vi, temp);
     
    
    shi.beginShape(TRIANGLE_STRIP);
    shi.vertex(mouseX, mouseY);  
    shi.endShape();
    vi++;    
  } 
  else
    drawing = 1;
    
  
}


void mouseMoved()
{
  background(0);

  shape(shi);

  // # # Search closest

  // calc vars
  float c_dist = height+width;
  int closest = 0;
  float s_dist = height+width;
  int second = 0;

  // check all nodes for 
  for (int i=0; i<shi.getVertexCount(); i++)
  {

    PVector vec = shi.getVertex(i);
    println("i: ", i, " - ", vec.x, ", ", vec.y);

    stroke(10, 70, 180);
    line(vec.x, vec.y, mouseX, mouseY);    

    // vex - mouseX
    vec.sub( mouseX, mouseY);
    float mm = vec.mag();
    
    if (mm < c_dist) {
      // repl 2nd with 1st
      second = closest;
      s_dist = c_dist;
      // repl 1st with new
      c_dist = mm;
      closest = i;
    } else if (mm < s_dist) {
      second = i;
      s_dist = mm;
    }
  }
  println("clos : ", closest, " = ", c_dist);
  println("\tsec : ", second, " = ", s_dist);
  stroke( 180, 10, 10);
  line( shi.getVertex(closest).x, shi.getVertex(closest).y, mouseX, mouseY);
  stroke( 60, 180, 0);
  line( shi.getVertex(second).x, shi.getVertex(second).y, mouseX, mouseY);
}

void keyPressed()
{

  if (key == 's') {
    // S 
    drawing = 0;
    PVector temp = shi.getVertex(vi-1);
    shi.setVertex(vi, temp);
  }


  // Eo CODED
  //
}