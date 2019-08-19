import de.voidplus.leapmotion.*;

LeapMotion leap;
Hand hand;
PVector handPosition;
PVector handDirection;


                                                        //    ###     Setup
void setup() {
  //size(800, 500);
  size(1024, 640, P3D);
  background(255);
  // ...

  leap = new LeapMotion(this);
  // Eo setup
}


                                                          // STM
char state = 'i';    // idle
char last_state = state;
void to_state(char st) {
  last_state = state;
  state = st;     
}

boolean hand_present = false;

                                                            // H
void detect_hand( ) {
  float conf = hand.getConfidence();
  if( !hand_present)
    if( conf > 0.85 ) {
       to_state('h');    // hand = ready
       backg = color( 70, 220, 220);
       hand_present = true;
    }
    else if( conf > 0.4 )
     backg = color( map(conf, 0.4, 0.9, 160, 70), 
                   map(conf, 0.4, 0.9, 230, 200),
                  map(conf, 0.4, 0.9, 230, 200) );
    //
}

int backg_fade = 0;
color backg = color( 255, 255, 255 );

void draw_hand( ) {
  float conf = hand.getConfidence();
  if( conf > 0.9 )
    backg = color( 70, 200, 200);
  else if( conf > 0.4 ) {
     backg = color( map(conf, 0.4, 0.9, 255, 70), 
                   map(conf, 0.4, 0.9, 255, 200),
                  map(conf, 0.4, 0.9, 255, 200) );
  }
    
   if(false)  { //if( backg_fade < 100) {
     // fade in background col
     backg_fade += 10;
     backg = color( 255 - backg_fade, 255 - backg_fade/2, 255 - backg_fade/2 );
   }
   
   //hand.drawSphere();
   
   stroke( backg);    strokeWeight(10);
   noFill();
   //ellipse( handPosition.x, handPosition.y, 30, 30);
   ellipse( width/2, height/2, 50, 50);
}

float r, g, b;

void fade_out_init( ) {
  r = red(backg);
  g = green(backg);
  b = blue(backg);
  
}

void fade_out() {
  if( r < 255)
     r += (255-r) /10; 
  else
    r++;
    
  if( g < 255)
     g += (255-g) /10;
  else
   g++;
   
  if( b < 255)
     b += (255-b) /10; 
  else
     b++; 
  
   backg = color( r, g, b );
   stroke( backg);    strokeWeight(10);
   noFill();
   //ellipse( handPosition.x, handPosition.y, 30, 30);
   ellipse( width/2, height/2, 50, 50);
   //
}


                                                          // Hand Roll

boolean in_scroll = false;
int roll_debounce = 0;                
int roll_debounce_thresh = 100; 
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
    state = 'h';
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
  scroll_hand_begin = handPosition;
}


void scroll_callback( ) {
  
  if( !check_scroll_end() ) {
  
    //PVector position =  hand.getPosition();
      // map hand x position to scroll dist  
    scroll_dist = map( (handPosition.x-scroll_hand_begin.x), -250, 250, -width/4, width/4 );
    //System.out.println(scroll_dist);
    
    // draw scroll menu
    for ( int i=-5; i<6; i++) 
      slice( scroll_last +scroll_dist -(i*200), 150, (i+5)*25);
  }
}

void end_scroll_callback() {
  // add scroll dist to scroll position
  scroll_last += scroll_dist;
  state = 'h'; 
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


                                                            //    ###    Draw ( )
void draw() //$d
{
  background(255);
  // ...
  
  for (Hand h_hand : leap.getHands () )  {
    
    hand = h_hand;
    handPosition = hand.getPosition();
    handDirection = hand.getDirection();
    
    // only for right hand    if( hand.isRight() ){
    
    switch( state) {
       case 'i':    // idle - nothing
         detect_hand();
         break;
       case 'h':    // hand present , no gesture
         draw_hand( );
         check_scroll_gesture(); 
         break;
       case 's':    // scroll gesture
         scroll_callback();
         break;
       // Eo switch
    }
    
    
    // --------------------------------------------------
    // Drawing
    //hand.draw();
    
    // draw a cube for hand representation
    if(false) {    
      float x = map( handPosition.x, 0 , 1000, 0, width );
      float y = map( handPosition.y, 30, 500, 0, height );
      float z = map( handPosition.z, 0, 80,  300, -100 );
      translate( x, y, z);
      rotateZ( hand.getRoll() *PI /180 );
      rotateX( hand.getPitch() *PI /180 );
      rotateY( hand.getYaw() *PI /180 );
      strokeWeight(1);        fill(20,80,110);      
      box(40, 10, 60); 
    }
    
    if( !no_hand_bo )
      no_hand_bo = true;
    // |
    // |
    // Eo for hand
  }
  
  if( leap.getHands().size() == 0 ) {
    // do it with no hands
    if(no_hand_bo) {
      no_hand_bo = false;
      fade_out_init();
    }
    fade_out();
    hand_present = false;
    state = 'i';
  }
  
  if( state != last_state) {
    System.out.print(" new state ");  System.out.println(state);
    last_state = state;    
  }
  // Eo draw    
}

boolean no_hand_bo = true;

// ----