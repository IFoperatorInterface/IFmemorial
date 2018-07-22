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
  moduleView = new ModuleView();



  dddd = controlP5.addSlider2D("test")
        // .setLabelVisible(false)
        .setPosition(width/2, height/2)
        .setSize(100, 100)
        .setMinMax(100, 100, 0, 0)
        .setValue(50, 50)
        // .disableCrosshair()
        ;
}


void draw() {
  background(0);
  controlP5.draw();
  moduleView.draw();
  for(Window w : windows){
    w.display();
  }

  dddd.setCursorX(-20);
  dddd.setCursorY(-20);
}