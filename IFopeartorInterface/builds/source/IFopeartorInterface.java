import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import java.util.*; 
import processing.serial.*; 
import hypermedia.net.*; 
import processing.core.*; 
import java.net.*; 
import java.awt.Color; 
import java.util.Arrays; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class IFopeartorInterface extends PApplet {











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

public void setup() {
  setting = new SETTING();
  dataController = new DATA(false);

  controlP5 = new ControlP5(this);
  controlP5.setAutoDraw(false);
  effectController = new EffectController();
  fieldController = new FieldController();
  moduleView = new ModuleView();
}


public void draw() {
  background(0);
  controlP5.draw();
  moduleView.draw();
  for(Window w : windows){
    w.display();
  }
}
class Effect {
  public BarMode barMode;
  public int size;
  public int[] position;
  public boolean[] fieldMode;
  public int[] colorRGB;
  public int[][] brightness;


  Effect() {
    barMode = BarMode.BOUNCE;
    size = 50;
    position = new int[2];
    position[0] = 0;
    position[1] = 100;
    fieldMode = new boolean[5];
    colorRGB = new int[3];
    brightness = new int[4][2];
  }


  public Effect copy() {
    Effect newEffect = new Effect();

    newEffect.barMode = barMode;
    newEffect.size = size;
    newEffect.position[0] = position[0];
    newEffect.position[1] = position[1];
    newEffect.fieldMode = fieldMode;
    newEffect.colorRGB = colorRGB;
    newEffect.brightness = brightness;

    return newEffect;
  }
}
public class EffectController {
  private Effect effect;
  private controlP5.RadioButton b;


  EffectController() {
    effect = new Effect();

    int x = PApplet.parseInt(windows[2].pos.x);
    int y = PApplet.parseInt(windows[2].pos.y);
    int h = PApplet.parseInt(windows[2].size.y);
    int pd = 10;
    int btSize = PApplet.parseInt(h / 3);
    b = controlP5.addRadioButton("barModeRadioButton")
      .setPosition(x, y)
      .setSize(btSize, btSize)
      .addItem("Bounce", BarMode.BOUNCE.ordinal())
      .addItem("Blink", BarMode.BLINK.ordinal())
      .addItem("Stretch", BarMode.STRETCH.ordinal())
      .activate(effect.barMode.ordinal())
      .plugTo(this);

    x = x + btSize + pd;
    controlP5.addSlider("sizeSlider")
      .setPosition(x, y)
      .setSize(btSize, h)
      .setRange(0, 100)
      .setValue(effect.size)
      .plugTo(this);

    x = x + btSize + pd;
    controlP5.addRange("positionRange")
      .setPosition(x, y)
      .setSize(btSize, h)
      .setRange(0, 100)
      .setRangeValues(effect.position[0], effect.position[1])
      .plugTo(this);

    x = x + btSize + pd;
    //TODO: behavior chart add

    x = PApplet.parseInt(windows[3].pos.x);
    y = PApplet.parseInt(windows[3].pos.y);
    int c = color(128, 0, 255);
    controlP5.addColorWheel("ledColor", x, y, h).setRGB(c);

    x = x + h + pd;
    y = y + btSize * 2;
    controlP5.addButton("applyC")
      .setValue(c)
      .setPosition(x, y)
      .setCaptionLabel("apply color")
      .setSize(btSize, btSize);

    String[] btMode = {
      "fieldModeLeftToggle",
      "fieldModeDownToggle",
      "fieldModeRightToggle",
      "fieldModeUpToggle"
    };
    String[] btTitle = {
      "left",
      "down",
      "right",
      "up"
    };

    for (int i = 0; i < btTitle.length; i++) {
      int baseX = PApplet.parseInt(windows[3].pos.x) + h + (pd + btSize) * 3;
      int baseY = PApplet.parseInt(windows[3].pos.y);
      x = (i < btTitle.length - 1) ? baseX + (btSize + pd) * i : baseX + (btSize + pd);
      y = (i < btTitle.length - 1) ? baseY + btSize + 1 : baseY;
      controlP5.addToggle(btMode[i])
        .setPosition(x, y)
        .setSize(btSize, btSize)
        .setCaptionLabel(btTitle[i])
        .plugTo(this, "fieldModeToggle");
    }
  }



  public void barModeRadioButton(int a) {
    if (a == -1)
      // Reactivate radio button if pressed same button
      b.activate(effect.barMode.ordinal());
    else
      // Update barMode
      effect.barMode = BarMode.values()[a];
  }


  public void sizeSlider(int a) {
    effect.size = a;
  }


  public void positionRange(ControlEvent theEvent) {
    effect.position[0] = (int) theEvent.getArrayValue()[0];
    effect.position[1] = (int) theEvent.getArrayValue()[1];
  }


  public void fieldModeToggle(ControlEvent theEvent) {
    int idx = -1;

    if (theEvent.isFrom("fieldModeUpToggle"))
      idx = FieldMode.UP.ordinal();
    else if (theEvent.isFrom("fieldModeDownToggle"))
      idx = FieldMode.DOWN.ordinal();
    else if (theEvent.isFrom("fieldModeLeftToggle"))
      idx = FieldMode.LEFT.ordinal();
    else if (theEvent.isFrom("fieldModeRightToggle"))
      idx = FieldMode.RIGHT.ordinal();

    if (idx != -1)
      effect.fieldMode[idx] = theEvent.getValue() != 0.0f;
  }


  public Effect getEffect() {
    return effect.copy();
  }
}
public class FieldController {
  FieldController() {
    int indx = 0;
    PVector[] fieldBtsPos = new PVector[6 * 6];
    fieldBtsPos = setFieldPostion();
    int btSize = (int) fieldBtsPos[36].x;

    for (int i = 0; i < 6; i++)
      for (int j = 0; j < 6; j++) {
        float x = fieldBtsPos[indx].x;
        float y = fieldBtsPos[indx].y;
        controlP5.addButton("" + (i * 6 + j))
          .setValue(i * 6 + j)
          .setPosition(x, y)
          .setSize(btSize, btSize)
          .setId(i * 6 + j)
          .plugTo(this, "fieldButton");
        indx++;
      }
  }

  public void fieldButton(int a) {
    Trigger trigger = new Trigger(effectController.getEffect(), a % 6, a / 6, frameCount);

    moduleView.addTrigger(trigger);
  }

   public PVector[] setFieldPostion() {
    PVector[] result = new PVector[6 * 6 + 1];
    int padding = 2;
    int spacing = 25;
    int margin = 5;
    int windowWidth = (int) windows[5].size.x - spacing * 2;
    int windowHeight = (int) windows[5].size.y - spacing * 2;
    int windowX = (int) windows[5].pos.x + spacing;
    int windowY = (int) windows[5].pos.y + spacing;
    int btSize = (windowWidth > windowHeight) ? (windowHeight - margin * 2 - padding * 5) / 6 : (windowWidth - margin * 2 - padding * 5) / 6;
    int indx = 0;
    for (int i = 0; i < 6; i++)
      for (int j = 0; j < 6; j++) {
        int x = windowX + (btSize + margin) * j;
        int y = windowY + (btSize + margin) * i;
        result[indx] = new PVector(x, y);
        indx++;
      }
    result[36] = new PVector(btSize, btSize);
    return result;
  }
}
class Module {
  private int x, y, btSize;
  private Trigger trigger;
  private int barH = opc.barLength;
  Integer indx;
  Boolean isJumped, isStanding;
  float[] pressures = new float[4];
  PVector barPos;
  PVector fieldBtsPos;

  Module(int indx, int x, int y, PVector fieldPos, int btSize) {
    this.indx = indx;
    this.x = x;
    this.y = y;
    this.btSize = btSize;
    fieldBtsPos = fieldPos;

    isJumped = false;
    isStanding = false;

    for (float prss: pressures) {
      prss = 0.0f;
    }

    barPos = new PVector(0, 0);
  }

  public void draw() {

    drawLine(64, 0, barH); //TODO: remove this

    if (trigger != null) {
      switch (trigger.effect.barMode) {
        case BOUNCE:
          bounce();
          break;
        case BLINK:
          blink();
          break;
        case STRETCH:
          stretch();
          break;
      }

      if (frameCount - trigger.startTime >= 30)
        trigger = null;
    }
  }


  private void bounce() {
    float phase = (frameCount - trigger.startTime) / 30.0f;
    float ratio = 1 - (phase - 0.5f) * (phase - 0.5f) * 4;

    int start = round(80 * ratio);
    int end = start + 20;

    drawLine(255, start, end);
  }


  private void blink() {
    int start = 0;
    int end = barH;

    drawLine(255, start, end);
  }


  private void stretch() {
    float phase = (frameCount - trigger.startTime) / 30.0f;

    int start = 0;
    int end = round(barH * phase);

    drawLine(255, start, end);
  }


  private void drawLine(int strokeColor, int start, int end) {
    stroke(strokeColor);
    // line((50+x*130+y*20)/SCALE, (150-end)/SCALE, (50+x*130+y*20)/SCALE, (150-start)/SCALE);
    line(x, y - end, x, y + start);
  }


  public void updateTrigger(Trigger trigger) {
    this.trigger = trigger;
  }

  public void drawBar() {
    float x = map(barPos.x, 0, 1, 0, btSize / 2);
    float y = map(barPos.y, 0, 1, 0, btSize / 2);
    pushMatrix();
    translate(fieldBtsPos.x + btSize / 2, fieldBtsPos.y + btSize / 2);
    stroke(100);
    line(0, 0, x, y);
    popMatrix();
  }
}
class ModuleView {
  private List < Trigger > triggers;
  private Module modules[][];
  private static final int ROWS = 6;
  private static final int COLUMNS = 6;
  private static final int DELAY = 5;

  private List < Rider > riders;
  ModuleView() {
    triggers = new ArrayList < Trigger > ();
    modules = new Module[6][6];
    riders = new ArrayList < Rider > ();

    int indx = 0;
    PVector[] fieldBtsPos = new PVector[ROWS * COLUMNS];
    fieldBtsPos = fieldController.setFieldPostion();
    for (int i = 0; i < ROWS; i++)
      for (int j = 0; j < COLUMNS; j++) {
        int x = (int) opc.ledStripPos[indx].x;
        int y = (int) opc.ledStripPos[indx].y;
        PVector loc = fieldBtsPos[indx];
        int btSize = (int) fieldBtsPos[36].x;
        modules[i][j] = new Module(indx, x, y, loc, btSize);
        indx++;
      }
  }



  public void draw() {
    for (int i = 0; i < ROWS; i++) {
      for (int j = 0; j < COLUMNS; j++) {
        modules[i][j].draw();
        modules[i][j].drawBar();
      }
    }
    for (Rider r: riders) {
      r.draw();
    }

    // Remove old trigger in triggers
    Iterator < Trigger > triggersIterator = triggers.iterator();
    while (triggersIterator.hasNext()) {
      Trigger t = triggersIterator.next();

      int phase = frameCount - t.startTime;

      if ((phase > DELAY * ROWS) &&
        (phase > DELAY * COLUMNS))
        triggersIterator.remove();

      if (phase == 1)
        modules[t.y][t.x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));

      if (t.effect.fieldMode[FieldMode.UP.ordinal()] && (phase % DELAY == 1)) {
        int y = t.y - (frameCount - t.startTime) / DELAY;
        if (y >= 0)
          modules[y][t.x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));
      }

      if (t.effect.fieldMode[FieldMode.DOWN.ordinal()] && (phase % DELAY == 1)) {
        int y = t.y + (frameCount - t.startTime) / DELAY;
        if (y < 6)
          modules[y][t.x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));
      }

      if (t.effect.fieldMode[FieldMode.LEFT.ordinal()] && (phase % DELAY == 1)) {
        int x = t.x - (frameCount - t.startTime) / DELAY;
        if (x >= 0)
          modules[t.y][x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));
      }

      if (t.effect.fieldMode[FieldMode.RIGHT.ordinal()] && (phase % DELAY == 1)) {
        int x = t.x + (frameCount - t.startTime) / DELAY;
        if (x < 6)
          modules[t.y][x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));
      }
    }
  }


  public void addTrigger(Trigger trigger) {
    triggers.add(trigger);
  }
}
class Trigger {
  public final Effect effect;
  public final int x, y;
  public final int startTime;


