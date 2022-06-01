// 基底クラス
class MyObject {
    public MyObject() {}
    void DisplayShape() {}
    void SetPos(PVector position) {}
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
        
        a = new PVector(r1 * cos(alpha) + origin.x, r1 * sin(alpha) + origin.y);
        b = new PVector(r2 * cos(alpha) + origin.x, r2 * sin(alpha) + origin.y);
        ad = new PVector(r1 * cos(theta) + origin.x, r1 * sin(theta) + origin.y);
        bd = new PVector(r2 * cos(theta) + origin.x, r2 * sin(theta) + origin.y);
    }
    
    void DisplayShape() {
        noFill();
        arc(origin.x, origin.y, r2 * 2, r2 * 2, alpha, theta);
        arc(origin.x, origin.y, r1 * 2, r1 * 2, alpha, theta);
        fill(255);
        line(a.x, a.y, b.x, b.y); //回転前の線分
        line(ad.x, ad.y, bd.x, bd.y); //回転後の線分
    }
    
    void SetPos(PVector position) {
        origin.set(position);
        
        a.set(r1 * cos(alpha) + origin.x, r1 * sin(alpha) + origin.y);
        b.set(r2 * cos(alpha) + origin.x, r2 * sin(alpha) + origin.y);
        ad.set(r1 * cos(theta) + origin.x, r1 * sin(theta) + origin.y);
        bd.set(r2 * cos(theta) + origin.x, r2 * sin(theta) + origin.y);
    }
}

//長方形
class MyBox extends MyObject{
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
    
    void DisplayShape() {
        noFill();
        rect(pos.x - w / 2, pos.y - h / 2, w, h);
        fill(255);
    }
    
    void SetPos(PVector position) {
        pos.set(position);
        v[0].set(pos.x + w / 2, pos.y + h / 2);
        v[1].set(pos.x - w / 2, pos.y + h / 2);
        v[2].set(pos.x - w / 2, pos.y - h / 2);
        v[3].set(pos.x + w / 2, pos.y - h / 2);
    }
}

//円
class MyCircle extends MyObject{
    PVector p;
    float r;
    public MyCircle(PVector position, float radius) {
        p = new PVector(position.x,position.y);
        r = radius;
    }
    
    void DisplayShape() {
        noFill();
        ellipse(p.x,p.y,r * 2,r * 2);
        fill(255);
    }
    
    void SetPos(PVector position) {
        p.set(position);
    }
}

