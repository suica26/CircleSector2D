/*
グローバル変数記述用ファイル








*/

ArrayList<MyObject> objects = new ArrayList<MyObject>();            //オブジェクトリスト
ArrayList<Sector2D> sectors = new ArrayList<Sector2D>();            //扇形オブジェクトリスト
ArrayList<MyBox> boxes = new ArrayList<MyBox>();                    //長方形オブジェクトリスト
ArrayList<MyCircle> circles = new ArrayList<MyCircle>();            //円形オブジェクトリスト
ArrayList<MyObject> movingObjects = new ArrayList<MyObject>();      //動くオブジェクトリスト
ArrayList<MyObject> rotatingObjects = new ArrayList<MyObject>();    //回転するオブジェクトリスト
ArrayList<PVector> moveVec = new ArrayList<PVector>();              //オブジェクトの速さリスト
FloatList rotVec = new FloatList();                                 //オブジェクトの角速度リスト
ArrayList<PVector> latticePoints = new ArrayList<PVector>();        //扇形範囲確認用の格子点リスト
float epsilon = 0.01;                                               //計算誤差補正値
float s,t;                                                          //扇形のパラメトリック表現用の変数
float velocity = 5.0;                                               //動くオブジェクトの移動速度
boolean moveFlg = true;                                             //オブジェクト動作停止用フラグ
int ls = 50;                                                        //格子のサイズ
boolean display = true;                                             //描画切り替えフラグ
MyBox willRotateBox;                                                //回転前長方形
MyBox RotatedBox;                                                   //回転後長方形
PVector[] AABBpoints = new PVector[8];                              //AABB計算用頂点
MyBox AABB;                                                         //AABBボックス

Sector2D sector;