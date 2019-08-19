

PVector canvasSize, canvasPos; 

int PIXEL_X = 8;
int PIXEL_Y = 8;
float PIXEL_W, PIXEL_H;

color paintCol;

void setup()
{
  
  size(800, 800);
  colorMode(RGB, 255, 255, 255);
  
  paintCol = color( 40, 0, 0 );
  
  canvasSize = new PVector( 600,600 );
  canvasPos = new PVector( 100, 100 );
  
  PIXEL_W = canvasSize.x / PIXEL_X;
  PIXEL_H = canvasSize.y / PIXEL_Y;
  
  int frameS = 5;
  background(0);
  noFill();  stroke(255);  strokeWeight(frameS);
  rect(canvasPos.x-frameS, canvasPos.y-frameS, 
        canvasSize.x+frameS, canvasSize.y+frameS);
  
  // ** Eo setup
}



void draw()
{
  
  // ** Eo draw
}



void draw_pixel( int X, int Y )
{
  // just draw the right rect
  
  // find index
  
  float rx = map( X, 
             canvasPos.x, canvasSize.x +canvasPos.x ,
             0, PIXEL_X );
  rx = constrain(rx, 0, PIXEL_X );
  
  float ry = map( Y, 
             canvasPos.y, canvasSize.y +canvasPos.y ,
             0, PIXEL_Y );
  ry = constrain(ry, 0, PIXEL_Y );
  
  int Rx = floor(rx);
  int Ry = floor(ry);  
  
  fill(paintCol);  noStroke();  
  rect( canvasPos.x +Rx* PIXEL_W, 
         canvasPos.y +Ry * PIXEL_H,
         PIXEL_W, PIXEL_H );
  
  
  // ** Eo draw pixel
}


void mousePressed()
{
    draw_pixel(mouseX, mouseY);
}


void mouseDragged()
{
    draw_pixel(mouseX, mouseY);
}

void mouseReleased()
{
   send_pixels(); 
}

void send_pixels()
{
  for( float y=canvasPos.y+PIXEL_H/2; y<canvasPos.y+canvasSize.y;  y+=PIXEL_H )
  {
    
    for(float x=canvasPos.x+PIXEL_W/2; x<canvasPos.x+canvasSize.x;  x+=PIXEL_W )
    {
      // we on X and Y
      color c = get( int(x), int(y) );
      println(x, y, red(c), green(c), blue(c) );
      
      // * For Y
    }
    // * for X    
  }
  
  // Eo function  
}

void keyPressed()
{
  //if(key==){
  //  println("SPACEKEY");
  //}
  // EO keyPressed
}
