import controlP5.*;
import java.util.*;

import processing.serial.*;
import hypermedia.net.*;
import processing.core.*;
import java.net.*;
import java.awt.Color;
import java.util.Arrays;

ControlP5 controlP5;
EffectController effectController;
FieldController fieldController;
RecordController recordController;
ModuleView moduleView;
final int SCALE = 1;

PApplet sketch = this;

DATA dataController;
SETTING setting;

public void settings() {
  // size(1920, 1080);
  fullScreen();
}

void setup() {
  setting = new SETTING();
  dataController = new DATA(false);

  controlP5 = new ControlP5(this);
  controlP5.setAutoDraw(false);
  effectController = new EffectController();
  fieldController = new FieldController();
  recordController = new RecordController();
  moduleView = new ModuleView();
}


void draw() {
  background(0);
  controlP5.draw();
  recordController.onDraw();
  moduleView.draw();
  for(Window w : windows){
    w.display();
  }
   
}