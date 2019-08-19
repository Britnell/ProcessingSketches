
var r = 550;
var d = 28;
var c;
var off;
var grid, count;

function setup() {
  createCanvas(800,800);
  frameRate(5);
  c = createVector(width/2, height/2);
  grid = width/d;
  count = 0;
  off = createVector(d/2,d/2);
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
    for(var y=0;y<grid;y++){
      let po = createVector( off.x +x*d , off.y +y*d );
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