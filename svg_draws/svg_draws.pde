/*
 *  SVG Export
 *      https://processing.org/reference/libraries/svg/index.html
 *
 */

import processing.svg.*;

void setup() {
  // 2 - Screen Display
  size(800, 800);
  noLoop();  
  // Eo setup
}


void draw() {
  PVector C = new PVector(width/2, height/2);

  // * dd
  beginRecord(SVG, "lines_B.svg");
  
  //spiral();
  //double_spiral();
  //spiral_around();
  //square_pat('A');  // gauss
  //square_pat('B');  // gauss with square cutout
  //square_C( C, 200);
  
  // length, y_sep, x_sep
  //lines1( 100, 15, 15);
  lines2( 100, 15, 15, 4,10);

  // *  leng, y_sep, x_sep, dot
  // 1 - ( 100, 18, 15, 4   );
  //linesDot( 100, 18, 15, 4   );
  
  // 2 - Screen display
  endRecord();
  // Eo Draw
}



// * Draws a spiral

void spiral() {
  PVector cntr = new PVector(width/2, height/2);
  PVector arm;
  PVector last = cntr;

  float len_step = 0.1;
  float theta_step = PI/100;

  float len = len_step;
  float theta = theta_step;

  strokeWeight(1);
  stroke(0);

  while (len<0.8*width) {
    arm = PVector.fromAngle(theta);
    arm.mult(len);
    arm.add(cntr);
    //println( last, arm );
    line(last.x, last.y, arm.x, arm.y);
    last = arm;
    theta += theta_step  ;
    len += len_step;
  }

  // Eo spiral
}


// dual spiral
void double_spiral() {
  PVector cntr = new PVector(width/2, height/2);
  PVector arm;
  PVector last = cntr;

  float len_step = 0.1;
  float theta_step = PI/100;

  float len = len_step;
  float theta = theta_step;

  strokeWeight(1);
  stroke(0);

  while (len<0.8*width) {
    arm = PVector.fromAngle(theta);
    arm.mult(len);
    arm.add(cntr);
    //println( last, arm );
    line(last.x, last.y, arm.x, arm.y);
    last = arm;
    theta += theta_step  ;
    len += len_step;
  }

  len = len_step;
  theta = PI+theta_step;
  last = cntr;
  while (len<0.8*width) {
    arm = PVector.fromAngle(theta);
    arm.mult(len);
    arm.add(cntr);
    //println( last, arm );
    line(last.x, last.y, arm.x, arm.y);
    last = arm;
    theta += theta_step  ;
    len += len_step;
  }

  // Eo spiral
}


// * spiral around?

void spiral_around() {
  PVector cntr = new PVector(width/2, height/2);
  PVector arm;
  PVector last = cntr;

  float len_step = 0.1;
  float theta_step = PI/100;

  float len = len_step;
  float theta = theta_step;

  strokeWeight(1);
  stroke(0);

  while (len<100) {
    arm = PVector.fromAngle(theta);
    arm.mult(len);
    arm.add(cntr);
    //println( last, arm );
    line(last.x, last.y, arm.x, arm.y);
    last = arm;
    theta += theta_step  ;
    len += len_step;
  }
  // then go back in
  cntr.add(200, 0);
  theta += PI;
  while (len>0) {
    arm = PVector.fromAngle(theta);
    arm.mult(len);
    arm.add(cntr);
    //println( last, arm );
    line(last.x, last.y, arm.x, arm.y);
    last = arm;
    theta -= theta_step  ;
    len -= len_step;
  }

  // Eo spiral
}

void square_pat(char typos) {
  float dim = 50;

  PVector begin = new PVector(width/2, height/2);

  for ( float x=-dim; x<=width+dim; x+=2.5*dim)
  {
    for (float y=-dim; y<=height+dim; y+=2.5*dim) {
      //begin = new PVector(x,height/2); 
      begin = new PVector(x, y);
      if (typos=='A')
        square_A(begin, dim);
      else if (typos=='B')
        square_B(begin, dim);
    }
  }

  for ( float x=0.25*dim; x<=width+dim; x+=2.5*dim)
  {
    //float y = 0.25*dim;
    for (float y=0.25*dim; y<=height+dim; y+=2.5*dim) {
      //begin = new PVector(x,height/2); 
      begin = new PVector(x, y);
      if (typos=='A')
        square_A(begin, dim);
      else if (typos=='B')
        square_B(begin, dim);
    }
  }
}

