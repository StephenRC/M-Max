///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Y Makerslide Mounts - mount the Y makerslides to the frame
// created: 10/13/2016
// last modified: 9/2/2018
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 9/2/18	- Added a flat version of the ms_ends()
//////////////////////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <inc/screwsizes.scad>
$fn=100;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// variables
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Width = 170;
Height = 120;
Thickness = 5;
OffsetX = 150;	// hole distance between the two plates
OffsetY = 100;	// hole distance on the plate
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

ms_ends(1);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module cubeX(size,Rounding) { // temp module
	cuboid(size,rounding=Rounding,p1=[0,0]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ms_ends(Flat=0) {
	//if($preview) %translate([-50,-50,-5]) cube([200,200,5]);
	y_slide_end(Flat);
	translate([42,0,0]) y_slide_end(Flat);
	translate([42,42,0]) y_slide_end(Flat);
	translate([0,42,0]) y_slide_end(Flat);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module y_slide_end(Flat=0) {
	if(!Flat) {
		difference() {
			color("cyan") cubeX([20,40,Thickness-1],2);
			translate([10,10,-1]) color("red") cylinder(h=Thickness*2,d=screw5);
			translate([10,10,Thickness-1.5]) color("white") cylinder(h=Thickness*2,d=screw5hd);
			translate([10,30,-1]) color("blue") cylinder(h=Thickness*2,d=screw5);
			translate([10,30,Thickness-1.5]) color("gray") cylinder(h=Thickness*2,d=screw5hd);
		}
		difference() {
			color("salmon") cubeX([Thickness-1,40,25],2);
			translate([-1,10,15]) rotate([0,90,0]) color("red") cylinder(h=Thickness*2,d=screw5);
			translate([Thickness-1.5,10,15]) rotate([0,90,0]) color("white") cylinder(h=Thickness*2,d=screw5hd);
			translate([-1,30,15]) rotate([0,90,0]) color("blue") cylinder(h=Thickness*2,d=screw5);
			translate([Thickness-1.5,30,15]) rotate([0,90,0]) color("gray") cylinder(h=Thickness*2,d=screw5hd);
		}
		translate([0,0,0]) support();
		translate([0,18,0]) support();
		translate([0,36,0]) support();
	} else {
		difference() {
			color("cyan") cubeX([40,40,Thickness-1],2);
			translate([10,10,-1]) color("red") cylinder(h=Thickness*2,d=screw5);
			translate([10,10,Thickness-1.5]) color("white") cylinder(h=Thickness*2,d=screw5hd);
			translate([30,10,-1]) color("blue") cylinder(h=Thickness*2,d=screw5);
			translate([30,10,Thickness-1.5]) color("gray") cylinder(h=Thickness*2,d=screw5hd);
			translate([10,30,-1]) color("gray") cylinder(h=Thickness*2,d=screw5);
			translate([10,30,Thickness-1.5]) color("black") cylinder(h=Thickness*2,d=screw5hd);
			translate([30,30,-1]) color("black") cylinder(h=Thickness*2,d=screw5);
			translate([30,30,Thickness-1.5]) color("plum") cylinder(h=Thickness*2,d=screw5hd);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module support() {
	difference() {
		translate([5,0,5]) rotate([0,90,90]) color("green") cylinder(h=Thickness-1,d=25,$fn=100);
		translate([-5,-0.5,-48]) color("gray") cube([50,Thickness+1,50]);
		translate([-48,-0.5,-5]) color("yellow") cube([50,Thickness+1,50]);
	}
}

////////////////////// end of y-carriage.scad //////////////////////////////////////////////////////////////////
