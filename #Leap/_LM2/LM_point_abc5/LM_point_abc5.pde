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

String abc_text = "";

Hand hand;
void shake_callback() {
  abc_text = "";   
}


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
         shake_callback();
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
  //cursor = new PVector( width*1/4, height*1/4 );
//  cursor_x = width*3/4;
//  cursor_y = height/2;
  cursor_x = width/2;//*3/5;
  cursor_y = height/2;
  cursor_r = 150;
  
}


color col;

void draw_trail() {
  trail_pos.add( PVector.div(trail_mov, 3) ); 
  stroke( 10, 10, 160);    strokeWeight(20);
   ellipse( trail_pos.x, trail_pos.y, 20, 20);
   
   //System.out.println( trail_pos);
   //
}


//PVector handPosition;

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

char state = 'p';    // pointing
float cursor_x;
float cursor_y;
float cursor_r;

void draw_abc_cursor(  ) {
  noStroke();
  fill( 128);
  ellipse( cursor_x, cursor_y, cursor_r, cursor_r);  
}

boolean check_cursor_touch( PVector mouse) {
  PVector calc = new PVector( cursor_x -mouse.x, cursor_y -mouse.y);
  //println( calc.mag() );
  
  if( calc.mag() <= (cursor_r + 20)/2 ) {
    return true;
  }
  return false;
}



void begin_abc_callback( PVector maus)
{
  
  //
}


void draw_cursor( PVector point ) {
  col = color( 0,0,0);
  stroke( col);        noFill();    strokeWeight( 1);
  ellipse( point.x, point.y, 20, 20); 
  
}



int letters = 10;

void draw_letters( int mid, int sel ) {
  PVector letter_pos = new PVector( width/9, height/2);
  int step = int( width *1 / (letters) );
  step -= (8* letters);
  
  for( int i=0; i < letters; i++ ) {
    
    if( i == sel) {
      textSize( step *(1+ letters*0.05) );
      fill(100, 200, 200);
    }
    else {
      textSize(step *0.95);
      fill(40, 80, 120);
    }
    text(char(mid+i+65), letter_pos.x + i *(step+8), letter_pos.y);
  }
  
}

                                                          // Hand Roll

boolean abc_tap_bo = false;
int abc_tap_t = 0;
PVector last_vel = new PVector( 0,0);

void check_for_tap( PVector vel ) {
  PVector temp = PVector.sub( vel, last_vel );
  
  
  
    // get accel for sel
  if(!abc_tap_bo) {
    //println(" accel-y : ", temp.y );
    
    if( ( temp.y ) > 250) {
      // its a tap!
      abc_tap_bo = true;
      abc_tap_t = millis(); 
      
      tap_callback();
    }
  }
  else {
    // debounce
   if( millis() -abc_tap_t > 400 ) {
    abc_tap_bo = false;
   } 
  }
  
  last_vel = vel;
 // Eo func 
}

void tap_callback( ) {
 //
 
}


                                                          // Hand Roll

boolean in_scroll = false;
int roll_debounce = 0;                
int roll_debounce_thresh = 80; 
boolean roll_debounce_i = false;

void check_scroll_gesture( ) 
{
  float handRoll = hand.getRoll();
  //PVector handPosition = hand.getPosition();
    
  // check for scroll
  if ( handRoll > 60 && handRoll < 120  )
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
            begin_scroll_callback( );
            in_scroll = true;
          }
        }
        //System.out.print("Hand vertical");
      }  
}


// return true so scroll function can skip
boolean check_scroll_end( ) {
  float handRoll = hand.getRoll();
  
  // debounce & end scroll
  if( in_scroll)
  if( handRoll < 50 || handRoll > 130 ) {
    in_scroll = false;
    roll_debounce_i = false;
    
    end_scroll_callback();
    return true;
  }
  
  return false;
  // Eo check end  
}


PVector scroll_hand_begin;
float scroll_z_begin;

float scroll_last = 0;
float scroll_dist = 0;

void begin_scroll_callback(  ) {
  state = 's';    // scroll
  scroll_hand_begin = hand.getPosition();  //handPosition;
  abc_scroll = 0;
}


int abc_pos = 0;
int abc_len = 30;
int abc_scroll;

void scroll_callback( PVector handPosition ) {
  
  if( !check_scroll_end() ) {
    
    float diff = -(handPosition.x-scroll_hand_begin.x);
    //PVector position =  hand.getPosition();
      // map hand x position to scroll dist  
    if( diff < 0 ) {
      //scroll_dist = map( diff, -scroll_hand_begin.x, 0, -abc_pos, 0);
    }
    else if ( diff > 0) {
      //scroll_dist = map( diff, 0, width-scroll_hand_begin.x, 0, abc_len -abc_pos );
    }
    else {
      //scroll_dist = 0;
    }
    scroll_dist = map( diff, -900, 900, -14, 14 );
    
    abc_scroll = int(scroll_dist);
    
    println("diff ", diff, " to " ,scroll_dist);
    
    
    // draw scroll menu
     
  }
}

