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
  row_y = height/2;
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

boolean row_debounce = false;
int row_debounce_t = 0;

void alphabetical( PVector maus ) {
  PVector dir = new PVector( maus.x -cursor_x, maus.y -cursor_y );
  float angl = dir.heading() +PI;
  //println( angl );
  
  // angle : ring
  if(true) {
    int ID = int(angl /segm_step) +14;
    if(ID>28)
      ID -= 28;
    println(ID);
    //draw_abc_ring( ID );
  }
  
  float ID = map( maus.x, row_beg, row_end, 0, 28);
  
  if(!row_debounce) {
    //if( maus.y < row_y || maus.y > row_y +row_h ) {
    if( maus.y > row_y +row_h ) {
      print(char(int(ID)+65) );
      row_debounce = true; 
    }
  }
  else {
    // debounce
    if( maus.y > row_y && maus.y < row_y +row_h )
      row_debounce = false; 
  }
  
  //println( ID );
  
  
  //draw_abc_row( ID);
  
  col = color( 0,0,0);
  stroke( col);        noFill();    strokeWeight( 1);
  ellipse( maus.x, maus.y, 20, 20);
}

int abc_ring_outer = 450;
int abc_ring_inner = 200;
int abc_ring_label = 300;
int segm = 28;
float segm_step = 2*PI/segm;

// ASCUU a = 97     A = 65

float row_beg = 50;
float row_h = 300;
float row_y = cursor_y -row_h/2;
float row_step = 60;
float row_end = row_beg + 28*(row_step +5);

char abc_dir = 'n';
//int abc_cursor = 3;
PVector last_maus = new PVector(0,0);
String abc_text = "";
boolean abc_tap_bo = false;
int abc_tap_t = 0;
float abc_dist;
float abc_dist_i;
float abc_cursor;

float map_dist_scroll( float diff) {
  float magn = abs( diff);
  float ret;
  
  if( magn < 705 ) {
    ret = magn * magn /33000;
    if( diff <0 )
      ret *= -1;
  }
  else
    ret = diff / 47;
  
  print(" diff ", magn, " squ: ", ret, " \n");
  
//  if( magn < 180 )
//    return 0;
//  if( magn < 250)   // 180 to 250  =  1
//    return diff /180;
//  else if( magn < 325)  // 250 - to 325 = 2
//    return diff /125;
//  else if( magn < 400 )  // 325 to 400 = 3
//   return diff / 109;
//  else if( magn < 475 )    // 400 to 550 = 4
//   return diff / 100;
//  else 
//    return diff / 99;    // 5 +
  
    return ret;
}


