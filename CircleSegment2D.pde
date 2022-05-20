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
    fanShape = new Sector2D(radians(30),radians(120),origin, 100,300);
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
    
    fill(0,255,0);
    ArrayList<PVector> points = GetCrossPoints_SectorBox(fanShape,box);
    
    for (PVector v : box.v) {
        points.add(v);
    }
    
    for (PVector point : points) {
        if (CheckPointInSector(fanShape,point))
            ellipse(point.x, point.y, 10, 10);
    }
    
    var finish = millis();
    
    popMatrix();
    fill(0);
    if (frameCount % 20 == 0) {
        println(finish - start);
    }
}

/////////////////////////関数ブロック///////////////////////////

void mouseMoved() {
    mousePos.set(mouseX - (width / 2),mouseY - (height / 2));
    box.SetPos(mousePos);
}

//外積関数
float Cross(PVector a, PVector b) {
    return a.x * b.y - a.y * b.x;
}

//円と線分の交点算出
PVector[] GetCrossPoints_CircleLine(float x1, float y1, float x2, float y2, float circleX, float circleY, float r) {
    
    //参考URL
    //https :/ /tjkendev.github.io/procon-library/python/geometry/circle_line_cross_point.html
    //傾きの算出
    float xd = x2 - x1;
    float yd = y2 - y1;
    //円の公式(x ^ 2 + y ^ 2 = r ^ 2)への代入と整理
    float x = x1 - circleX;
    float y = y1 - circleY;
    float a = xd * xd + yd * yd;
    float b = xd * x + yd * y;
    float c = x * x + y * y - r * r;
    //二次関数の解の公式
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

//線分と線分の交点
PVector GetCrossPoints_LineLine(PVector a, PVector b, PVector c, PVector d) {
    //参考URL
    //https :/ /qiita.com/zu_rin/items/09876d2c7ec12974bc0f
    float s,t;
    float deno = Cross(PVector.sub(b,a),PVector.sub(d,c));
    //線分が平行な場合はnull
    if (deno == 0.0) return null;
    
    s = Cross(PVector.sub(c,a),PVector.sub(d,c)) / deno;
    t = Cross(PVector.sub(b,a),PVector.sub(a,c)) / deno;
    
    //線分が交差していない場合
    if (s < 0.0 || 1.0 < s || t < 0.0 ||  1.0 < t) return null;
    
    return PVector.add(a,PVector.mult(PVector.sub(b,a),s));
}

//扇形構成要素(外円、内円、二線分)と四角形の交点算出
ArrayList<PVector> GetCrossPoints_SectorBox(Sector2D f,MyBox b) {
    //円と線分の交差点算出
    ArrayList<PVector> points = new ArrayList<PVector>();
    for (int i = 0;i < 3;i++) {
        var p1 = GetCrossPoints_CircleLine(b.v[i].x,b.v[i].y,b.v[i + 1].x,b.v[i + 1].y,f.origin.x,f.origin.y,f.r1);
        var p2 = GetCrossPoints_CircleLine(b.v[i].x,b.v[i].y,b.v[i + 1].x,b.v[i + 1].y,f.origin.x,f.origin.y,f.r2);
        
        if (p1[0] != null)points.add(p1[0]);
        if (p1[1] != null)points.add(p1[1]);
        if (p2[0] != null)points.add(p2[0]);
        if (p2[1] != null)points.add(p2[1]);
    }
    var p1 = GetCrossPoints_CircleLine(b.v[3].x,b.v[3].y,b.v[0].x,b.v[0].y,f.origin.x,f.origin.y,f.r1);
    var p2 = GetCrossPoints_CircleLine(b.v[3].x,b.v[3].y,b.v[0].x,b.v[0].y,f.origin.x,f.origin.y,f.r2);
    
    if (p1[0] != null)points.add(p1[0]);
    if (p1[1] != null)points.add(p1[1]);
    if (p2[0] != null)points.add(p2[0]);
    if (p2[1] != null)points.add(p2[1]);
    
    //円と線分の交差点算出
    for (int i = 0; i < 3;i++) {
        var p = GetCrossPoints_LineLine(b.v[i],b.v[i + 1],f.a,f.b);
        var q = GetCrossPoints_LineLine(b.v[i],b.v[i + 1],f.ad,f.bd);
        
        if (p!= null) points.add(p);
        if (q!= null) points.add(q);
    }
    var p = GetCrossPoints_LineLine(b.v[3],b.v[0],f.a,f.b);
    var q = GetCrossPoints_LineLine(b.v[3],b.v[0],f.ad,f.bd);
    
    if (p!= null) points.add(p);
    if (q!= null) points.add(q);
    
    return points;
}

boolean CheckPointInSector(Sector2D f, PVector p) {
    //内円よりも外側にあるかどうか
    if (p.mag() < f.r1 - epsilon) return false;
    //外円よりも内側にあるかどうか
    if (p.mag() > f.r2 + epsilon) return false;
    //回転方向で場合分け
    //正の回転の場合
    if (f.theta - f.alpha >= 0) {
        if (Cross(PVector.sub(p,f.a),PVector.sub(f.b,f.a)) >= epsilon) return false;
        if (Cross(PVector.sub(p,f.ad),PVector.sub(f.bd,f.ad)) < - epsilon) return false;
    }
    else{
        if (Cross(PVector.sub(p,f.a),PVector.sub(f.b,f.a)) <- epsilon) return false;
        if (Cross(PVector.sub(p,f.ad),PVector.sub(f.bd,f.ad)) >= epsilon) return false;
    }
    
    return true;
}

//回転行列
PVector RotateMatrix(float theta, PVector v) {
    float x = v.x * cos(theta) - v.y * sin(theta);
    float y = v.x * sin(theta) + v.y * cos(theta);
    PVector r = new PVector(x,y);
    return r;
}

//次の条件の時、扇形の中の点を返す
//0 <= s <= 1
//0 <= t <= 1
PVector SectorPoint(Sector2D f, float s, float t) {
    PVector v = PVector.add(PVector.sub(f.a,f.origin),PVector.mult(PVector.sub(f.b,f.a),s));
    PVector p = PVector.add(RotateMatrix(t * (f.theta - f.alpha),v),f.origin);
    return p;
}

/////////////////////////クラスブロック///////////////////////////

// 基底クラス
class MyObject {
    public MyObject() {}
    void DisplayShape() {}
}

// 2D扇形
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
        pos = new PVector(position.x,position.y);
        w = width;
        h = height;
        v[0] = new PVector(pos.x + w / 2, pos.y + h / 2);
        v[1] = new PVector(pos.x - w / 2, pos.y + h / 2);
        v[2] = new PVector(pos.x - w / 2, pos.y - h / 2);
        v[3] = new PVector(pos.x + w / 2, pos.y - h / 2);
    }
    
    void SetPos(PVector position) {
        pos.set(position);
        v[0].set(pos.x + w / 2, pos.y + h / 2);
        v[1].set(pos.x - w / 2, pos.y + h / 2);
        v[2].set(pos.x - w / 2, pos.y - h / 2);
        v[3].set(pos.x + w / 2, pos.y - h / 2);
    }
    
    void DisplayShape() {
        noFill();
        rect(pos.x - w / 2, pos.y - h / 2, w, h);
        fill(255);
    }
}