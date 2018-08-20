// Add point to same shape
// insert point in shape, shift all other points

PShape IT;

int this_trig = 0;

PShape trig;
PShape tmp_trig;

void setup()
{
  size(800,800);
  //colorMode(HSB, 360,100,100);
  
  IT = createShape();  //GROUP
  trig = createShape();
  //tmp_trig = createShape();
}

void draw()
{
  //
}


void mousePressed()
{   
     IT.beginShape();
     IT.fill(255);
     IT.vertex(mouseX, mouseY);
     IT.endShape();
     this_trig++;
  
  background(0);
  shape(IT);
  // Eo pressed
}

PVector closest, second, neighb;

void mouseMoved()
{
  //int clos = get_closest();
    
  background(0);
  shape(IT);
  
  // Eo mouseMoved
}

int closest_v = 0;

void get_closest()
{
  float c_dist = height+width;
  
  
    // through every node 
    for(int v=0; v<IT.getVertexCount(); v++)
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
    // Eo for}
  
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
  if(key=='x') {
     // add finished shape
     
     // end shape
     IT.addChild( trig );
     trig = createShape();
     //this_trig = 0;

  }


  // Eo CODED
  //
}