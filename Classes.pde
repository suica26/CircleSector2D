/*
クラス記述用ファイル








*/

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
    void DisplayShape(float gray) {}
    void DisplayShape(float gray, float alpha) {}
    void DisplayShape(float v1, float v2, float v3) {}
    void DisplayShape(float v1, float v2, float v3, float alpha) {}
    //中心設定関数
    void SetPos(PVector pos) {}
    //回転角(ラジアン)と回転中心を入力することで回転
    void Rotate(float t, PVector o) {}
    //draw()内で呼び出す。
    void update() {}
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
    
    public Sector2D(PVector origin, float alpha, float theta, float radius1, float radius2, int registID) {
        this.origin = new PVector(origin.x,origin.y);
        this.alpha = alpha;
        this.theta = theta;
        angle = theta - alpha;
        r1 = radius1;
        r2 = radius2;
        
        a = new PVector(r1 * cos(alpha) + origin.x, r1 * sin(alpha) + origin.y);
        b = new PVector(r2 * cos(alpha) + origin.x, r2 * sin(alpha) + origin.y);
        ad = new PVector(r1 * cos(theta) + origin.x, r1 * sin(theta) + origin.y);
        bd = new PVector(r2 * cos(theta) + origin.x, r2 * sin(theta) + origin.y);
        position = PVector.mult(PVector.add(PVector.sub(a,origin),PVector.sub(ad,origin)).normalize(),(r2 + r1) / 2.0); //扇形の中心点(重心)
        
        //扇形オブジェクトリストに登録
        if (registID == 1) {
            objects.add(this);
            sectors.add(this);
        }
        else if (registID == 2) {
            objects.add(this);
        }
        else if (registID == 3) {
            sectors.add(this);
        }
    }
    
    void Copy(Sector2D s) {
        this.origin.set(s.origin.x, s.origin.y);
        this.alpha = s.alpha;
        this.theta = s.theta;
        this.angle = s.angle;
        this.r1 = s.r1;
        this.r2 = s.r2;
        this.a.set(s.a.x, s.a.y);
        this.b.set(s.b.x, s.b.y);
        this.ad.set(s.ad.x, s.ad.y);
        this.bd.set(s.bd.x, s.bd.y);
        this.position.set(s.position.x, s.position.y);
    }
    
    void DisplayShape() {
        noFill();
        float al = alpha + angle;
        float th = theta + angle;
        
        arc(origin.x, origin.y, r2 * 2, r2 * 2, al, th);
        arc(origin.x, origin.y, r1 * 2, r1 * 2, al, th);
        line(a.x, a.y, b.x, b.y); //回転前の線分
        line(ad.x, ad.y, bd.x, bd.y); //回転後の線分
    }
    
    void DisplayShape(float gray) {
        fill(gray);
        float al = alpha + angle;
        float th = theta + angle;
        
        arc(origin.x, origin.y, r2 * 2, r2 * 2, al, th);
        fill(255);  //小円部分は白で塗りつぶす
        arc(origin.x, origin.y, r1 * 2, r1 * 2, al, th);
        line(a.x, a.y, b.x, b.y); //回転前の線分
        line(ad.x, ad.y, bd.x, bd.y); //回転後の線分
    }
    
    void DisplayShape(float gray, float alpha) {
        fill(gray, alpha);
        float al = this.alpha + angle;
        float th = this.theta + angle;
        
        arc(origin.x, origin.y, r2 * 2, r2 * 2, al, th);
        fill(255);  //小円部分は白で塗りつぶす
        arc(origin.x, origin.y, r1 * 2, r1 * 2, al, th);
        line(a.x, a.y, b.x, b.y); //回転前の線分
        line(ad.x, ad.y, bd.x, bd.y); //回転後の線分
    }
    
    void DisplayShape(float v1, float v2, float v3) {
        fill(v1, v2 ,v3);
        float al = alpha + angle;
        float th = theta + angle;
        
        arc(origin.x, origin.y, r2 * 2, r2 * 2, al, th);
        fill(255);  //小円部分は白で塗りつぶす
        arc(origin.x, origin.y, r1 * 2, r1 * 2, al, th);
        line(a.x, a.y, b.x, b.y); //回転前の線分
        line(ad.x, ad.y, bd.x, bd.y); //回転後の線分
    }
    
    void DisplayShape(float v1, float v2, float v3, float alpha) {
        fill(v1, v2 ,v3, alpha);
        float al = this.alpha + angle;
        float th = this.theta + angle;
        
        arc(origin.x, origin.y, r2 * 2, r2 * 2, al, th);
        fill(255);  //小円部分は白で塗りつぶす
        arc(origin.x, origin.y, r1 * 2, r1 * 2, al, th);
        line(a.x, a.y, b.x, b.y); //回転前の線分
        line(ad.x, ad.y, bd.x, bd.y); //回転後の線分
    }
    
    void SetPos(PVector pos) {
        var moveVec = PVector.sub(pos, position);   //positionからposへの移動ベクトル
        position.add(moveVec);
        origin.add(moveVec);
        a.add(moveVec);
        b.add(moveVec);
        ad.add(moveVec);
        bd.add(moveVec);
    }
    
    void Rotate(float t, PVector o) {
        //回転中心を原点に移動
        var moveVec = new PVector(o.x, o.y);
        SetPos(PVector.sub(position,moveVec));
        
        //回転
        a = RotateMatrix(t,a);
        b = RotateMatrix(t,b);
        ad = RotateMatrix(t,ad);
        bd = RotateMatrix(t,bd);
        origin = RotateMatrix(t,origin);
        position = RotateMatrix(t,position);
        angle += t;
        
        //回転中心をもとの座標に戻す
        SetPos(PVector.add(position, moveVec));
    }
}

