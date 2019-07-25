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


// ======================================================
// 1. Callbacks

void leapOnInit() {
  // println("Leap Motion Init");
}
void leapOnConnect() {
  // println("Leap Motion Connect");
}
void leapOnFrame() {
  // println("Leap Motion Frame");
}
void leapOnDisconnect() {
  // println("Leap Motion Disconnect");
}
void leapOnExit() {
  // println("Leap Motion Exit");
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


int music_i = 1;
int music_squ = 100;
int music_sep = 300;
void draw_music( int ind, boolean pause)
{
  noStroke();

  for ( int i= 0; i<3; i++) {
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

float scroll_hand_begin;
float scroll_last = 0;
float scroll_dist = 0;
int roll_debounce = 0;
boolean roll_debounce_i = false;
int roll_debounce_thresh = 200; 

float volume = 50;
float volume_begin;
float volume_interm;
boolean volume_hold = false;

float grab_begin;
float grab_pos = 0;
float grab_z;

PVector up_begin;
PVector up_track = new PVector(0, 0, 0);
PVector up_interm = new PVector(0, 0, 0);
boolean up_interm_bo = false;
boolean up_push_bo = false;
boolean up_pause = false;

float up_tap;

int debounce_delay = 0;
char lastState = 'n';

int pinchTime = 0;
int pinch_delay = 0;
boolean pinch_delay_bo =true;
boolean pinch_delay_bo_once =false;

// $$

void draw() {
  background(255);
  // ...
  //translate( width/2, height/2, 0);

  int fps = leap.getFrameRate();
  for (Hand hand : leap.getHands ()) {


    // ==================================================
    // 2. Hand

    int     handId             = hand.getId();
    PVector handPosition       = hand.getPosition();
    PVector handStabilized     = hand.getStabilizedPosition();
    PVector handDirection      = hand.getDirection();
    PVector handDynamics       = hand.getDynamics();
    float   handRoll           = hand.getRoll();
    float   handPitch          = hand.getPitch();
    float   handYaw            = hand.getYaw();
    boolean handIsLeft         = hand.isLeft();
    boolean handIsRight        = hand.isRight();
    float   handGrab           = hand.getGrabStrength();
    float   handPinch          = hand.getPinchStrength();
    float   handTime           = hand.getTimeVisible();
    PVector spherePosition     = hand.getSpherePosition();
    float   sphereRadius       = hand.getSphereRadius();

    // time in seconds
    //System.out.print("time  ");    System.out.println(handTime );

    //if( handTime > 0.15 )
    //System.out.print("conf  ");    System.out.println( hand.getConfidence() );
    if ( true)
    {
      // quick hand debounce

        // Detect vertical hand
      // 60 < roll < 120
      //System.out.print("roll ");    System.out.println(handRoll );
      if ( handState == 'n' || handState=='s' || handState=='v' )
        if ( handRoll > 60 && handRoll < 120 )
        {
          // if not in vertical mode : 
          if ( handState != 's' ) {
            // get initial timestamp
            if (!roll_debounce_i) {
              roll_debounce_i = true;
              roll_debounce = millis();
            } else {
              if ( millis() -roll_debounce > roll_debounce_thresh ) {
                scroll_hand_begin = handPosition.x;
                handState = 's';
              }
            }
            //System.out.print("Hand vertical");
          }

          if ( handState == 's' ) {
            scroll_dist = map( (handPosition.x-scroll_hand_begin), -250, 250, -width/4, width/4 );
            for ( int i=-5; i<6; i++) {
              slice( scroll_last +scroll_dist -(i*200), 150, (i+5)*25);
            }
          }
        } else {
          roll_debounce_i = false;
          if (handState=='s') {
            scroll_last += scroll_dist;
            handState = 'n';
          }
          //println( handRoll );
          if ( handRoll > 140 || handRoll < -150 ) {
            if ( handState != 'v' ) {
              handState = 'v';
              //System.out.print("Flip");
              volume_begin = handPosition.y;
            } else
            {
              // in flip
              //volume += (handPosition.y -volume_begin) /2;
              //System.out.println(handPosition.x);
              if( handPosition.x > 350 && handPosition.x < 650 ) {
                volume_interm = (handPosition.y-volume_begin);
                draw_volume(  volume +1* volume_interm );
                volume_hold = false;
              }
              else {
                // not in perimeter
                if(!volume_hold) {
                  volume_hold = true;
                  volume += 1*volume_interm; 
                }
                volume_begin = handPosition.y;
                draw_volume(  volume );
                //draw_volume(  volume +2* volume_interm );
                //draw_volume(  volume +2*(handPosition.y-volume_begin) );
                // Eo in middle
              }
              //System.out.println(handPosition.x);
              noFill();
              strokeWeight(3);      stroke( 40, 120, 40 );
              ellipse( handPosition.x,  handPosition.y,  30, 30 );
            }

            // Eo if 180
          } else {
            if (handState=='v') {
              handState = 'n';
              volume += 2*(handPosition.y-volume_begin);
            }
          }
        }



      //if( hand.getOutstretchedFingers().size() >= 3) 
      if ( handState=='n' || handState=='u')
        if (handPitch > 39)
        {
          //System.out.print("angle  ");    System.out.println(handDirection );
          //System.out.print("pitch  ");    System.out.println(handPitch );
          if ( handState != 'u') {
            handState = 'u';
            up_begin = handPosition;
          }

          //System.out.print("pitch  ");    System.out.println(handPitch );
          //System.out.print("roll  ");    System.out.println(handRoll );
          //System.out.print("grab  ");    System.out.println(handGrab );
          //System.out.print("pinch  ");    System.out.println( handPinch );
          //System.out.print("index  ");    System.out.println(hand.getIndexFinger().getDirection() );
          //System.out.print("second  ");    System.out.println(hand.getMiddleFinger().getDirection() );
          //System.out.print("fingers  ");    System.out.println(hand.getOutstretchedFingers().size() );

          //up_interm = PVector.sub( handPosition, up_begin);
          //up_scroll( PVector.add( up_track, up_interm ) );

          //System.out.print("d Z  ");    System.out.println( abs(handPosition.z - up_begin.z)   );
          if (!up_interm_bo)
            if ( (handPosition.x - up_begin.x) >150 ) {
              music_i--;
              //up_begin.x += 150;
              up_interm_bo = true;
            }

          if (!up_interm_bo)
            if ( (handPosition.x - up_begin.x) < -150 ) {
              music_i++;
              //up_begin.x -= 150;
              up_interm_bo = true;
            }

          if (up_interm_bo)
            if ( abs(handPosition.x - up_begin.x) < 50 )
              up_interm_bo = false;

          //System.out.print("d Z  ");    System.out.println( (handPosition.z - up_begin.z)   );
          if ( !up_push_bo)
            if (handPosition.z - up_begin.z > 15 ) {
              //System.out.println("Push pause  ");
              if (up_pause)
                up_pause = false;
              else
                up_pause = true;

              up_push_bo = true;
            }

          if (handPosition.z - up_begin.z < 8 ) {
            up_push_bo = false;
          }
          draw_music( music_i, up_pause );
        } else {
          //System.out.print("pitch  ");    System.out.println(handPitch );
          //System.out.print("grab  ");    System.out.println(handGrab );
          if ( handState == 'u' ) {
            // end 
            handState = 'n';
            up_track.add(PVector.sub( handPosition, up_begin) );
            System.out.print("stop  ");
          }
        }


      // after hand orientation, check for fist

        //System.out.println( handGrab );
      if (handState == 'n' || handState=='f' )
        if ( handGrab > 0.90 )
        {
          if (!fist_debounce)
          {
            if ( handState != 'f' ) {
              handState = 'f';
              System.out.println("Fist ");  
              grab_z = handPosition.z;
              grab_begin = handRoll;
            }
            //System.out.println("roll ");  
            //System.out.println( handRoll -grab_begin );
            //System.out.println( abs(handPosition.z -grab_z) ); 
            if ( abs(handPosition.z -grab_z) > 12) {
              fist_debounce = true;
              System.out.println("fist select"); 
              //grab_pos = handPosition.z - grab_begin;
              //grab_vol += handRoll -grab_begin;
            }
            grab_wheel( grab_vol +handRoll -grab_begin );
            //grab_anim( handPosition.z - grab_begin + grab_pos );
          }
        } else {
          // end handstate
          if (handState == 'f') {
            handState = 'n';
            System.out.println("release"); 
            //grab_pos = handPosition.z - grab_begin;
            //grab_vol += handRoll -grab_begin;
          }
          // unbounce fist select
          if (fist_debounce)
            fist_debounce = false;
        }


      /// ### pinch
      if (handState=='n' || handState=='p' )
        if ( handPinch > 0.5 ) {
          // 
          if ( handState=='n') {
            // its the first pinch
            if ( pinch_delay_bo_once) {
              pinch_delay_bo_once = false;
              pinch_delay = millis();
              pinchTime = pinch_delay;
              System.out.println("init pinch start");
              //pinchTime = millis();
            }
            //System.out.println("debounce");  
            //System.out.println(pinch_delay_bo);
            if (pinch_delay_bo)
              if ( millis() -pinch_delay > 80 ) {
                handState = 'p';
                pinch_delay_bo = false;
                //System.out.println("pinch");
                drag_start = handPosition;
              }
            // Eo coming from 'n'
          }
          fill( 10, 80, 80);    
          noStroke();
          ellipse(40, 40, 30, 30);
          if( handState=='p' ) {
            // its a pinch!
            pinch_drag( PVector.add( drag_posit, PVector.sub(handPosition, drag_start)  )  );
            //System.out.print("pinch vect ");        System.out.println( drag_posit);
          }
          // Eo pinch > thr
        } else {
          if ( handState == 'p' ) {
            // end pinch
            handState = 'n';
            pinch_delay_bo_once = true;
            pinch_delay_bo = true;

            // check pinch length
            System.out.println(millis() -pinchTime);  
            if ( millis() -pinchTime < 700 ) {
              System.out.println("quick");
            }
            
            drag_posit.add( PVector.sub(handPosition, drag_start) );
          }
        }


                                                                                      // last check for point
      if (handState == 'n' )
        if ( hand.getOutstretchedFingers().size() == 1)
          if ( hand.getOutstretchedFingers().get(0).getType() ==1 ) {
            // # index finger
            //Finger  indexFinger        = hand.getIndexFinger();
            Finger indexFinger = hand.getOutstretchedFingers().get(0);

            PVector  indexDirection = indexFinger.getDirection();

            // index direction
            // X : 0 =striaght, 
            //System.out.print("index ");    System.out.println(indexDirection );
            float i_x = map( indexDirection.x, -0.4, 0.4, 0, width );
            float i_y = map( indexDirection.y, -0.2, 0.8, 0, height );
            noFill();
            ellipse(  i_x, i_y, 30, 30  );
            //
          }        
      

      if ( handState != lastState) {
        // new state
        System.out.print("state  ");    
        System.out.println(handState );
        lastState = handState;
      }

      //rotateY( 0.5);
      //strokeWeight(1);        fill(20,80,110);       box(40, 10, 60);

      // ## Eo if confidence
    }

    // --------------------------------------------------
    // Drawing
    //hand.draw();

    // ## Eo for leap.hand()
  }
  
  // always draw rect 
  if( handState=='n' ) {
       pinch_drag ( drag_posit); 
    }
      
  //
}


// ----