void alfabet( PVector maus ) {
  PVector centr = new PVector( width/2, height/2 );
  
  PVector dir = new PVector( maus.x -cursor_x, maus.y -cursor_y );
  float angl = dir.heading() +PI;
  //println( angl );
  
  float diff = ( maus.x - centr.x );
  
  PVector accel = PVector.sub( maus, last_maus );
  
  //print(" ACc ");    print( accel);
//  print("\t D ");  print(diff); 
//  print(" : ");  print(  angl);
//  println("");
  
  // get x diff for cursor
//  if( diff > 0) {
//    if( diff < 400 )
//      curs = map( diff, 0, 400, 0, 4);
//    else  
//      curs = map( diff, 400, 750, 4, 8);
//  }
//  else {
//    if( diff > -400 )
//      curs = map( diff, 0, -400, 0, -4 );
//    else  
//      curs = map( diff, -400, -750, -4, -8);
//  }
  
  if( abc_dir == 'n' )  {
    //
    if( diff > 150 ) {
      abc_dir = 'r'; 
      abc_dist = 0;
      abc_begin = maus;
      diff = ( maus.x - centr.x );
    }
    else if( diff < -150 ) {
      abc_dir = 'l';
      abc_dist = 0;
      abc_begin = maus;
      diff = ( maus.x - centr.x );
    }
    //-
  }
  else if( abc_dir == 'r' ) {
     if( diff > abc_dist ) {
       abc_dist = diff; 
       abc_dist_i = map_dist_scroll( diff);
       //print("diff ", diff, ", i ", abc_dist_i , "\n");
     }
     else {
       if( diff < 150 ) {
         abc_dir = 'n'; 
         abc_cursor += abc_dist_i;  // add dist to cursor to remain
         abc_dist_i = 0;
       }
     }
     // Eo 'r' 
  }
  
  if( abc_dir == 'l' ) {
     if( diff < abc_dist ) {
       abc_dist = diff;
       abc_dist_i = map_dist_scroll( diff);
     }
     else if( diff > -150 ) {
       abc_dir = 'n';
       abc_cursor += abc_dist_i;  // add dist to cursor to remain
       abc_dist_i = 0;
     }
     // Eo 'l'
  }
  
    // wrap around alphabet 
  int abc_sel = int(abc_dist_i) +int(abc_cursor) ;
  while( abc_sel < 0) 
    abc_sel += 29;
  while( abc_sel > 29 )
    abc_sel -= 29;
  
  
    // get accel for sel
  if(!abc_tap_bo) {
    if( ( accel.y ) > 30) {
      // its a tap!
      abc_tap_bo = true;
      abc_tap_t = millis(); 

      if( abc_sel < 0 )
        abc_sel = 0;
      if( abc_sel > 29 )
        abc_sel = 29;
      
      if(abc_sel < 26 )
        abc_text += char( abc_sel+65 );
      else 
        abc_text = abc_text.substring( 0, abc_text.length() -1 );
    }
  }
  else {
    // debounce
   if( millis() -abc_tap_t > 800 ) {
    abc_tap_bo = false;
   } 
  }
  
  // draw message
  textSize(150);
  text( abc_text, width*2/5, 200 );
  
  // draw abc row
  draw_dynam_row( abc_sel, abc_dir );
  
  // draw accel
  strokeWeight( 3);    stroke( 30, 40, 100);
  line( centr.x, centr.y, centr.x + accel.x, centr.y +accel.y );
  
  // draw mouse cursor
  //draw_cursor(maus);
  
  noStroke();    
  if( abc_dir == 'n' )
    fill(128); 
  else
    fill(60, 180, 180);
  
  rect( centr.x,  height/2 +150, maus.x-centr.x, 10);
  
  
  
  last_maus = maus;
  
  
  //
}

PVector abc_begin;

void begin_abc_callback( PVector maus)
{
  abc_begin = maus;
  abc_dir = 'n';
  abc_dist_i = 0;
  abc_tap_bo = true;
  abc_tap_t = millis();
}

void draw_dynam_row( int sel, char dir ) {
  PVector centre = new PVector( width/2, height/2);
  int step = 160; 
  //1
  fill(255);
  textSize(180);
  text(char(sel+65), centre.x, centre.y);
  //2
  fill(128);
  textSize(100);
  text(char(sel-1+65), centre.x -step, centre.y);
  textSize(100);
  text(char(sel+1+65), centre.x +step, centre.y);
  //3
  textSize(90);
  text(char(sel-2+65), centre.x -2*step, centre.y);
  textSize(90);
  text(char(sel+2+65), centre.x +2*step, centre.y);
  
  // arrows
  if(dir=='l') { 
    triangle( centre.x -2.8*step, centre.y -150,
               centre.x -2.8*step, centre.y +50,
                 centre.x -3.2*step, centre.y -25 );
  }
  if(dir=='r') { 
    triangle( centre.x +2.8*step, centre.y -150,
               centre.x +2.8*step, centre.y +50,
                 centre.x +3.2*step, centre.y -25 );
  }
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
      
      PVector point = get_screen_point( fingerPosition, fingerDirection );
      
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
      
      if( state == 'z' ) {
        
        //alphabetical( point ); 
        alfabet( point );
        
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
    arduino.write( 0 );
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
