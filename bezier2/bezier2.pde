/*
Draws arched bezier curves across screen.
the bezier control point follows the mouse
*/

class Arch {
  // begin and end point
  int X1, Y1, X2, Y2, Bx, By;
  
  Arch(int x1, int y1, int x2, int y2){
    X1 = x1;
    Y1 = y1;
    X2 = x2;
    Y2 = y2;
    
    Bx = (X1 + X2) / 2;
    By = (Y1 + Y2) / 2;
  }
  
  void B( int x, int y){
    Bx = x;
    By = y;
  }
  
  void Draw()
  {
    
    bezier( X1, Y1, Bx, By,   Bx, By,  X2, Y2 );
  }
  
}

int As = 10;
int diff_a = 50;
int diff_b = 10;
Arch [] arches = new Arch[As];


void setup(){
  size(1200,800);
  for(int x=0; x<As; x++){
    arches[x] = new Arch(0,x*diff_a, width, x*diff_a);
    //arches[x].Draw();
  }
  
}


void draw()
{
  background(0);
  stroke(255);
  strokeWeight(5);
  noFill();
  for(int x=0; x<As; x++){
    arches[x].B(mouseX, mouseY+x*diff_a);
    arches[x].Draw();
  }
}