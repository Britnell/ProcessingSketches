// Add point to same shape
// insert point in shape, shift all other points
// 1 add mode 'f' where clostest is kept and not re-calculated. cleared after drawing
// 2 copy shape function. go thrrough vertexes and add to new shape
// 3 smooth curve function



TheJig jig, tmp_jig;
ArrayList<TheJig> JigList = new ArrayList<TheJig>();
ArrayList<TheJig> CopyList = new ArrayList<TheJig>();
TheJig curr_copy;

void setup()
{
  //fullScreen();
  size(1200, 800);
  //colorMode(HSB, 360,100,100);
  
  //jig = new TheJig();
  JigList.add( new TheJig() );
  CopyList.add(new TheJig() );
  
  jig = JigList.get( JigList.size()-1 );
  tmp_jig = new TheJig();
  curr_copy = new TheJig();
  
  setup_mic();
  //mic = new Mic(in, amp);
}

char mode = 'd';
int cl, nb;
int[] res = new int[2];
float phase = 0;

void draw()
{
  //
  background(0);
  
  float val = mic_decay();
  //shape(jit.jigs , val, -val);
  // draw all Jigs in List
  if(mode=='s' || mode=='d' || mode=='f' ){
    for(TheJig J : JigList){
      // draw bobbing
      val = map(val,  0,1,  0,50);
      // apply sin to values
      //val *= sin(phase);
      shape(J.jigs, val, -val);
      
      //val = map(val, 0,1,  0,100);
      //shapeMode(CENTER);
      //shape(J.jigs,0-val,0-val, width+val, height+val);
    }
  }
  if(mode=='d' || mode=='f' || mode=='m' || mode=='r') {
    for(TheJig J : JigList){
      // draw original
       shape(J.jigs);
    }
  }
  
  switch(mode)
  {
      case 'd':    // drawing mode
        // draw temp trig
        // on current jig
        if(jig.count >= 2)
          shape( jig.get_tmp_trig() );
          
        break;
      case 'h':
        // dont draw temp trig
        break;
      case 'f':
        // get points for fixed
        if(jig.count >= 2){  
          shape( jig.get_tmp_trig_fixed(cl, nb) );
        }
        break;
      case 'm':    // mode : move
        // identify nearest
        
        // check only (last) shape
        //cl = jig.get_closest(jig.jigs, mouseX, mouseY);
        //PVector pos = jig.jigs.getVertex(cl);
        
        // check list of shapes
        res = get_closest_of_all(JigList);
        println("res: ",res[0],"/", res[1]);
        
        //tmp_jig = JigList.get(res[1]);                // get child
        PVector pos = JigList.get(res[0]).jigs.getVertex(res[1]);  // get that childs closest node
        
        // mark with circle
        
        noFill();
        stroke(150,30,30);
        strokeWeight(5);
        ellipse(pos.x, pos.y, 20, 20);
        break;
      // ##### Eo Switch
  }
  
  // .
  
  // Eo draw
}


void mousePressed()
{
  if(jig.count >2)
  {
    if( mode=='d') {
      cl = jig.get_closest(jig.jigs, mouseX, mouseY);
      nb = jig.get_neighb(jig.jigs, cl);
      mode = 'f';
    }
    else if(mode == 'f') {
      jig.add_point_fixed(mouseX, mouseY, nb, cl);
      // back into normal draw mode to find new edge
      mode = 'd'; 
    }
    else if(mode == 'm') {
       // move point mode
       // stop searching for nearest, thus current closest selected 
       // as identified by cl
       // now dragging
       mode = 'r';
    }
    else if(mode== 'r') {
       // dragging mode
       // on this 2nd click, position is kept and move back to move mode
       mode = 'm';
    }
  }
  else
  {
    // for first 3 points, just add
    jig.add_point(mouseX,mouseY);
  }
  // jig.add_point(mouseX,mouseY);
  
  // update copy list
  // JigList >  CopyList
  
  //curr_copy = copy_of(jig);
  // Eo mousePressed
}


void mouseMoved()
{
  if(mode=='r'){
     // dragging selected node
     //PVector temp = jig.jigs.getVertex(cl);
     //jig.jigs.setVertex(cl, mouseX, mouseY);//~
     JigList.get( res[0] ).jigs.setVertex(res[1], mouseX, mouseY );

  }
  // Eo mouseMoved
}



void keyPressed()
{
  switch(key)
  {
    case 'h':    // hide
      mode = 'h';
      break;
    case 'd':
      mode = 'd';
      break;
    case 'x':
      JigList.add( new TheJig() );
      jig = JigList.get( JigList.size()-1 );
      break;
    case 'm':
      mode = 'm';
      break;
    case 's':
      mode = 's';
      break;
    // Eo switch
  }
  // Eo keyPressed
}

//void copy_list(

PShape copy_of(PShape orig){
  //---
 PShape copies = createShape();
 
 for(int x=0; x<orig.getVertexCount(); x++){
   PVector vec = orig.getVertex(x);
    copies.vertex( vec.x, vec.y);
 }
 copies.endShape();
 
 return copies;  
}
  
  void amp_flares( PShape orig)
  {
    float val = mic_decay(0,200);
    
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
   
   
  int[] get_closest_of_all( ArrayList<TheJig> TheList) {
      int [] clossest = new int[2];
      clossest[0] = 0;
      clossest[1] = 0;
      float c_dist = -1;
      
      for( int c=0; c< TheList.size() ; c++ ) {
        // 
        if(TheList.get(c).count >= 2) {
          float [] res = jig.get_closest_aray(TheList.get(c).jigs, mouseX, mouseY);
          // res[0] = ID of closest    res[1] = dist
          
          if(c_dist == -1) {
             clossest[0] = c;  // child
             clossest[1] = floor(res[0]);  // vertex ID
             c_dist = res[1];
          }
          else if( res[1] < c_dist ){
             clossest[0] = c;
             clossest[1] = floor(res[0]);
             c_dist = res[1];
          }
        }
        // Eo for
      }
      
      return clossest;
    }   // Eo get_closest_of_all

  // Eo CODED
  //