 PFont titleFont, tinyFont;
 Window[] windows = new Window[6];

 class SETTING {
     private boolean isCompleted = false;
     SETTING() {
         setFont();
         setWindow();
     }
     void setFont() {
         titleFont = createFont("stan0758.ttf", 8);
         tinyFont = createFont("stan0758.ttf", 8);
     }
     void setWindow() {
         PVector[] pos = new PVector[windows.length];
         String[] title = {
             "WINDOW1",
             "WINDOW2",
             "WINDOW3",
             "WINDOW4",
             "WINDOW5",
             "WINDOW6"
         };
         int spacing = 15;
         int x = 0;
         int y = 0;
         for (int i = 0; i < windows.length; i++) {
             x = (i < 4) ? spacing : width / 2 + spacing;
             y = (i) % 4 * ((height - spacing) / 4) + spacing;
             pos[i] = new PVector(x, y);
         }
         for (int i = 0; i < windows.length; i++) {
             float winX = pos[i].x;
             float winY = pos[i].y;
             float winWidth = width / 2 - spacing * 2;
             float winHeight = (i < 5) ? pos[1].y - pos[0].y - spacing : height - pos[1].y - pos[0].y - 1;
             windows[i] = new Window(winX, winY, winWidth, winHeight, title[i]);
         }
     }
     void draw() {
         String welcome = "welcome, operator";
         int h = 12;
         textSize(h);
         text(welcome.toUpperCase(), width / 2 - textWidth(welcome) / 2, height / 2 - h / 2);
     }
 }

 class Window {
     PVector pos;
     PVector size;
     Integer spacing, padding;
     String title;

     Window(float x, float y, float w, float h, String title) {
         pos = new PVector(x, y);
         size = new PVector(w, h);
         this.title = title;
         //  margin = 5;
     }
     void display() {
         pushStyle();
         noFill();
         stroke(20);
         rect(pos.x, pos.y, size.x, size.y);
         textAlign(CENTER, CENTER);
         textFont(tinyFont);
         fill(100);
         float x = pos.x + size.x / 2;
         float y = pos.y + size.y + 5;
         text(title, x, y);
         popStyle();
     }
 }

 class Setups {
     Setups() {
         dataController = new DataController(false);
         systemView = new SystemView();
         controlP5 = new ControlP5(sketch);
         controlP5.setAutoDraw(false);
         effectController = new EffectController();
         fieldController = new FieldController();
         presetController = new PresetController();
         moduleView = new ModuleView();
         fieldView = new FieldView();
         dataView = new DataView();

         settingCompleted = true;
     }

 }