class Rider {
    PVector pos;
    private color c;
    private int r;
    private float weight;
    Rider(PVector pos) {
        this.pos = pos;
        c = color(random(255), random(255), random(255), 100);
        r = 20;
    }

    void update(PVector pos, float weight) {
        this.pos = pos;
        this.weight = weight;
    }

    void draw() {
        pushStyle();
        fill(c);
        ellipse(pos.x, pos.y, r * weight, r * weight);
        popStyle();
    }
}