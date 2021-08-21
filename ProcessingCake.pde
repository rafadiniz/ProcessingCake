
//cake globals
PShape p1;
int stopFaceIndex;
int maxFaceIndex;
float countV;
float countF;

//text globals
String p = "Processing ";
String hb = "Happy Birthday! ";

PFont font;
PShape[] ct1 = new PShape[p.length()];
PShape[] ct2 = new PShape[hb.length()];

float amp = 1000;
float amp2 = 1000;
PGraphics pg;
float t;

void setup() {
  size(1024, 1024, P3D);

  pg = createGraphics(width, height, P3D);

  //load cake shape
  p1 = pg.loadShape("10868_birthday-cake_v3.obj");

  font = createFont("Barlow Bold", 90);
  textFont(font);

  //processing text points
  for (int i = 0; i < p.length(); i ++) {
    ct1[i] = font.getShape(p.charAt(i));
  }

  //happy birthday points
  for (int i = 0; i < hb.length(); i ++) {
    ct2[i] = font.getShape(hb.charAt(i));
  }

  maxFaceIndex = p1.getChildCount();
  stopFaceIndex = maxFaceIndex;

  pg.smooth(8);

  delay(1000);
}

void draw() {
  t += 0.01;

  pg.beginDraw();

  pg.background(240);

  pg.directionalLight(250, 250, 250, -1, -1, -1);
  pg.directionalLight(200, 250, 200, -1, 1, -1);


  //shape expanding 
  countV += 20;
  if (countV > maxFaceIndex) {
    countV = maxFaceIndex;
    countF += 30;
    if (countF > maxFaceIndex) {
      countF = maxFaceIndex;
    }
  }

  pg.strokeWeight(0.4);

  pg.push();
  pg.translate(width/2, height/2+150, 350);

  if (frameCount > 10*60) {
    drawHB();
    amp -= 2;
    if (amp <= 0.2) {
      amp = 0.2;
    }
  }
  if (frameCount > 15*60) {
    drawProcessing();
    amp2 -= 2;
    if (amp2 <= 0.2) {
      amp2 = 0.2;
    }
  }

  pg.rotateX(radians(90));
  pg.rotateZ(radians(frameCount));

  pg.scale(1);

  //drawing cake
  drawV();
  drawF();

  pg.pop();

  pg.endDraw();

  //showing pg
  image(pg, 0, 0);
  
  saveFrame("frames/f#####.png");
}

//Processing vertex
void drawProcessing() {
  for (int c = 0; c < p.length(); c++) {  
    pg.push();
    pg.scale(0.8);
    pg.translate(c*60, 0);
    pg.beginShape(QUAD_STRIP);
    pg.stroke(40);
    for (int i = 0; i < ct1[c].getVertexCount(); i++) {
      pg.fill(
        127+tan(ct1[c].getVertexY(i)*0.1+t)*127, 
        127+tan(ct1[c].getVertexY(i)*0.2+t)*127, 
        127+tan(ct1[c].getVertexY(i)*0.31+t)*127
        );

      float x = tan(ct1[c].getVertexX(i)*0.2+t)*amp2;
      float y = tan(ct1[c].getVertexY(i)*0.007+t)*amp2;


      pg.vertex(ct1[c].getVertexX(i)-310+x, ct1[c].getVertexY(i)-300+y, -10);
      pg.vertex(ct1[c].getVertexX(i)-310+x, ct1[c].getVertexY(i)-300+y);
    }
    pg.endShape();

    pg.beginShape();
    pg.stroke(40);
    for (int i = 0; i < ct1[c].getVertexCount(); i++) {
      pg.fill(0, 0, 
        127+tan(ct1[c].getVertexY(i)*0.1+t)*127
        );

      float x = tan(ct1[c].getVertexX(i)*0.2+t)*amp2;
      float y = tan(ct1[c].getVertexY(i)*0.007+t)*amp2;

      pg.vertex(ct1[c].getVertexX(i)-310+x, ct1[c].getVertexY(i)-300+y);
    }

    pg.endShape();
    pg.pop();
  }
}

//happy birthday vertex
void drawHB() {
  for (int c = 0; c < hb.length(); c++) {  
    pg.push();
    pg.translate(c*50, 0);
    pg.scale(0.6);
    pg.beginShape(QUAD_STRIP);
    pg.stroke(40);
    for (int i = 0; i < ct2[c].getVertexCount(); i++) {
      pg.fill(
        127+tan(ct2[c].getVertexY(i)*0.1+t)*127, 
        127+tan(ct2[c].getVertexY(i)*0.2+t)*127, 
        127+tan(ct2[c].getVertexY(i)*0.31+t)*127
        );

      float x = tan(ct2[c].getVertexX(i)*0.2+t)*amp;
      float y = tan(ct2[c].getVertexY(i)*0.007+t)*amp;

      if (c >= 0 && c < 5) {
        pg.vertex(ct2[c].getVertexX(i)-200+x, ct2[c].getVertexY(i)-620+y);
      }
      if (c >= 5 && c < 15) {
        pg.vertex(ct2[c].getVertexX(i)-820+x, ct2[c].getVertexY(i)-540+y);
      }
    }
    pg.endShape();

    pg.beginShape();
    pg.stroke(40);
    for (int i = 0; i < ct2[c].getVertexCount(); i++) {
      pg.fill(
        127+tan(ct2[c].getVertexY(i)*0.1+t)*127,
        127+tan(ct2[c].getVertexY(i)*0.11+t)*127,
        127+tan(ct2[c].getVertexY(i)*0.12+t)*127
        );

      float x = tan(ct2[c].getVertexX(i)*0.2+t)*amp;
      float y = tan(ct2[c].getVertexY(i)*0.007+t)*amp;

      if (c >= 0 && c < 5) {
        pg.vertex(ct2[c].getVertexX(i)-200+x, ct2[c].getVertexY(i)-620+y);
      }
      if (c >= 5 && c < 15) {
        pg.vertex(ct2[c].getVertexX(i)-820+x, ct2[c].getVertexY(i)-540+y);
      }
    }

    pg.endShape();
    pg.pop();
  }
}

//cake wires
void drawV() {
  pg.beginShape(QUADS);
  for (int i = 0; i < countV; i+=2) {
    PShape face = p1.getChild(i);
    int numVertices = face.getVertexCount();
    for (int j = 0; j < numVertices; j++) {
      pg.noFill();
      pg.stroke(0);

      float x = tan(face.getVertexX(j)*0.001+t)*200;
      float y = tan(face.getVertexY(j)*0.007+t)*200;
      float z = tan(face.getVertexZ(j)*0.001+t)*200;

      pg.vertex(
        face.getVertexX(j)*20, 
        face.getVertexY(j)*20, 
        face.getVertexZ(j)*20
        );
    }
  }
  pg.endShape();
}

//cake faces
void drawF() {
  pg.beginShape(QUADS);
  for (int i = 0; i < countF; i++) {
    PShape face = p1.getChild(i);
    int numVertices = face.getVertexCount();

    for (int j = 0; j < numVertices; j++) {

      pg.fill(
        127+tan(face.getVertexY(j)*1.1+t)*127, 
        127+tan(face.getVertexZ(j)*1.2+t)*127, 
        127+tan(face.getVertexY(j)*1.31+t)*127
        );
      pg.strokeWeight(0.6);  
      pg.vertex(
        face.getVertexX(j)*20, 
        face.getVertexY(j)*20, 
        face.getVertexZ(j)*20
        );
    }
  }
  pg.endShape();
}
