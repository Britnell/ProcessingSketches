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
  
  translate(width/2, height/2);
  stroke(120);
  ellipse(0,0,3,3);
  
  // calc
  for(int i=0; i<balls; i++){
    r = baloons[i].update( );
    
    if(r==1){
      baloons[i].towards( randomGaussian()*width, randomGaussian()*height );
      baloons[i].speed(8 + 3.1*randomGaussian() );
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
    speed = 3;
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
    
    float dif = tx - x;
    
    //  -------  do X
   if(dif != 0)
   {
     if( abs(dif) <= lastStep) {
         x = tx;
         ret = 1;
       }
       else
       {
         val = dif / (speed * 60);
         
         if( abs(val) > maxStep)
         {
           if(tx > x)
               val = maxStep;
             else
               val = -maxStep;           
         }
         else if( abs(val) < minStep ) 
         {
             if(tx > x)
               val = minStep;
             else
               val = -minStep;             
         }
         
         x += val;  
       }   // Eo else
        
   }  // Eo diff NOT 0
   else
   {
     // diff = 0
      ret = 1; 
   }
   
   // ----------    do Y
   dif = ty - y;
   if(dif != 0){
     
     if( abs(dif) < lastStep){
        y = ty;
        if(ret==1)
          return 1;
        else
          return 0;
     }
     else
     {
       val = dif / (speed * 60);
       
       if( abs(val) > maxStep)
       {
         if( ty > y)
             val = maxStep;
           else
             val = -maxStep;
       }
       else if( abs(val) < minStep)
       {
           if( ty > y)
             val = minStep;
           else
             val = -minStep;
       }
       
       y += val;
       ret = 0;
     }  // Eo else
     
   }  // Eo diff=0
   else
   {
     if(ret==1)
       return 1;
     else
       return 0;
   }
   
   return ret; 
  }
  
  
  // Eo class
} 