  Trigger(Effect effect, int x, int y, int startTime) {
    this.effect = effect;
    this.x = x;
    this.y = y;
    this.startTime = startTime;
  }
}
UDP udp_sending, udp_receiving;
OPC opc;
int NUM_STRIPS = 36;

class DATA {
    Boolean runWithConnection;

    DATA(boolean a) {
        runWithConnection = a;
        setUDP();
        setOPC();
    }
    public void setUDP() {
        int receivingPort = 40000;
        int sendingPort = 40001;
        udp_receiving = new UDP(sketch, receivingPort);
        udp_sending = new UDP(sketch);
        udp_receiving.listen(runWithConnection);
    }

    public void setOPC() {
        int opcPort = 7890; //7890 default
        int NUM_LED = 64;
        int spacing = 20;
        int margin = 5;
        int windowWidth = width / 2 - spacing * 2 - margin * 2;
        int windowX = (width / 2 - windowWidth) / 2;
        int windowY = 200;
        // PVector ledInit_pos = new PVector(windowX, windowY); //50,250 previously
        int padding = 3;
        int stripSpacing = (windowWidth - margin * 2) / 49;
        opc = new OPC(sketch, "192.168.7.2", opcPort, runWithConnection);
        opc.ledGrid(0, NUM_LED, 49, windowX, windowY, windowWidth, padding, stripSpacing, HALF_PI, true);
        opc.reIndx();

    }
}


