import controlP5.*;
import java.util.*;
import processing.serial.*;
import hypermedia.net.*;
import processing.core.*;
import arb.soundcipher.*;
import java.net.*;
import java.awt.Color;
import java.util.Arrays;

ControlP5 controlP5;
EffectController effectController;
FieldController fieldController;
RecordController recordController;
PresetController presetController;
ModuleView moduleView;
FieldView fieldView;
SystemView systemView;
DataView dataView;
Logger logger;
Loader loader;
TimeView timeView;
Setups setups;

PApplet sketch = this;

DataController dataController;
Data mdata[];
SETTING setting;
boolean settingCompleted = false;

int mouseStartX, mouseStartY;
final int MOUSE_MODE = 1;

public void settings() {
  // size(1920, 1080);
  fullScreen();
}

void setup() {
  setting = new SETTING();
}


void draw() {
  background(0);
  
  switch (setting.mode) {
    case (0):
      setting.draw();
      break;
    case (1):
      try {
        controlP5.draw();
        effectController.onDraw();
        fieldController.onDraw();
        recordController.onDraw();
        presetController.onDraw();
        moduleView.draw();
        fieldView.draw();
        systemView.draw();
        dataView.draw();
        timeView.draw();
      } catch (Exception e) {}
      break;
  }
}


void mouseClicked() {
  if (MOUSE_MODE != 0)
    return;
if(!setting.isCompleted)
  return;

  effectController.press(mouseX, mouseY);
  recordController.press(mouseX, mouseY);
}


void mousePressed() {
  if(!setting.isCompleted)
  return;
  fieldController.onMousePressed();

  if (MOUSE_MODE != 1)
    return;

  mouseStartX = mouseX;
  mouseStartY = mouseY;

  effectController.mousePressed();
}


void mouseReleased() {
  if(!setting.isCompleted)
  return;
  fieldController.onMouseReleased();

  if (MOUSE_MODE != 1)
    return;

  effectController.press(mouseStartX, mouseStartY, mouseX, mouseY);
  recordController.press(mouseStartX, mouseStartY, mouseX, mouseY);
  presetController.press(mouseStartX, mouseStartY, mouseX, mouseY);

  effectController.mouseReleased();
}


void stop() {
  logger.stop();
}

void keyReleased() {
  if (key == ' ' && setting.mode == 0) {
    setting.isCompleted = true;
    setups = new Setups();
    timeView = new TimeView();
    setting.mode = 1;
  }
}