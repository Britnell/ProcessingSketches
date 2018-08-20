// Add point to same shape
// insert point in shape, shift all other points
// 1 add mode 'f' where clostest is kept and not re-calculated. cleared after drawing
// 2 copy shape function. go thrrough vertexes and add to new shape
// 3 smooth curve function

import processing.sound.*;

// shape and draw
PShape IT;
int count = 0;
PShape tmp_trig;

// Mic
PShape amplIT;
AudioIn in;
Amplitude amp;

void setup()
{
  size(800, 800);
  //colorMode(HSB, 360,100,100);
  
  IT = createShape();  //GROUP
  IT.beginShape();
  IT.fill(255);
  IT.endShape();
  count = 0;
  
  in = new AudioIn(this, 0);
  amp = new Amplitude(this);
  in.start();
  amp.input(in);
  
  //tmp_trig = createShape();
}

char mode = 'd';

void draw()
{
  //

  switch(mode)
  {
      // closest
      case 'd':
        
        background(0);
        
        //amp_shape(IT);
        //amp_flares(IT);
        //shape(IT);
        
        float val = smooth_amplit();
        val = map(val, 0,1, 0,100);
        
        // shadow
        IT.beginShape();
        IT.fill(120);
        IT.endShape();
        shape(IT,0,val/10);
        
        // white
        IT.beginShape();
        IT.fill(255);
        IT.endShape();
        shape(IT, val, -val);
        
        // get neighbours
        if (count >=2)
        {
          int cl = get_closest(IT);
          PVector clos = IT.getVertex(cl);
      
          int nb = get_neighb(IT, cl);
          PVector neighb = IT.getVertex(nb);
          
          tmp_trig = createShape( );
          tmp_trig.beginShape();
          tmp_trig.vertex(clos.x, clos.y);
          tmp_trig.vertex(neighb.x, neighb.y);
          tmp_trig.vertex(mouseX, mouseY);
          tmp_trig.fill(120);
          tmp_trig.strokeWeight(1);
          tmp_trig.endShape();
          
          shape(tmp_trig);
          
          //println("cl: ",cl,"nb: ",nb);
          /*ellipse(clos.x, clos.y, 10,10);
           ellipse(neighb.x, neighb.y, 10,10);   */
        }
        
        break;
      case 'm':
        
        
        break;
      // ##### Eo Switch
  }
  
  
  // Eo draw
}


void mousePressed()
{

  // create first shape  
  if (count <3)
  {
    IT.beginShape();
    IT.vertex(mouseX, mouseY);
    IT.endShape();
    count++;
  } else
  {
    // insert points after
    int cl = get_closest(IT);
    PVector clos = IT.getVertex(cl);

    int nb = get_neighb(IT, cl);
    PVector neighb = IT.getVertex(nb);

    //println("points ", cl,":", nb);

    PVector mos = new PVector(mouseX, mouseY);
    IT = insert_point(IT, cl, nb, mos );
  }

  //background(0);
  //shape(IT);
  

  // Eo mousePressed
}


void mouseMoved()
{
  //redraw();

  // Eo mouseMoved
}

float last_amp = 1;

PShape copy_shape(PShape block)
{
   PShape wire = createShape();
   wire.beginShape();
   for( int v=0; v<block.getVertexCount(); v++) {
     PVector vec = block.getVertex(v);
     wire.vertex(vec.x, vec.y);
   }
   wire.endShape();
   return wire;
}

void amp_flares( PShape orig)
{
  float val = amp.analyze();
  val = map(val, 0,1, 0,200);
  
  PVector dir = new PVector( width/2, height/2);
  dir.sub(mouseX, mouseY);
  dir.normalize();
  dir.mult(val);
  
  
  for( int v=0; v<orig.getVertexCount(); v++) {
   PVector flare = orig.getVertex(v);
   
   stroke(255);
   strokeWeight(2);
   line(  flare.x, flare.y,   flare.x +dir.x, flare.y +dir.y);
  }  // Eo for
  
  //return copy;
}

void amp_shape( PShape orig)
{
  PShape copy = orig;
  
  float val = amp.analyze();
  
  //copy.beginShape();
  //copy.fill(180);
  //copy.endShape();
  
  //val = map(val, 0,1, 1,1.2);
  //copy.scale( 1/ last_amp);
  //copy.scale( val );
  
  val = map(val, 0,1, 0,120);
  
  copy.translate( last_amp, -last_amp);
  copy.translate(-val, val );
  last_amp = val;
  
  //return copy;
}

float prev = 0;
float decay = 0.03;

float smooth_amplit( )
{
  float sig = amp.analyze();
  // if larger than old
  // give new, largest signal
  if(sig > prev){
    prev = sig;
    return sig;  
  }
  else
  {
    // decay
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


PShape insert_point( PShape shop, int a, int b, PVector pop)
{
  int p2;
  int len = shop.getVertexCount();

  if ( (a==len-1) && (b==0) )
  {
    println("last one");
    // add point to end
    shop.beginShape();
    shop.vertex(mouseX, mouseY);
    shop.endShape();
  } else if ( (a==0) && (b==len-1) )
  {
    println("last one");
    // add point to end
    shop.beginShape();
    shop.vertex(mouseX, mouseY);
    shop.endShape();
  } else
  {
    if (a<b) {
      //p1 = a;
      p2 = b;
    } else {    //if(a>b){
      //p1 = b; 
      p2 = a;
    }

    // add point to end
    shop.beginShape();
    shop.vertex(0, 0);
    shop.endShape();

    len++;
    // shift point up
    for (int x=len-1; x>p2; x--) {
      PVector vec = shop.getVertex(x-1); 
      shop.setVertex(x, vec);
    }
    shop.setVertex(p2, pop);
  }

  return shop;
}

int get_neighb( PShape shop, int id)
{
  int lo = shop.getVertexCount()-1;
  int n1, n2;
  PVector V1, V2;

  if (id==0) {
    n1 = 1;
    V1 = shop.getVertex(n1);
    n2 = lo;
    V2 = shop.getVertex(n2);
  } else if (id==lo) {
    n1 = 0;
    V1 = shop.getVertex(n1);
    n2 = lo-1;
    V2 = shop.getVertex(n2);
  } else {
    n1 = id-1;
    V1 = shop.getVertex(n1);
    n2 = id+1;
    V2 = shop.getVertex(n2);
  }

  V1.sub(mouseX, mouseY);
  V2.sub(mouseX, mouseY);

  if ( V1.mag() < V2.mag() ) {
    return n1;
  } else
    return n2;

  // Eo get_neighbour
}

int get_closest(PShape shop)
{
  float c_dist = -1;
  int closest_v = 0;

  // through every node 
  for (int v=0; v<shop.getVertexCount(); v++)
  {
    PVector vex = shop.getVertex(v);
    vex.sub( mouseX, mouseY );
    float mm = vex.mag();

    if ( c_dist== -1)
    {
      closest_v = v;
      c_dist = mm;
    } else if ( mm < c_dist) {
      // deduct closest
      // repl 1st
      c_dist = mm;
      closest_v = v;
    }
    // Eo for
  }

  // found closest
  // clos = closest_v

  return closest_v;
}

void keyPressed()
{

  if (key == 'h') {
    // hide
    if (IT.isVisible() ) {
      IT.setVisible(false);
    } else {
      IT.setVisible(true);
    }
  }
  if (key=='x') {
    // add finished shape

    // end shape
    IT.addChild( tmp_trig );
    tmp_trig = createShape();
    //this_trig = 0;
  }


  // Eo CODED
  //
}