/*
 *  SVG Export
 *      https://processing.org/reference/libraries/svg/index.html
 *
 */

import processing.svg.*;

void setup(){
  // 1 - No display
  //size(400,400,SVG,"test.svg");
  
  // 2 - Screen Display
  size(400, 400);
  noLoop();
  
  //beginRecord(SVG, "test2.svg");
  
  // Eo setup
}


void draw(){
  strokeWeight(40);
  line(0,0, width, height);
  
  // 1 - No display
  //exit();
  
  // 2 - Screen display
  endRecord();
  // Eo Draw
}