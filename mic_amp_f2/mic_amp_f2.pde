import processing.sound.*;

AudioIn in;
Amplitude amp;

FFT fft;
int bands = 512;
float[] spectrum = new float[bands];

void setup() {
  size(1024, 360);
  background(255);
    
  // Create the Input stream
  amp = new Amplitude(this);
  
  in = new AudioIn(this, 0);
  //in.play();
  in.start();
  amp.input(in);
  //fft.input(in);
}      

int x = 0;
float soft = 1;
float step = 1.0;
float mic_thresh = 0.1;
static float smooth = 1.0;
float factor = 10;
int small_step = 2;

float soft_decay(float xy){
    
   if( xy > smooth-smooth/10)
     smooth = xy;
   else
     smooth -= smooth / factor;
     
   return smooth;
}

int amplit= 1;
float last_xy = 0;

int fixed_amplit(float xy){
   float thres = 0.05;
   int th_peak = 30;
   int amplit_imp = height/3;
   
   // if input above thresh, but amplit already above thresh too:
   if( xy >= thres && amplit >= th_peak )
       amplit = int(amplit + amplit * (xy-last_xy) );
   else  // if input above thresh but we aren't
   if( xy >= thres )
     amplit = amplit_imp;
   else  // decay
     amplit -= amplit / 10;
   
   if(amplit < 1)
     amplit = 1;
     
   last_xy = xy;
   return amplit;
}

int ind = 0;
int run_size = 5;
float run_av[] = new float [run_size];

float running_average(float newest) {
  // add
  run_av[ind] = newest;
  
  // roll over
  if(ind<newest-1)
    ind++;
  else
    ind = 0;
  
  // sum & average
  float sum = 0;
  for(int x=0; x<run_size; x++)
    sum += run_av[ind];
  sum /= run_size;
  
  return sum; 
}

void draw() {
  background(255, 30);
  
  fill(0);
  noStroke();
  //float val = map(amp.analyze(), 0,1, 0,height/3);
  float val = amp.analyze();
  
  fill(0);
  rect(0,0,20, map( val, 0,1, 0, height-10) );
  
  //if( val > mic_thresh)  
  //  soft = soft_decay( height/3);
  
  //soft = soft_decay(val);
  //float scale = map(soft, 0,1, 0, height/2);
  
  int scale = fixed_amplit(val);
  
  ellipse(width/2, height/2, scale, scale);  
  //rect(0,height/2,width,height);
}