/*
最短距離算出関数をまとめたファイルです
参考文献：http://marupeke296.com/COL_3D_No27_CapsuleCapsule.html
*/

//点から直線までの最短距離計算関数
//pは点、lpは直線状の点、vは直線の方向ベクトル
//返り値は、{点と直線の最短距離、媒介変数t}の順で格納された配列
float[] CalcPointLineDist(PVector p, PVector lp, PVector v) {
    float denominator = PVector.dot(v, v);
    float numerator = PVector.dot(v, p) - PVector.dot(v, lp);
    float t = numerator / denominator;
    PVector h = PVector.add(lp, PVector.mult(v, t));
    float[] returnItems = {dist(p.x, p.y, h.x, h.y), t};
    return returnItems;
}

//点から線分までの最短距離計算関数
//pは点、sは線分の始点、eは線分の終点
//返り値は、{点と線分の最短距離、媒介変数t}の順で格納された配列
float[] CalcPointSegmentDist(PVector p, PVector s, PVector e) {
    PVector v = PVector.sub(e, s);
    
    float[] plDistItems = CalcPointLineDist(p, s, v);
    
    if (plDistItems[1] < 0.0) {
        //始点よりも外側にある場合、点pと点sの距離を算出
        plDistItems[0] = dist(p.x, p.y, s.x, s.y);  //距離
        plDistItems[1] = 0;     //媒介変数t
    }
    else if (plDistItems[1] > 1.0) {
        //終点よりも外側にある場合、点pと点eの距離を算出
        plDistItems[0] = dist(p.x, p.y, e.x, e.y);  //距離
        plDistItems[1] = 1.0;   //媒介変数t
    }
    
    return plDistItems;
}

//2直線L、Mの最短距離計算関数
//点aは直線L上の点
//ベクトルvは直線Lの方向を表す
//点bは直線M上の点
//ベクトルwは直線Mの方向を表す
//返り値は、{直線と直線の最短距離、媒介変数s、媒介変数t}の順で格納された配列
float[] CalcLineLineDist(PVector a, PVector v, PVector b, PVector w) {
    //複数回利用する内積値とベクトル    
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
    
    float[] returnItems = {dist(p.x, p.y, q.x, q.y), s, t};
    
    return returnItems;
}

//2線分AB、CDの最短距離計算関数
//それぞれの引数は線分の端点
//返り値は、{直線と直線の最短距離、媒介変数s、媒介変数t}の順で格納された配列
float[] CalcSegmentSegmentDist(PVector a, PVector b, PVector c, PVector d) {
    var v = PVector.sub(b, a);
    var w = PVector.sub(d, c);
    float[] llDistItems = CalcLineLineDist(a, v, c, w);
    float dist = llDistItems[0];
    float s = llDistItems[1];
    float t = llDistItems[2];
    
    //垂線が両線分の間にある
    if ((0.0 <= s && s <= 1.0) && (0.0 <= t && t <= 1.0)) {
        return llDistItems;
    }
    
    //垂線の足が外にある事が判明
    //sを0～1の間にクランプして線分CDに垂線を降ろす
    println("calc" + 1);
    s = constrain(s, 0.0, 1.0);
    PVector p = PVector.add(a, PVector.mult(v, s)); //点Pを計算
    float[] plDistItems = CalcPointLineDist(p, c, w);    //最短距離を計算しなおし
    t = plDistItems[1];
    if (0.0 <= t && t <= 1.0) {
        float[] returnItems = {plDistItems[0], s, t};
        return returnItems;
    }
    
    //tを0～1の間にクランプして線分ABに垂線を降ろす
    println("calc" + 2);
    t = constrain(t, 0.0, 1.0);
    PVector q = PVector.add(c, PVector.mult(w, t)); //点Qを計算
    plDistItems = CalcPointLineDist(q, a, v);    //最短距離を計算しなおし
    s = plDistItems[1];
    if (0.0 <= s && s <= 1.0) {
        float[] returnItems = {plDistItems[0], s, t};
        return returnItems;
    }
    
    // 双方の端点が最短と判明
    println("calc" + 3);
    s = constrain(s, 0.0, 1.0);
    p = PVector.add(a, PVector.mult(v, s));
    float[] returnItems = {dist(p.x, p.y, q.x, q.y), s, t};
    return returnItems;
}