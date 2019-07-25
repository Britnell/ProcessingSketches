
class Dot{
 int x, y, r;
 color col;
 
 Dot( )
 {
    x = 0;
    y = 0;
    r = 0;
    col = color(255);
 }
 
 Dot( int xx, int yy, int rr )
 {
    x = xx;
    y = yy;
    r = rr;
    col = color(255);
 }
 
 void set(int X, int Y, int S){
   x  = X;
   y = Y;
   r = S;
 }
 
 void move(int dx, int dy) {
    x += dx;
    y += dy;
 }
 
 void Draw()
 {
   noStroke();
   fill(col);
   ellipse(x,y,r,r);   
 }
  
}

Dot d1 = new Dot(10,10,10);
Dot d2 = new Dot(600,600,50);

void setup()
{
  size(240,320);
  background(0);
  
  d1.Draw();
  d2.Draw();
}

void draw()
{
  background(0);
  d1.move(1,1);
  d1.Draw();
  d2.move(-1,0);
  d2.Draw();
}
