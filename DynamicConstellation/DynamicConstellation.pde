//Inspired by: https://www.openprocessing.org/sketch/448612

float maxDist=Float.MAX_VALUE;
float minDist=150;
float grav=0.1;
int totalID=0;
PVector calcDir(float x, float y, int id, boolean display) {
  PVector acc=new PVector(0, 0);
  for (Thing t : things) {
    if (t.id==id)continue;
    PVector dir=PVector.sub(t.pos, new PVector(x, y)).normalize();
    float d=the_dist(x, y, t.pos.x, t.pos.y);
    if (d>maxDist||d<minDist) {
      if (display) {
        stroke(255, 20);
        line(x, y, t.pos.x, t.pos.y);
      }
      continue;
    }
    float f=grav/d;
    acc.add(dir.mult(f));
  }
  return acc;
}
class Thing {
  PVector pos;
  PVector vel;
  PVector acc;
  int id;

  Thing(float x, float y) {
    pos=new PVector(x, y);
    vel=new PVector(0, 0);
    acc=new PVector(0, 0);
    id=totalID;
    totalID++;
  }

  void update(boolean doDraw) {
    //PVector newAcc=new PVector(0,0);
    acc.add(calcDir(pos.x, pos.y, id, doDraw));
    vel.add(acc);
    pos.add(acc);
  }

  void display() {
    fill(255);
    noStroke();
    ellipse(pos.x, pos.y, 5, 5);
  }
  void displayExtras() {
    stroke(255, 255/2, 0, 50);
    line(pos.x, pos.y, pos.x+vel.x, pos.y+vel.y);
    stroke(255/2, 255, 0, 50);
    float accMult=100;
    line(pos.x, pos.y, pos.x+acc.x*accMult, pos.y+acc.y*accMult);
  }
}

ArrayList<Thing>things;

void setup() {
  size(1024, 1024);
  background(0);
  things=new ArrayList<Thing>();
}
void mouseDragged() {
  if (frameCount%5==0)addPoint(mouseX, mouseY);
}
void mousePressed() {
  addPoint(mouseX, mouseY);
}
int mode=0;
void keyPressed() {
  if (key=='1')mode=0;
  if (key=='2')mode=1;
  if (key=='3')mode=2;
  if (key=='4')extras=!extras;
}
boolean extras=false;
//TODO: add draw mode controls
void addPoint(float x, float y) {
  Thing t=new Thing(x, y);
  things.add(t);
}
float the_dist(float a1, float a2, float b1, float b2) {
  //return abs(a1-b1)+abs(a2-b2);
  return sqrt(sq(a1-b1)+sq(a2-b2));
}

void draw() {
  //background(0);
  fill(0, 20);
  rect(0, 0, width, height);
  surface.setTitle("DynamicConstellation: frameRate="+nf(frameRate, 2, 3));
  for (Thing t : things) {
    if (mode==0)t.update(true);
    if (mode==1||mode==2)t.update(false);
    if (mode==2)t.display();
  }
  if (extras) {
    for (Thing t : things) {
      t.displayExtras();
    }
  }
  //for (int x=0; x<width; x+=64) {
  //for (int y=0; y<height; y+=64) {
  //stroke(0,255,0,10);
  //PVector vec=calcDir(x, y, -1, false).mult(10000);
  //line(x, y, x+vec.x, y+vec.y);
  //}
  //}
}