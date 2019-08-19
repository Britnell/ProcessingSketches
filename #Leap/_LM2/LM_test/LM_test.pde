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
  // box
  noFill();
  strokeWeight(10);
  stroke( 0);
  rect( width/2 -50, height/5,  100, height*3/5 ); 
  // vol bar
  fill(20, 80, 150);
  noStroke( );
  rect( width/2 -50, height/5 +vol,  100, height*3/5 -vol ); 
  
}


void grab_anim( float drag )
{
   noFill();
   stroke( 100, 100, 10);
   strokeWeight(3);
   translate( width/2, height/2, -5*drag );
   
    for( int i=0; i< 5; i++) {
      box(50, 50, 50 );
      translate(0,0, 100);
    }
}

int mat_b = 22;
int mat_w = 220;

void up_scroll( PVector dist)
{
  strokeWeight(3);
  translate( dist.x, 2*dist.y, -10*dist.z );
  for( int y=0; y<5;y++)
  for( int x=0; x<5; x++)
  {
     fill( 40, 40+y*40, 40+x*40 );
     rect( mat_b +x*(mat_w+mat_b), mat_b +y*(mat_w+mat_b),  mat_w, mat_w );
    
    
    // Eo for x
  }
  // Eo func
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

float grab_begin;
float grab_pos = 0;

PVector up_begin;
PVector up_track = new PVector(0,0,0);
PVector up_interm = new PVector(0,0,0);
boolean up_interm_bo = false;


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
    if( true)
    {
       // quick hand debounce
       
       // Detect vertical hand
       // 60 < roll < 120
       //System.out.print("roll ");    System.out.println(handRoll );
       if( handRoll > 60 && handRoll < 120 )
       {
             // if not in vertical mode : 
             if( handState != 's' ){
               // get initial timestamp
               if(!roll_debounce_i){
                 roll_debounce_i = true;
                 roll_debounce = millis();
               }
               else {
                 if( millis() -roll_debounce > roll_debounce_thresh )  {
                   scroll_hand_begin = handPosition.x;
                   handState = 's';
                 }
               }
               //System.out.print("Hand vertical");
             }
             
             if( handState == 's' )  {
               scroll_dist = map( (handPosition.x-scroll_hand_begin), -250, 250, -width/4, width/4 );
               for( int i=-5; i<6; i++) {
                  slice( scroll_last +scroll_dist -(i*200), 150, (i+5)*25);
               }
               
             }

        }
        else {
          roll_debounce_i = false;
          if(handState=='s') {
            scroll_last += scroll_dist;
            handState = 'n';
          }
          //println( handRoll );
          if( handRoll > 140 || handRoll < -150 ){
            if( handState != 'v' ) {
              handState = 'v';
              //System.out.print("Flip");
              volume_begin = handPosition.y;
            }
            else
            {
              // in flip
              //volume += (handPosition.y -volume_begin) /2;
              draw_volume(  volume +2*(handPosition.y-volume_begin) );
              
            }
            
            // Eo if 180
          }
          else {
            if(handState=='v') {
              handState = 'n';
              volume += 2*(handPosition.y-volume_begin);
            } 
          }
        }
         
        
        
        //if( hand.getOutstretchedFingers().size() >= 3) 
        if(handPitch > 35)
        {
           //System.out.print("angle  ");    System.out.println(handDirection );
           //System.out.print("pitch  ");    System.out.println(handPitch );
           if( handState != 'u') {
               handState = 'u';
               up_begin = handPosition;
           }
           //System.out.print("pitch  ");    System.out.println(handPitch );
           //System.out.print("grab  ");    System.out.println(handGrab );
           //System.out.print("pinch  ");    System.out.println( handPinch );
           System.out.print("index  ");    System.out.println(hand.getIndexFinger().getDirection() );
           System.out.print("second  ");    System.out.println(hand.getMiddleFinger().getDirection() );
           System.out.print("fingers  ");    System.out.println(hand.getOutstretchedFingers().size() );
           
           if( hand.getOutstretchedFingers().size() >3) {
             up_interm = PVector.sub( handPosition, up_begin);
             up_scroll( PVector.add( up_track, up_interm ) );
             up_interm_bo = true;
           }
           else {
             //
             if(up_interm_bo) {
               up_track.add( up_interm );
               up_begin = handPosition;
               up_interm_bo = false;
             }
             up_scroll( up_track );
             //up_begin.add( up_interm);
           }
           
        }
        else {
          System.out.print("pitch  ");    System.out.println(handPitch );
           System.out.print("grab  ");    System.out.println(handGrab );
           if( handState == 'u' ) {
             // end 
             handState = 'n';
             up_track.add(PVector.sub( handPosition, up_begin) );
             System.out.print("stop  ");
           } 
        }
        
        
        // last check for point
//        if(handState == 'n' )
        if( hand.getOutstretchedFingers().size() == 1)
          if( hand.getOutstretchedFingers().get(0).getType() ==1 ){
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
        
                                          // after hand orientation, check for fist
       
        //System.out.println( handGrab );
        if(handState == 'n' || handState=='f' )
        if( handGrab > 0.95 )
        {
          if( handState != 'f' ) {
            handState = 'f';
            System.out.println("Fist ");  
            grab_begin = handPosition.z;
          }
          
          grab_anim( handPosition.z - grab_begin + grab_pos );          
        }
        else {
          // end handstate
          if(handState == 'f') {
            handState = 'n';
            System.out.println("release"); 
            grab_pos = handPosition.z - grab_begin;
          }
        }
        
        
        /*
            // position.X 0 to 1000 , left to right
            // position.Y  500 = 5 cm  ;   30 = 0.5m 
            // position z =   45 = middle ; 80 forward  ;  0 backward
        //System.out.print("position " );    System.out.println(handPosition );
        float x = map( handPosition.x, 0 , 1000, 0, width );
        float y = map( handPosition.y, 30, 500, 0, height );
        float z = map( handPosition.z, 0, 80,  300, -100 );
        translate( x, y, z);
        
            // roll, twist arm 
            // twist left to -180
            // twist right to +180
            // -> rotate Z
        //System.out.print("roll ");    System.out.println(handRoll );
        rotateZ( handRoll *PI /180 );
        rotateX( handPitch *PI /180 );
        rotateY( handYaw *PI /180 );
        */
        
        //System.out.print("dir ");    System.out.println(handDirection );
        
        //rotateY( 0.5);
        //strokeWeight(1);        fill(20,80,110);       box(40, 10, 60);
    }
    
    // --------------------------------------------------
    // Drawing
    hand.draw();
  }
  //
}


// ----
