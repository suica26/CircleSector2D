/*
最短距離算出関数をまとめたファイルです
参考文献：http://marupeke296.com/COL_3D_No27_CapsuleCapsule.html
*/

//点から直線までの最短距離計算関数
//pは点、lpは直線状の点、vは直線の方向ベクトル
float CalcPointLineDist(PVector p, PVector lp, PVector v) {
    float denominator = PVector.dot(v, v);
    float numerator = PVector.dot(v, lp) - PVector.dot(v, p);
    float t = numerator / denominator;
    PVector h = PVector.add(lp, PVector.mult(v, t));
    return dist(h.x, h.y, p.x, p.y);
}

//点から線分までの最短距離計算関数
//pは点、sは線分の始点、eは線分の終点
float CalcPointSegmentDist(PVector p, PVector s, PVector e) {
    PVector v = PVector.sub(e, s);
    boolean isOverS = PVector.dot(v, PVector.sub(p, s)) < 0;
    boolean isOverE = PVector.dot(v, PVector.sub(p, e)) > 0;
    
    if (isOverS) {
        //始点よりも外側にある場合、点pと点sの距離を算出
        return dist(p.x, p.y, s.x, s.y);
    }
    else if (isOverE) {
        //終点よりも外側にある場合、点pと点eの距離を算出
        return dist(p.x, p.y, e.x, e.y);
    }
    else return CalcPointLineDist(p, s, v); //それ以外は点と直線の距離に帰結
}

//2直線L、Mの最短距離計算関数
//点aは直線L上の点
//ベクトルvは直線Lの方向を表す
//点bは直線M上の点
//ベクトルwは直線Mの方向を表す
float CalcLineLineDist(PVector a, PVector v, PVector b, PVector w) {
    //複数利用する内積値とベクトル
    float vv = PVector.dot(v, v);
    float vw = PVector.dot(v, w);
    float ww = PVector.dot(w, w);
    PVector ab = PVector.sub(b, a);
    
    //変数tの算出
    float tDeno = ww * vv - vw * vw;
    float tNume = PVector.dot(v, ab) * vw - PVector.dot(w, ab) * vv;
    float t = tNume / tDeno;
    //直線M上の点Qを算出
    PVector q = PVector.add(b, PVector.mult(w, t));
    
    //変数sの算出
    float s = PVector.dot(v, PVector.add(ab, PVector.mult(w, t))) / vv;
    //直線L上の点Pを算出
    PVector p = PVector.add(a, PVector.mult(v, s));
    
    return dist(p.x, p.y, q.x, q.y);
}