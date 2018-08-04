class FieldView {
    PVector winPos, winSize;
    private List < Rider > riders;
    int NUM_CUR_P, NUM_PRE_P;

    FieldView() {
        this.winPos = windows[5].pos;
        this.winSize = windows[5].size;
        riders = new ArrayList < Rider > ();
    }

    void update(int num, PVector[] pos, float[] weight) {
        NUM_CUR_P = num;

        if (NUM_CUR_P != NUM_PRE_P) {
            riders.clear();
            for (int i = 0; i < NUM_CUR_P; i++) 
                riders.add(new Rider(pos[i], weight[i], i));
        }

        for (int i = 0; i < riders.size(); i++)
            riders.get(i).update(pos[i], weight[i]);

        NUM_PRE_P = riders.size();
    }

    public void draw() {
        if (riders.size() > 0) {
            for (int i = 0; i < riders.size(); i++) {
                riders.get(i).draw();
                if (!riders.get(i).checkStateRiderIsOn())
                    riders.remove(i);
            }
        }
    }
}