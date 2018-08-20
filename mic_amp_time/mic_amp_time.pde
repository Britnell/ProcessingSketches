/*  Shows mic amplitude over time
*    calc sliding average, display as red dot
*    line is blueish when val > average
*/

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

int ind = 0;
int run_size = 3;
float run_av[] = new float [run_size];

float running_average(float newest) {
  // add
  run_av[ind] = newest;
  
  // roll over
  if(ind<run_size-1)
    ind++;
  else
    ind = 0;
  
  // sum & average
  float sum = 0;
  for(int x=0; x<run_size; x++) {
    sum += run_av[x];
  }
  
  sum /= run_size;
  
  return sum; 
}

int x = 0;
int step = 5;
float thresh = 0.08;

void draw() {
  //println(amp.analyze());
  float mic = amp.analyze();
  float mic_v = running_average(mic);
  
  // overpaint
  stroke(255);
  strokeWeight(5);
  line(x,0,x,height);
  
  // if larger than average
  if( mic > mic_v +thresh){
    stroke(20,180,80);
  }
  else{
    stroke(0); 
  }
    
  strokeWeight(5);
  line(x,0,x, map(mic ,0,1, 0,height/2) );
  
  stroke(180,20,20);
  point( x, map( mic_v, 0,1, 0, height/2) );
  
  // step over
  x += step;
  if(x>= width)
    x=0;
  fill(20,20,160);
  //rect(0,height/2,width,height);
}

//