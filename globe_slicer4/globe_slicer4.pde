/*
 *   Calculate linear overlap for layers
 *
 */
 
import processing.svg.*;

String svg_name = "circles1.svg";
boolean RECORD_SVG = true;
char drawMode = 'c';    
// 'l' for lines
// 'c' for circles

float HEIGHT = 30; //cm->px
float HALFHEIGHT = HEIGHT/2;
float cardboard = 0.22;//cm
float thickness = 3.0;//cm

float firstOffset = 0.05;
float ringOverlap = 1.0;

float lastInner, lastOuter;

PVector Offset = new PVector(0,0); 

void setup(){
    
    size(1000,1000);
    noLoop();
    
    if(RECORD_SVG)
    beginRecord(SVG, svg_name);
    
    int Layers = 0;
    
    float draw_size = 30;
    
    float D, alph, Router, Rinner;
    
    // get First for while loop
    D = -HALFHEIGHT +firstOffset;
    alph = acos( (D/HALFHEIGHT));
    Router = sin(alph) * HALFHEIGHT;
    lastInner = 0;    lastOuter = Router;
    
    //println("FIRST angle : ", alph );
    
    while(alph>=HALF_PI)
    {
        // from Angle get radius of sphere 
        Router = sin(alph) * HALFHEIGHT;
        
        if(D==-HALFHEIGHT +firstOffset){
          Rinner = 0; 
        }
        else {
          // on FIRST HALF, we select Rinner from Router
          Rinner = lastOuter -ringOverlap;
        }
        
        println("a:", alph, "\tR:", Rinner, ">", Router  );
        
        // Advance variables
        lastInner = Rinner;
        lastOuter = Router;
        D += cardboard;
        alph = acos( (D/HALFHEIGHT));
        
        // Layers
        Layers++;
        // Draw
        if(drawMode=='l'){
          PVector offs = new PVector(500,500);
          stroke(0);  strokeWeight(cardboard *draw_size);
          // draw from TOP and bottom
          line( offs.x+ D*draw_size,  offs.y+Rinner*draw_size, 
                 offs.x+ D*draw_size, offs.y+Router*draw_size);
          line( offs.x+ D*draw_size,  offs.y-Rinner*draw_size, 
                 offs.x+ D*draw_size, offs.y-Router*draw_size);
        }
        else if(drawMode=='c'){
          stroke(0); strokeWeight(1); noFill();
          ellipse(Offset.x,Offset.y, Rinner, Rinner);
          ellipse(Offset.x,Offset.y, Router, Router);
          if(Layers%20==0){
            Offset.x = 0;
            Offset.y += HALFHEIGHT;
          }
          else {
            Offset.x += Router;
          }
        }
        
    }
    
    //after while loop were at
    //println("AFTER : ", D );
    float Rnext;
    
    // we already stepped D and angle, so lets get Radius
    Router = sin(alph) * HALFHEIGHT;
    while(alph>0){
        
        // get Next outer
        D += cardboard;
        alph = acos( (D/HALFHEIGHT));
        Rnext = sin(alph) * HALFHEIGHT;
        
        // on SECOND HALF, we match inner with outer of Next
        if(D<=HALFHEIGHT){
          Rinner = Rnext -ringOverlap;   
        }
        else {
          //println("NAAAAN");
          Rinner = 0;
        }
        
        
        println("D:",D, "a:",alph, "O:",Router, "N:",Rnext, "in:", Rinner);
        //println("D:", D, "a:", alph, "Rads-", Rinner, ">", Router  );
        
        // Layers
        Layers++;
        // Draw
        if(drawMode=='l'){
          PVector offs = new PVector(500,500);
          stroke(0);  strokeWeight(cardboard *draw_size);
          // draw from TOP and bottom
          line( offs.x+ D*draw_size,  offs.y+Rinner*draw_size, 
                 offs.x+ D*draw_size, offs.y+Router*draw_size);
          line( offs.x+ D*draw_size,  offs.y-Rinner*draw_size, 
                 offs.x+ D*draw_size, offs.y-Router*draw_size);
        }
        else if(drawMode=='c'){
          stroke(0); strokeWeight(1); noFill();
          ellipse(Offset.x,Offset.y, Rinner, Rinner);
          ellipse(Offset.x,Offset.y, Router, Router);
          if(Layers%20==0){
            Offset.x = 0;
            Offset.y += HALFHEIGHT;
          }
          else {
            Offset.x += Router;
          }
        }
        
        // Advance variables
        Router = Rnext;
        
    }
    
    println("\nDONE\n ring has ", Layers, " layers of cardboard" );
    
    if(RECORD_SVG)
    endRecord();
    
  // Eo setup
}


void draw (){
  
  
  
  
  // Eo draw
} 