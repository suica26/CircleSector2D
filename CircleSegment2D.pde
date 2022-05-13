PVector origin = new PVector(0,0);
PVector mousePos = new PVector(0,0);
Sector2D fanShape;
MyBox box;

/////////////////////////メインブロック///////////////////////////

void settings() {
    size(1000,1000);
}

void setup() {
    fanShape = new Sector2D(radians( -60),radians(60),origin,100,300);
    box = new MyBox(origin,150,150);
}

void draw() {
    translate(width / 2, height / 2);
    background(255);
    fill(255);
    
    fanShape.DisplayShape();
    box.DisplayShape();
    
    ArrayList<PVector> points = GetCrossPoints_CircleBox(fanShape,box);
    
    for (PVector point : points) {
        fill(#7FFF5C);
        ellipse(point.x, point.y, 10, 10);
    }
}

/////////////////////////関数ブロック///////////////////////////

void mouseMoved() {
    mousePos.set(mouseX - (width / 2),mouseY - (height / 2));
    box.SetPos(mousePos);
}

PVector[] GetCrossPoints(float x1, float y1, float x2, float y2, float circleX, float circleY, float r) {
    
    float xd = x2 - x1;
    float yd = y2 - y1;
    float x = x1 - circleX;
    float y = y1 - circleY;
    float a = xd * xd + yd * yd;
    float b = xd * x + yd * y;
    float c = x * x + y * y - r * r;
    //D = 0の時は1本で、D < 0の時は存在しない
    float d = b * b - a * c;
    float s1 = ( -b + sqrt(d)) / a;
    float s2 = ( -b - sqrt(d)) / a;
    
    PVector[] crossPoint = new PVector[2];
    int s = 0;
    if (s1 >= 0 && s1 <= 1)
        {
        crossPoint[s] = new PVector(x1 + s1 * xd, y1 + s1 * yd);
        s++;
    }
    if (s2 >= 0 && s2 <= 1)
        {
        crossPoint[s] = new PVector(x1 + s2 * xd, y1 + s2 * yd);
        s++;
    }
    
    return crossPoint;
}

ArrayList<PVector> GetCrossPoints_CircleBox(Sector2D f,MyBox b)
    {
    ArrayList<PVector> points = new ArrayList<PVector>();
    for (int i = 0;i < 3;i++)
        {
        var p1 = GetCrossPoints(b.v[i].x,b.v[i].y,b.v[i + 1].x,b.v[i + 1].y,f.origin.x,f.origin.y,f.r1);
        var p2 = GetCrossPoints(b.v[i].x,b.v[i].y,b.v[i + 1].x,b.v[i + 1].y,f.origin.x,f.origin.y,f.r2);
        
        if (p1[0] != null)points.add(p1[0]);
        if (p1[1] != null)points.add(p1[1]);
        if (p2[0] != null)points.add(p2[0]);
        if (p2[1] != null)points.add(p2[1]);
    }
    var p1 = GetCrossPoints(b.v[3].x,b.v[3].y,b.v[0].x,b.v[0].y,f.origin.x,f.origin.y,f.r1);
    var p2 = GetCrossPoints(b.v[3].x,b.v[3].y,b.v[0].x,b.v[0].y,f.origin.x,f.origin.y,f.r2);
    
    if (p1[0] != null)points.add(p1[0]);
    if (p1[1] != null)points.add(p1[1]);
    if (p2[0] != null)points.add(p2[0]);
    if (p2[1] != null)points.add(p2[1]);
    
    return points;
}

/////////////////////////クラスブロック///////////////////////////

// 基底クラス
class MyObject {
    public MyObject() {}
    void DisplayShape() {}
}

//2D扇形
class Sector2D extends MyObject{
    //alphaは回転前の角度
    //thetaは回転後の角度
    float alpha,theta;
    //r1はa,adを通る円の半径(短)
    //r2はb,bdを通る円の半径(長)
    float r1,r2;
    //回転中心の位置ベクトル
    PVector origin;
    //a,bは回転前の位置ベクトル
    //ad,bdは回転後の位置ベクトル
    PVector a,b,ad,bd;
    
    public Sector2D(float alpha, float theta, PVector origin, float radius1, float radius2) {
        this.alpha = alpha;
        this.theta = theta;
        this.origin = new PVector(origin.x,origin.y);
        r1 = radius1;
        r2 = radius2;
        
        a = new PVector(r1 * cos(alpha), r1 * sin(alpha));
        b = new PVector(r2 * cos(alpha), r2 * sin(alpha));
        ad = new PVector(r1 * cos(theta), r1 * sin(theta));
        bd = new PVector(r2 * cos(theta), r2 * sin(theta));
    }
    
    void DisplayShape() {
        noFill();
        arc(origin.x, origin.y, r2 * 2, r2 * 2, alpha, theta);
        arc(origin.x, origin.y, r1 * 2, r1 * 2, alpha, theta);
        fill(255);
        line(a.x, a.y, b.x, b.y); //回転前の線分
        line(ad.x, ad.y, bd.x, bd.y); //回転後の線分
    }
}

class MyBox {
    PVector pos;
    PVector[] v = new PVector[4];
    float w,h;
    
    public MyBox(PVector position, float width, float height) {
        this.pos = new PVector(position.x,position.y);
        w = width;
        h = height;
        v[0] = new PVector(pos.x + w / 2, pos.y + h / 2);
        v[1] = new PVector(pos.x - w / 2, pos.y + h / 2);
        v[2] = new PVector(pos.x - w / 2, pos.y - h / 2);
        v[3] = new PVector(pos.x + w / 2, pos.y - h / 2);
    }
    
    void SetPos(PVector position) {
        this.pos.set(position);
        v[0] = new PVector(pos.x + w / 2, pos.y + h / 2);
        v[1] = new PVector(pos.x - w / 2, pos.y + h / 2);
        v[2] = new PVector(pos.x - w / 2, pos.y - h / 2);
        v[3] = new PVector(pos.x + w / 2, pos.y - h / 2);
    }
    
    void DisplayShape() {
        noFill();
        rect(pos.x - w / 2, pos.y - h / 2, w, h);
        fill(255);
    }
}