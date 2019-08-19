
float HEIGHT = 30;//cm
float HALFHEIGHT = HEIGHT/2;
float cardboard = 0.22;//cm
float thickness = 2.0;//cm


void setup(){
    size(1000,800);
  
    //1-for(float x=cardboard/2 ;x<HEIGHT; x+= cardboard){
      // 2 - steps + arcsin
    for(float x=-HALFHEIGHT +cardboard/2 ;x<HALFHEIGHT; x+= cardboard){
      //  = x
      float top = x;
      //float bottom = x+cardboard;
      
      float R_outer;
      // scale linear
      // 1- x=0; use lwoer R_outer = sin( bottom /HEIGHT *PI ) * HEIGHT;  // * HEIGHT for cm
      //R_outer = sin( x /HEIGHT *PI ) * HEIGHT;
      
      float alph = sin( (x/HALFHEIGHT));
      R_outer = sin(alph) * HALFHEIGHT;
      float R_inner = R_outer -thickness;
      
      float draw_size = 10;
      
      stroke(0);  strokeWeight(4);
      line( 100+ x*draw_size,100+R_inner*draw_size, 
             100+ x*draw_size,100+R_outer*draw_size);
       // Eo for x 
    }
    
  
  
  // Eo setup
}


void draw (){
  
  
  
  
  // Eo draw
} 