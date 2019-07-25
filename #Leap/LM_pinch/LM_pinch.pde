// Now only measuring swipes when velocity is positive / neg.
//// improces accuracy recognition
// additionally speed and magnitude are used to filter false positives and smaller swipes.


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


float [] trackr = new float [30];
int track_i;
int track_s;
int track_l;

void clear_trackr(int LS){
  track_i = 0;
  track_s = LS;
  track_l = 0;
}

void add_trackr(float X){
  trackr[ track_i ] = X;
  track_i ++;
  
  if( track_i >= track_s)
    track_i = 0;

  if(track_l < track_s)    track_l++;
  // 
}

float get_tracked( int i){
  int indx = track_i -i;
  
  if(track_l==0){
    indx = 0; 
  }
  if(track_l < track_s){
    indx = 0;
  }
  else{
    if (indx <0)
    indx += track_l;    
  }
  
  //println("pos: ",track_i," -",i,"=",indx);
 
  return trackr[indx];  
}

float plot_x = 10;
int plot_w = 4;

void plot_data( float val, float min, float max, 
             float y_min, float y_max, float heit, color col )
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
  clear_trackr(20);
  
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
boolean trou_bo = false;
float peak_vel = 0;
float trou_vel = 0;

boolean new_hand = true;

                                                        // ###  ###


PVector tipPosLast = new PVector(0,0,0);
Boolean is_pinching = false;
int release_time = 0;

void draw() {
  //background(background_col);
  //background(255);
  
  // ...
  
  
  //println("hands : ", leap.getHands().size()  );
  
  //int fps = leap.getFrameRate();
  for (Hand hand : leap.getHands ()) {
    
    // for each hand
    PVector handPos = hand.getPosition();
    //PVector handPos = hand.getIndexFinger().getPosition();
    
    //System.out.print("position ");     System.out.println( handPosition );
    //PVector handVel = hand.getDynamics();
    
    PVector thumbPos = hand.getThumb().getPosition();
    PVector indexPos = hand.getIndexFinger().getPosition();
    
    PVector diff_v = PVector.sub( thumbPos, indexPos);
    
    add_trackr(diff_v.mag());
    
    //for( int i=0; i<9; i++){
    //   print("\t",i,":",get_tracked(i),",");
    //}
    //println();
    
    
    /*void plot_data( float val, float min, float max, 
                     float y_min, float y_max, 
                       float heit, color col )    */
    
    
    // Pinch = 0 to 1.0 = pinch
    //println("pinch :  ", hand.getPinchStrength() );
    
    // closed : -20 ~0
    // wide open : 280
    //println(" pinch distance -Y " , diff.y );
    plot_data( diff_v.y , -100, 300, 0, 200, 250, blue);
    
    // close d~50
    // open 330
    //println(" pinch magnitude " , diff.mag() );
    plot_data( diff_v.mag() , 0, 350, 0, 100, 400, turqu );
    
    
    // Cplot_data( diff.mag() -get_tracked(13), 0, 100, 0, 100, 700, color(60) );
    // B    plot_data( diff.mag() -get_tracked(15), 0, 100, 0, 100, 700, color(80) );
    // A    plot_data( diff.mag() -get_tracked(17), 0, 100, 0, 100, 700, color(127) );
    
    // delayed difference
    float pinch = hand.getPinchStrength();
    
    plot_data(  pinch, 0, 1, 0, 50, 500, grey);
    
    float diff = diff_v.mag() -get_tracked(13);
    plot_data( diff, 0, 200, 0, 100, 600, color(60) );
    
    if( pinch>0.9){
      if(!is_pinching){
        // rising edge
        is_pinching = true;

      }
    }
    else{
      if(is_pinching){
        // falling edge
        is_pinching = false;
        release_time = millis();
      }
    }
    
    if( millis()-release_time< 300){
      //println(" pinch dist:  ", diff );
      println(" pinch dist:  ", diff_v.y);
      if(diff_v.y>230){
         plot_data( 1, 0, 1, 0, 100, 730, green);
      }
      else
        plot_data( 1, 0, 1, 0, 100, 730, red);
    }
    else
      plot_data( 0, 0, 1, 0, 100, 730, red);
      
    //-
    
    
    //plot_data( handDiff.x, -200, 200, -100, 100, 500, blue);
    
    plot_step();
    
    // ## Eo draw()
  }
  
  
  
  if( leap.getHands().size() == 0 )  {
    // no hands
    clear_trackr(20);
    new_hand = true;
  }
  
  
  // ## Eo draw
}




// ----