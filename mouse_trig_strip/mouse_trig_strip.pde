

PShape shi;
int vi = 0;
int drawing;

void setup()
{
  size(1200,800);
  
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
  background(0);
  shape(shi);
}

void mouseClicked()
{
  if(drawing==1){
    PVector temp = new PVector( mouseX, mouseY);
    shi.setVertex(vi, temp);
    
    shi.beginShape(TRIANGLE_STRIP);
    shi.vertex(mouseX, mouseY);  vi++; 
    shi.endShape();
  }
  else
    drawing = 1;
}

void mouseMoved()
{
   //shi.vertex(mouseX, mouseY);
   if(drawing==1){
     PVector temp = new PVector( mouseX, mouseY);
     shi.setVertex(vi, temp);
   }
  
}

void keyPressed()
{
  
     if(key == 's'){
        // S 
       drawing = 0;
       PVector temp = shi.getVertex(vi-1);
       shi.setVertex(vi, temp);
     }
    
    
   // Eo CODED
  //
}