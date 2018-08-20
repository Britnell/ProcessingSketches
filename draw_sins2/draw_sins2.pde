




void setup()
{
  size(1200,800);
  frameRate(1);
  
  
}



void draw()
{
  
  background(0);
  //stroke(120,20,10);
  //draw_sin(height/10, height*2/10, 8*PI);
  
  //draw_sin(height/20, height*2/10, 4*PI);
  noFill();
  stroke(10,140,10);
  strokeWeight(4);
  bez_sin( height/10, height*2/10+0, 8*PI);
  // Eo draw()
  stroke(10,20,140);
  strokeWeight(4);
  rand_sin( height/10, height*2/10+10, 8*PI);
  
}


// ***     *  *  *  *
// *
// *
float dif = 0;

void bez_sin( int amplit, int offset, float range)
{
  // range number of cycles in WIDTH
  float step = width / (range/PI);
  float bez = step*0.37;
  
  float temp;
  
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
      // since starting on peak, next is trough
      // bezierVertex( c1, c1,   c2, c2,   p2, p2)
      
      now.set( x, offset - amplit);
      bezierVertex( last.x+bez, last.y,   now.x-bez, now.y,    now.x,  now.y);
      last.set(now);
      
      x += step;
      now.set( x, offset + amplit);
      bezierVertex( last.x+bez, last.y,   now.x-bez, now.y,    now.x,  now.y);
      last.set(now);
    }  // Eo else
    
  }  // Eo for
  endShape();
  
  // Eo bez_sin()
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


// ## ##