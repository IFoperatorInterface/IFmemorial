class Rider {
    PVector pos;
    private color c;
    private int r;
    Rider(PVector pos) {
        this.pos = pos;
        c = color(random(255), random(255), random(255), 100);
        r = 20;
    }
    void draw() {
        pushStyle();
        fill(c);
        ellipse(pos.x, pos.y, r, r);
        popStyle();
    }
}