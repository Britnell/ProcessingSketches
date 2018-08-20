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
  
   /*
   if(xy > smooth)
     smooth = xy;
   else if(xy >= smooth - 20)
     smooth = xy;
   else
     smooth -= smooth/factor;
     */
     
   if( xy > smooth-smooth/10)
     smooth = xy;
   else
     smooth -= smooth / factor;
     
   return smooth;
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
  
    soft = soft_decay(val);
  float scale = map(soft, 0,1, 0, height/2);
  
  ellipse(width/2, height/2, scale, scale);  
  //rect(0,height/2,width,height);
}