public void receive(byte[] data) {
    int NUM_MODULE_TOKENS = 10;
    //1.num People, 2.Node id, 3.X angle, 4.Y angle, 5.Force 1, 6.Force 2, 7.Force 3, 8.Force 4, 9.Jumpped, 10.standing
    String received = new String(data);

    String[] tokens = split(received, ',');
    // printArray(tokens);


    int size = PApplet.parseInt(tokens[0]) * 2 + NUM_MODULE_TOKENS;

    if (tokens.length == size && dataController.runWithConnection) {
        float[] a = new float[size];
        for (int i = 0; i < a.length; i++) {
            a[i] = PApplet.parseFloat(tokens[i]);
        }

        //================================module================================
        int numPerson = (int) a[0];
        int indx = (int) a[1];
        PVector barPos = new PVector(a[2], a[3]);
        float[] pressures = new float[4];
        for (int i = 0; i < pressures.length; i++) {
            pressures[i] = a[i + 4];
        }
        boolean isJumped = (a[8] == 1) ? true : false;
        boolean isStanding = (a[9] == 1) ? true : false;

        for (int i = 0; i < moduleView.modules.length; i++) {
            for (int j = 0; j < moduleView.modules[0].length; j++) {
                if (indx == moduleView.modules[i][j].indx) {
                    moduleView.modules[i][j].barPos = barPos;
                    moduleView.modules[i][j].pressures = pressures;
                    moduleView.modules[i][j].isJumped = isJumped;
                    moduleView.modules[i][j].isStanding = isStanding;
                }
            }
        }


        //================================global================================
        if (numPerson != 0) {
            PVector[] pos = new PVector[numPerson];
            for (int i = 0; i < numPerson; i++) {
                pos[i] = new PVector(a[NUM_MODULE_TOKENS + i], a[NUM_MODULE_TOKENS + 1 + i]);
                moduleView.riders.add(new Rider(pos[i]));
            }
        }
    }
}


