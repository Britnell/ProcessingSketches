// Add point to same shape
// insert point in shape, shift all other points

PShape IT;

int count = 0;

PShape trig;
PShape tmp_trig;

void setup()
{
  size(800,800);
  //colorMode(HSB, 360,100,100);
  
  IT = createShape();  //GROUP
  IT.beginShape();
  IT.fill(255);
  IT.endShape();
  
  count = 0;
  //tmp_trig = createShape();
}

void draw()
{
  //
  
  background(0);
  shape(IT);
  
  // closest
  if(count >=3)
  {
    int cl = get_closest(IT);
    PVector clos = IT.getVertex(cl);
    
    int nb = get_neighb(IT, cl);
    PVector neighb = IT.getVertex(nb);
    
    //println("cl: ",cl,"nb: ",nb);
    /*
    noFill();
    stroke(120,10,10);
    ellipse(clos.x, clos.y, 5,5);
    noFill();
    stroke(20,120,10);
    ellipse(neighb.x, neighb.y, 5,5);
    */
    
    tmp_trig = createShape( TRIANGLE, clos.x, clos.y, neighb.x, neighb.y, mouseX, mouseY);
    tmp_trig.fill(120);
    shape(tmp_trig);
    
  }
  
  // Eo draw
}


void mousePressed()
{
  
   // create first shape  
  if(count <3)
  {
     IT.beginShape();
     IT.vertex(mouseX, mouseY);
     IT.endShape();
     count++;
  }
  else
  {
    // insert points after
    int cl = get_closest(IT);
    PVector clos = IT.getVertex(cl);
    
    int nb = get_neighb(IT, cl);
    PVector neighb = IT.getVertex(nb);
    
    println("points ", cl,":", nb);
    
    PVector mos = new PVector(mouseX, mouseY);
    IT = insert_point(IT, cl, nb, mos );
    
  }
  
  background(0);
  shape(IT);
  
  // Eo mousePressed
}


void mouseMoved()
{
  redraw();
  
  // Eo mouseMoved
}

PShape insert_point( PShape shop, int a, int b, PVector pop)
{
  int p1, p2;
  int len = shop.getVertexCount();
  
  if( (a==len-1) && (b==0) )
  {
    println("last one");
    // add point to end
    shop.beginShape();
    shop.vertex(mouseX, mouseY);
    shop.endShape();    
  }
  else if( (a==0) && (b==len-1) )
  {
    println("last one");
    // add point to end
    shop.beginShape();
    shop.vertex(mouseX, mouseY);
    shop.endShape();    
    
  }
  else
  {
    if(a<b){
      p1 = a;
      p2 = b;
    }
    else {    //if(a>b){
      p1 = b; 
      p2 = a;
    }
    
    // add point to end
    shop.beginShape();
    shop.vertex(0,0);
    shop.endShape();
    
    len++;
    // shift point up
    for(int x=len-1; x>p2; x--){
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
  
  if(id==0) {
    n1 = 1;
    V1 = shop.getVertex(n1);
    n2 = lo;
    V2 = shop.getVertex(n2);
  }
  else if(id==lo) {
    n1 = 0;
    V1 = shop.getVertex(n1);
    n2 = lo-1;
    V2 = shop.getVertex(n2);
  }
  else {
    n1 = id-1;
    V1 = shop.getVertex(n1);
    n2 = id+1;
    V2 = shop.getVertex(n2);
  }
  
  V1.sub(mouseX, mouseY);
  V2.sub(mouseX, mouseY);
  
  if( V1.mag() < V2.mag() ) {
      return n1;
  }
  else
    return n2;
  
  // Eo get_neighbour
}

int get_closest(PShape shop)
{
  float c_dist = -1;
  int closest_v = 0;
  
    // through every node 
    for(int v=0; v<shop.getVertexCount(); v++)
    {
      PVector vex = shop.getVertex(v);
      vex.sub( mouseX, mouseY );
      float mm = vex.mag();
      
      if( c_dist== -1)
      {
        closest_v = v;
        c_dist = mm;
      }
      else if( mm < c_dist) {
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