/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MeanWell LRS-350-24 power supply moount
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 9/5/2021
// last update 9/12/21
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 9/5/21	- Mount for powersupply PSMount(), with braces PSMountV2, both for edge mouting to 2020/2040
// 9/11/21	- PSMountV3() for flate mounting to 2040/2020
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <mmax_h.scad>
include <inc/brassinserts.scad>
include <bosl2/std.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
//Use3mmInsert=1;
//LargeInsert=1;
//Use4mmInsert=1;
//Use5mmInsert=1;
Width=10;
Thickness=6.5;
CoverThickness=Thickness-2.5;
ScrewHorzOffset=154.5;
ScrewVertOffset=54.5;
Length1=ScrewHorzOffset+10;
Length2=ScrewVertOffset+10;
LayerThickness=0.4;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

//PSMount();
//PSMountV2();
PSMountV3(3);
translate([0,70,0])
	PSCover();

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module PSCover() {
	difference() {
		union() {
			color("cyan") cuboid([115+CoverThickness*2,40+CoverThickness,CoverThickness],rounding=2,p1=[0,0]);
			color("blue") cuboid([115+CoverThickness*2,CoverThickness,CoverThickness+7],rounding=2,p1=[0,0]);
			color("green") cuboid([CoverThickness,40+CoverThickness,25+CoverThickness],rounding=2,p1=[0,0]);
			translate([115.5+CoverThickness,0,0]) color("plum")
				cuboid([CoverThickness,40+CoverThickness,25+CoverThickness],rounding=2,p1=[0,0]);
		}
		translate([-5,39,17.5+CoverThickness]) color("khaki") rotate([0,90,0]) cylinder(h=160+CoverThickness*2,d=screw4);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PSMountV2() {
	difference() {
		translate([-5,-5,0]) PSBase();
		translate([2,0,0]) PSScrewHoles();
	}
	difference() {
		translate([-5,-50,0]) ExtrusionMount();
		translate([2,0,0]) PSScrewHoles();
	}
	MountSupport();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MountSupport(Screw=screw5) {
	difference() {
		translate([-5,-30,0]) color("lightgray") cuboid([Length1,5,30],rounding=2,p1=[0,0]);
		translate([45,-22,10+Thickness]) color("blue") rotate([90,0,0]) cylinder(h=10,d=Screw);
		translate([Length1-45,-22,10+Thickness]) color("white") rotate([90,0,0]) cylinder(h=10,d=Screw);
		translate([45,-21,10+Thickness]) color("white") rotate([90,0,0]) cylinder(h=5,d=screw5hd);
		translate([Length1-45,-21,10+Thickness]) color("blue") rotate([90,0,0]) cylinder(h=5,d=screw5hd);
	}
	color("blue") hull() {
		translate([4,-30,0]) cuboid([Thickness,5,20],rounding=2,p1=[0,0]);
		translate([4,49,0]) cuboid([Thickness,5,5],rounding=2,p1=[0,0]);
	}
	translate([(ScrewHorzOffset/2)-2,0,0]) color("green") hull() {
		translate([0,-30,0]) cuboid([Thickness,5,20],rounding=2,p1=[0,0]);
		translate([0,49,0]) cuboid([Thickness,5,5],rounding=2,p1=[0,0]);
	}
	translate([ScrewHorzOffset-12,0,0]) color("plum") hull() {
		translate([0,-30,0]) cuboid([Thickness,5,20],rounding=2,p1=[0,0]);
		translate([0,49,0]) cuboid([Thickness,5,5],rounding=2,p1=[0,0]);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PSMountV3(Shift=0) {
	difference() {
		translate([-5,-5,0]) PSBase(0);
		translate([2,0,0]) PSScrewHoles();
	}
	ExtrusionMountEnds(screw5,Shift);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PSMount() {
	difference() {
		translate([-5,-5,0]) PSBase();
		translate([2,0,0]) PSScrewHoles();
	}
	difference() {
		translate([-5,-50,0]) ExtrusionMount();
		translate([2,0,0]) PSScrewHoles();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PSScrewHoles(Screw=screw4+0.2) {
	translate([0,0,-3]) color("red") cylinder(h=10,d=Screw);
	translate([0,49.5,-3]) color("blue") cylinder(h=10,d=Screw);
	translate([149.5,0,-3]) color("white") cylinder(h=10,d=Screw);
	translate([149.5,49.5,-3]) color("plum") cylinder(h=10,d=Screw);
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PSBase(Sides=1) {
	%difference() {
		translate([-26,0,0]) cube([215,10,5]);
		translate([7,5,2]) PSScrewHoles();
	}
	if(Sides) {
		color("khaki") cuboid([Length1,Width,Thickness],rounding=2,p1=[0,0,0]);
		translate([0,ScrewVertOffset,0]) color("pink") cuboid([Length1,Width,Thickness],rounding=2,p1=[0,0,0]);
	}
	translate([0,0,0]) color("lightgray") cuboid([Width+5,Length2,Thickness],rounding=2,p1=[0,0,0]);
	translate([ScrewHorzOffset-5,0,0]) color("gray") cuboid([Width+5,Length2,Thickness],rounding=2,p1=[0,0,0]);
	translate([3,0,0]) color("lightblue") rotate([0,0,18]) cuboid([Length1,Width,Thickness-2.5],rounding=2,p1=[0,0,0]);
	translate([3,ScrewVertOffset,0]) color("lightgreen") rotate([0,0,-18])
		cuboid([Length1,Width,Thickness-2.5],rounding=2,p1=[0,0,0]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtrusionMount(Screw=screw5) {
	//%cuboid([Length1,20,20],p1=[0,0,0]);
	difference() {
		color("red") cuboid([Length1,Width+40,Thickness],rounding=2,p1=[0,0,0]);
		translate([10,10,-3]) color("blue") cylinder(h=10,d=Screw);
		translate([Length1-10,10,-3]) color("white") cylinder(h=10,d=Screw);
		translate([10,10,Thickness-1]) color("white") cylinder(h=5,d=screw5hd);
		translate([Length1-10,10,Thickness-1]) color("blue") cylinder(h=5,d=screw5hd);
		translate([Length1/2,10,-3]) color("gray") cylinder(h=10,d=Screw);
		translate([Length1/2,10,Thickness-1]) color("green") cylinder(h=5,d=screw5hd);
		translate([35,35,Thickness/2]) {
			cyl(l=Thickness+0.5, r=8, rounding1=-2, rounding2=-2, $fa=1, $fs=1);
			translate([30,0,0]) cyl(l=Thickness+0.5, r=8, rounding1=-2, rounding2=-2, $fa=1, $fs=1);
			translate([60,0,0]) cyl(l=Thickness+0.5, r=8, rounding1=-2, rounding2=-2, $fa=1, $fs=1);
			translate([90,0,0]) cyl(l=Thickness+0.5, r=8, rounding1=-2, rounding2=-2, $fa=1, $fs=1);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtrusionMountEnds(Screw=screw5,Shift=0) {
	difference() {
		translate([-45,7-Shift,0]) color("red") cuboid([45,40,Thickness],rounding=2,p1=[0,0,0]);
		translate([-38,17-Shift,-3]) color("blue") cylinder(h=10,d=Screw);
		translate([-38,37-Shift,-3]) color("white") cylinder(h=10,d=Screw);
		translate([-38,17-Shift,Thickness-1]) color("white") cylinder(h=10,d=screw5hd);
		translate([-38,37-Shift,Thickness-1]) color("blue") cylinder(h=10,d=screw5hd);
	}
	difference() {
		translate([Length1-10,7-Shift,0]) color("cyan") cuboid([45,40,Thickness],rounding=2,p1=[0,0,0]);
		translate([Length1+26,17-Shift,-3]) color("white") cylinder(h=10,d=Screw);
		translate([Length1+26,37-Shift,-3]) color("blue") cylinder(h=10,d=Screw);
		translate([Length1+26,17-Shift,Thickness-1]) color("blue") cylinder(h=10,d=screw5hd);
		translate([Length1+26,37-Shift,Thickness-1]) color("white") cylinder(h=10,d=screw5hd);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
