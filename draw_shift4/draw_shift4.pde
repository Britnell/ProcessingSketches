/*
shifting point with array of 30 points
*/


int balls = 30;
Shift [] baloons = new Shift[balls];

void setup()
{
  size(1200,800);
  frameRate(60);
  //translate(width/2, height/2);
  for(int i=0; i<balls; i++){
    baloons[i] = new Shift( random(width), random(height) );
  }
  
  
}


void draw()
{
  int r;
  background(0);
  
  //translate(width/2, height/2);
  stroke(120);
  ellipse(0,0,3,3);
  
  // calc
  for(int i=0; i<balls; i++){
    r = baloons[i].update( );
    
    if(r==1){
      //baloons[i].towards( randomGaussian()*width, randomGaussian()*height );
      baloons[i].towards( mouseX, mouseY);
      baloons[i].speed( random( 0.3,2) );
    }
    
    stroke(0,40,140);
    ellipse(baloons[i].x, baloons[i].y, 10,10);
  }
  
  // draw
  
  
  
}

public class Shift
{
  public float x,y;
  float tx, ty;
  public float speed;
  
  public float minStep = 0.1;
  public float maxStep = 5;
  public float lastStep = 0.3;
  
  public Shift(float xx, float yy){
    x = xx;
    tx = xx;
    y = yy;
    ty = yy;
    speed = 0.3;
  }
  
  public float X(){
     return x; 
  }
  
  public float Y(){
     return y; 
  }
  
  public void speed( float S){
     speed = S; 
  }
  
  public void Set(float xx, float yy) {
     x = xx;
     y = yy;
     tx = xx;
     ty = yy;
  }
  
  public void towards( float nx, float ny){
    tx = nx;
    ty = ny;
  }
  
  // returns 1 if x onhas reached target
  public int update( ){
    int ret = 0;
    float val;
    
    //println("vals ", x, " : ", y );
    //println("diff ", (tx-x), " : ", (ty-y) );
    PVector dir;
    
    dir = new PVector( tx-x, ty-y);
    
    if( abs(tx-x) <= lastStep){
       dir.x = 0;
       x = tx;
    }
    if( abs(ty -y) <= lastStep){
       dir.y = 0;
       y = ty;
    }
    
    dir = dir.normalize();
    dir.mult( speed);
    
    x += dir.x;
    y += dir.y;
    
   if( dir.x ==0 && dir.y==0)
     ret = 1;
   
   return ret; 
  }
  
  
  // Eo class
} 