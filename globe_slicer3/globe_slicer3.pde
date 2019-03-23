/*
 *   Calculate linear overlap for layers
 *
 */
 
float HEIGHT = 30;//cm
float HALFHEIGHT = HEIGHT/2;
float cardboard = 0.22;//cm
float thickness = 2.0;//cm

float firstOffset = 0.1;
float ringOverlap = 0.5;

float lastInner, lastOuter;


void setup(){
    
    size(1000,1000);
    lastInner=0;
    lastOuter=0;
    
    //1-for(float x=cardboard/2 ;x<HEIGHT; x+= cardboard){
      // 2 - steps + arcsin
    for(float x=-HALFHEIGHT +firstOffset ;x<HALFHEIGHT; x+= cardboard){
      //  = x
      //float top = x;
      //float bottom = x+cardboard;
      
      float R_outer, alph, R_inner;
      // scale linear
      // 1- x=0; use lwoer R_outer = sin( bottom /HEIGHT *PI ) * HEIGHT;  // * HEIGHT for cm
      //R_outer = sin( x /HEIGHT *PI ) * HEIGHT;
      
      alph = acos( (x/HALFHEIGHT));  // use inverse cos to get angle where were at
      R_outer = sin(alph) * HALFHEIGHT;    // > get sin of where were at
      
      if(R_outer < thickness){
        // buggie way of getting first
        R_inner = 0;
        lastInner = R_inner;
        lastOuter = R_outer;
      }
      else {
         
          // first half, going UP so outer is larger than last
          R_inner = lastOuter -ringOverlap;  
        
        lastInner = R_inner;
        lastOuter = R_outer;
      }
      
      // 1. Static thickness
      //  R_inner = R_outer -thickness;  // static thickness
      
      println("a:", alph, "\tR:", R_inner, ">", R_outer  );
      
      float draw_size = 30;
      PVector offs = new PVector(500,500);
      stroke(0);  strokeWeight(cardboard *draw_size);
      // draw from TOP and bottom
      line( offs.x+ x*draw_size,  offs.y+R_inner*draw_size, 
             offs.x+ x*draw_size, offs.y+R_outer*draw_size);
      line( offs.x+ x*draw_size,  offs.y-R_inner*draw_size, 
             offs.x+ x*draw_size, offs.y-R_outer*draw_size);
       // Eo for x 
    }
    
  
  
  // Eo setup
}


void draw (){
  
  
  
  
  // Eo draw
} 