class Circle {
  float r, x, y;
  void display() {
    noFill();
    stroke(0, 0.00001);
    if (!screenBuffer.contains(this))fill(#009FFF, 5);
    //noStroke();
    //fill(100,100,255,10);
    ellipseMode(CENTER);
    ellipse(x, y, r, r);
  }
  Circle singleNew() {
    Circle c=new Circle();
    c.x=random(-r, r)+x;
    c.y=random(-r, r)+y;
    c.r=r/2;
    return c;
  }
  ArrayList<Circle>makeNew() {
    ArrayList<Circle>list=new ArrayList<Circle>();
    //if(r<10)return list;
    for (int i=0; i<20; i++)list.add(singleNew());
    return list;
  }
}
ArrayList<Circle>finished=new ArrayList<Circle>();
ArrayList<Circle>work=new ArrayList<Circle>();
ArrayList<Circle>screenBuffer=new ArrayList<Circle>();
void settings(){
  size(int(displayWidth*1.25), int(displayWidth*1.25));
}
void setup() {
  //fullScreen();
  //size(500,500);
  Circle c=new Circle();
  c.x=width/2;
  c.y=height/2;
  c.r=500;
  work.add(c);
}
void connect(Circle a, Circle b, float alpha) {
  stroke(0, alpha);
  line(a.x, a.y, b.x, b.y);
}
void draw() {
  background(255);
  float alpha=1;
  iterate();
  iterate();
  iterate();
  iterate();
  for (Circle c : finished) {    
    c.display();
  }
  for (Circle c : finished) {
    for (Circle c1 : finished) {
      if (c1.x!=c.x&&c1.y!=c.y) {
        if (sq(c1.x-c.x)+sq(c1.y-c.y)<sq(c1.r/2+c.r/2)) {
          connect(c, c1, alpha);
        }
      }
    }
  }
  saveFrame("frame.png");
  exit();
}
void keyPressed() {
  if (key=='s') {
    saveFrame("frame.png");
    exit();
  }

  //Circle c=new Circle();
  //c.x=mouseX;
  //c.y=mouseY;
  //c.r=100;
  //work.add(c);
}
void mousePressed() {
  iterate();
}
void iterate() {
  ArrayList<Circle>storage=new ArrayList<Circle>();
  for (Circle c : work) {
    storage.addAll(c.makeNew());
  }
  println(storage.size());
  finished.addAll(work);
  screenBuffer.clear();
  screenBuffer.addAll(work);
  work.clear();
  work.addAll(storage);
}