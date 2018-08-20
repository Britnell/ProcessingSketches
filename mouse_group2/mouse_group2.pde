// Finds closest point
// identifies other point of that edge
// draws triangle to add to shape

PShape IT;

int this_trig = 0;
PShape trig;
PShape tmp_trig;

void setup()
{
  size(800,800);
  //colorMode(HSB, 360,100,100);
  
  IT = createShape(GROUP);
  trig = createShape();
  //tmp_trig = createShape();
}

void draw()
{
  //
}


void mousePressed()
{
  if(this_trig<3){
     // create new triag shape 
     
     trig.beginShape();
     trig.fill(255);
     trig.vertex(mouseX, mouseY);
     trig.endShape();
     this_trig++;
     
     // add finished shape
     if(this_trig == 3){
       // end shape
       IT.addChild( trig );
       trig = createShape();
       //this_trig = 0;
     }
     
  
  }  // Eo if trig<3
  else
  {
     // usual draw funct
     trig.beginShape();
     trig.fill(255);
     trig.vertex(closest.x, closest.y);
     trig.vertex(neighb.x, neighb.y);
     trig.vertex(mouseX, mouseY);
     trig.endShape();
     this_trig++;
     IT.addChild( trig );
     trig = createShape();
     
  }
  
  background(0);
  shape(IT);
  // Eo pressed
}

PVector closest, second, neighb;

void mouseMoved()
{
  float c_dist = height+width;
  float s_dist = height+width;
  closest = new PVector(0,0);
  second = new PVector(0,0);
  PVector nei1 = new PVector(0,0);
  PVector nei2 = new PVector(0,0);
  
  background(0);
  shape(IT);
  
  int count = 0;
  // loop through every chil
  for(int c=0; c< IT.getChildCount(); c++)
  {
    PShape sh = IT.getChild(c);
    // through every node 
    for(int v=0; v<sh.getVertexCount(); v++)
    {
      PVector vex = sh.getVertex(v);
      //stroke(20,100,100);
      //line(vex.x, vex.y,  mouseX, mouseY);
      vex.sub( mouseX, mouseY );
      float mm = vex.mag();
      
      // deduct closest
      if( mm < c_dist) {
        // repl 2nd
        second = closest;
        s_dist = c_dist;
        // repl 1st
        closest = sh.getVertex(v);
        c_dist = mm;
        
        // get neighb
        int co = IT.getChild(c).getVertexCount()-1;
        if(v==0) {
           //println("V: ",v," n1: ", v+1, "n2: ", co);
           nei1 = IT.getChild(c).getVertex(v+1);
           nei2 = IT.getChild(c).getVertex( co ); 
        }
        else if(v==co) {
          //println("V: ",v," n1: ", v-1, "n2: ", 0);
           nei1 = IT.getChild(c).getVertex(v-1);
           nei2 = IT.getChild(c).getVertex( 0 );
        }
        else {
          //println("V: ",v," n1: ", v+1, "n2: ", v-1);
          nei1 = IT.getChild(c).getVertex(v-1);
          nei2 = IT.getChild(c).getVertex(v+1);
        }
        // Eo if
      }
      else if( mm < s_dist ) {
         second = sh.getVertex(v);
         s_dist = mm;
      }
      count++;
      // Eo for 
    }
    // Eo for
  }
  
  if(count >= 2) {
    
    //stroke(124);
    //line(closest.x, closest.y, mouseX, mouseY);
    //line(second.x, second.y, mouseX, mouseY);
    
    PVector calc;
    calc = new PVector( mouseX, mouseY);
    calc.sub( nei1);
    float m1 = calc.mag();
    calc = new PVector( mouseX, mouseY);
    calc.sub( nei2);
    float m2 = calc.mag();
    
    
    
    if( m1 < m2) {
      neighb = nei1.copy();
    }
    else {
      neighb = nei2.copy();
    }
    
    //stroke(10,30,160);
    //line(neighb.x, neighb.y, mouseX, mouseY);
    tmp_trig = createShape(TRIANGLE, closest.x, closest.y,
                          neighb.x, neighb.y,
                            mouseX, mouseY);
    tmp_trig.setFill(120);
    shape(tmp_trig);
    
  }
    
  // Eo mouseMoved
}

void keyPressed()
{

  if (key == 'h') {
    // hide
    if(IT.isVisible() ){
       IT.setVisible(false);
    }
    else {
       IT.setVisible(true); 
    }
  }


  // Eo CODED
  //
}