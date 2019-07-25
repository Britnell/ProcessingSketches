//


import de.voidplus.leapmotion.*;
LeapMotion leap;


import processing.serial.*;
Serial arduino;


color bar_c = color(60, 80, 120);

PVector last_vec = new PVector(0,0,0);

ArrayList<PVector> impulses = new ArrayList<PVector>();

int last_imp = 0;
boolean shake = false;
int shake_t = 0;
boolean first_shake_b = true;
int first_shake_t = 0;

void detect_shake( PVector vec )
{
  
  PVector temp = PVector.sub( vec, last_vec);
  
  PVector centr = new PVector( width/2, height/2, 0);
  
      // # scale absolute vel vector
  //float x_val = map( temp.x -950, -2000, 2000, -500, 500);
  //float y_val = map( temp.y -800, -1000, 1000, -500, 500 );
  //float x_val = map( temp.x , -500, 500, -500, 500);
  //float y_val = map( temp.y , -500, 500, -500, 500 );
  float x_val = temp.x;
  float y_val = temp.y;
   
  //System.out.println(temp);
  
  // check for spikes
  if( temp.mag() > 200 ) 
  {
    //System.out.print( temp.mag() );    System.out.print(",  ");   System.out.println( temp.heading() );
    //System.out.print(" last imp ");   System.out.println( millis() -last_imp);
    
    // get shaketime for debounce
    if(first_shake_b) {
      first_shake_b = false;
      first_shake_t = millis(); 
    }
    //System.out.println( millis() -last_imp );
    
    // time debounce
    if( millis() -last_imp < 50) {
       
       // add to list
       impulses.add( temp );
       float dir_changes = 0;
       
//       float prev_angle = impulses.get(0).heading();
//       float this_angle;
       // sum up angle diffr
       for( int i=1; i<impulses.size(); i++ ){
          // count dir changes
          dir_changes += ( PVector.angleBetween(impulses.get(i), impulses.get(i-1)) ) ;
          //
       }
       //System.out.print(" angle change sum "); System.out.println(dir_changes);
       if( dir_changes > 20 ) {
         // its a shake!
         shake = true;
         shake_t = millis(); 
       }
    }
    else {
      // clear array 
       for( int x=0; x< impulses.size(); x++)         impulses.remove(0);
       //System.out.println(" reset shake");
       first_shake_b = true; 
    }
    
    last_imp = millis();
  }
  
  // draw accel line
//    fill(bar_c);
//    stroke(bar_c);
//    //rect( width/2, height/2, x_val, y_val );
//    strokeWeight(10);
//    line( centr.x, centr.y,  centr.x +x_val,  centr.y +y_val );
    
    
  last_vec = vec;
}



int centre_dist_bright;
color background_col = color(255, 255, 255);


PVector trail_pos;
PVector trail_mov;



void setup() {
  //size(800,800);
  size(1900, 1000);
  //size(1900, 800); 
  //size(displayWidth, displayHeight); 

  background(255);
  
  // arduino seria
  printArray(Serial.list());
  //arduino = new Serial(this, Serial.list()[1], 115200);
  
  trail_pos = new PVector( width/2, height/2);
  trail_mov = new PVector( 0,0);
  
  // leap motion
  leap = new LeapMotion(this);
  //
  
  
  // varialbes
  
  // Eo setup
}


color col;

void draw_trail() {
  trail_pos.add( PVector.div(trail_mov, 3) ); 
  stroke( 10, 10, 160);    strokeWeight(20);
   ellipse( trail_pos.x, trail_pos.y, 20, 20);
   
   //System.out.println( trail_pos);
   //
}

PVector get_screen_point( PVector posit, PVector direct ) 
{
  PVector point = new PVector(0,0);
  
          // calculate X point position
  float x_angle = -atan2( direct.z, direct.x );
  
  float point_view_left = map( posit.x, 250, 900, 2.35, 2.55 );
  float point_view_right = map( posit.x, 250, 900, 0.6, 1.07 );
  
  point.x = map( x_angle, point_view_left,  point_view_right, 0, width);
  
  
          // cac Y point position
  // Y = y.axis : up down forward
  // X = z.axis : frward / backward ( will always be -1.0)
  float y_angle = atan2( direct.y, direct.z);
  if( y_angle < 0 )
    y_angle = ( PI+(PI+y_angle) );
  
  float point_view_high  = map( posit.y, 250, 600, 3.3, 3.74 );
  float point_view_low  = map( posit.y, 250, 600, 2.55, 3.10 );
  point.y = map( y_angle, point_view_high, point_view_low, 0, height);

  return point;  
}



                                                        // Vector magnitude tracking
int still_hist = 10;
float still_thr = 50;
int still_len = 0;
int still_i = 0;
PVector still_last;
float [] stillness = new float [still_hist];

