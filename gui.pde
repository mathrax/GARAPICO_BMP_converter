import controlP5.*;

ControlP5 cp5;
RadioButton radio;
RadioButton loopBtn;

void guiSetup() {
  PFont font = createFont("arial", 14);
  textFont(font);

  cp5 = new ControlP5(this);

  cp5.addButton("ANIMATION")
    .setValue(0)
    .setPosition(20, 320)
    .setFont(createFont("arial", 10))
    .setSize(160, 20)
    ;
  cp5.addButton("export")
    .setValue(0)
    .setPosition(20, 350)
    .setFont(createFont("arial", 10))
    .setSize(160, 20)
    ;
  radio = cp5.addRadioButton("radioButton")
    .setPosition(20, 240)
    .setSize(20, 20)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setItemsPerRow(4)
    .setSpacingColumn(20)
    .addItem("1", 1)
    .addItem("2", 2)
    .addItem("3", 3)
    .addItem("4", 4)
    .activate(0)
    ;
  playSpeed=3;

  loopBtn = cp5.addRadioButton("loopButton")
    .setPosition(20, 270)
    .setSize(20, 20)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setItemsPerRow(1)
    .setSpacingColumn(20)
    .addItem("loop", 1)
    .activate(0)
    ;
  loopStatus=1;
}

public void loopButton(int theValue) {
  loopStatus =  theValue;
}

int lastRadioButton;

public void radioButton(int theValue) {
  if (theValue<0) {
    radio.activate(lastRadioButton-1);
  } else {
    playSpeed = theValue*3;
    //println(theValue);
    lastRadioButton=theValue;
  }
}

public void ANIMATION(int theValue) {
  if (playMode ==0) {
    playMode=1;  
    if (imgCount==(imgCountMax-1))imgCount=0;
  } else {
    playMode=0;
  }
  //println(theValue);
}

public void export(int theValue) {
  if (first==0)return;
  if (loadDone==0) {
    println("Please load images.");
    return;
  }
  output = createWriter("picdata.txt");
  
  print("Convert");

  int col, red, grn, blu;
  color[][] cBuff = new color[32][32];
  String myName = imgname;

  output.flush();

  output.println("const unsigned char frame_"+myName+"[] = {");
  output.print("\t");
  for (int i=0; i<imgCountMax; i++) {
    output.print(i+",");
    if (i>0 && i%15==0) {
      output.println("");
      output.print("\t");
    }
  }
  output.println("");
  output.println("};");
  output.println("");
  output.println("const unsigned char "+myName+"[][768] = {");
  for (int i=0; i<imgCountMax; i++) {

    print(".");

    canvas.beginDraw();
    canvas.image(img[i], 0, 0);
    for (int y=0; y<=16; y++) {
      for (int x=0; x<=16; x++) {
        cBuff[y][x]=canvas.get(x, y);
      }
    }
    canvas.endDraw();

    output.print("\t// ");
    output.println("image " + nf(i, 2));
    output.println("\t{");

    //16x16
    output.println("\t\t//RED");
    for (int num=0; num<16; num++) {
      output.print("\t\t");
      for (int index=num*16; index<num*16+16; index++) {
        output.print((cBuff[num][index-num*16] >> 16 &0xFF));
        output.print(",");
      }  
      output.println("");
    }

    output.println("\t\t//GRN");
    for (int num=0; num<16; num++) {
      output.print("\t\t");
      for (int index=num*16; index<num*16+16; index++) {
        output.print((cBuff[num][index-num*16] >> 8 &0xFF));
        output.print(",");
      }  
      output.println("");
    }

    output.println("\t\t//BLU");
    for (int num=0; num<16; num++) {
      output.print("\t\t");
      for (int index=num*16; index<num*16+16; index++) {
        output.print((cBuff[num][index-num*16] >> 0 &0xFF));
        output.print(",");
      }  
      output.println("");
    }

    output.println("\t},");
    output.println("");
  }

  //println("};");
  output.println("};");
  println("Done!");
  output.close();  // Finishes the file
  //output.flush();
}