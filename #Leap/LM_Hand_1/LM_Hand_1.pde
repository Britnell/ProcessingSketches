import de.voidplus.leapmotion.*;
import processing.serial.*;

/* ======================================================
 *
 *    Lets look at leap gestures again for controlling windows
 *
 *
 * ======================================================
*/


LeapMotion leap;

String COMport = "COM61";
Serial serialHID;

void setup() {
  size(2000, 1200);
  background(255);
  // ...
  
  leap = new LeapMotion(this);
  
  print( "list or ports:\t");
  println( Serial.list() );
  
  String portName = Serial.list()[0];
  serialHID = new Serial(this, portName, 115200 );
  
  // **  Eo setup
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

Boolean handbounce = false;

void draw() {
  background(255);
  // ...

  int fps = leap.getFrameRate();
  for (Hand hand : leap.getHands ()) {
    
    //println( "hand time: ", hand.getTimeVisible() ); 
    
    if(hand.getTimeVisible() > 0.6 )
    {
        if(!handbounce)
        {
            handbounce = true;
            println("Hand valid " );
        }
    }
    else
    {
        // * No hands!
        if(handbounce) 
        {
          handbounce = false;
        }
        
    }
    
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
      
          // -------------    HAND    ----------------
          
          hand.draw();
          
          finger_spread( hand);
          
      
          // ==================================================
          // 3. Arm
      
          if (hand.hasArm()) {
            Arm     arm              = hand.getArm();
            float   armWidth         = arm.getWidth();
            PVector armWristPos      = arm.getWristPosition();
            PVector armElbowPos      = arm.getElbowPosition();
          }
      
      
          // ==================================================
          // 4. Finger
      
          Finger  fingerThumb        = hand.getThumb();
          // or                        hand.getFinger("thumb");
          // or                        hand.getFinger(0);
      
          Finger  fingerIndex        = hand.getIndexFinger();
          // or                        hand.getFinger("index");
          // or                        hand.getFinger(1);
      
          Finger  fingerMiddle       = hand.getMiddleFinger();
          // or                        hand.getFinger("middle");
          // or                        hand.getFinger(2);
      
          Finger  fingerRing         = hand.getRingFinger();
          // or                        hand.getFinger("ring");
          // or                        hand.getFinger(3);
      
          Finger  fingerPink         = hand.getPinkyFinger();
          // or                        hand.getFinger("pinky");
          // or                        hand.getFinger(4);
      
      
          for (Finger finger : hand.getFingers()) {
            // or              hand.getOutstretchedFingers();
            // or              hand.getOutstretchedFingersByAngle();
      
            int     fingerId         = finger.getId();
            PVector fingerPosition   = finger.getPosition();
            PVector fingerStabilized = finger.getStabilizedPosition();
            PVector fingerVelocity   = finger.getVelocity();
            PVector fingerDirection  = finger.getDirection();
            float   fingerTime       = finger.getTimeVisible();
          }
          
          
      
      
    // ** Eo for hand
  }

  
  
  // ** Eo draw
}



Boolean spread_bo = false;
float last_spread = 0;
float spread_at;

void finger_spread( Hand hand){
  
  float spread = 0;
  
  //println(hand.countFingers() );
  
  if(hand.countFingers() == 5 )
  {
    PVector A = hand.getFinger(0).getStabilizedPosition();
    PVector B = hand.getFinger(4).getStabilizedPosition();
    A.z = 0;
    B.z = 0;
    A.sub(B);
    spread = A.mag();
    
      //for( int i=0; i<4; i++){
      //  // take x-y 2D distance
      //  PVector A = hand.getFinger(i).getStabilizedPosition();
      //  PVector B = hand.getFinger(i+1).getStabilizedPosition();
      //  //PVector A = hand.getFinger(i).getPosition();
      //  //PVector B = hand.getFinger(i+1).getPosition();
      //  A.z = 0;
      //  B.z = 0;
      //  A.sub(B);
      //  spread += A.mag();
        
      //  //println( i, A.mag() );
        
      //  /*  This took the absolute distance, in 3D space
      //  PVector A = hand.getFinger(i).getStabilizedPosition();
      //  PVector B = hand.getFinger(i+1).getStabilizedPosition();
      //  A.sub(B);
      //  spread += A.mag();
      //  println( i, A.mag() );
      //  */
        
      //  /* X distance only
      //  PVector A = hand.getFinger(i).getStabilizedPosition();
      //  PVector B = hand.getFinger(i+1).getStabilizedPosition();
      //  spread += abs(A.x+ B.x);
      //  */
      //}
      
      float diff = (spread-last_spread);
      
      if(abs(diff)>10)   println(" finger spread", spread, "\t diff: ", diff , "\t\t sink ", spread_at -spread );
      
      //println(spread);
      
      if(diff > 110 || spread > 700 ) 
      {
        //println(" @ spread during spread", spread);
        if(!spread_bo && handbounce)
        {
          serialHID.write("#T");  // tab GUI screen
          //println("FINGER SPREAD");
          spread_at = spread;
          spread_bo=true;
          //println(" spread at ", spread_at);
        }
      }
      
      if(spread_bo) 
      {
        // * low diff
        //println( "spread sinking to ", spread_at -spread);
        //if(spread < 400){
        if(spread_at -spread > 90){
          serialHID.write("#E");  // ESC          
          spread_bo=false;
          //println("spread over ");
        }        
        
      }
      
      last_spread = spread;
      
      // * if finger count
  }
  
  // * Eo func
}