void end_scroll_callback() {
  // add scroll dist to scroll position
  //scroll_last += scroll_dist;
  println("abc was ", abc_pos, " + ", abc_scroll );
  
  abc_pos += abc_scroll;
  state = 'z'; 
}

boolean pinch_bo = false;
int pinch_bo_t = 0;
int pinch_thr = 0;
boolean pinching = false;

void check_pinch(  ) {
  float pinch = hand.getPinchStrength();
  println("pinch : ", pinch);
  if( pinch > 0.3 ) {
    //println("pinch : ", pinch);
    
    if(!pinch_bo) {
      pinch_bo = true;
      pinching = true;
      //pinch_bo_t = millis(); 
      pinch_begin_callback();
    }
    
//    if(pinch_bo)
//    if( millis() -pinch_bo_t > pinch_thr ) {
//      pinch_bo = false;
//      pinching = true;
//    }
  }
  else {
    if(pinch_bo) {
      pinching = false;
      pinch_bo = false;
      //println("unbounce");
    } 
  }
  // 
}

void pinch_begin_callback( ) {
  PVector pos = hand.getIndexFinger().getPosition();
  
  //println(" it's a Tap! , ", char(65+point_id+abc_pos) );
  if( pos.y < height / 3 ) {
    // delete
    abc_text = abc_text.substring( 0, abc_text.length() -1 );        
  }
  else if( pos.y > height *4/5 ) {
     // back
     state = 'p';
  }
  else
    abc_text += char(65+point_id+abc_pos);
}


int point_id;


void draw() {
  background(background_col);
  // ...
  
  for (Hand hh : leap.getHands ()) {
    // for each hand
    hand = hh;
    
    PVector handPosition = hand.getPosition();
    //System.out.print("position ");     System.out.println( handPosition );
    
                                                                            //    ## Fingers
    //for (Finger finger : hand.getOutstretchedFingers()  ) {
      //
      Finger finger = hand.getIndexFinger();
      
      PVector fingerPosition   = finger.getPosition();
      PVector fingerVelocity   = finger.getVelocity();
      PVector fingerDirection  = finger.getDirection();
      
      //PVector point = get_screen_point( fingerPosition, fingerDirection );
      PVector point = fingerPosition;
      
      
      //System.out.print("Y : ");     System.out.print( fingerPosition.y );
      //System.out.print(" z : ");     System.out.print( fingerDirection.z );
      //System.out.print(" angle : ");     System.out.println( y_angle );
      
      
      if( state=='p') {
        if(check_cursor_touch(point) ) {
          state = 'z';
          begin_abc_callback(point);
        }
        else {
          draw_abc_cursor( );
          
            // draw screen point pos
          col = color( 0,0,0);
          stroke( col);        noFill();    strokeWeight( 1);
          ellipse( point.x, point.y, 20, 20);
          
          // calc trail & draw
          trail_mov = PVector.sub( point, trail_pos ); 
          draw_trail();
        }
        // Eo state p
      }
      else {
         //if(!check_cursor_touch(point) )          state = 'p';
      }
      
      if( state == 'z' ) {    // point at letters
        
        
        // check hand roll for swipe
        check_scroll_gesture( );
        
        if( state=='z')
          check_pinch( );
                
        // detect tap    check_for_tap( fingerVelocity );
        if( !pinching)
        if( state=='z') {        // get point cursor
          point_id = int(  map( point.x, 100, width-100, 0, letters)  );
          // draw curr letters
          draw_letters( abc_pos, point_id );
        }
        else 
          draw_letters( abc_pos, -1);
        
        // draw message
        textSize(150);
        text( abc_text, 500, 200 );
        
        // draw 
        draw_cursor( point);
        
        // end of Z
      }
      
      if( state =='s' ) {
        // scrolling 
        
        // check scroll dist
        scroll_callback( handPosition);
        
        draw_letters( abc_pos +abc_scroll, -1);
        
      }
          // calc direction for trail
      //trail_mov = new PVector( point.x -trail_pos.x, point.y -trail_pos.y );
      
          // # velocity
      //System.out.print(" velocity : ");     System.out.println( fingerVelocity );
      
      
      detect_shake( fingerVelocity  );
      
      
      
          // # map dist from centre to background color feedback
          
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
      
          // # centre dist debug
      //System.out.print(" pos  ");     System.out.print( fingerPosition.z );
      //System.out.print(" y diff : ");     System.out.println( fingerPosition.y-529 );
      //System.out.print(" offcentre  : ");     System.out.println( int(centre_dist) );
      //System.out.print(" bright indx : ");     System.out.println( centre_dist_bright );      
      
      
      
          // # Values
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
//    arduino.write( 0 );
    background_col = color(255, 255, 255);
    
    trail_mov = new PVector( width/2 -trail_pos.x,  height/2 -trail_pos.y );
  }
  
  
      // carry out shake and debounce
  if( shake ) {
    state = 'p';
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
  
  // ## Eo draw
}




// ----
