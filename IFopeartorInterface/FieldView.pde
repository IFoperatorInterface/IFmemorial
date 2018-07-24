class FieldView {
    int PEOPLE, PEOPLE_;
    PVector winPos, winSize;
    private List < Rider > riders;
    private float weight;

    FieldView() {
        this.winPos = windows[5].pos;
        this.winSize = windows[5].size;
        riders = new ArrayList < Rider > ();
    }
    void update(int num, PVector[] loc, float[] weight) {
        riders.clear();
        
        for (int i=0; i<loc.length && i<weight.length; i++)
            riders.add(new Rider(loc[i], weight[i]));

        PEOPLE = num;
        PEOPLE_ = PEOPLE;
    }
    public void draw() {
        for (Rider r: riders) {
            r.draw();
        }
    }
}