void square_A( PVector ctr, float len ) {
  //float len = 20;

  stroke(0);    
  strokeWeight(1);
  // cross
  line(ctr.x, ctr.y, ctr.x+len, ctr.y);
  line(ctr.x+len, ctr.y, ctr.x+len, ctr.y+len);
  line(ctr.x+len, ctr.y+len, ctr.x+0.5*len, ctr.y+len );
  line( ctr.x+0.5*len, ctr.y+len, ctr.x+0.5*len, ctr.y+0.5*len );

  line(ctr.x, ctr.y, ctr.x-len, ctr.y);
  line(ctr.x-len, ctr.y-len, ctr.x-len, ctr.y);
  line(ctr.x-len, ctr.y-len, ctr.x-0.5*len, ctr.y-len);
  line( ctr.x-0.5*len, ctr.y-len, ctr.x-0.5*len, ctr.y-0.5*len);

  line(ctr.x, ctr.y, ctr.x, ctr.y+len);
  line(ctr.x-len, ctr.y+len, ctr.x, ctr.y+len);
  line(ctr.x-len, ctr.y+len, ctr.x-len, ctr.y+0.5*len);
  line(ctr.x-len, ctr.y+0.5*len, ctr.x-0.5*len, ctr.y+0.5*len);

  line(ctr.x, ctr.y, ctr.x, ctr.y-len);
  line(ctr.x+len, ctr.y-len, ctr.x, ctr.y-len);
  line(ctr.x+len, ctr.y-len, ctr.x+len, ctr.y-0.5*len);
  line(ctr.x+len, ctr.y-0.5*len, ctr.x+0.5*len, ctr.y-0.5*len);



  // Eo square
}


void square_B( PVector ctr, float len ) {
  //float len = 20;

  stroke(0);    
  strokeWeight(1);
  // cross
  line(ctr.x, ctr.y, ctr.x+len, ctr.y);
  line(ctr.x+len, ctr.y, ctr.x+len, ctr.y+len);
  line(ctr.x+len, ctr.y+len, ctr.x+0.5*len, ctr.y+len );
  line(ctr.x+len, ctr.y+0.75*len, ctr.x+0.5*len, ctr.y+0.75*len );
  line( ctr.x+0.5*len, ctr.y+0.75*len, ctr.x+0.5*len, ctr.y+len );

  line(ctr.x, ctr.y, ctr.x-len, ctr.y);
  line(ctr.x-len, ctr.y-len, ctr.x-len, ctr.y);
  line(ctr.x-len, ctr.y-len, ctr.x-0.5*len, ctr.y-len);
  line(ctr.x-len, ctr.y-0.75*len, ctr.x-0.5*len, ctr.y-0.75*len);
  line(ctr.x-0.5*len, ctr.y-0.75*len, ctr.x-0.5*len, ctr.y-len);

  line(ctr.x, ctr.y, ctr.x, ctr.y+len);
  line(ctr.x-len, ctr.y+len, ctr.x, ctr.y+len);
  line(ctr.x-len, ctr.y+len, ctr.x-len, ctr.y+0.5*len);
  line(ctr.x-0.75*len, ctr.y+len, ctr.x-0.75*len, ctr.y+0.5*len);
  line(ctr.x-0.75*len, ctr.y+0.5*len, ctr.x-len, ctr.y+0.5*len);

  line(ctr.x, ctr.y, ctr.x, ctr.y-len);
  line(ctr.x+len, ctr.y-len, ctr.x, ctr.y-len);
  line(ctr.x+len, ctr.y-len, ctr.x+len, ctr.y-0.5*len);
  line(ctr.x+0.75*len, ctr.y-len, ctr.x+0.75*len, ctr.y-0.5*len);
  line(ctr.x+0.75*len, ctr.y-0.5*len, ctr.x+len, ctr.y-0.5*len);




  // Eo square
}

// fills image with lines
void lines1(float leng, float y_sep, float x_sep ) {

  stroke(0);    
  strokeWeight(1);
  for (float y=0; y<=height+leng; y+= (y_sep+leng)/2 ) {
    for (float x=0; x<=width; x+= x_sep) {
      line(x, y, x, y+leng);
    }
    y += (y_sep+leng)/2;
    for (float x=x_sep/2; x<=width; x+= x_sep) {
      line(x, y, x, y+leng);
    }      
    // Eo for y
  }
}

// draws grid of Xrows * cols
void lines2(float leng, float y_sep, float x_sep, int rows, int cols ) {

  stroke(0);    
  strokeWeight(1);
  //for (float y=0; y<=height+leng; y+= (y_sep+leng)/2 ) {
  for( int r=0; r<rows; r++){
    float y = r * (y_sep+leng);
    //for (float x=0; x<=width; x+= x_sep) {
    for( int c=0; c<cols; c++){
      float x = c*x_sep;
      line(x, y, x, y+leng);
    }
    y += (y_sep+leng)/2;
    for( int c=0; c<cols; c++){
      float x = x_sep/2 + c *x_sep;
      line(x, y, x, y+leng);
    }      
    // Eo for y
  }
}

void linesDot(float leng, float y_sep, float x_sep, float dot ) {

  stroke(0);    
  
  for (float y=0; y<=height+leng; y+= (y_sep+leng)/2 ) {
    for (float x=0; x<=width; x+= x_sep) {
      strokeWeight(1);
      line(x, y, x, y+leng);
      strokeWeight(dot);
      point(x, y);    
      point(x, y+leng);
    }
    y += (y_sep+leng)/2;
    for (float x=x_sep/2; x<=width; x+= x_sep) {
      strokeWeight(1);
      line(x, y, x, y+leng);
      strokeWeight(dot);
      point(x, y);    
      point(x, y+leng);
    }

    // Eo for y
  }
}
// Eo File