// 長方形
class MyBox extends MyObject{
    //頂点
    PVector[] v = new PVector[4];
    //幅、高さ
    float w,h;
    
    public MyBox(PVector pos, float width, float height, int registID) {
        position = new PVector(pos.x,pos.y);
        w = width;
        h = height;
        v[0] = new PVector(position.x + w / 2, position.y + h / 2);
        v[1] = new PVector(position.x - w / 2, position.y + h / 2);
        v[2] = new PVector(position.x - w / 2, position.y - h / 2);
        v[3] = new PVector(position.x + w / 2, position.y - h / 2);
        
        //矩形オブジェクトリストに登録
        if (registID == 1) {
            objects.add(this);
            boxes.add(this);
        }
        else if (registID == 2) {
            objects.add(this);
        }
        else if (registID == 3) {
            boxes.add(this);
        }
    }
    
    void Copy(MyBox b) {
        this.position.set(b.position.x, b.position.y);
        this.w = b.w;
        this.h = b.h;
        this.angle = b.angle;
        this.v[0].set(b.v[0].x, b.v[0].y);
        this.v[1].set(b.v[1].x, b.v[1].y);
        this.v[2].set(b.v[2].x, b.v[2].y);
        this.v[3].set(b.v[3].x, b.v[3].y);
    }
    
    void BoxShape() {
        pushMatrix();
        translate(position.x, position.y);
        rotate(angle);
        rect( -w / 2, -h / 2, w, h);
        popMatrix();
    }
    
    void DisplayShape() {
        noFill();
        BoxShape();
    }
    
    void DisplayShape(float gray) {
        fill(gray);
        BoxShape();
    }
    
    void DisplayShape(float gray, float alpha) {
        fill(gray, alpha);
        BoxShape();
    }
    
    void DisplayShape(float v1, float v2, float v3) {
        fill(v1, v2, v3);
        BoxShape();
    }
    
    void DisplayShape(float v1, float v2, float v3, float alpha) {
        fill(v1, v2, v3, alpha);
        BoxShape();
    }
    
    void SetPos(PVector pos) {
        PVector moveVec = PVector.sub(pos, position);    //positionからposへの移動ベクトル
        position.set(pos);
        for (int i = 0;i < 4;i++) v[i] = PVector.add(v[i],moveVec);
    }
    
    void Rotate(float t, PVector o) {
        //回転中心を原点に移動
        var moveVec = new PVector(o.x, o.y);    //oをそのまま利用すると、o = positionの時にpositionが0ベクトルになり、元の座標に戻せなくなる
        SetPos(PVector.sub(position, moveVec));
        
        //回転
        var rotPos = RotateMatrix(t, position);
        position.set(rotPos.x, rotPos.y);
        for (int i = 0;i < 4;i++) {
            var rotV = RotateMatrix(t,v[i]);
            v[i].set(rotV.x, rotV.y);
        }
        angle += t;
        
        //回転中心をもとの座標に戻す
        SetPos(PVector.add(position, moveVec));
    }
}

// 円
class MyCircle extends MyObject{
    //半径
    float r;
    public MyCircle(PVector pos, float radius, int registID) {
        this.position = new PVector(pos.x,pos.y);
        r = radius;
        
        //円オブジェクトリストに登録するかどうか
        if (registID == 1) {
            objects.add(this);
            circles.add(this);
        }
        else if (registID == 2) {
            objects.add(this);
        }
        else if (registID == 3) {
            circles.add(this);
        }
    }
    
    void Copy(MyCircle c) {
        this.position.set(c.position.x, c.position.y);
        this.angle = c.angle;
    }
    
    void DisplayShape() {
        noFill();
        ellipse(position.x, position.y, r * 2, r * 2);
    }
    
    void DisplayShape(float gray) {
        fill(gray);
        ellipse(position.x, position.y, r * 2, r * 2);
    }
    
    void DisplayShape(float gray, float alpha) {
        fill(gray, alpha);
        ellipse(position.x, position.y, r * 2, r * 2);
    }
    
    void DisplayShape(float v1, float v2, float v3, float alpha) {
        fill(v1, v2, v3, alpha);
        ellipse(position.x, position.y, r * 2, r * 2);
    }
    
    void SetPos(PVector pos) {
        position.set(pos);
    }
    
    void Rotate(float t, PVector o) {
        //回転中心を原点に移動
        var moveVec = new PVector(o.x, o.y);
        SetPos(PVector.sub(position, moveVec));
        
        //回転
        position = RotateMatrix(t, position);
        angle += t;
        
        //回転中心をもとの座標に戻す
        SetPos(PVector.add(position, moveVec));
    }
}

class MyCapsule extends MyObject{
    float r;
    //始点と終点
    PVector s, e;
    
}