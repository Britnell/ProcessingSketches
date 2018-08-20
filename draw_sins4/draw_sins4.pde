/*
  A shifting sin wave
  bezier array is created, 
  then num_moving elements are Shifted at random.
  
  !!due to split bezier, immediately rough edges occur
*/

int len = 0;
Shift [] wave = new Shift[50];
Shift [] funky = new Shift[50];

void setup()
{
  size(1200,800);
  frameRate(60);
  wave = bez_ray(height/10, height/2, 200);
}

int num_moving = 10;
float ran_x = 5;
float ran_y = 5;

void draw()
{
  // update
  // if moving < 2
  // shift by rand impulse
  
  int moving =0;
  
  for(int i=0; i<wave.length; i++){
     int ret = wave[i].update();
     if( ret!=1){
       // x on target
       moving ++;
     }
  }
  
  // if not all moving, add new moving
  //    at 10% chance, so not all moving together 
  if(moving < num_moving && random(1)<0.1 )
  {
    // chose random one, not moving
    int ran = int( random(wave.length) );
    while( wave[ran].is_still() != 1){
       ran = int( random(wave.length) );
    }
    
    // add random impulse
    wave[ran].impulse( ran_x*randomGaussian(), ran_y*randomGaussian() );
    
  }
  
  
  // randomize
  
  background(0);
  
  noFill();
  stroke(10,140,10);
  strokeWeight(4);
  bez_draw( wave);
  
}

// Randomize

// ***     *  *  *  *
// *
// *

Shift[] bez_ray( int amplit, int offset, float wavelen)
{
  // range number of cycles in WIDTH
  float step = wavelen/2;       //width / (range/PI);
  float bez = step*0.37;
  
  //int ray_len = 1 + ceil(range/TWO_PI) *6 ;        // 1 + ceil(3*width/step);
  int ray_len = 1 + ceil(width/wavelen) *6 ;        // 1 + ceil(3*width/step);
  
  //println("estimated ", ray_len);
  //println(" ceil ", ceil(width/wavelen) );
  
  Shift [] ray = new Shift[ray_len];
  int r_l = 0;
  
  // ~ Initialise
  for(int i=0; i<ray_len; i++){
     ray[i] = new Shift(0,0);
     ray[i].speed(6);
  }
  
  // Fill array
  float w=0;
  while(w < width)
  {
    //println("x/y ",r_l," ", w );
    
    // add first anchor point, after first is always last from previous
    if(r_l ==0){
      ray[r_l].Set( w, offset-amplit);    
      r_l++;
    }
     
    // c1 
    ray[r_l].Set( w+bez, offset-amplit);
    r_l++;
    
    w += step;
    
    // c2
    ray[r_l].Set( w-bez, offset+amplit);
    r_l++;
    // p2
    ray[r_l].Set( w, offset+amplit);
    r_l++;
    // c2.1
    ray[r_l].Set( w+bez, offset+amplit);
    r_l++;
    
    w += step;
    
    // c2.2
    ray[r_l].Set( w-bez, offset-amplit);
    r_l++;
    // p2.2
    ray[r_l].Set( w, offset-amplit);
    r_l++;
    
    // w += step done by for loop
  }  // Eo for
  
  //println("r_l", r_l);
  //println("array length ", ray.length);

  return ray;
  // Eo bez_sin()
}

void bez_draw( Shift[] ray )
{
  beginShape();
  
  vertex(ray[0].x, ray[0].y);
  //println("drawer len : ", ray.length );
  
  for(int x=1; x<ray.length; x+=3)
  {
    // add first vertex, after first is from last
    
    // c1, c2, p2
    bezierVertex( ray[x+0].x, ray[x+0].y,    
                   ray[x+1].x, ray[x+1].y,  
                    ray[x+2].x, ray[x+2].y );
    
  }  // Eo for
  
  endShape();
  // Eo bez_draw
}  

void rand_sin( int amplit, int offset, float range)
{
  // range number of cycles in WIDTH
  float step = width / (range/PI);
  float bez = step*0.37;
  float factor_x = 10;
  float factor_y = 10;
  
  PVector rand= new PVector();
  
  beginShape();
  
  PVector last = new PVector( );
  PVector now = new PVector( );
  
  for(float x=0; x<=width; x+=step)
  {
    if(x==0){
      // always start on peak
      last.set(0,offset +amplit);
      vertex( last.x, last.y);
    }
    else
    {
      //rand.set( noise(x), noise(x) );
      rand.set( randomGaussian()*factor_x, randomGaussian()*factor_y );
      
      // since starting on peak, next is trough
      // bezierVertex( c1, c1,   c2, c2,   p2, p2)
      now.set( x +rand.x, offset - amplit +rand.y);
      bezierVertex( last.x+bez, last.y,   now.x-bez, now.y,    now.x,  now.y);
      last.set(now);
      
      x += step;
      rand.set( randomGaussian(), randomGaussian() );
      now.set( x +rand.x, offset + amplit +rand.y);
      bezierVertex( last.x+bez, last.y,   now.x-bez, now.y,    now.x,  now.y);
      last.set(now);
    }  // Eo else
    
  }  // Eo for
  endShape();
  
  // Eo bez_sin()
}


// ## ##        Class
// #
// #


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
  
  public int is_still( ) {
     if( x==tx && y==ty )
       return 1;
     else
       return 0;
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
  
  public void impulse(float ix, float iy ){
    tx = x + ix;
    ty = y + iy;
  }
  
  // returns 1 if point has reached target
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