public class OPC {
    Socket socket;
    OutputStream output;
    String host;
    int port;
    Boolean connection;

    int[] pixelLocations;
    byte[] packetData;
    byte firmwareConfig;
    String colorCorrection;
    boolean enableShowLocations;

    int sendDataOneTime = 0;
    PVector[] ledStripPos = new PVector[49];
    PVector window;
    Integer barLength;
    float ENDPOINT = 88;
    float windowWidth;

    OPC(PApplet parent, String host, int port, boolean runWithConnection) {
        if (runWithConnection) {
            this.host = host;
            this.port = port;

        }
        this.enableShowLocations = true;
        parent.registerMethod("draw", this);
        connection = runWithConnection;
    }

    public void reIndx() {
        int[] indx_mapper = new int[NUM_STRIPS];

        indx_mapper[0] = 38;
        indx_mapper[1] = 37;
        indx_mapper[2] = 19;
        indx_mapper[3] = 18;
        indx_mapper[4] = 3;
        indx_mapper[5] = 2;
        indx_mapper[6] = 32;
        indx_mapper[7] = 35;
        indx_mapper[8] = 16;
        indx_mapper[9] = 17;
        indx_mapper[10] = 0;
        indx_mapper[11] = 1;
        indx_mapper[12] = 31;
        indx_mapper[13] = 30;
        indx_mapper[14] = 22;
        indx_mapper[15] = 23;
        indx_mapper[16] = 46;
        indx_mapper[17] = 44;
        indx_mapper[18] = 28;
        indx_mapper[19] = 29;
        indx_mapper[20] = 20;
        indx_mapper[21] = 21;
        indx_mapper[22] = 40;
        indx_mapper[23] = 42;
        indx_mapper[24] = 27;
        indx_mapper[25] = 26;
        indx_mapper[26] = 11;
        indx_mapper[27] = 10;
        indx_mapper[28] = 7;
        indx_mapper[29] = 6;
        indx_mapper[30] = 24;
        indx_mapper[31] = 25;
        indx_mapper[32] = 8;
        indx_mapper[33] = 9;
        indx_mapper[34] = 4;
        indx_mapper[35] = 5;

        PVector[] _temp = new PVector[NUM_STRIPS];
        for (int i = 0; i < NUM_STRIPS; i++) {
            _temp[i] = ledStripPos[indx_mapper[i]];
        }
        for (int i = 0; i < NUM_STRIPS; i++) {
            ledStripPos[i] = _temp[i];
        }
        barLength = PApplet.parseInt(ledStripPos[0].y - ENDPOINT);
    }
    // Set the location of a single LED
    public void led(int index, int x, int y) {
        // For convenience, automatically grow the pixelLocations array. We do want this to be an array,
        // instead of a HashMap, to keep draw() as fast as it can be.
        if (pixelLocations == null) {
            pixelLocations = new int[index + 1];
        } else if (index >= pixelLocations.length) {
            pixelLocations = Arrays.copyOf(pixelLocations, index + 1);
        }
        pixelLocations[index] = x + width * y;
    }

