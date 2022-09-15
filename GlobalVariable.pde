/*
グローバル変数記述用ファイル








*/

ArrayList<MyObject> objects = new ArrayList<MyObject>();            //オブジェクトリスト
ArrayList<Sector2D> sectors = new ArrayList<Sector2D>();            //扇形オブジェクトリスト
ArrayList<MyBox> boxes = new ArrayList<MyBox>();                    //長方形オブジェクトリスト
ArrayList<MyCircle> circles = new ArrayList<MyCircle>();            //円形オブジェクトリスト
PVector currentFillColor = new PVector();                           //直近のfillに設定した色
float epsilon = 0.01;                                               //計算誤差補正値
float s,t;                                                          //扇形のパラメトリック表現用の変数
boolean display = true;                                             //描画切り替えフラグ
PVector[] AABBpoints = new PVector[8];                              //AABB計算用頂点
MyBox AABB;                                                         //AABBボックス

Sector2D sector;
MyBox box;
MyCircle circle;