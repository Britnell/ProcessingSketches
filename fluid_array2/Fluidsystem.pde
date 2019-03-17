class FluidSystem{
    
    int IDX;
    int px = 0;
    int py = 0;
    
    int w, h, fluidgrid_scale;
    int BACKGROUND_COLOR = 0;
    
    DwPixelFlow glscope;
    DwFluid2D fluid;
    MyFluidData cb_fluid_data;

    PGraphics2D pg_fluid;
    PGraphics2D pg_obstacles;
    
    FluidSystem(int IDX, DwPixelFlow glscope, int w, int h, int fluidgrid_scale){
      this.IDX = IDX;
      this.glscope = glscope;
      this.w = w;
      this.h = h;
      this.fluidgrid_scale = fluidgrid_scale;
     
      fluid = new DwFluid2D(glscope, w, h, fluidgrid_scale);
      
      fluid.param.dissipation_density     = 0.99f;
      fluid.param.dissipation_velocity    = 0.85f;
      fluid.param.dissipation_temperature = 0.99f;
      fluid.param.vorticity               = 0.00f;
      fluid.param.timestep                = 0.25f;
      fluid.param.num_jacobi_projection   = 80;
      
      fluid.addCallback_FluiData(new MyFluidData(this));

      pg_fluid = (PGraphics2D) createGraphics(w, h, P2D);
      pg_fluid.smooth(4);
      
      pg_obstacles = (PGraphics2D) createGraphics(w, h, P2D);
      pg_obstacles.smooth(4);
      pg_obstacles.beginDraw();
      pg_obstacles.clear();
      pg_obstacles.fill(64);
      pg_obstacles.noStroke();
      pg_obstacles.ellipse(w/2, 2*h/3f, 100, 100);
      pg_obstacles.endDraw();
    }
    
    void update(){
  
      fluid.addObstacles(pg_obstacles);
      fluid.update();

      pg_fluid.beginDraw();
//      pg_fluid.clear();
      pg_fluid.background(BACKGROUND_COLOR);
      pg_fluid.endDraw();
      
      fluid.renderFluidTextures(pg_fluid, 0);
    }
    
    public void setObstacle( PGraphics2D newObst){
      this.pg_obstacles = newObst; 
    }
    
    public DwFluid2D getFluid(){
     return fluid; 
    }
    
    public PGraphics2D getPG_Fluid(){
     return pg_fluid; 
    }

    public void setPosition(int px, int py){
      this.px = px;
      this.py = py;
    }

    public void display(){
      image(pg_fluid    , px, py);
      image(pg_obstacles, px, py);
    }
  }
  
  
  
  
  class MyFluidData implements DwFluid2D.FluidData{
    
    FluidSystem system;
    
    MyFluidData(FluidSystem system){
      this.system = system;
    }
    
    @Override
    // this is called during the fluid-simulation update step.
    public void update(DwFluid2D fluid) {

      float px, py, vx, vy, radius, vscale, temperature;

      int w = system.w;
      int h = system.h;
      
      
      if(mousePressed){
        vscale = 15;
        px     = mouseX;
        py     = height-mouseY;
        vx     = (mouseX - pmouseX) * +vscale;
        vy     = (mouseY - pmouseY) * -vscale;
        
        // shift by relative position
        px -= system.px;
        py -= system.py;
        
        if(system.IDX==0)
        {
            radius = 28;
            fluid.addDensity (px, py, radius, 0.0f, 0.35f, 0.7f, 1);
            if(mouseButton == LEFT){
              radius = 10;
              fluid.addVelocity(px, py, radius, vx, vy);
            }
            if(mouseButton == RIGHT){
              radius = 15;
              fluid.addTemperature(px, py, radius, 5f);
            }
        }
        // Eo mousePressed
      }
      
        // ** Nevermind the mouse
        
      if(system.IDX == 1){
        temperature = 1.5f;
        vscale = 15;
        px     = w/2-0;
        py     = 0;
        radius = h/6f;
        fluid.addDensity (px, py, radius, 0.0f, 0.4f, 1.00f, 1f, 1);
        radius = w/6f;
        fluid.addTemperature(px, py, radius, temperature);
      }
      
      
      
    }
    
  }