    // Set the location of several LEDs arranged in a strip.
    // Angle is in radians, measured clockwise from +X.
    // (x,y) is the center of the strip.
    public void ledStrip(int index, int count, float x, float y, float spacing, float angle, boolean reversed) {
        float s = sin(angle);
        float c = cos(angle);
        for (int i = 0; i < count; i++) {
            led(reversed ? (index + count - 1 - i) : (index + i),
                (int)(x + (i - (count - 1) / 1.0f) * spacing * c + 0.5f),
                (int)(y + (i - (count - 1) / 1.0f) * spacing * s + 0.5f));
        }

    }

    // Set the location of several LEDs arranged in a grid. The first strip is
    // at 'angle', measured in radians clockwise from +X.
    // (x,y) is the center of the grid.
    public void ledGrid(int index, int stripLength, int numStrips, float x, float y, float winW,
        float ledSpacing, float stripSpacing, float angle, boolean zigzag) {
        float s = sin(angle + HALF_PI);
        float c = cos(angle + HALF_PI);
        // float h = 130; //if project max reachable length
        for (int i = 0; i < numStrips; i++) {
            ledStrip(index + stripLength * i, stripLength,
                x + (i - (numStrips - 1) / 1.0f) * stripSpacing * c,
                y + (i - (numStrips - 1) / 1.0f) * stripSpacing * s, ledSpacing,
                angle, zigzag);

            ledStripPos[i] = new PVector(x + (i - (numStrips - 1) / 1.0f) * stripSpacing * c, y + (i - (numStrips - 1) / 1.0f) * stripSpacing * s);
        }
        window = new PVector(x, y);
        windowWidth = winW;
    }

