// 基底クラス
class MyObject {
    //オブジェクトの中心座標
    PVector position = new PVector();
    //回転角度(姿勢)
    float angle = 0;
    //コンストラクタ(未使用)
    public MyObject() {}
    //図形描画関数
    void DisplayShape() {}
    //中心設定関数
    void SetPos(PVector pos) {}
    //回転角(ラジアン)を入力することで回転
    void Rotate(float t) {}
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
    
    public Sector2D(float alpha, float theta, PVector origin, float radius1, float radius2, boolean isMoving, boolean isRotating) {
        this.alpha = alpha;
        this.theta = theta;
        this.origin = new PVector(origin.x,origin.y);
        r1 = radius1;
        r2 = radius2;
        
        a = new PVector(r1 * cos(alpha) + origin.x, r1 * sin(alpha) + origin.y);
        b = new PVector(r2 * cos(alpha) + origin.x, r2 * sin(alpha) + origin.y);
        ad = new PVector(r1 * cos(theta) + origin.x, r1 * sin(theta) + origin.y);
        bd = new PVector(r2 * cos(theta) + origin.x, r2 * sin(theta) + origin.y);
        position = PVector.div(PVector.add(PVector.add(a,b),PVector.add(ad,bd)),4); //扇形の中心点(重心)
        
        sectors.add(this);
        RegistObjList(this, isMoving, isRotating);
    }
    
    void DisplayShape() {
        noFill();
        float al = alpha + angle;
        float th = theta + angle;
        arc(origin.x, origin.y, r2 * 2, r2 * 2, al, th);
        arc(origin.x, origin.y, r1 * 2, r1 * 2, al, th);
        fill(255);
        line(a.x, a.y, b.x, b.y); //回転前の線分
        line(ad.x, ad.y, bd.x, bd.y); //回転後の線分
        //ellipse(origin.x,origin.y,15,15); //回転中心
    }
    
    void SetPos(PVector pos) {
        var PO = PVector.sub(origin,position);
        position.set(pos);
        origin = PVector.add(position,PO);
        
        float al = alpha + angle;
        float th = theta + angle;
        
        a.set(r1 * cos(al) + origin.x, r1 * sin(al) + origin.y);
        b.set(r2 * cos(al) + origin.x, r2 * sin(al) + origin.y);
        ad.set(r1 * cos(th) + origin.x, r1 * sin(th) + origin.y);
        bd.set(r2 * cos(th) + origin.x, r2 * sin(th) + origin.y);
    }
    
    void Rotate(float t) {
        //回転行列を利用して回転
        a = PVector.add(RotateMatrix(t,PVector.sub(a,position)),position);
        b = PVector.add(RotateMatrix(t,PVector.sub(b,position)),position);
        ad = PVector.add(RotateMatrix(t,PVector.sub(ad,position)),position);
        bd = PVector.add(RotateMatrix(t,PVector.sub(bd,position)),position);
        origin = PVector.add(RotateMatrix(t,PVector.sub(origin,position)),position);
        angle += t;
    }
}

//長方形
class MyBox extends MyObject{
    //頂点
    PVector[] v = new PVector[4];
    //幅、高さ
    float w,h;
    
    public MyBox(PVector pos, float width, float height, boolean isMoving, boolean isRotating) {
        position = new PVector(pos.x,pos.y);
        w = width;
        h = height;
        v[0] = new PVector(position.x + w / 2, position.y + h / 2);
        v[1] = new PVector(position.x - w / 2, position.y + h / 2);
        v[2] = new PVector(position.x - w / 2, position.y - h / 2);
        v[3] = new PVector(position.x + w / 2, position.y - h / 2);
        
        boxes.add(this);
        RegistObjList(this,isMoving, isRotating);
    }
    
    void DisplayShape() {
        stroke(0);
        for (int i = 0;i < 3;i++) {
            line(v[i + 1].x,v[i + 1].y,v[i].x,v[i].y);
        }
        line(v[3].x,v[3].y,v[0].x,v[0].y);
    }
    
    void SetPos(PVector pos) {
        PVector tl = PVector.sub(pos,position);
        position.set(pos);
        for (int i = 0;i < 4;i++) v[i] = PVector.add(v[i],tl);
    }
    
    void Rotate(float t) {
        for (int i = 0;i < 4;i++) v[i] = PVector.add(RotateMatrix(t,PVector.sub(v[i],position)),position);
        angle += t;
    }
}

// 円
class MyCircle extends MyObject{
    //半径
    float r;
    public MyCircle(PVector pos, float radius, boolean isMoving) {
        this.position = new PVector(pos.x,pos.y);
        r = radius;
        
        circles.add(this);
        RegistObjList(this,isMoving,false);
    }
    
    void DisplayShape() {
        noFill();
        ellipse(position.x,position.y,r * 2,r * 2);
        fill(255);
    }
    
    void SetPos(PVector pos) {
        position.set(pos);
    }
    
    void Rotate(float t) {angle += t;}
}

