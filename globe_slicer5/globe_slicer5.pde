/*
 *   Calculate linear overlap for layers
 *    NEXT - SORTING ALGORITHM
 *     class row element [number of rows]
        > new ring, is Rinner > Router of largest in Row? [Row max] 
        > if so add to row,   [Row x] , adjust [Row max]
        > if not compare to next
        > if last row then start new row [N rows
 *
 */

import processing.svg.*;

String svg_name = "circles";
boolean RECORD_SVG = true;
char drawMode = 's';    
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

class ringrow 
{
  float y, x, min, max, elem;
  
  ringrow( float Y ){
    x=0;
    y=Y;
    max=0;
    min = HALFHEIGHT;
  }
  
  boolean fitsAround( float Rin){
    if( Rin > max)
      return true;
    else
      return false;
  }
  
  boolean fitsIn( float Rout){
    if( Rout < min)
      return true;
    else
      return false;
  }
  
  void adds( float Rin, float Rout){
    max = Rout;
    min = Rin;
    //x += Rout;
  }
  //
}

void setup(){
    
    size(1000,1000);
    noLoop();
    
    ringrow[] rows = new ringrow[136];
    int R=0;
    boolean nomatch;
    
    if(RECORD_SVG)
    beginRecord(SVG, svg_name+".svg");
    
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
        
        //println("a:", alph, "\tR:", Rinner, ">", Router  );
        
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
        else if(drawMode=='s'){
          // check each row
          nomatch=true;
          for( int r=0; r<R; r++){
            if(nomatch)  // only if not matched already
            if(rows[r].fitsAround(Rinner)){  // if ring fits around row
              rows[r].adds(Rinner, Router);
              // draw into diagram
              stroke(0); strokeWeight(1); noFill();
              ellipse(rows[r].x, rows[r].y, Rinner, Rinner);
              ellipse(rows[r].x, rows[r].y, Router, Router);
              nomatch=false;
            }
          }
          if(nomatch){
            // for nomatch, add new row
            rows[R] = new ringrow( R*HALFHEIGHT);
            // draw into diagram
            stroke(0); strokeWeight(1); noFill();
            ellipse(rows[R].x, rows[R].y, Rinner, Rinner);
            ellipse(rows[R].x, rows[R].y, Router, Router);
            R++;
          }
          // check
        }
        
    }
    
    //endRecord();
    //beginRecord(SVG, svg_name+"B.svg");
    
    //after while loop were at
    //println("AFTER : ", D );
    println("Finished sorting first half, got rows : ", R);
    float Rnext;
    //translate(50, R*HALFHEIGHT );
    translate(50,0);
    R=0;
    
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
        
        
        //println("D:",D, "a:",alph, "O:",Router, "N:",Rnext, "in:", Rinner);
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
        else if(drawMode=='s'){
          // check each row
          nomatch=true;
          for( int r=0; r<R; r++){
            if(nomatch)  // only if not matched already
            if(rows[r].fitsIn(Router)){  // if ring fits around row
              rows[r].adds(Rinner,Router);
              // draw into diagram
              stroke(0); strokeWeight(1); noFill();
              ellipse(rows[r].x, rows[r].y, Rinner, Rinner);
              ellipse(rows[r].x, rows[r].y, Router, Router);
              nomatch=false;
            }
          }
          if(nomatch){
            // for nomatch, add new row
            rows[R] = new ringrow( R*HALFHEIGHT);
            // draw into diagram
            stroke(0); strokeWeight(1); noFill();
            ellipse(rows[R].x, rows[R].y, Rinner, Rinner);
            ellipse(rows[R].x, rows[R].y, Router, Router);
            R++;
          }
          // check
        }
        
        // Advance variables
        Router = Rnext;
        
    }
    
    
    if(RECORD_SVG)
    endRecord();
    
    println("Finished sorting second half, got rows : ", R);
    
    println("\nDONE\n ring has ", Layers, " layers of cardboard" );
    
    
    
    
  // Eo setup
}


void draw (){
  
  // Eo draw
} 