
var r = 400;
var d = 28;
var c;
var off;
var grid, count;
var trig;

function setup() {
  createCanvas(800,800);
  frameRate(5);
  c = createVector(width/2, height/2);
  count = 0;
  off = createVector(d/2,d/2);
  trig = d/3; //sin(PI/3)*d;
  //grid = width/d;
  grid = height / trig;
   //off = createVector(0,0);
  // *
}



function draw() {
  
  background(255);
  
  fill(111);
  ellipse(width/2,height/2,r,r);
  
  count = 0;
  grid = width/d;
  
  for(var x=0;x<grid;x++){
    for(var y=0;y<grid*1.5;y++){
      let po;
      // trig is h between rows, d dist between LEDs. d/2 offset of every other row
      if(y%2==0){
        po = createVector( off.x +x*d , off.y +y*trig );
      }
      else {
        
        po = createVector( d/2 + off.x +x*d , off.y +y*trig );
      }
      let dis = p5.Vector.sub(po, c );
      //let dis = createVector(x*d, y*d);
      if(dis.mag() < r/2 ){
        count ++;
        stroke(0,50,180);
        //console.log( dis.mag(), r);
      }
      else {
        stroke(200,200,200);
      }
      strokeWeight(5); 
      point( po.x, po.y );
    }
  }
  stroke(255); strokeWeight(5);
  point(width/2,height/2);
  
  textSize(30);
  strokeWeight(1); stroke(0);  fill(0);
  text(count.toString(),30, height-30);
  
}

function mouseDragged(event){
  off.add( createVector( (mouseX-pmouseX)/10 , (mouseY-pmouseY)/10 ) );  
}

function keyPressed(){
  //console.log(keyCode );
  if(keyCode==73){
    r -= 1;
    console.log( r);
    return false;
  }
  else if(keyCode==79){
    r += 1;
    console.log( r);
    return false;
  }
  
}