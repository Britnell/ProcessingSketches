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

void draw() {
  //println(amp.analyze());
  stroke(255);
  line(x,0,x,height);
  stroke(0);
  line(x,0,x, map(amp.analyze(),0,1,0,height/2) );
  x += 1;
  if(x>= width)
    x=0;
  fill(20,20,160);
  //rect(0,height/2,width,height);
}