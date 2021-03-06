SetFactory("OpenCASCADE");

lc=30;
lcmin=5;
zmin=-0.5;
z_length=1;
xmin=0;
xmax=2000;
ymin=-1000;
ymax=0;
depth_lake=800;
width_lake=1000;
x0_well=800;
width_well=50;
depth_well=900;

Point(1)={xmin, ymin, zmin,lc};
Point(2)={xmax, ymin, zmin,lc};
Point(3)={xmax, ymax, zmin,lc};
Point(4)={xmin, ymax, zmin,lc};
Point(5)={xmax, ymax-depth_lake, zmin, lc};
Point(6)={xmax-width_lake, ymax, zmin, lc};
Point(7)={x0_well - width_well/2, ymax, zmin, lc};
Point(8)={x0_well + width_well/2, ymax, zmin, lc};
Point(9)={x0_well - width_well/2, ymax-depth_well, zmin, lc};
Point(10)={x0_well + width_well/2, ymax-depth_well, zmin, lc};

Line(1) = {4, 1};
Line(2) = {1, 2};
Line(3) = {2, 5};
Line(4) = {5, 3};
Line(5) = {3, 6};
Line(6) = {5, 6};
Line(7) = {6, 8};
Line(8) = {8, 10};
Line(9) = {10, 9};
Line(10) = {9, 7};
Line(11) = {7, 8};
Line(12) = {7, 4};
Curve Loop(1) = {5, -6, 4};
Plane Surface(1) = {1};
Curve Loop(2) = {7, 8, 9, 10, 12, 1, 2, 3, 6};
Plane Surface(2) = {2};
Curve Loop(3) = {8, 9, 10, 11};
Plane Surface(3) = {3};

//refine
x0=x0_well;
Point(2000) = {x0, ymin, zmin, lc};
Point(2001) = {x0, ymax, zmin, lc};
Line(2000)={2000,2001};
y0=-675;
Point(3000) = {xmin, y0, zmin, lc};
Point(3001) = {xmax, y0, zmin, lc};
Line(3000)={3000,3001};
Field[1] = Attractor;
Field[1].NNodesByEdge = 400;
Field[1].EdgesList = {2000, 3000};
Field[2] = Threshold;
Field[2].IField = 1;
Field[2].LcMin = lcmin; 
Field[2].LcMax = lc/2;
Field[2].DistMin = width_well*1.5;
Field[2].DistMax = width_well*3;
// // ---
// Field[3] = Attractor;
// Field[3].NNodesByEdge = 400;
// Field[3].EdgesList = {16, 3, 8, 9, 14, 12, 10, 20, 23, 24};
// Field[4] = Threshold;
// Field[4].IField = 3;
// Field[4].LcMin = lcmin; // minimum cell size is 2m
// Field[4].LcMax = lc;
// Field[4].DistMin = 200;
// Field[4].DistMax = 500;

Field[7] = Min;
Field[7].FieldsList = {2};
Background Field = 7;

Extrude {0, 0, z_length} {
Surface{1:3};
Layers{1};
Recombine;
}

v_crust={2};
v_lake={1};
v_well={3};
s_frontAndBack={1:3, 16, 18, 7};
s_wall={13, 15, 6};
s_bottom={14};
s_top={4, 8, 17, 12};

// // refine 
// s()=Unique(Abs(Boundary{ Volume{v_crust[]}; }));
// l() = Unique(Abs(Boundary{ Surface{s()}; }));
// p[] = Unique(Abs(Boundary{ Line{l()}; }));
// Characteristic Length{p()} = lc;

Physical Volume("crust") = {v_crust[]};
Physical Volume("lake") = {v_lake[]};
Physical Volume("well") = {v_well[]};
Physical Surface("frontAndBack") = {s_frontAndBack[]};
Physical Surface("sidewalls") = {s_wall[]};
Physical Surface("bottom") = {s_bottom[]};
Physical Surface("top") = {s_top[]};

Color Black{Volume{v_crust[]};}
Color Blue{Volume{v_lake[]};}
Color Orange{Volume{v_well[]};}
Color Gray{Surface{s_frontAndBack[]};}
Color Pink{Surface{s_bottom[]};}
Color Blue{Surface{s_top[]};}
Color Green{Surface{s_wall[]};}