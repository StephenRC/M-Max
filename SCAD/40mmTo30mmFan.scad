/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 40mmTo30mmFan.scad
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 2/7/21
// last update 2/14/21
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 2/11/21	- Added an offset fan adapter
// 2/14/21	- Added an angled fan adapter
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <inc/cubex.scad>
include <inc/brassinserts.scad>
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
40mmOffset=33;
30mmOffset=24;
40mmFanDiameter=40;
30mmFanDiameter=30;
40mmScrewOffset=3;
30mmScrewOffset=7.9;
LayerHeight=0.3;
Use3mmInsert=1;
LargeInsert=0;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//rotate([180,0,0]) FanAdapter();
// rotate([180,0,0]) FanAdapterWithOffset();
FanAdapterWithOffsetAngled();
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanAdapter(Thickness=5) {
	difference() {
		color("cyan") hull() {
			cubeX([40mmFanDiameter,40mmFanDiameter,1],2);
			translate([(40mmFanDiameter-30mmFanDiameter)/2,(40mmFanDiameter-30mmFanDiameter)/2,-Thickness])
				cubeX([30mmFanDiameter,30mmFanDiameter,1],2);
		}
		40mmMount(Thickness);
		30mmMount(Thickness);
		FanHole(Thickness);
	}
	SupportFor30mmMount(Thickness);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanAdapterWithOffset(Thickness=5) {
	difference() {
		color("cyan") hull() {
			cubeX([40mmFanDiameter,40mmFanDiameter,1],2);
			translate([-5,(40mmFanDiameter-30mmFanDiameter)/2,-Thickness])
				cubeX([30mmFanDiameter,30mmFanDiameter,1],2);
		}
		40mmMount(Thickness);
		translate([-10,0,0]) 30mmMount(Thickness);
		FanHoleWithOffset(Thickness);
	}
	SupportFor30mmMountWithOffset(Thickness);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanAdapterWithOffsetAngled(Thickness=10) {
	difference() {
		color("cyan") hull() {
			translate([-7,0,0]) rotate([0,-30,0]) cubeX([40mmFanDiameter,40mmFanDiameter,1],2);
			translate([-5,(40mmFanDiameter-30mmFanDiameter)/2,-Thickness-3])
				cubeX([30mmFanDiameter,30mmFanDiameter,8],2);
		}
		translate([-18,0.5,20]) rotate([0,-30,0]) 40mmMount(Thickness);
		translate([-10,0,2]) 30mmMountV2(Thickness);
		FanHoleWithOffsetV2(Thickness);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module 40mmMount(Thickness) {
	translate([40mmScrewOffset,40mmScrewOffset,-Thickness*2.5]) color("red")
		cylinder(h=Thickness*4,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
	translate([40mmScrewOffset+40mmOffset,40mmScrewOffset,-Thickness*2.5]) color("blue")
		cylinder(h=Thickness*4,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
	translate([40mmScrewOffset+40mmOffset,40mmScrewOffset+40mmOffset,-Thickness*2.5]) color("plum")
		cylinder(h=Thickness*4,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
	translate([40mmScrewOffset,40mmScrewOffset+40mmOffset,-Thickness*2.5]) color("black")
		cylinder(h=Thickness*4,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module 30mmMount(Thickness) {
	translate([30mmScrewOffset,30mmScrewOffset,-Thickness*2.5]) color("red") cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset,-Thickness*2.5]) color("lightgray") cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset+30mmOffset,-Thickness*2.5]) color("plum")
		cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset,30mmScrewOffset+30mmOffset,-Thickness*2.5]) color("black") cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset,30mmScrewOffset,-Thickness]) color("black") cylinder(h=Thickness*4,d=screw3hd);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset,-Thickness-1]) color("plum") cylinder(h=Thickness*4,d=screw3hd);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset+30mmOffset,-Thickness-1]) color("red")
		cylinder(h=Thickness*4,d=screw3hd);
	translate([30mmScrewOffset,30mmScrewOffset+30mmOffset,-Thickness]) color("white") cylinder(h=Thickness*4,d=screw3hd);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset,-Thickness]) color("plum") cylinder(h=Thickness*7,d=screw3hd);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset+30mmOffset,-Thickness]) color("plum")
		cylinder(h=Thickness*8,d=screw3hd);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module 30mmMountV2(Thickness) {
	translate([30mmScrewOffset,30mmScrewOffset,-Thickness*2.5]) color("red") cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset,-Thickness*2.5]) color("lightgray") cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset+30mmOffset,-Thickness*2.5]) color("plum")
		cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset,30mmScrewOffset+30mmOffset,-Thickness*2.5]) color("black") cylinder(h=Thickness*4,d=screw3);
	translate([30mmScrewOffset,30mmScrewOffset,-Thickness+5]) color("black") cylinder(h=Thickness*4,d=screw3hd);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset,-Thickness+5]) color("plum") cylinder(h=Thickness*4,d=screw3hd);
	translate([30mmScrewOffset,30mmScrewOffset+30mmOffset,-Thickness+5]) color("white") cylinder(h=Thickness*7,d=screw3hd);
	translate([30mmScrewOffset+30mmOffset,30mmScrewOffset+30mmOffset,-Thickness+5]) color("red")
		cylinder(h=Thickness*8,d=screw3hd);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanHole(Thickness) {
	color("blue") hull() {
		translate([20,20,Thickness+2]) cylinder(h=1,d=39);
		translate([20,20,-Thickness-5]) cylinder(h=1,d=27);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanHoleWithOffset(Thickness) {
	color("blue") hull() {
		translate([20.5,20,Thickness-1]) cylinder(h=1,d=36);
		translate([9.5,20,-Thickness-4]) cylinder(h=1,d=25);
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanHoleWithOffsetV2(Thickness) {
	color("blue") hull() {
		translate([8,20,Thickness+9]) rotate([0,-30,0]) cylinder(h=1,d=36);
		translate([10,19.8,-Thickness-4]) cylinder(h=1,d=25.5);
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SupportFor30mmMount(Thickness) {
	difference() {
		translate([30mmScrewOffset*2.5,30mmScrewOffset*2.5,-Thickness]) color("gray")
			cylinder(h=LayerHeight,d=30mmFanDiameter+11);
		translate([0,0,-Thickness*2]) rotate([45,0,0]) color("pink") cube([40mmFanDiameter,7,7]);
		translate([0,40,-Thickness*2]) rotate([45,0,0]) color("lightgray") cube([40mmFanDiameter,7,7]);
		translate([-5,0,-Thickness*1]) rotate([0,45,0]) color("purple") cube([7,40mmFanDiameter,7]);
		translate([35,0,-Thickness*1]) rotate([0,45,0]) color("khaki") cube([7,40mmFanDiameter,7]);
		FanHole(Thickness);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SupportFor30mmMountWithOffset(Thickness) {
	difference() {
		translate([10,30mmScrewOffset*2.5,-Thickness-LayerHeight-1]) color("gray") cylinder(h=LayerHeight,d=30mmFanDiameter+11);
		translate([-5,1,-Thickness*2-2]) rotate([45,0,0]) color("pink") cube([40mmFanDiameter,7,7]);
		translate([-5,39,-Thickness*2-2]) rotate([45,0,0]) color("lightgray") cube([40mmFanDiameter,7,7]);
		translate([-10.6,0,-Thickness*1.5]) color("purple") cube([7,40mmFanDiameter,7]);
		translate([25,0,-Thickness]) rotate([0,45,0]) color("khaki") cube([7,40mmFanDiameter,7]);
		FanHoleWithOffset(Thickness);
		40mmMount(Thickness);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
