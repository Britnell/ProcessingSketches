import de.voidplus.leapmotion.*;

// ======================================================
// Table of Contents:
// ├─ 1. Callbacks
// ├─ 2. Hand
// ├─ 3. Arms
// ├─ 4. Fingers
// ├─ 5. Bones
// ├─ 6. Tools
// └─ 7. Devices
// ======================================================


LeapMotion leap;

void setup() {
  size(1024, 640, P3D);
  background(255);
  // ...

  leap = new LeapMotion(this);
}



void grab_anim( float drag )
{
  noFill();
  stroke( 100, 100, 10);
  strokeWeight(3);
  translate( width/2, height/2, -5*drag );

  for ( int i=0; i< 5; i++) {
    box(50, 50, 50 );
    translate(0, 0, 100);
  }
}

float grab_vol = 0;

void grab_wheel( float roll )
{
  roll = map( roll, -50, 50, -HALF_PI, HALF_PI );
  noFill();
  stroke(0);
  strokeWeight(20);
  arc( width/2, height/2, 500, 500, PI*2/3, PI*7/3 );  
  stroke( 255);        
  strokeWeight(10);
  arc( width/2, height/2, 500, 500, PI*2/3, PI*3/2 +roll );
}
boolean fist_debounce = false;

int mat_b = 22;
int mat_w = 220;

void up_scroll( PVector dist)
{
  strokeWeight(3);
  translate( dist.x, 2*dist.y, -10*dist.z );
  for ( int y=0; y<5; y++)
    for ( int x=0; x<5; x++)
    {
      fill( 40, 40+y*40, 40+x*40 );
      rect( mat_b +x*(mat_w+mat_b), mat_b +y*(mat_w+mat_b), mat_w, mat_w );


      // Eo for x
    }
  // Eo func
}


PVector drag_start;
PVector drag_posit = new PVector( 0,0, 0);


void pinch_drag( PVector drag )
{ 
     System.out.print("drag V ");        System.out.println( drag);
     
     // position.X 0 to 1000 , left to right
     // position.Y  500 = 5 cm  ;   30 = 0.5m 
     // position z =   45 = middle ; 80 forward  ;  0 backward
     //System.out.print("position " );    System.out.println(handPosition );
       //float x = map( drag.x, 0 , 1000, 0, width );
       //float y = map( drag.y, 30, 500, 0, height );
       //float z = map( drag.z, 0, 80,  300, -100 );
       //translate( x, y, z);
     //float x = map( drag.x, 0 , 1000, 0, width );
     //float y = map( drag.y, 30, 500, 0, height );
     //float z = map( drag.z, 0, 80,  300, -100 );
     translate( width/2, height/2, 0);
     
     translate( drag.x,   2*drag.y,  -8*drag.z  );
     stroke(0);    strokeWeight(4);
     noFill();
     box(100);
     // roll, twist arm 
     // twist left to -180
     // twist right to +180
     // -> rotate Z
     //System.out.print("roll ");    System.out.println(handRoll );
     //rotateZ( handRoll *PI /180 );
     //rotateX( handPitch *PI /180 );
     //rotateY( handYaw *PI /180 );
  
}



char handState = 'n';



float grab_begin;
float grab_pos = 0;
float grab_z;

int debounce_delay = 0;
char lastState = 'n';

int pinchTime = 0;
int pinch_delay = 0;
boolean pinch_delay_bo =true;
boolean pinch_delay_bo_once =false;

// $$

                                                //   ##    handRoll gestures

                                                // # Roll
int roll_debounce = 0;                
int roll_debounce_thresh = 100; 
boolean roll_debounce_i = false;
boolean in_scroll = false;


float scroll_hand_begin;
float scroll_last = 0;
float scroll_dist = 0;

void begin_scroll_callback( Hand hand ){ 
  scroll_hand_begin = hand.getPosition().x; 
  handState = 's';
  //System.out.println("begin scroll");
}

void scroll_callback( PVector position) {
  // map hand x position to scroll dist  
  scroll_dist = map( (position.x-scroll_hand_begin), -250, 250, -width/4, width/4 );
  //System.out.println(scroll_dist);
  
  // draw scroll menu
  for ( int i=-5; i<6; i++) {
    slice( scroll_last +scroll_dist -(i*200), 150, (i+5)*25);
  } 
}

