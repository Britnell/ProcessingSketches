/*    The Jig
*
*/

class TheJig
{
    
    // shape and draw
    PShape jigs;
    int count = 0;
    PShape tmp_trig;
    
    // Mic
    PShape copyJig;
    
    TheJig()
    {
      jigs = createShape();  //GROUP
      jigs.beginShape();
      jigs.fill(255);
      jigs.stroke(0);
      jigs.strokeWeight(1);
      jigs.endShape();
      
      count = 0;
    }
    
    PShape get_tmp_trig()
    {
        // --drawing mode
        // draw temp triangle
        // get neighbours
        int cl = get_closest(jigs, mouseX, mouseY);
        PVector clos = jigs.getVertex(cl);
        
        int nb = get_neighb(jigs, cl);
        PVector neighb = jigs.getVertex(nb);
        
        tmp_trig = createShape( );
        tmp_trig.beginShape();
        tmp_trig.vertex(clos.x, clos.y);
        tmp_trig.vertex(neighb.x, neighb.y);
        tmp_trig.vertex(mouseX, mouseY);
        tmp_trig.fill(120);
        tmp_trig.strokeWeight(1);
        tmp_trig.endShape();
        
        //shape(tmp_trig);
        return tmp_trig;
        
        //println("cl: ",cl,"nb: ",nb);
        /*ellipse(clos.x, clos.y, 10,10);
         ellipse(neighb.x, neighb.y, 10,10);   */

      
      // Eo draw
    }
    
    
    void add_point(float X, float Y)
    {
      
      // create first shape  
      if (count <3)
      {
        jigs.beginShape();
        jigs.vertex(X, Y);
        jigs.endShape();
        count++;
      }
      else
      {
        // insert points after
        int cl = get_closest(jigs, X, Y);
        //PVector clos = jigs.getVertex(cl);
        
        int nb = get_neighb(jigs, cl);
        //PVector neighb = jigs.getVertex(nb);
    
        //println("points ", cl,":", nb);
    
        PVector mos = new PVector(X, Y);
        jigs = insert_point(jigs, cl, nb, mos );
      }  
    
      // Eo add_jig
    }
        
    /*  insert point to shape between two vertexes
    *    
    */
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
      // Eo insert_point
    }
    
    /* Find closest neighbour of given point
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
    
    /*  find closest point onon given shape
    */
    int get_closest(PShape shop, float X, float Y)
    {
      float c_dist = -1;
      int closest_v = 0;
    
      // through every node 
      for (int v=0; v<shop.getVertexCount(); v++)
      {
        PVector vex = shop.getVertex(v);
        vex.sub( X, Y );
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
      // clos = closest_v at c_dist
    
      return closest_v;
    }
 
    // # 
    // #### Eo class
}

// End