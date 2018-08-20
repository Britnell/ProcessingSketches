/*  Tidy my functions for audio projects
*  keeps all the mic stuff separate
*  one function to read
*  one to get smooth decaying value
*/
import processing.sound.*;

// Funcitons

// val()
// val(min, max)
// decay()
// decay(min,max)

  // global
  AudioIn in;
  Amplitude amp;
  
  // setup
  void setup_mic(){
    in = new AudioIn(this,0);
    amp = new Amplitude(this);
    in.start();
    amp.input(in);
  }

  
  //read
  
  float mic( ){
    return amp.analyze();
  }
  
  float mic(float min, float max){  
    return map(amp.analyze(), 0,1, min, max);
  }
  
  
  // float d sets pace of decay, as %
  float mic_decay( ){
     return smooth_amplit( ); 
  }
  
  float mic_decay(float min, float max){
     return map( smooth_amplit( ), 0,1, min, max); 
  }
  
  float prev = 0;
  float decay = 0.03;
  
  float smooth_amplit( )
  {
    float sig = amp.analyze();
    
    // return new if larger than old
    // to give spikes
    if(sig > prev){
      prev = sig;
      return sig;  
    }
    else
    {
      // if smaller, decay at set pace
      if( prev >decay){
         prev -= decay;
         return prev;
      }
      else{
        // decay to 0
        prev = 0;
        return prev;
      }
      
      // Eo else
    }  
    // Eo smooth_amplit
  }
 

//