void end_scroll_callback() {
  // add scroll dist to scroll position
  scroll_last += scroll_dist;
  handState = 'n'; 
  //System.out.println("end scroll");
}


void slice( float offs, float scale, int col)
{
  strokeWeight(1);
  fill( col, 20, 255 -col);

  beginShape();
  vertex( offs +width/2, scale +height/2, scale );
  vertex( offs +width/2, scale +height/2, -scale );
  vertex( offs +width/2, -scale +height/2, -scale );
  vertex( offs +width/2, -scale +height/2, scale );
  endShape();
}


                                                // # Flip
boolean in_flip = false;
float volume = 50;
float volume_begin;
float volume_interm;
boolean volume_hold = false;

void begin_flip_callback( PVector position) {
  handState = 'v';
  //System.out.print("Flip");
  volume_begin = position.y;
}

void flip_callback( PVector position) {
  // only scroll when in centre
  if( position.x > 350 && position.x < 650 ) {
    // store intermediate val  for when exiting scroll area
    volume_interm = (position.y-volume_begin);    
    
    // draw
    draw_volume(  volume +1* volume_interm );      
    volume_hold = false;
  }
  else {
    // not in perimeter
    if(!volume_hold) {
      volume_hold = true;
      volume += 1*volume_interm; 
    }
    volume_begin = position.y;
    draw_volume(  volume );
    //draw_volume(  volume +2* volume_interm );
    //draw_volume(  volume +2*(handPosition.y-volume_begin) );
    // Eo in middle
  } 
}

void end_flip_callback( PVector position ) {
  handState = 'n';
  volume += 2*(position.y-volume_begin); 
  //volume += 2*(volume_interm);
}

void draw_volume( float vol)
{
  fill( 180);        noStroke();
  rect( width/2 -150, height/5, 300, height*3/5 );
  
  // box
  noFill();
  strokeWeight(10);
  stroke( 0);
  rect( width/2 -50, height/5, 100, height*3/5 ); 
  // vol bar
  fill(20, 80, 150);
  noStroke( );
  rect( width/2 -50, height/5 +vol, 100, height*3/5 -vol );
}


void check_handroll_gestures( Hand hand) 
{
  float handRoll = hand.getRoll();
  PVector handPosition = hand.getPosition();
  
  // 60 < roll < 120
  //System.out.print("roll ");    System.out.println(handRoll );    
      
  // check for scroll
  if ( handRoll > 60 && handRoll < 120  )    
    {
      // if not in a scroll gesture 
      if ( !in_scroll ) {
        // get initial timestamp
        if (!roll_debounce_i) {
          // get roll begin for debounce
          roll_debounce_i = true;
          roll_debounce = millis();
        } 
        else {
          // debounce roll
          if ( millis() -roll_debounce > roll_debounce_thresh ) {
            //
            begin_scroll_callback( hand);
            in_scroll = true;
          }
        }
        //System.out.print("Hand vertical");
      }
      
      // if already in scroll gesture
      if ( in_scroll ) {
        scroll_callback( handPosition);
      }
      // Eo hand vertical ~90
    } 
    else 
    {
      // debounce & end scroll
      roll_debounce_i = false;
      if ( in_scroll) {
        end_scroll_callback();
        in_scroll = false;
        //$roll_debounce_i = false;
      }
      
      //println( handRoll );
      // if hand flipped ~ +/- 180 
      if ( handRoll > 140 || handRoll < -150 ) {
        // begin flip
        if ( !in_flip ) {
          in_flip = true;
          begin_flip_callback( handPosition);
        } 
        else
        {
          // run flip
          //volume += (handPosition.y -volume_begin) /2;
          //System.out.println(handPosition.x);
          
          flip_callback( handPosition);
          
          // draw circle for hand position
          noFill();
          strokeWeight(3);      stroke( 40, 120, 40 );
          ellipse( handPosition.x,  handPosition.y,  30, 30 );
        }
        
        // Eo if 180
      } else {
        if (in_flip) {
          // bounce flip
          in_flip = false;
          end_flip_callback( handPosition );
        }
      }
    }
    //  Eo check scroll gestures
}

                                                      //    ##     vertical gesture

