
PVector center;
PShape sh;

void setup(){
  size(1000,800);
  
  frameRate(5);
  center = new PVector( width/2, height/2);
  sh = createShape();
  int frame = 200;
  sh.beginShape();
  sh.noFill(); sh.strokeWeight(1);
  sh.vertex(center.x,center.y-frame);
  sh.vertex(center.x+frame,center.y);
  sh.vertex(center.x,center.y+frame);
  sh.vertex(center.x-frame,center.y);
  //sh.vertex(center.x,center.y-frame);
  sh.endShape(CLOSE);
  
  
  background(255);
  shape(sh);
}


void draw() {
    //sh.scale(1.01);
    for(int v=0; v<sh.getVertexCount(); v++){
      PVector next = sh.getVertex(v);
      PVector dir = PVector.sub(next, center);
        dir.normalize();
        dir.mult(random(-3,9));
        dir.rotate( random(-PI,PI)/2);
      next.add(dir);
      sh.setVertex(v,next);
      // Eo for 
    }
    //background(255);
    noStroke();  fill(255,80);
      rect(0,0,width,height);
    shape(sh);
  
}

void mouseClicked(){
  int cl = get_closest(sh);
  PVector clos = sh.getVertex(cl);
  
  int nb = get_neighb(sh, cl);
  PVector neighb = sh.getVertex(nb);

  //println("points ", cl,":", nb);

  PVector mos = new PVector(mouseX, mouseY);
  sh = insert_point(sh, cl, nb, mos );
  
  background(255);
  shape(sh);
}
  
  
  
  
  /*    ****************
  *     *
  *     *
  */
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



PShape insert_point( PShape shop, int a, int b, PVector pop)
{
  int p2;
  int len = shop.getVertexCount();

  if ( (a==len-1) && (b==0) )
  {
    println("last one");
    // add point to end
    //shop.beginShape();
    shop.vertex(mouseX, mouseY);
    //shop.endShape();
  } 
  else if ( (a==0) && (b==len-1) )
  {
    println("last one");
    // add point to end
    //shop.beginShape();
    shop.vertex(mouseX, mouseY);
    //shop.endShape();
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
    //shop.beginShape();
    shop.vertex(0, 0);
    //shop.endShape();

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

void insert_code(){
  // choose vertex
  PVector prev;
  int Len = sh.getVertexCount();
  int inc = int(random(0, Len-1));
  sh.vertex(0,0);
  for( int SH=Len; SH>inc; SH--){
    // SH = last
    // get 1 before last and copy into last;
    // finally SH = inc+1 becomes inc
    prev = sh.getVertex(SH-1);
    sh.setVertex(SH, prev);
  }
  // so then can put new Vect into inc
  
}