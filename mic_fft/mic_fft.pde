import processing.sound.*;

AudioIn in, in2;
Amplitude amp;

FFT fft;
int bands = 512;
float[] spectrum = new float[bands];


void setup() {
  size(1024, 360);
  background(255);
    
  // Create the Input stream
  amp = new Amplitude(this);
  fft = new FFT(this, bands);
  in = new AudioIn(this, 1);
  in2 = new AudioIn(this, 0);
  //in.play();
  in.start();
  fft.input(in);
  amp.input(in2);
  
}      

int x = 0;

void draw() {
  
  int[] slope = new int[bands];
  //println(amp.analyze());
  //rect(0,height/2,width,height);
  background(255);
  
  // --- 
  fft.analyze(spectrum);
  strokeWeight(1);
  stroke(20,20,180);
  for(int i=1; i< bands; i++)
  {
    if( spectrum[i]>spectrum[i-1] ) {
      slope[i] = 1;
    }
    else if( spectrum[i] == spectrum[i-1]) {
      slope[i] = 0;
    }
    else {
      slope[i] = -1;
    }
      
    line( i, height, i, height*(1-spectrum[i]*5) );
  }
  
  stroke(160,20,20);
  line(512,0,512,height);
  
  float ampl = amp.analyze();
  rect(512,height, width, height -map(ampl, 0,1, 0, height) );
}