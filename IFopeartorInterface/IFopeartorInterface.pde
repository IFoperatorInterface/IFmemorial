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
PresetController presetController;
ModuleView moduleView;
FieldView fieldView;
SystemView systemView;
DataView dataView;

PApplet sketch = this;

DataController dataController;
Data mdata[];
SETTING setting;

public void settings() {
  // size(1920, 1080);
  fullScreen();
}

void setup() {
  setting = new SETTING();
  dataController = new DataController(false);
  systemView = new SystemView();
  controlP5 = new ControlP5(this);
  controlP5.setAutoDraw(false);
  effectController = new EffectController();
  fieldController = new FieldController();
  recordController = new RecordController();
  presetController = new PresetController();
  moduleView = new ModuleView();
  fieldView = new FieldView();
  dataView = new DataView();
  

}


void draw() {
  background(0);
  controlP5.draw();
  effectController.onDraw();
  fieldController.onDraw();
  recordController.onDraw();
  moduleView.draw();
  fieldView.draw();
  systemView.draw();
  dataView.draw();
}