PVector origin = new PVector(0,0);
PVector mousePos = new PVector(0,0);
Sector2D fanShape;
MyBox box;
float epsilon = 0.01;
float s,t;

/////////////////////////メインブロック///////////////////////////

void settings() {
    size(1000,1000);
}

void setup() {
    textSize(32);
    fanShape = new Sector2D(radians( -60),radians(30),origin, 100,300);
    box = new MyBox(origin,150,150);
}

void draw() {
    pushMatrix();
    translate(width / 2, height / 2);
    background(255);
    fill(255);
    
    fanShape.DisplayShape();
    box.DisplayShape();
    
    s = cos(radians(frameCount * 5)) / 2 + 0.5;
    t = sin(radians(frameCount)) / 2 + 0.5;
    
    var p = SectorPoint(fanShape,s,t);
    fill(255,0,0);
    ellipse(p.x,p.y,10,10);
    
    var start = millis();
    
    ArrayList<PVector> points = GetCrossPoints_SectorBox(fanShape,box);
    
    for (PVector v : box.v) {
        points.add(v);
    }
    
    for (PVector point : points) {
        fill(255,0,0);
        if (CheckPointInSector(fanShape,point))
            fill(0,255,0);
        ellipse(point.x, point.y, 10, 10);
    }
    
    var finish = millis();
    
    popMatrix();
    fill(0);
    if (frameCount % 20 == 0) {
        println(finish - start);
    }
}
