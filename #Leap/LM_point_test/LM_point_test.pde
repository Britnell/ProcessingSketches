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
  size(1900, 800);
  background(255);
  // ...

  leap = new LeapMotion(this);
}


color col;
void draw() {
  background(255);
  // ...

  int fps = leap.getFrameRate();
  for (Hand hand : leap.getHands ()) {
    // for each hand
    PVector handPosition = hand.getPosition();
    //System.out.print("position ");     System.out.println( handPosition );
    
    
                                                                            //    ## Fingers
    for (Finger finger : hand.getOutstretchedFingers()  ) {
      //
      //Finger finger = hand.getIndexFinger();
      
      int     fingerId         = finger.getId();
      PVector fingerPosition   = finger.getPosition();
      PVector fingerStabilized = finger.getStabilizedPosition();
      PVector fingerVelocity   = finger.getVelocity();
      PVector fingerDirection  = finger.getDirection();
      float   fingerTime       = finger.getTimeVisible();      
      
          // Direction.x
          //  -> 0 = middle
          //  -> 1.0 = pointing right along x
          //  -> -1.0 = pointing left  
          // Direction.y
          //  -> straight forward = 0
          //  -> 1.0 = down
          //  -> -1.0 = up
          // Direction.z
          //  -> -1.0 = forward at screen
          //  -> 0 = left or right
          //  -> 1.0 = backwards
      //System.out.print("direction ");     System.out.println( fingerDirection );
      float ind_x = map( fingerDirection.x, -0.5, 0.5, 0, width );    // straight in front big screen
      float ind_y = map( fingerDirection.y, -0.4, 0.4, 0, height );    // straight in front big screen
      
      col = color( 50, 40 +fingerId*40, 255 -fingerId*40);
      stroke( col);        fill( col );
      ellipse( ind_x, ind_y, 40, 40);
      
      // finger positions
      System.out.print("  tips ");     System.out.println( fingerStabilized);
      float pos_x = map( fingerStabilized.x, 0, 1000, 0, width );    // straight in front big screen
      float pos_y = map( fingerStabilized.y, 100, 600, 0, height );    // straight in front big screen
      
      col = color( 40 +fingerId*40, 50, 255 -fingerId*40);
      stroke( col);        fill( col );
      ellipse( pos_x, pos_y, 30, 30);
      
      
      
            // Bone
      //Bone bone = finger.getMetacarpalBone();
      //PVector bones = finger.getMetacarpalBone().getDirection();
      //System.out.print("bone ");     System.out.println( bones );
      
      //System.out.print("velocit ");     System.out.println( fingerVelocity );
      
      // ## Eo for finger()
    }
    
    // ## Eo for hand()
  }
  
  
  // ## Eo draw
}





// ----