boolean in_palm = false;
PVector up_begin;
PVector up_track = new PVector(0, 0, 0);
PVector up_interm = new PVector(0, 0, 0);
boolean up_interm_bo = false;
boolean up_push_bo = false;
boolean up_pause = false;

void begin_palm_callback( PVector posit ) {
 handState = 'u';
 up_begin = posit; 
}

void end_palm_callback( PVector posit) {
  handState = 'n';
  up_track.add(PVector.sub( posit, up_begin) );
  System.out.print("stop  ");
}

PVector last_velocit = new PVector(0,0,0);

int tap_debounce_t = 0;
boolean tap_debounce = false;

boolean detect_tap_y( Hand hand ) {    //PVector velocit ) {
  PVector velocit = hand.getIndexFinger().getVelocity();
  PVector point = hand.getIndexFinger().getDirection();
  
  float tap = velocit.y - last_velocit.y;
  //last_velocit = velocit;
  
  //System.out.print("index velocit  ");    System.out.println( velocit );
  //System.out.print("index accel  ");    System.out.print( tap );
  //System.out.print(" in y : ");    System.out.println( velocit.x - last_velocit.x );
  
  if(tap_debounce)    // debounce
    if(millis() -tap_debounce_t >800){
      tap_debounce = false;
    }
  
  if(!tap_debounce)
  if( tap > 200 ) {    // detect  
    tap_debounce = true;
    tap_debounce_t = millis();
    System.out.print("smoosh! ");
    System.out.println( point );
    return true;
  }
  return false;
  //
}


int detect_tap_x( PVector velocit ) {
  float tap = velocit.x - last_velocit.x;
  //last_velocit = velocit;
  
  //System.out.print("index velocit  ");    System.out.println( velocit );
  
  if(tap_debounce)
    if( millis() -tap_debounce_t >800){
      tap_debounce = false;
    }
  
  if(!tap_debounce)
  if( tap > 500 ) {  
    tap_debounce = true;
    tap_debounce_t = millis();
    return -1;
  }
  else if( tap < -500) {
    tap_debounce = true;
    tap_debounce_t = millis();
    return 1;
  }
  
  return 0;
  //
}
       



boolean in_palm_bo = false;
int in_palm_t = 0;
int in_palm_bo_th = 600;

void check_palm_gesture( Hand hand) 
{
  float handPitch = hand.getPitch();
  PVector handPosition = hand.getPosition();
  
  PVector pointing = hand.getIndexFinger().getDirection();
  //System.out.print("pitch  ");    System.out.println(handPitch );
  //System.out.print("index point  ");    System.out.println(pointing );
  //System.out.print("velocit  ");    System.out.println(hand.getIndexFinger().getVelocity() );
  
  
  //if (handPitch > 39)
 // detect & enter palm mode
 if( !in_palm)
 if( pointing.y < -0.7) 
    {
      //System.out.print("pitch  ");    System.out.println(handPitch );
      
      // debounce palm
      if ( !in_palm ) {
        in_palm = true;
        begin_palm_callback( handPosition);
        in_palm_bo = true;
      }
      
      //System.out.print("d Z  ");    System.out.println( abs(handPosition.z - up_begin.z)   );
    }
  
  if( in_palm)
  if( pointing.y < -0.5)
    {
  
      // detect palm scroll
      if (!up_interm_bo && !up_push_bo)
        if ( (handPosition.x - up_begin.x) >150 ) {
          // palm scroll right
          music_i--;
          //up_begin.x += 150;
          up_interm_bo = true;
        }
      if (!up_interm_bo && !up_push_bo)
        if ( (handPosition.x - up_begin.x) < -150 ) {
          // palm scroll left
          music_i++;
          //up_begin.x -= 150;
          up_interm_bo = true;
        }        
      
      // unbounce after l/r scroll
      if (up_interm_bo)
        if ( abs(handPosition.x - up_begin.x) < 50 )
          up_interm_bo = false;
      
      // detect push = Z axis
      //System.out.print("d Z  ");    System.out.println( (handPosition.z - up_begin.z)   );
      // detect forward push
      if ( !up_interm_bo && !up_push_bo)
        if (handPosition.z - up_begin.z > 15 ) {
          //System.out.println("Push pause  ");
          
          // pause / unpause
          if (up_pause)            up_pause = false;
          else            up_pause = true;
          
          up_push_bo = true;
        }
      
      // unbounce push
      if (handPosition.z - up_begin.z < 8 ) {
        up_push_bo = false;
      }
      
      // detect tap forward
      if (!up_interm_bo && !up_push_bo)
      if( detect_tap_y( hand ) )  {
        // its a tap!
        if (up_pause)            up_pause = false;
          else            up_pause = true;
      }
      
      // detect tap / flick sideways
      PVector velocit = hand.getIndexFinger().getVelocity();
      
      if (!up_interm_bo && !up_push_bo)
        music_i += detect_tap_x( velocit );    // instead of booean, add for -1, 0, +1
      
      last_velocit = velocit; 
      
      // draw
      draw_music( music_i, up_pause );
      
      // get time for debounce
      in_palm_t = millis();
    } 
    else 
    {
      // no longer pointing up
      
      //System.out.print("pitch  ");    System.out.println(handPitch );
      //System.out.print("grab  ");    System.out.println(handGrab );
      if ( in_palm ) 
      if(in_palm_bo) 
      {
        draw_music( music_i, up_pause );  // if debouncing, draw anyway
        
        if( millis() -in_palm_t > in_palm_bo_th )
        {
          // end
          in_palm = false;
          in_palm_bo = false;
          end_palm_callback( handPosition);
        }
        //else    System.out.println(" palm debounce");
      }
    }  
  
   // 
}


