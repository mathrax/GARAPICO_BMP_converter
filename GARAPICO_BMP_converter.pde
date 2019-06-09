//PATTERN EDITOR
//2016.12.10
//by MATHRAX LLC.

import drop.*;
SDrop drop;

int maxAnim=100;
PImage[] img = new PImage[maxAnim];
File[] fn = new File[maxAnim];


PrintWriter output;
PGraphics canvas;

String imgname="";

int imgCount;
int imgCountMax;
int preCount;
int loadDone;
int playSpeed;
int loopStatus;
int playMode;
int first;


void setup() {
  size(200, 380);
  noSmooth();

  drop = new SDrop(this);
  guiSetup();
  for (int i=0; i<maxAnim; i++) {
    img[i] = loadImage("dummy.png");
  }

  canvas = createGraphics(16, 16);

  first = 1;
}

void draw() {
  background(30, 30, 50);

  stroke(255, 100);
  fill(0);
  rect(18, 18, 162, 162);

  if (loadDone==1) {
    loadImage_DragDrop();
  }
}


void loadImage_DragDrop() {

  preCount++;
  if (preCount>=playSpeed) {
    preCount=0;
    if (playMode>0)imgCount++;
    if (imgCount>(imgCountMax-1)) {
      if (loopStatus>0) {
        imgCount=0;
      } else {
        imgCount=(imgCountMax-1);
        playMode=0;
      }
    }
  }

  image(img[imgCount], 20, 20, 160, 160);

  //fill(255, 100);
  //textSize(10);
  //textAlign(LEFT);
  //text(imgname, 20, 190);

  fill(255, 100);
  textSize(10);
  textAlign(LEFT);
  text(imgCount, 20, 190);

  fill(255, 100);
  textSize(10);
  textAlign(LEFT);
  text((imgCountMax-1), 20, 220);
}



//DRAG & DROP
String[] extensions = {
  ".bmp", ".gif", ".png", 
  ".BMP", ".GIF", ".PNG"
};

void dropEvent(DropEvent theDropEvent) {

  loadDone=0;

  if (theDropEvent.isFile()) {

    File myFile = theDropEvent.file();
    File[] files = myFile.listFiles();

    if (myFile.isDirectory()) {
      for (int i=0; i<maxAnim; i++) {
        img[i] = loadImage("dummy.png");
      }
      imgname = myFile.getName();

      int fileCount = myFile.listFiles().length;
      imgCountMax=0;
      preCount=0;
      imgCount=0;

      //files=sort(files);

      String[] path = {};
      for (int i=0; i<fileCount; i++) {
        for (String extension : extensions) {
          if (files[i].getPath().endsWith(extension)) {
            path = append(path, files[i].getAbsolutePath());
            path = sort(path);
            preCount++;
          }
        }
      }
      
      for(int i=0; i<preCount; i++){
            img[imgCountMax]  = loadImage(path[i]);
            imgCountMax++;
      }
    }
  }

  loadDone=1;
}
