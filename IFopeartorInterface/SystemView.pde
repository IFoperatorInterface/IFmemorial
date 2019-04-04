class SystemView {
    Title[] sliderTitles = new Title[2];
    Title previewTitle;
    SystemView() {
    }
    void draw() {

        adrGUI();

        for (Title t: sliderTitles)
            t.display();

        windowGUI();
    }
    void windowGUI() {
        PVector pos = new PVector(0, 0);
        float pd = 10;
        float w = 14;
        float h = pos.y - windows[1].pos.y;
        pushStyle();
        noFill();
        stroke(120);
        rect(pos.x - w / 2, pos.y - h + pd, w, h, w / 2);
        popStyle();
        previewTitle.display();

        for (Window win: windows)
            win.display();

    }
    void adrGUI() {
        int NUM_ADR = 3;
        int pd = 10;
        int h = int(windows[NUM_ADR - 1].size.y - pd);
        int btSize = int(h / 3);

        int x = int(windows[NUM_ADR - 1].pos.x) + (btSize + pd) * NUM_ADR + pd * 3 / 2;
        int y = int(windows[NUM_ADR - 1].pos.y + pd / 2);
        int w = width / 2 - 15 - x - pd / 2;
        // color c = (!adrBt.isMouseOver()) ? color(0, 55, 110) : color(0, 116, 180);
        color c = color(0, 45, 90);
        pushStyle();
        stroke(c);
        strokeWeight(pd);
        fill(c);
        rect(x, y, w, h);
        popStyle();
    }
}

class Title {
    PVector pos;
    String title;
    Title(PVector pos, String title) {
        this.pos = pos;
        this.title = title;
    }
    void display() {
        pushStyle();
        fill(255);
        textAlign(CENTER, CENTER);
        textFont(titleFont);
        if (!title.contains("NoTitle"))
            text(title.toUpperCase(), pos.x, pos.y);

        popStyle();
    }
}