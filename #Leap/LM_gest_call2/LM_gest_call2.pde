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
  //cursor = new PVector( width*1/4, height*1/4 );
//  cursor_x = width*3/4;
//  cursor_y = height/2;
  cursor_x = width*4/5;
  cursor_y = height/2;
  cursor_r = 900;
  
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


int still_hist = 5;
float still_thr = 50;
int still_len = 0;
int still_i = 0;
PVector still_last;
float [] stillness = new float [still_hist];

void clear_stillness() {
  still_len = 0;
  still_i = 0;
}


boolean check_stillness( PVector point )
{
  
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
  
  // - calc sum
  if( still_len < still_hist ) {
    return false; 
  }
  else {
    float sum = 0;
    for( int i= 0; i<still_hist; i++) {
      sum += stillness[i];
    }
    println(" mov sum = ", sum );
    
    if( sum < still_thr ) {
      return true; 
    }
    
  }
  
  return false;
}

boolean still = false;


char state = 'p';    // pointing
float cursor_x;
float cursor_y;
float cursor_r;

void draw_abc_cursor(  ) {
  noFill();
  stroke( 128);    strokeWeight(20);
  ellipse( cursor_x, cursor_y, cursor_r, cursor_r);
  if(cursor_activ_b) {
    stroke( 80, 160, 160);
    arc( cursor_x, cursor_y, cursor_r -30, cursor_r -30, 0 , map( millis() -cursor_activ_t, 0, cursor_activ_thr, 0, TWO_PI) );
  }
}

int cursor_activ_t = 0;
int cursor_activ_thr = 1500;
boolean cursor_activ_b = false;

boolean check_cursor_touch( PVector mouse) {
  PVector calc = new PVector( cursor_x -mouse.x, cursor_y -mouse.y);
  //println( calc.mag() );
  
  if( calc.mag() <= (cursor_r + 20)/2 ) {
    if( !cursor_activ_b )  {
      cursor_activ_t = millis();
      cursor_activ_b = true;
    }
    else {
      if( still)    cursor_activ_t -= 20;
      if( millis() -cursor_activ_t > cursor_activ_thr ) 
        return true;
    }
  }
  else {
    cursor_activ_b = false;
  }
  // All else  
  return false;
  
}


float popup_x = 1000;
float popup_y = 600;
float popup_w = 700;
float popup_h = 200;

void popup_begin( PVector maus) {
  popup_initial = maus;
  // 
}

PVector popup_initial;

void confirm_popup( PVector maus) {
  //
  
  // YES
  stroke(60, 200, 60);    strokeWeight(20);
  line( popup_x -popup_w, popup_y -popup_h,
          popup_x -popup_w, popup_y +popup_h );
  
  // NO
  stroke(200, 60, 60);    
  line( popup_x +popup_w, popup_y -popup_h,
          popup_x +popup_w, popup_y +popup_h );
          
  //stroke(0);    ellipse(popup_x, popup_y, 15, 15);
  
  
  float w = ( maus.x -popup_initial.x) / 1.5;
  
  stroke(0);     //strokeWeight(15);
  line( popup_x, popup_y -popup_h, popup_x +w, popup_y -popup_h );
  line( popup_x, popup_y +popup_h, popup_x +w, popup_y +popup_h);
  
  // Eo popup
}

void draw_cursor( PVector point ) {
 col = color( 0,0,0);
  stroke( col);        noFill();    strokeWeight( 1);
  ellipse( point.x, point.y, 20, 20); 
  
}

void draw() {
  background(background_col);
  // ...
  
  for (Hand hand : leap.getHands ()) {
    // for each hand
    PVector handPosition = hand.getPosition();
    //System.out.print("position ");     System.out.println( handPosition );
    
                                                                            //    ## Fingers
    //for (Finger finger : hand.getOutstretchedFingers()  ) {
      //
      Finger finger = hand.getIndexFinger();
      
      PVector fingerPosition   = finger.getPosition();
      PVector fingerVelocity   = finger.getVelocity();
      PVector fingerDirection  = finger.getDirection();
      
      // 
      //fingerPosition
      // handPosition
      PVector point = get_screen_point( fingerPosition, fingerDirection );
      
      //System.out.print("Y : ");     System.out.print( fingerPosition.y );
      //System.out.print(" z : ");     System.out.print( fingerDirection.z );
      //System.out.print(" angle : ");     System.out.println( y_angle );
      
      still = check_stillness( point );
      
      
      if( state=='p') {

          if(check_cursor_touch(point) ) {
            state = 'c';
            popup_begin( point);
          }
          else {
            // Draw popup circle
            draw_abc_cursor( );
            
              // draw screen point pos
            col = color( 0,0,0);
            stroke( col);        noFill();    strokeWeight( 1);
            ellipse( point.x, point.y, 20, 20);
            
            // calc trail & draw
            //trail_mov = PVector.sub( point, trail_pos ); 
            //draw_trail();
          }
          // Eo state p
      }
      else {
         //
      }
      
      if( state == 'c' ) {
         //
         confirm_popup( point );
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
      
    // ## Eo for hand()
  }
  
  if(  leap.getHands().size() == 0){
    // no hands
    //arduino.write( 0 );
    
    // back to hand state
    state = 'p';
    
    // clear still tracker
    clear_stillness();
    
    background_col = color(255, 255, 255);
    
    trail_mov = new PVector( width/2 -trail_pos.x,  height/2 -trail_pos.y );
  }
  
  
      // carry out shake and debounce
  if( shake ) {
    // draw X  ( or do sth)
    state = 'p';
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