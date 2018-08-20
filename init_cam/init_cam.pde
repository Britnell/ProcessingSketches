import processing.video.*;

Capture cam;

void setup() {
  // framerate in FPS
  frameRate(10);
  
  // x = frameCount;
  //size(1280,720);
  size(640, 480);

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    //cam = new Capture(this, cameras[0]);
    cam = new Capture(this, width, height);
    cam.start();     
  }      
}

void draw() {
  if (cam.available() == true) {
    cam.read();
    image(cam, 0, 0, width, height);
    
    //print("i");
    
    cam.loadPixels();
    
    int index = 0;
    float brightest= 0;
    int brightX=0;
    int brightY = 0;
    
    for( int y=0; y<cam.height; y++)
    {
      for(int x=0; x<cam.width; x++)
      {
        int pixelValue = cam.pixels[index];
        float pixelBright = brightness(pixelValue);
        if(pixelBright > brightest)
        {
          brightest = pixelBright;
          brightY = y;
          brightX = x;
        }
        index++;
      }
    }
  }
  //image(cam, 0, 0);
   // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
}