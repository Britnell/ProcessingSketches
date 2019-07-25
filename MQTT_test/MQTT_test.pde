// This example sketch connects to shiftr.io
// and sends a message on every keystroke.
//
// After starting the sketch you can find the
// client here: https://shiftr.io/try.
//
// Note: If you're running the sketch via the
// Android Mode you need to set the INTERNET
// permission in Android > Sketch Permissions.
//
// by Joël Gähwiler
// https://github.com/256dpi/processing-mqtt

import mqtt.*;

MQTTClient client;
int x1, x2, y1, y2;

void draw_grid()
{
  background(60);
  
  strokeWeight(4);  stroke(0);
  line(x1,0,  x1,height);
  line(x2,0, x2,height);
  
  line(0,y1, width, y1);
  line(0,y2, width, y2);
  
}
  
void setup() {
  client = new MQTTClient(this);
  String mqtt_proto = "mqtt://192.168.86.2";
  //String mqtt_port = "12948";
  client.connect(mqtt_proto, "processing");
  client.subscribe("message");
  client.subscribe("keypad");
  
  size(1000,880);
  x1 = width/3;
  x2 = width*2/3;
  
  y1 = height/3;
  y2 = height*2/3;
  
  draw_grid();
  
  // client.unsubscribe("/example");
}

void draw() {
}

void mousePressed(){
  //println("click");
  int x=mouseX;
  int y=mouseY;
  int pr = -1;
  
  if(x<x1 && y<y1)
    pr=1;
  else if(x<x2&&y<y1)
    pr=2;
  else if(x>=x2&&y<y1)
    pr=3;
  else if(x<x1 && y<y2)
    pr=4;
  else if(x<x2&&y<y2)
    pr=5;
  else if(x>=x2&&y<y2)
    pr=6;
  else if(x<x1 &&y>=y2)
    pr=7;
  else if(x<x2&&y>=y2)
    pr=8;
  else if(x>=x2&&y>=y2)
    pr=9;
  
  client.publish("keypad",str(pr) );
  //println("mouse press");
  // Eo clicked
}

void mouseReleased() {
  //println("mouse RELEASE");
  client.publish("keypad", "r");
}

void messageReceived(String topic, byte[] payload) {
  //
  if(topic.equals("keypad") ){
    char keey = char(payload[0]);
    //fill(120, 50, 0);
    fill(245);
    
    switch(keey){
      case '1':        
        rect(0,0,x1,y1);
        break;
      case '2':
        rect(x1,0,x1,y1);
        break;
      case '3':
        rect(x2,0,x1,y1);
        break;
      
      case '4':
        rect(0,y1,x1,y1);
        break;
      case '5':
        rect(x1,y1,x1,y1);
        break;
      case '6':
        rect(x2,y1,x1,y1);
        break;
        
      case '7':
        rect(0,y2,x1,y1);
        break;
      case '8':
        rect(x1,y2,x1,y1);
        break;
      case '9':
        rect(x2,y2,x1,y1);
        break;
        
      case 'r':
        draw_grid();
        break;
    }
    
    println("[" + topic + "] : " + new String(payload));
    
    // Eo keyboard
  }
  else
    println("[" + topic + "] : " + new String(payload));
  
  //--
}