    // Set the location of 64 LEDs arranged in a uniform 8x8 grid.
    // (x,y) is the center of the grid.
    // void ledGrid8x8(int index, float x, float y, float spacing, float angle, boolean zigzag)
    // {
    //         ledGrid(index, 8, 8, x, y, spacing, spacing, angle, zigzag);
    // }
    //
    // void ledGrid16x16(int index, float x, float y, float spacing, float angle, boolean zigzag)
    // {
    //         ledGrid(index, 16, 16, x, y, spacing, spacing, angle, zigzag);
    // }

    // Should the pixel sampling locations be visible? This helps with debugging.
    // Showing locations is enabled by default. You might need to disable it if our drawing
    // is interfering with your processing sketch, or if you'd simply like the screen to be
    // less cluttered.
    public void showLocations(boolean enabled) {
        enableShowLocations = enabled;
    }

    // Automatically called at the end of each draw().
    // This handles the automatic Pixel to LED mapping.
    // If you aren't using that mapping, this function has no effect.
    // In that case, you can call setPixelCount(), setPixel(), and writePixels()
    // separately.
    // void setPixel(int numofPixelsUpdated){
    //   numStrips = numofPixelsUpdated;
    // }
    public void setup() {


    }
    public void draw() {
        if (dataController.runWithConnection) {
            if (pixelLocations == null) {
                // No pixels defined yet
                return;
            }

            if (output == null) {
                // Try to (re)connect
                connect();
            }
            if (output == null) {
                return;
            }

            int numPixels = pixelLocations.length;
            int ledAddress = 4;

            setPixelCount(numPixels);
            loadPixels();

            for (int i = 0; i < numPixels; i++) {
                int pixelLocation = pixelLocations[i];
                int pixel = pixels[pixelLocation];

                packetData[ledAddress] = (byte)(pixel >> 16);
                packetData[ledAddress + 1] = (byte)(pixel >> 8);
                packetData[ledAddress + 2] = (byte) pixel;
                ledAddress += 3;

                if (enableShowLocations) {
                    pixels[pixelLocation] = 0xFFFFFF ^ pixel;
                }
            }
            println("2");
            writePixels();


            sendDataOneTime++;

            if (sendDataOneTime > 400)
                sendDataOneTime = 0;

            if (enableShowLocations) {
                updatePixels();
            }
        }
        gui();
    }

    public void gui() {
        pushStyle();

        //================================strip indx===============================
        int indxFontSize = 8;
        textFont(tinyFont);
        textAlign(CENTER, CENTER);
        int pd = 8;
        int sp = 6;
        fill(120);
        // textSize(indxFontSize);
        for (int i = 0; i < NUM_STRIPS; i++) {
            float x = ledStripPos[i].x;
            float y = ledStripPos[i].y + sp;
            text(i, x, y);
        }
        //============================window indicator============================
        rectMode(CORNERS);
        float x1 = window.x + pd;
        float x2 = window.x + windowWidth - pd;
        float y1 = window.y + pd;
        float y2 = ENDPOINT - pd; // 88 
        noStroke();
        fill(0);
        rect(x1, 0, x2, y2 + pd);
        stroke(255);
        noFill();
        rect(x1, y1 + indxFontSize, x2, y2);
        // //=================================text//=================================
        // textFont(titleFont);
        // textAlign(CENTER, CENTER);
        // fill(255);
        // String title = "WINDOW1";
        // float mid = width / 4;

        // text(title, mid, y2 - 10);

        popStyle();
    }

