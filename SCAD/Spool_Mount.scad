///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Spool_Sount.scad - mount a spool onto 2020
// created: 1/27/2019
// last modified: 1/4/21
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/27/19	- Mounting a spool to 2020, uses 4 M3x8mm screws, 4 M3 post install nuts, 200mm of 8mm threaded rod,
//			  three M8 nuts, two M8 washers, 20mm of 2020, one M5 insall nut, one M5x5mm or M5x25mm cap screw
// 11/27/20	- Added spacers for the mounting rod for the sppol, since it's longer than needed for my current spools
// 12/26/20	- Added a roller for preventing filament from unspooling
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// uses http://www.thingiverse.com/thing:1647748 to hold the spool
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/cubex.scad>
include <inc/screwsizes.scad>
include <inc/brassinserts.scad>
$fn=100;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Use5mmInsert=1;
clearance = 0.4;
w2020 = 20 + clearance;
outer_w = 28;
length = 60;
Thickness=5;
Diameter608ZZ=22.2;
Layer=0.6;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//spool();
//Spacer(4,25);
//RollerGuide(0,0);
//RollerGuideV2(0,0);
RollerStand(0,0);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RollerStand(Test=0,MountOnly=0) {
	RollerGuideV2(Test,1);
	translate([154,165,0]) rotate([0,0,180]) RollerGuideV2(Test,1);
	translate([0,36,0]) color("plum") cubeX([20,93,Thickness],2);
	translate([134,36,0]) color("pink") cubeX([20,93,Thickness],2);
	translate([135,32,0]) color("black") rotate([0,0,53]) cubeX([10,155,Thickness],2);
	translate([12,40,0]) color("green") rotate([0,0,-53]) cubeX([10,160,Thickness],2);
	if(Test) {
		translate([-Thickness,85,0]) UpperSideMount();
		translate([149+Thickness*2,85,0]) rotate([0,0,180]) UpperSideMount();
	} else {
		translate([150,-40,0]) rotate([0,-90,0]) UpperSideMount();
		translate([-150,200,0]) rotate([0,-90,180]) UpperSideMount();
	}
	difference() {
		translate([0,30,0]) color("red") cubeX([Thickness,105,40],2);
		translate([0,85,0]) UpperScrewMount(Yes5mmInsert(Use5mmInsert));
	}
	difference() {
		translate([149,30,0]) color("blue") cubeX([Thickness,105,40],2);
		translate([145,85,0]) UpperScrewMount(Yes5mmInsert(Use5mmInsert));
	}
	translate([-20,80,10]) SpoolRunner();
	translate([-60,80,10]) SpoolRunner();
	translate([-40,30,10]) SpoolRunner();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RollerGuideV2(Test=0,MountOnly=0) { // something to keep the filament on the reel
	difference() {
		color("cyan") cubeX([154,40,Thickness],2);
		translate([81,0,-2]) ExtrusionMountV2();
		translate([2,0,-2]) ExtrusionMountV2();
	}
	translate([0,20,0]) SideMountV2();
	translate([144+Thickness,20,0]) SideMountV2();
	if(!MountOnly) {
		if(Test)
			translate([10.5+Thickness,10,30])	rotate([0,90,0]) SpoolRunner(); // test fit
		else
			translate([20,80,10]) SpoolRunner();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RollerGuide(Test=0,MountOnly=0) { // something to keep the filament on the reel
	difference() {
		color("cyan") cubeX([154,60,Thickness],2);
		translate([81,0,-2]) ExtrusionMount();
		translate([2,0,-2]) ExtrusionMount();
	}
	translate([0,20,0]) SideMount();
	translate([144+Thickness,20,0]) SideMount();
	if(!MountOnly) {
		if(Test)
			translate([10.5+Thickness,10,30])	rotate([0,90,0]) SpoolRunner(); // test fit
		else
			translate([20,80,10]) SpoolRunner();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtrusionMount() {
	color("red") hull() {
		translate([10,10,0]) cylinder(h=Thickness*2,d=screw5);
		translate([60,10,0]) cylinder(h=Thickness*2,d=screw5);
	}
	color("gray") hull() {
		translate([10,10,6]) cylinder(h=5,d=screw5hd);
		translate([60,10,6]) cylinder(h=5,d=screw5hd);
	}
	translate([0,40,0]) color("blue") hull() {
		translate([10,10,0]) cylinder(h=Thickness*2,d=screw5);
		translate([60,10,0]) cylinder(h=Thickness*2,d=screw5);
	}
	translate([0,40,0]) color("lightgray") hull() {
		translate([10,10,6]) cylinder(h=5,d=screw5hd);
		translate([60,10,6]) cylinder(h=5,d=screw5hd);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtrusionMountV2() {
	color("red") hull() {
		translate([10,10,0]) cylinder(h=Thickness*2,d=screw5);
		translate([60,10,0]) cylinder(h=Thickness*2,d=screw5);
	}
	color("gray") hull() {
		translate([10,10,6]) cylinder(h=5,d=screw5hd);
		translate([60,10,6]) cylinder(h=5,d=screw5hd);
	}
	translate([0,40,0]) color("blue") hull() {
		translate([10,10,0]) cylinder(h=Thickness*2,d=screw5);
		translate([60,10,0]) cylinder(h=Thickness*2,d=screw5);
	}
	translate([0,40,0]) color("lightgray") hull() {
		translate([10,10,6]) cylinder(h=5,d=screw5hd);
		translate([60,10,6]) cylinder(h=5,d=screw5hd);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SideMount() {
	difference() {
		 color("lightgray") hull() {
			translate([0,0,50])cubeX([Thickness,20,1],2);
			translate([0,-20,3])cubeX([Thickness,60,1],2);
		}
		translate([-3,10,30]) color("gray") rotate([0,90,0]) cylinder(h=Thickness*2,d=screw8);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SideMountV2() {
	difference() {
		 color("lightgray") hull() {
			translate([0,0,30]) rotate([0,90,0]) cylinder(h=Thickness,d=Diameter608ZZ+5);;
			translate([0,-20,3]) cube([Thickness,40,1]);
		}
		translate([-3,0,30]) color("gray") rotate([0,90,0]) cylinder(h=Thickness*2,d=screw8);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module UpperSideMount() {
	difference() {
		color("gray") hull() {
			translate([0,0,280]) rotate([0,90,0]) cylinder(h=Thickness,d=Diameter608ZZ+5);;
			translate([0,-30,3]) cubeX([Thickness,60,1],2);
		}
		color("white") hull() {
			translate([-3,0,280]) rotate([0,90,0]) cylinder(h=Thickness*2,d=screw8);
			translate([-3,0,100]) rotate([0,90,0]) cylinder(h=Thickness*2,d=screw8);
		}
		UpperScrewMount(screw5);
	}
	difference() {
		translate([Thickness,0,0]) color("white") hull() {
			translate([-4,0,280]) rotate([0,90,0]) cylinder(h=Thickness+1,d=Diameter608ZZ);
			translate([-4,0,100]) rotate([0,90,0]) cylinder(h=Thickness+1,d=Diameter608ZZ);
		}
		color("black") hull() {
			translate([Thickness-5,0,280]) rotate([0,90,0]) cylinder(h=Thickness*3,d=screw8);
			translate([Thickness-5,0,100]) rotate([0,90,0]) cylinder(h=Thickness*3,d=screw8);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module UpperScrewMount(Screw=screw5) {
	translate([-2,0,10]) color("red") rotate([0,90,0]) cylinder(h=Thickness*3,d=Screw);
	translate([-2,0,30]) color("blue") rotate([0,90,0]) cylinder(h=Thickness*3,d=Screw);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SpoolBearing(Top=0) {
	union() {
		difference() {
			color("plum") cylinder(h=10,d=Diameter608ZZ+5);
			translate([0,0,-4]) color("pink") cylinder(h=20,d=Diameter608ZZ);
		}
		translate([0,0,10]) difference() {
			color("cyan") cylinder(h=Thickness,r1=(Diameter608ZZ+5)/2,r2=(Diameter608ZZ+2)/2);
			translate([0,0,-3]) color("red") cylinder(h=Thickness*2,d=screw8+1);
		}
	}
	if(Top) translate([0,0,10]) color("black") cylinder(h=Layer,d=Diameter608ZZ);

}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SpoolRunner() {
	union() {
		difference() {
			union() {
				color("gray") cylinder(h=60,r1=screw8+3,r2=screw8+10);
				translate([0,0,60]) color("green") cylinder(h=60,r1=screw8+10,r2=screw8+3);
			}
			translate([0,0,-10]) color("blue") cylinder(h=150,d=screw8+1);
		}
		translate([0,0,-10]) SpoolBearing(1);
		translate([0,0,130]) rotate([0,180,0]) SpoolBearing();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Spacer(Quanity=1,Length=50) {
	for(x = [0:Quanity-1]) {
		translate([x*15,0,0]) difference() {
			color("cyan") cylinder(h=Length,d=screw8*1.5);
			translate([0,0,-5]) color("red") cylinder(h=Length+10,d=screw8+0.5);
		}
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module spool() {
	frame_mount();
	rod_mount();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module rod_mount() {
	difference() {
		translate([length/2,outer_w,outer_w]) rotate([90,0,0]) color("cyan") cylinder(h=outer_w,d=30);
		spool_screw_hole();
		notch_2020();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module spool_screw_hole() {
	translate([length/2,outer_w+2,outer_w]) rotate([90,0,0]) color("blue") cylinder(h=outer_w+5,d=screw8);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module frame_mount() {
	difference() {
		color("lightgrey") cubeX([length,outer_w,outer_w],2); 
		notch_2020();
		spool_screw_hole();
		mount_2020();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module mount_2020() {
	translate([15,outer_w+3,10]) color("plum") rotate([90,0,0]) cylinder(h=outer_w+5,d=screw3);
	translate([45,outer_w+3,10]) color("yellow") rotate([90,0,0]) cylinder(h=outer_w+5,d=screw3);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module notch_2020() {
	translate([-2,(outer_w-w2020)/2,-5+clearance]) color("red") cube([length+5,w2020,25],2);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
