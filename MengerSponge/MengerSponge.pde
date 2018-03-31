void setup() {
  size(750, 750, P3D);
  perspective(PI/3.0, (float) width/height, 1, 1000000);
  boxes=new ArrayList<Box>();
  float ss=125;
  boxes.add(new Box(-ss/2,-ss/2,-ss/2,ss));
}
void mousePressed() {
  iterate();
}
void iterate() {
  ArrayList<Box>newboxes=new ArrayList<Box>();
  for (Box box : boxes) {
    Box[]news=box.iterate();
    for (Box newbox : news)newboxes.add(newbox);
  }
  boxes=newboxes;
  //boxes.addAll(newboxes);
}
class Box {
  PVector pos;
  float size;
  Box(float x, float y, float z, float s) {
    pos=new PVector(x, y, z);
    size=s;
  }
  void display() {
    //stroke(255);
    noStroke();
    colorMode(HSB, 100);
    float val=pos.mag();
    //color col=color(val,20,75);
    color col=color(val, 100, 100);
    colorMode(RGB, 255);
    col=color(red(col),green(col),blue(col),100-size);
    fill(col);
    //fill(0);
    pushMatrix();
    rotateX(rotX);
    rotateY(rotY);
    rotateZ(rotZ);
    translate(pos.x+size/2, pos.y+size/2, pos.z+size/2);
    box(size);
    popMatrix();
  }
  Box[] iterate() {
    Box[]news=new Box[20];
    float ns=size/3;
    int counter=0;
    for(int x=0;x<3;x++){
      for(int y=0;y<3;y++){
        for(int z=0;z<3;z++){
          if(same(x,y,z,1,1,1))continue;
          
          if(same(x,y,z,0,1,1))continue;
          if(same(x,y,z,2,1,1))continue;
          
          if(same(x,y,z,1,0,1))continue;
          if(same(x,y,z,1,2,1))continue;
          
          if(same(x,y,z,1,1,0))continue;
          if(same(x,y,z,1,1,2))continue;
          
          news[counter]=new Box(x*ns+pos.x,y*ns+pos.y,z*ns+pos.z,ns);
          counter++;
        }
      }
    }
    return news;
  }
}
boolean same(float x, float y, float z, float a, float b, float c) {
  return x==a&&y==b&&z==c;
}
ArrayList<Box>boxes;
float rotX=0, rotY=0, rotZ=0;
void draw() {
  background(0);
  if(keyPressed&&key=='a')rotY-=0.05;
  if(keyPressed&&key=='d')rotY+=0.05;
  if(keyPressed&&key=='w')rotX-=0.05;
  if(keyPressed&&key=='s')rotX+=0.05;
  if(keyPressed&&key=='q')rotZ-=0.05;
  if(keyPressed&&key=='e')rotZ+=0.05;
  PVector eye=new PVector(150, -100, 150);
  PVector center=new PVector(0, 10, 0);
  PVector up=new PVector(0, 1, 0);
  camera(eye.x, eye.y, eye.z, center.x, center.y, center.z, up.x, up.y, up.z);
  noFill();
  stroke(255);
  for (Box b : boxes) {
    b.display();
  }
}