    // Change the number of pixels in our output packet.
    // This is normally not needed; the output packet is automatically sized
    // by draw() and by setPixel().
    public void setPixelCount(int numPixels) {
        int numBytes = 3 * numPixels;
        int packetLen = 4 + numBytes;
        if (packetData == null || packetData.length != packetLen) {
            // Set up our packet buffer
            packetData = new byte[packetLen];
            packetData[0] = 0; // Channel
            packetData[1] = 0; // Command (Set pixel colors)
            packetData[2] = (byte)(numBytes >> 8);
            packetData[3] = (byte)(numBytes & 0xFF);
        }
    }

    // Directly manipulate a pixel in the output buffer. This isn't needed
    // for pixels that are mapped to the screen.
    public void setPixel(int number, int c) {
        int offset = 4 + number * 3;
        if (packetData == null || packetData.length < offset + 3) {
            setPixelCount(number + 1);
        }

        packetData[offset] = (byte)(c >> 16);
        packetData[offset + 1] = (byte)(c >> 8);
        packetData[offset + 2] = (byte) c;
    }

    // Read a pixel from the output buffer. If the pixel was mapped to the display,
    // this returns the value we captured on the previous frame.
    public int getPixel(int number) {
        int offset = 4 + number * 3;
        if (packetData == null || packetData.length < offset + 3) {
            return 0;
        }
        return (packetData[offset] << 16) | (packetData[offset + 1] << 8) | packetData[offset + 2];
    }

    // Transmit our current buffer of pixel values to the OPC server. This is handled
    // automatically in draw() if any pixels are mapped to the screen, but if you haven't
    // mapped any pixels to the screen you'll want to call this directly.
    public void writePixels() {
        if (packetData == null || packetData.length == 0) {
            // No pixel buffer
            return;
        }
        if (output == null) {
            // Try to (re)connect
            connect();
        }
        if (output == null) {
            return;
        }

        try {
            output.write(packetData);
        } catch (Exception e) {
            dispose();
        }
    }

    public void dispose() {
        // Destroy the socket. Called internally when we've disconnected.
        if (output != null) {
            connection = false;
            println("Disconnected from OPC server");
        }
        socket = null;
        output = null;
    }

    public void connect() {
        // Try to connect to the OPC server. This normally happens automatically in draw()
        try {
            socket = new Socket(host, port);
            socket.setTcpNoDelay(true);
            output = socket.getOutputStream();
            connection = true;
            println("Connected to OPC server");
        } catch (ConnectException e) {
            dispose();
        } catch (IOException e) {
            dispose();
        }
    }
}
enum BarMode {
  BOUNCE, BLINK, STRETCH
}


enum FieldMode {
  UP, DOWN, LEFT, RIGHT, ELLIPSE
}


enum Rgb {
  RED, GREEN, BLUE
}
class Rider {
    PVector pos;
    private int c;
    private int r;
    Rider(PVector pos) {
        this.pos = pos;
        c = color(random(255), random(255), random(255), 100);
        r = 20;
    }
    public void draw() {
        pushStyle();
        fill(c);
        ellipse(pos.x, pos.y, r, r);
        popStyle();
    }
}
 PFont titleFont, tinyFont;
 Window[] windows = new Window[6];
 class SETTING {

     SETTING() {
         titleFont = createFont("stan0758.ttf", 8);
         tinyFont = createFont("stan0758.ttf", 8);
         setWindow();
     }
     public void setWindow() {
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
             y = (i) % 4 * ((height - spacing ) / 4) + spacing;
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
 }

 class Window {
     PVector pos;
     PVector size;
     Integer spacing, padding, margin;
     String title;
     Window(float x, float y, float w, float h, String title) {
         pos = new PVector(x, y);
         size = new PVector(w, h);
         this.title = title;
         margin = 5;
     }
     public void display() {
         pushStyle();
         noFill();
         stroke(20);
         rect(pos.x, pos.y, size.x, size.y);
         textFont(tinyFont);
         text(title, pos.x, pos.y + 10);
         popStyle();
     }
 }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "IFopeartorInterface" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
