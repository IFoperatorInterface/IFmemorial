UDP udp_sending, udp_receiving;
OPC opc;
int NUM_STRIPS = 36;
class Data {
    Boolean isJumped, isStanding;
    float[] pressures = new float[4];
    PVector barPos;
    int indx;

    Data(int indx) {
        this.indx = indx;
        isJumped = false;
        isStanding = false;
        for (float prss: pressures) {
            prss = 0.0;
        }
        barPos = new PVector(0, 0);

    }
    void update(float[] a) {
        barPos = new PVector(a[2] * -1, a[3] * -1);
        for (int i = 0; i < pressures.length; i++) {
            pressures[i] = a[i + 4];
        }
        isJumped = (a[8] == 1) ? true : false;
        isStanding = (a[9] == 1) ? true : false;
    }
}

class DataController {
    Boolean runWithConnection;

    DataController(boolean a) {
        runWithConnection = a;
        setUDP();
        setOPC();
        setModuleData();
    }

    void setModuleData() {
        mdata = new Data[NUM_STRIPS];
        for (int i = 0; i < mdata.length; i++) {
            mdata[i] = new Data(i);
        }
    }

    void setUDP() {
        int receivingPort = 40000;
        int sendingPort = 40001;
        udp_receiving = new UDP(sketch, receivingPort);
        udp_sending = new UDP(sketch);
        udp_receiving.listen(runWithConnection);
    }

    void setOPC() {
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


void receive(byte[] data) {
    int NUM_MODULE_TOKENS = 10;
    //1.num People, 2.Node id, 3.X angle, 4.Y angle, 5.Force 1, 6.Force 2, 7.Force 3, 8.Force 4, 9.Jumpped, 10.standing
    String received = new String(data);

    String[] tokens = split(received, ',');
    // printArray(tokens);


    int size = int(tokens[0]) * 2 + NUM_MODULE_TOKENS;

    if (tokens.length == size && dataController.runWithConnection) {
        float[] a = new float[size];
        for (int i = 0; i < a.length; i++) {
            a[i] = float(tokens[i]);

        }

        // printArray(a);


        //================================module================================
        int numPerson = (int) a[0];
        int indx = (int) a[1];
        mdata[indx].update(a);

        //================================global================================
        if (numPerson != 0) {

            PVector[] pos = new PVector[numPerson];
            float[] weight = new float[numPerson];
            for (int i = 0; i < numPerson; i++) {
                pos[i] = new PVector(a[NUM_MODULE_TOKENS + i], a[NUM_MODULE_TOKENS + 1 + i]);
                weight[i] = a[NUM_MODULE_TOKENS + i + 2];
            }
            fieldView.update(numPerson, pos, weight);
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

    void reIndx() {
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
        barLength = int(ledStripPos[0].y - ENDPOINT);
    }
    // Set the location of a single LED
    void led(int index, int x, int y) {
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
    void ledStrip(int index, int count, float x, float y, float spacing, float angle, boolean reversed) {
        float s = sin(angle);
        float c = cos(angle);
        for (int i = 0; i < count; i++) {
            led(reversed ? (index + count - 1 - i) : (index + i),
                (int)(x + (i - (count - 1) / 1.0) * spacing * c + 0.5),
                (int)(y + (i - (count - 1) / 1.0) * spacing * s + 0.5));
        }

    }

    // Set the location of several LEDs arranged in a grid. The first strip is
    // at 'angle', measured in radians clockwise from +X.
    // (x,y) is the center of the grid.
    void ledGrid(int index, int stripLength, int numStrips, float x, float y, float winW,
        float ledSpacing, float stripSpacing, float angle, boolean zigzag) {
        float s = sin(angle + HALF_PI);
        float c = cos(angle + HALF_PI);
        // float h = 130; //if project max reachable length
        for (int i = 0; i < numStrips; i++) {
            ledStrip(index + stripLength * i, stripLength,
                x + (i - (numStrips - 1) / 1.0) * stripSpacing * c,
                y + (i - (numStrips - 1) / 1.0) * stripSpacing * s, ledSpacing,
                angle, zigzag);

            ledStripPos[i] = new PVector(x + (i - (numStrips - 1) / 1.0) * stripSpacing * c, y + (i - (numStrips - 1) / 1.0) * stripSpacing * s);
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
    void showLocations(boolean enabled) {
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
    void setup() {


    }
    void draw() {
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

    void gui() {
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
        float x1 = window.x ;
        float x2 = window.x + windowWidth - pd;
        float y1 = window.y + pd;
        float y2 = ENDPOINT - pd; // 88 
        noStroke();
        fill(0);
        rect(x1, 16, x2, y2 + pd);
        rect(0, 0 , x2, 15);
        stroke(255);
        noFill();
        rect(x1, y1 + indxFontSize, x2, y2);
        popStyle();
    }

    // Change the number of pixels in our output packet.
    // This is normally not needed; the output packet is automatically sized
    // by draw() and by setPixel().
    void setPixelCount(int numPixels) {
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
    void setPixel(int number, color c) {
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
    color getPixel(int number) {
        int offset = 4 + number * 3;
        if (packetData == null || packetData.length < offset + 3) {
            return 0;
        }
        return (packetData[offset] << 16) | (packetData[offset + 1] << 8) | packetData[offset + 2];
    }

    // Transmit our current buffer of pixel values to the OPC server. This is handled
    // automatically in draw() if any pixels are mapped to the screen, but if you haven't
    // mapped any pixels to the screen you'll want to call this directly.
    void writePixels() {
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

    void dispose() {
        // Destroy the socket. Called internally when we've disconnected.
        if (output != null) {
            connection = false;
            println("Disconnected from OPC server");
        }
        socket = null;
        output = null;
    }

    void connect() {
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