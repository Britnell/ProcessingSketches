// shows data on swipes
// posit. velocity and acceleration
// including coloring for recognition, still capturing entire swipe event, but this increases
// magnitude of false positives...


import de.voidplus.leapmotion.*;
LeapMotion leap;


import processing.serial.*;
Serial arduino;


color bar_c = color(60, 80, 120);

PVector last_vec = new PVector(0,0,0);

ArrayList<PVector> impulses = new ArrayList<PVector>();

PVector center;

                                                            // ## Functions

color green = color(30, 180, 80);
color red = color(180, 40, 40);
color blue = color(30, 80, 180);
color turqu = color( 30, 150, 150);

color grey = color(128, 128, 128);


float [] avrg = new float[30];
int avrg_i = 0;
int avrg_s = 10;
int avrg_l = 0;

void add_avrg( float x){
  avrg[ avrg_i] = x;
  
  avrg_i++;
  
  if(avrg_i >= avrg_s)    
    avrg_i = 0;
  
  if(avrg_l < avrg_s )    avrg_l++;
  
  // Eo add
}

float get_avrg() {
  float sum = 0;
  for( int x=0; x< avrg_l; x++){
    sum += avrg[ x];
  }
  
  if( sum != 0)    // avoid infinity...
    sum /= avrg_l;
    
  return sum;
}

void clear_avrg(){
  avrg_l = 0;
  avrg_i = 0;
}

float plot_x = 10;
int plot_w = 4;

void plot_data( float val, float min, float max, float y_min, float y_max, float heit, color col )
{
  strokeWeight(plot_w);    stroke(col);
  float plot_y = map( val, min, max, y_min, y_max );
  line( plot_x, heit, plot_x, heit -plot_y );
  
  
  
  // Eo plot_data
}

void plot_step(){
  
  stroke(255);  
  line( plot_x+10, 0, plot_x+10, height );
  //fill(255, 30);  
  //rect( plot_x, 0, 1, height);
  
  plot_x += plot_w;
  if(plot_x >= width)
    plot_x = 10;
}

                                                            // ## Setup
void setup() {
  //size(800,400);
  size(2200, 1200);  
  //size(3800, 2100); 

  background(255);
  
  // arduino seria
  printArray(Serial.list());
  //arduino = new Serial(this, Serial.list()[0], 115200);
  
  center = new PVector(width/2, height/2);
  
  // leap motion
  leap = new LeapMotion(this);
  
  //
}

                                                                  // ## Vel


PVector handPosLast = new PVector(0,0,0);
float last_diff = 0;
boolean peeking = false;
boolean troughing = false;

float peak_sum, trou_sum;

int peak_t = 0;
int trou_t = 0;
boolean peak_bo = false;
boolean trouff_bo = false;

boolean new_hand = true;



void track_peaks2( float mov_diff)
{
  
    //println("diff :  ", avrg); 
    
    //if( smooth_diff < 10)       println("Still"); 
    
    // get peak
      
      if( mov_diff > last_diff )  // growing
      {
        // begin peak - reset
        if(!peeking) {
          peak_sum = 0;
          peak_t = millis();
          peeking = true;
        }
        // growing, so add
        peak_sum += abs(mov_diff);  
        //##print intermediate?
      }
      else  // diff diminish.
      {
        // only end peeking when reach 0
        if( peeking  ) {
           //println("curr : ", smooth_diff, "\t last ", last_diff);
           peeking = false;
           peak_t = millis() -peak_t;    // get time
           float speed = peak_sum /peak_t;
           
           if(peak_sum > 220  &&  speed > 1.3   &&  abs(mov_diff) > 30  ) {
             println("\tright swipe dist.  ", peak_sum, "\tspeed ", speed, " curr val : ", mov_diff);
           }
           // End peak
        }
      }
      
    
    
    // get peak
      if( mov_diff < last_diff )  // growing
      {
        // begin peak - reset
        if(!troughing) {
          trou_sum = 0;
          trou_t = millis();
          troughing = true;
        }
        // growing, so add
        trou_sum += abs(mov_diff);  
      }
      else  // diff diminish. 
      {
        if( troughing) {
           troughing = false;
           trou_t = millis() -trou_t;
           float speed = trou_sum /trou_t;
           if(trou_sum > 220  &&  speed > 1.3  &&  abs(mov_diff) > 30 ) {
             println("\t left swipe dist.  ", trou_sum, "\tspeed ", speed, " curr val : ", mov_diff);
           }
           // End trough
        }
      }
      
    
    // After everything
    
    
    // Eo track_peak
}

                                                        // ###  ###



void draw() {
  //background(background_col);
  //background(255);
  
  // ...
  
  
  //println("hands : ", leap.getHands().size()  );
  
  //int fps = leap.getFrameRate();
  for (Hand hand : leap.getHands ()) {
    
    // for each hand
    PVector handPos = hand.getPosition();
    //System.out.print("position ");     System.out.println( handPosition );
    //PVector handVel = hand.getDynamics();
    PVector handDiff = PVector.sub( handPos, handPosLast );
    
    if(new_hand){
      new_hand = false;
      handDiff = new PVector(0,0,0);
    }
    add_avrg(handDiff.x);
    
    float smooth_diff = get_avrg();
    float accel = smooth_diff -last_diff;
    
    track_peaks2( smooth_diff);
    //track_peaks2(accel);
    
    
      // pos
    plot_data( handPos.x, 0, width, 0, 200, 250, blue);
    //plot_data( handDiff.x, -200, 200, -100, 100, 500, blue);
    
      // vel
    if(peeking && !peak_bo)
      plot_data( smooth_diff, -200, 200, -100, 100, 520, green);
    else if(troughing && !trouff_bo)
      plot_data( smooth_diff, -200, 200, -100, 100, 520, red);
    else
      plot_data( smooth_diff, -200, 200, -100, 100, 520, blue);
    
      // accel
    plot_data( accel, -50, 50, -100, 100, 770, turqu);
    plot_step();
    
    // before  next frame
    handPosLast = handPos;
    last_diff = smooth_diff;
    
    
    // ## Eo for hand()
  }
  
  
  
  if( leap.getHands().size() == 0 )  {
    // no hands
    clear_avrg();  
    new_hand = true;
  }
  
  
  // ## Eo draw
}




// ----