int vec_hist = 10;
PVector [] vec_track = new PVector [vec_hist]; 
int vec_i = 0;
int vec_len = 0;

void clear_vec() {
  still_len = 0;
  still_i = 0;
}


void add_to_track( PVector point )
{
  float sum = 0;
  
  // - add to array
  if( still_len == 0) {
    still_len++;
  }
  else 
  {
    stillness[still_i] =  PVector.sub( point, still_last ).mag();
    //println(" mov = ", stillness[still_i] );
    still_i++;
    if( still_i == still_hist )     still_i = 0;
    
    if( still_len < still_hist)
      still_len++;
  }
  still_last = point;
}

float get_track_magn( )
{
  float sum = 0;
  // - calc sum
  if( still_len < still_hist ) {
    //return false; 
  }
  else {
    sum = 0;
    for( int i= 0; i<still_hist; i++) {
      sum += stillness[i];
    }
    //println(" mov sum = ", sum );
  }
  
  //return false;
  return sum;
}

boolean swipe_bo = false;

void swipe_debounce( float fact, float thresh) {
  if( fact > thresh) {
    
  }
  else {
    // not a swipe 
  }
  
}
//boolean still = false;




void draw_cursor( PVector point, int r, int g, int b  ) {
  noStroke( );        fill(r,g,b);  
  ellipse( point.x, point.y, 20, 20);  
}

void draw_vector( PVector vec, int r, int g, int b ) {
  stroke(r, g, b);    strokeWeight(10); 
  line( width/2, height/2, width/2 -vec.x , height/2 -vec.y );
}

PVector get_angles( PVector direct) {
  PVector angle = new PVector();
  
  angle.x = atan2( direct.z, direct.x ) +HALF_PI;
  angle.y = atan2( direct.y, direct.z );
  
  return angle;
}

PVector last_handPos = new PVector();

void draw() {
  background(background_col);
  // ...
  float fps = leap.getFrameRate();
  //println("fps: ", fps);
  
  for (Hand hand : leap.getHands ()) {
    //PVector handPosition = hand.getPosition();
    PVector handRaw = hand.getRawPosition();
    //PVector handStabil = hand.getStabilizedPosition();
    
    Finger finger = hand.getIndexFinger();
    PVector fingerPosition   = finger.getRawPosition();
    PVector fingerVelocity   = finger.getVelocity();
    PVector fingerDirection  = finger.getDirection();
    PVector point = get_screen_point( fingerPosition, fingerDirection );
    //PVector point = fingerPosition;
    
    
      // - raw
    //println("X - raw: ", handRaw.x, " , x: ", handPosition.x );
    //println("Y - raw: ", handRaw.y, " , y: ", handPosition.y );
    PVector handPos = new PVector();
    //vec.x = handRaw.x +300;
    //vec.y = 900 -handRaw.y;
    handPos.x = map( handRaw.x, -300, 300, 0, width);
    handPos.y = map( handRaw.y, 100, 600, height, 0);
    handPos.z = handRaw.z;
    
    //println("hand -pos ", vec);
    draw_cursor( handPos, 60, 190, 60 );
    
    PVector diff = PVector.sub(handPos, last_handPos );
    //println("diff:  ", diff.mag() );
    draw_vector( diff, 40, 40, 100);
    
    last_handPos = handPos;
    
      //draw_cursor( handPosition, 30, 30, 110);
      //draw_cursor(point);
      
      //System.out.print("Y : ");     System.out.print( fingerPosition.y );
      //System.out.print(" z : ");     System.out.print( fingerDirection.z );
      //System.out.print(" angle : ");     System.out.println( y_angle );
      //float still = check_stillness( handPos, 120 );
      
      add_to_track( handPos);
      float still = get_track_magn();
      fill(40, 80, 140);
      //rect( 100, height/3, 100, still ); //map(still, 0, 1000, 0, height/3)
      float still_r = map(still, 0, 1000, 0, 500);
      ellipse(100, height/2, still_r, still_r); 
      
      swipe_debounce( still, 130);
      
      
      
      PVector angle = get_angles(fingerDirection);
      //println(" x: ", angle.x, " , y: ", angle.y); 
      
      detect_shake( fingerVelocity  );
      
      
    // ## Eo for hand()
  }
  
  if(  leap.getHands().size() == 0){
    // no hands
    //arduino.write( 0 );
    
    // back to hand state
    
    // clear still tracker
    clear_vec();
    
    background_col = color(255, 255, 255);
    
    trail_mov = new PVector( width/2 -trail_pos.x,  height/2 -trail_pos.y );
  }
  
  
  
  
  
      // do the trail
  
  // ## Eo draw
}




// ----