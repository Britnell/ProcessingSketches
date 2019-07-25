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

void draw_vector( PVector vec )
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
  
  if( temp.mag() > 200 ) 
  {
    //System.out.print( temp.mag() );    System.out.print(",  ");   System.out.println( temp.heading() );
    //System.out.print(" last imp ");   System.out.println( millis() -last_imp);
    if(first_shake_b) {
      first_shake_b = false;
      first_shake_t = millis(); 
    }
    //System.out.println( millis() -last_imp );
    
    if( millis() -last_imp < 50) {
       // add to list
       
       impulses.add( temp );
       float dir_changes = 0;
       
//       float prev_angle = impulses.get(0).heading();
//       float this_angle;
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
  //size(800,400);
  size(1900, 800);  
  //size(3800, 2100); 

  background(255);
  
  // arduino seria
  printArray(Serial.list());
  //arduino = new Serial(this, Serial.list()[0], 115200);
  
  trail_pos = new PVector( width/2, height/2);
  trail_mov = new PVector( 0,0);
  
  // leap motion
  leap = new LeapMotion(this);
  //
}


color col;

void draw_trail() {
  trail_pos.add( PVector.div(trail_mov, 3) ); 
  stroke( 10, 10, 160);    strokeWeight(20);
   ellipse( trail_pos.x, trail_pos.y, 20, 20);
   
   //System.out.println( trail_pos);
   //
}

void draw() {
  //background(background_col);
  background(255);
  
  // ...
  
  //int fps = leap.getFrameRate();
  for (Hand hand : leap.getHands ()) {
    // for each hand
    PVector handPosition = hand.getPosition();
    //System.out.print("position ");     System.out.println( handPosition );
    
                                                                            //    ## Fingers
    //for (Finger finger : hand.getOutstretchedFingers()  ) {
      //
      Finger finger = hand.getIndexFinger();
      
      int     fingerId         = finger.getId();
      PVector fingerPosition   = finger.getPosition();
      PVector fingerStabilized = finger.getStabilizedPosition();
      PVector fingerVelocity   = finger.getVelocity();
      PVector fingerDirection  = finger.getDirection();
      float   fingerTime       = finger.getTimeVisible();      
      
              // calculate X point position
      float x_angle = -atan2( fingerDirection.z, fingerDirection.x );
      //println(" x-angle ", x_angle, " - x pos ", handPosition.x );
      
      float point_view_left = map( handPosition.x, -80, 2800, 1.8, 2.5  );
      float point_view_right = map( handPosition.x, -80, 2800, 0.75, 1.05 );
      
      float point_x = map( x_angle, point_view_left,  point_view_right, 0, width);
      
      
              // cac Y point position
      // Y = y.axis : up down forward
      // X = z.axis : frward / backward ( will always be -1.0)
      float y_angle = atan2( fingerDirection.y, fingerDirection.z);
      if( y_angle < 0 )
        y_angle = ( PI+(PI+y_angle) );
      
      println(" y-angle ", y_angle, " - y pos ", handPosition.y );
      
      float point_view_high  = map( fingerPosition.y, 640, 1700, 3.6, 3.95 );
      float point_view_low  = map( fingerPosition.y, 640, 1700,  2.5, 3.25);
      float point_y = map( y_angle, point_view_high, point_view_low, 0, height);
      
      //System.out.print("Y : ");     System.out.print( fingerPosition.y );
      //System.out.print(" z : ");     System.out.print( fingerDirection.z );
      //System.out.print(" angle : ");     System.out.println( y_angle );
      
      
            // draw screen point pos
      col = color( 0,0,0);
      stroke( col);        noFill();    strokeWeight( 1);
      ellipse( point_x, point_y, 20, 20);
      
      
          // calc direction for trail
      trail_mov = new PVector( point_x -trail_pos.x, point_y -trail_pos.y );
      
          // # velocity
      //System.out.print(" velocity : ");     System.out.println( fingerVelocity );
      
      draw_vector( fingerVelocity  );
      
      
      
          // # dist from centre : x = 465 ; y = 529 
      //PVector finger_centre = new PVector( 465, 529, 0);
      float centre_dist = abs(fingerPosition.x-465) + 10* abs( fingerPosition.z -60);      //+ abs(fingerPosition.y-529);
      
      //centre_dist = map( centre_dist, 0, 1500, 0, 255);
      if( centre_dist < 300) {
        centre_dist_bright = 60;
        background_col = color( 195, 195, 255);
      }
      else if( centre_dist<1000 ) {
        centre_dist_bright = int( map(centre_dist, 300, 1000, 60, 0) );
        background_col = color( 255 -1* centre_dist_bright, 255 -1* centre_dist_bright, 255);
      }
      else {
        centre_dist_bright = 0;
        background_col = color(255, 255, 255);
      }
      //arduino.write( centre_dist_bright );
      
          // centre dist debug
      //System.out.print(" pos  ");     System.out.print( fingerPosition.z );
      //System.out.print(" y diff : ");     System.out.println( fingerPosition.y-529 );
      //System.out.print(" offcentre  : ");     System.out.println( int(centre_dist) );
      //System.out.print(" bright indx : ");     System.out.println( centre_dist_bright );      
      
      
      
        // Values
      //System.out.print("X : ");     System.out.print( fingerPosition.x );
      //System.out.print("Y : ");     System.out.print( fingerPosition.y );
      //System.out.print(" dir :  ");     System.out.print( fingerDirection.x );
      //System.out.print("  angle : ");     System.out.println( x_angle );
      //System.out.print("  pointer x : ");     System.out.println( point_x );
      
      
          // draw direction circle
//      float ind_x = map( fingerDirection.x, -0.5, 0.5, 0, width );    // straight in front big screen
//      float ind_y = map( fingerDirection.y, -0.4, 0.4, 0, height );    // straight in front big screen
//      col = color( 50, 40 +fingerId*40, 255 -fingerId*40);
//      stroke( col);        noFill();
//      ellipse( ind_x, ind_y, 30, 30);
      
          // draw position circle
      // first : x 0 to 1000,   y : 100 to 600
      // whole range : x -500 to 2000      y 0, to 700
//      float pos_x = map( fingerPosition.x, -500, 2000, 0, width );    // straight in front big screen
//      float pos_y = map( fingerPosition.y, 0, 700, 0, height );    // straight in front big screen
//      col = color( 2*fingerPosition.z, 50, 255-2*fingerPosition.z );
//      stroke( col);        noFill();
//      ellipse( pos_x, pos_y, 30, 30);
      //System.out.print("  posit ");     System.out.println( fingerPosition);
      
      
            // Bone
      //Bone bone = finger.getMetacarpalBone();
      //PVector bones = finger.getMetacarpalBone().getDirection();
      //System.out.print("bone ");     System.out.println( bones );
      
      //System.out.print("velocit ");     System.out.println( fingerVelocity );
      
      // ## Eo for finger()
    //}
    
    // ## Eo for hand()
  }
  
  if(  leap.getHands().size() == 0){
    // no hands
    //arduino.write( 0 );
    background_col = color(255, 255, 255);
    
    trail_mov = new PVector( width/2 -trail_pos.x,  height/2 -trail_pos.y );
  }
  
  
      // carry out shake and debounce
  if( shake ) {
    // draw X  ( or do sth)
    stroke( 180, 80, 20);    strokeWeight(50);
    noFill();
    rect( 100, 100, width-2*100, height-2*100 );
    strokeWeight(1);
    if( millis() -shake_t > 1000) {
      shake  = false;
    }
    // Eo shake
  }
  
  
      // do the trail
  draw_trail();
  // ## Eo draw
}




// ----