int music_i = 3;
int music_squ = 100;
int music_sep = 300;
void draw_music( int ind, boolean pause)
{
  noStroke();

  for ( int i= 0; i<5; i++) {
    if ( ind==i)
      music_squ = 150;
    else
      music_squ = 100; 
    fill( 40 +i*40, 40 +i*40, 80);
    rect( width/2 -music_squ -(i-ind)*music_sep, height/2 -music_squ, 2*music_squ, 2*music_squ );
  }

  if (pause) {
    noFill();
    stroke(255);
    strokeWeight(5);
    beginShape();
    vertex( width/2 -30, height/2 -30);
    vertex( width/2 -30, height/2 +30);
    vertex( width/2 +30, height/2 );
    vertex( width/2 -30, height/2 -30);
    endShape();
  } else {
    noFill();
    stroke(255);
    strokeWeight(5);
    rect( width/2 -20, height/2 -30, 5, 60);
    rect( width/2 +20, height/2 -30, 5, 60);
  }
}


void draw() {
  background(255);
  // ...
  //translate( width/2, height/2, 0);
  
  // Debug
      //System.out.print("pitch  ");    System.out.println(handPitch );
      //System.out.print("angle  ");    System.out.println(handDirection );
      //System.out.print("roll  ");    System.out.println(handRoll );
      //System.out.print("grab  ");    System.out.println(handGrab );
      //System.out.print("pinch  ");    System.out.println( handPinch );
      //System.out.print("index  ");    System.out.println(hand.getIndexFinger().getDirection() );
      //System.out.print("second  ");    System.out.println(hand.getMiddleFinger().getDirection() );
      //System.out.print("fingers  ");    System.out.println(hand.getOutstretchedFingers().size() );
  
  
  for (Hand hand : leap.getHands ()) {

    
    // time in seconds
    //System.out.print("time  ");    System.out.println(handTime );

    //if( handTime > 0.15 )
    //System.out.print("conf  ");    System.out.println( hand.getConfidence() );
    if ( true)
    {
      // roll vertical debounce callback
      
      // check roll gestures : flow='s'   volume='v'
      if ( handState == 'n' || handState=='s' || handState=='v' )
        check_handroll_gestures( hand );
      
      check_palm_gesture( hand );

      // ## Eo if confidence
    }

    // --------------------------------------------------
    // Drawing
    //hand.draw();

    // ## Eo for leap.hand()
  }
  
      
  //
}


// ----

