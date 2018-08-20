// Add point to same shape
// insert point in shape, shift all other points
// 1 add mode 'f' where clostest is kept and not re-calculated. cleared after drawing
// 2 copy shape function. go thrrough vertexes and add to new shape
// 3 smooth curve function



TheJig jig;
ArrayList<TheJig> JigList = new ArrayList<TheJig>();


void setup()
{
  size(800, 800);
  //colorMode(HSB, 360,100,100);
  
  //jig = new TheJig();
  JigList.add( new TheJig() );
  jig = JigList.get( JigList.size()-1 );
  
  setup_mic();
  //mic = new Mic(in, amp);
}

char mode = 'd';

void draw()
{
  //
  background(0);
  
  float val = mic_decay(0,200);
  //shape(jit.jigs , val, -val);
  // draw all Jigs in List
  for(TheJig J : JigList){
     shape(J.jigs, val, -val);
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
          
      // ##### Eo Switch
  }
  
  // .
  
  // Eo draw
}


void mousePressed()
{
  jig.add_point(mouseX,mouseY);
  

  // Eo mousePressed
}


void mouseMoved()
{
  if(mode=='m'){
     // get closest and draw circle to mark
     
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
    // Eo switch
  }
  // Eo keyPressed
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
   

  // Eo CODED
  //