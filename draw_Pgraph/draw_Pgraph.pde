
  // * Drawer
  
PGraphics canvas;
color brushCol = color(10,60,120);
float brushSize = 40;

  //    **    Fluids
  
import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.fluid.DwFluid2D;
import processing.core.*;
import processing.opengl.PGraphics2D;
  DwFluid2D fluid;
  PGraphics2D pg_fluid;




void setup(){
  
  size(800,600, P2D);
  
    //   **    Drawer
    
  canvas = createGraphics(width, height);
  canvas.smooth(4);  // default: 2
  canvas.beginDraw();  
  canvas.background(255);
  canvas.endDraw();
  
    // ** Fluids
  
  DwPixelFlow context = new DwPixelFlow(this);
  fluid = new DwFluid2D(context, width, height, 1);
    
    // some fluid parameters
    fluid.param.dissipation_velocity = 0.99;   // how quickly mixing slows down
    fluid.param.dissipation_density  = 0.99;  // how quickly disappears

    // adding data to the fluid simulation
    fluid.addCallback_FluiData(new  DwFluid2D.FluidData(){
      public void update(DwFluid2D fluid) {
        if(random(1)<0.02f){
          float speed = random(40,80);
          float ang = random(0,TWO_PI);
          float rx = random(0, width);
          float ry = random(0, height);
          
          fluid.addVelocity(rx, ry, 200, speed*sin(ang), speed*cos(ang) );
          addDensityTexture(fluid, canvas, 1.0f);
          //fluid.addDensity (rx, ry, 20, 1.0f, 1.0f, 1.0f, 1.0f);          
          //fluid.addDensity (rx, ry, 8, 0.0f, 0.4f, 1.0f, 1.0f);          
        }          
       }
    });
   
    // render-target
    pg_fluid = (PGraphics2D) createGraphics(width, height, P2D);
  
  // Eo setup
}

void draw(){ 
  // update simulation
    fluid.update();
    
    // clear render target
    pg_fluid.beginDraw();
    pg_fluid.background(0);
    pg_fluid.endDraw();

    // render fluid stuff
    fluid.renderFluidTextures(pg_fluid, 0);

    // display
    image(pg_fluid, 0, 0);
    
    //image(canvas,0,0);
  
}

void mousePressed(){
  canvas.beginDraw();
  canvas.noStroke();    canvas.fill(brushCol);
  canvas.ellipse(mouseX, mouseY, brushSize, brushSize);
  canvas.endDraw();
}

void mouseDragged(){
  canvas.beginDraw();
  canvas.strokeWeight(brushSize);    canvas.stroke(brushCol);   canvas.noFill();
  canvas.line(pmouseX, pmouseY,    mouseX, mouseY );
  canvas.endDraw();
}

void mouseReleased(){
  canvas.beginDraw();
  canvas.noStroke();    canvas.fill(brushCol);
  canvas.ellipse(mouseX, mouseY, brushSize, brushSize);
  canvas.endDraw();
}

// custom shader, to add density from a texture (PGraphics2D) to the fluid.
    public void addDensityTexture(DwFluid2D fluid, PGraphics2D pg, float mix){
      int[] pg_tex_handle = new int[1];
//      pg_tex_handle[0] = pg.getTexture().glName;
      context.begin();
      context.getGLTextureHandle(pg, pg_tex_handle);
      context.beginDraw(fluid.tex_density.dst);
      DwGLSLProgram shader = context.createShader(this, "data/addDensity.frag");
      shader.begin();
      shader.uniform2f     ("wh"        , fluid.fluid_w, fluid.fluid_h);                                                                   
      shader.uniform1i     ("blend_mode", 6);   
      shader.uniform1f     ("mix_value" , mix);     
      shader.uniform1f     ("multiplier", 1);     
      shader.uniformTexture("tex_ext"   , pg_tex_handle[0]);
      shader.uniformTexture("tex_src"   , fluid.tex_density.src);
      shader.drawFullScreenQuad();
      shader.end();
      context.endDraw();
      context.end("app.addDensityTexture");
      fluid.tex_density.swap();
    }


// ** Eof