void setup() {
  size(1000, 1000);
  //size(500, 500);
  pixelDensity(2);
  //textFont(loadFont("Monospaced-20.vlw"));
}
float density=2;
float offx=0;
float offy=0;
float scale=1;
float targoffx=0, targoffy=0, targscale=1;
float mapX(float x) {
  x=map(x, 0, width, -2, 2);
  x*=scale;
  return x;
}
float mapY(float y) {
  y=map(y, 0, height, -2, 2);
  y*=scale;
  return y;
}
void mouseWheel(MouseEvent me) {
  float count=me.getCount();
  targscale+=count/100;
}
public static long combo(long choose, long total) {
  if (total < choose)
    return 0;
  if (choose == 0 || choose == total)
    return 1;
  return combo(total-1, choose-1)+combo(total-1, choose);
}
void draw() {
  background(0);
  //n+=0.25;
  if (mousePressed) {
    targoffx=offx+mapX(mouseX);
    targoffy=offy+mapY(mouseY);
  }
  offx=lerp(offx, targoffx, 0.1);
  offy=lerp(offy, targoffy, 0.1);
  scale=lerp(scale, targscale, 0.1);
  if (targscale<0.00001)targscale=0.00001;
  if (scale<0.00001)scale=0.00001;
  for (float x=0; x<width*2; x+=density) {
    for (float y=0; y<height*2; y+=density) {
      float a=mapX(x);
      float b=mapY(y);
      a+=offx;
      b+=offy;

      int numIters=0;
      while (numIters<30&&sq(a)+sq(b)<n) {
        if (a>pa)a=2-a;
        else if (a<pb)a=-2-a;
        if (b>pa)b=2-b;
        else if (b<pb)b=-2-b;
        float mag=sqrt(a*a+b*b);
        if (mag<0.5) {
          a*=4;
          b*=4;
        } else if (mag<1) {
          a/=mag;
          b/=mag;
          a/=mag;
          b/=mag;
        }
        a*=mandelScale;
        b*=mandelScale;
        a+=ca;
        b+=cb;

        numIters++;
      }

      color col=color(0, 0, 0);
      float v=float(numIters)/10;
      if (doHSB) {
        colorMode(HSB, 100);
        col=color(v*100, 100, 100);
        colorMode(RGB, 255);
      } else {
        col=color(v*255);
      }
      if (numIters==30)col=color(0);
      fill(col);
      stroke(col);
      rect(x, y, density, density);
    }
  }
  stroke(255);
  //line(0, height/2, width, height/2);
  //line(width/2, 0, width/2, height);
  //save("frame.png");
  println("end frame "+frameCount);
  //exit();
  //n+=0.01;
}
float pa=1;
float pb=-1;
  float ca=0;
  float cb=1;
  float mandelScale=1;

float n=4;
boolean doHSB=true;
void keyPressed() {
  if (key=='h')doHSB=!doHSB;
  if(key=='1')mandelScale-=0.1;
  if(key=='2')mandelScale+=0.1;
  if(key=='3')n-=0.1;
  if(key=='4')n+=0.1;
}