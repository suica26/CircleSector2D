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
    //中心設定関数
    void SetPos(PVector pos) {}
    //回転角(ラジアン)と回転中心を入力することで回転
    void Rotate(float t, PVector o) {}
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
    
    public Sector2D(PVector origin, float alpha, float theta, float radius1, float radius2) {
        this.alpha = alpha;
        this.theta = theta;
        this.origin = new PVector(origin.x,origin.y);
        r1 = radius1;
        r2 = radius2;
        
        a = new PVector(r1 * cos(alpha) + origin.x, r1 * sin(alpha) + origin.y);
        b = new PVector(r2 * cos(alpha) + origin.x, r2 * sin(alpha) + origin.y);
        ad = new PVector(r1 * cos(theta) + origin.x, r1 * sin(theta) + origin.y);
        bd = new PVector(r2 * cos(theta) + origin.x, r2 * sin(theta) + origin.y);
        position = PVector.mult(PVector.add(PVector.sub(a,origin),PVector.sub(ad,origin)).normalize(),(r2 + r1) / 2.0); //扇形の中心点(重心)
        
        //扇形オブジェクトリストに登録
        sectors.add(this);
    }
    
    void DisplayShape() {
        var currentCol = currentFillColor;  //直近の色を保存
        
        float al = alpha + angle;
        float th = theta + angle;
        
        arc(origin.x, origin.y, r2 * 2, r2 * 2, al, th);
        fill(255);  //小円部分は白で塗りつぶす
        arc(origin.x, origin.y, r1 * 2, r1 * 2, al, th);
        line(a.x, a.y, b.x, b.y); //回転前の線分
        line(ad.x, ad.y, bd.x, bd.y); //回転後の線分
        
        fill(currentCol.x, currentCol.y, currentCol.z); //直近の色に戻す
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
        SetPos(PVector.sub(position,o));
        
        //回転
        a = RotateMatrix(t,a);
        b = RotateMatrix(t,b);
        ad = RotateMatrix(t,ad);
        bd = RotateMatrix(t,bd);
        origin = RotateMatrix(t,origin);
        position = RotateMatrix(t,position);
        angle += t;
        
        //回転中心をもとの座標に戻す
        SetPos(PVector.add(position, o));
    }
}

// 長方形
class MyBox extends MyObject{
    //頂点
    PVector[] v = new PVector[4];
    //幅、高さ
    float w,h;
    
    public MyBox(PVector pos, float width, float height) {
        position = new PVector(pos.x,pos.y);
        w = width;
        h = height;
        v[0] = new PVector(position.x + w / 2, position.y + h / 2);
        v[1] = new PVector(position.x - w / 2, position.y + h / 2);
        v[2] = new PVector(position.x - w / 2, position.y - h / 2);
        v[3] = new PVector(position.x + w / 2, position.y - h / 2);
        
        //矩形オブジェクトリストに登録
        boxes.add(this);
    }
    
    void DisplayShape() {
        pushMatrix();
        translate(position.x, position.y);
        rotate(angle);
        rect( -w / 2, -h / 2, w, h);
        popMatrix();
    }
    
    void SetPos(PVector pos) {
        PVector moveVec = PVector.sub(pos, position);    //positionからposへの移動ベクトル
        position.set(pos);
        for (int i = 0;i < 4;i++) v[i] = PVector.add(v[i],moveVec);
    }
    
    void Rotate(float t, PVector o) {
        //回転中心を原点に移動
        SetPos(PVector.sub(position, o));
        
        //回転
        position = RotateMatrix(t, position);
        for (int i = 0;i < 4;i++) v[i] = RotateMatrix(t,v[i]);
        angle += t;
        
        //回転中心をもとの座標に戻す
        SetPos(PVector.add(position, o));
    }
}

// 円
class MyCircle extends MyObject{
    //半径
    float r;
    public MyCircle(PVector pos, float radius) {
        this.position = new PVector(pos.x,pos.y);
        r = radius;
        
        //円オブジェクトリストに登録するかどうか
        circles.add(this);
    }
    
    void DisplayShape() {
        ellipse(position.x, position.y, r * 2, r * 2);
    }
    
    void SetPos(PVector pos) {
        position.set(pos);
    }
    
    void Rotate(float t, PVector o) {
        //回転中心を原点に移動
        SetPos(PVector.sub(position, o));
        
        //回転
        position = RotateMatrix(t, position);
        angle += t;
        
        //回転中心をもとの座標に戻す
        SetPos(PVector.add(position, o));
    }
}

