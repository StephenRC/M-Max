/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FanDuct_v3.scad - nozzle to put on a 5510 blower fan outlet
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created 8/10/2019
// last upate 1/6/22
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/10/19	- Created fan duct of my own design
// 8/12/19	- Added ability to set length
// 8/27/19	- Crerated v3 with a taper next to the fan to claer the mount better
// 1/6/22	- BOSL2
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
clearance=0.10;
WallThickness=1;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//FanDuct_v2(65);
FanDuct_v3(65);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuct_v2(Length=50) {
	difference() {
		color("cyan") hull() {
			FanDuct_Base();
			FanDuct_Outlet(Length);
		}
		FanDuct_Interior(Length);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuct_v3(Length=50) {
	difference() {
		union() {
			FanDuct_Base_v3();
			FanDuct_Outlet_v3(Length);
		}
		FanDuct_Interior_v3(Length);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuct_Base_v3() {
	//echo(parent_module(0));
	color("plum") hull() {
		cuboid([15.2+(WallThickness+clearance)*2,20+(WallThickness+clearance)*2,3],rounding=1,p1=[0,0]);
		translate([0,0,5]) cuboid([15.2+(WallThickness+clearance)*2,10+(WallThickness+clearance)*2,3],rounding=1,p1=[0,0]);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuct_Outlet_v3(Length) {
	//echo(parent_module(0));
	color("cyan") hull() {
		translate([5,5,Length-5]) rotate([60,0,0])
			cuboid([5.2+(WallThickness+clearance)*2,5+(WallThickness+clearance)*2,3,2],rounding=1,p1=[0,0]);
		translate([0,0,5]) cuboid([15.2+(WallThickness+clearance)*2,10+(WallThickness+clearance)*2,3],rounding=1,p1=[0,0]);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuct_Base() {
	//echo(parent_module(0));
	cube([15.2+(WallThickness+clearance)*2,20+(WallThickness+clearance)*2,3]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuct_Outlet(Length) {
	//echo(parent_module(0));
	translate([5,5,Length-5]) rotate([30,0,0]) 
		cuboid([5.2+(WallThickness+clearance)*2,3+(WallThickness+clearance)*2,3,2],rounding=1,p1=[0,0]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuct_Interior(Length) {
	//echo(parent_module(0));
	color("blue") hull() {
		translate([WallThickness+5,WallThickness+6.2,Length-4]) rotate([30,0,0]) color("blue")
			cuboid([5.2+(clearance)*2,2+(clearance)*2,5],rounding=1,p1=[0,0]);
		translate([WallThickness,WallThickness,-2]) color("blue") 
			cuboid([15.2+(clearance)*2,20+(clearance)*2,5],rounding=1,p1=[0,0]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuct_Interior_v3(Length) {
	//echo(parent_module(0));
	color("blue") hull() {
		translate([WallThickness+5,WallThickness+3.4,Length]) rotate([60,0,0]) color("blue")
			cuboid([5.2+(clearance)*2,4+(clearance)*2,1],rounding=0.5,p1=[0,0]);
		translate([WallThickness,WallThickness,-2]) color("blue") 
			cuboid([15.2+(clearance)*2,10+(clearance)*2,5],rounding=0.5,p1=[0,0]);
	}
	translate([0,0,-1]) color("red") hull() {
		translate([WallThickness+0.8,WallThickness+6,9]) rotate([-30,0,0])
			cuboid([14-(clearance),14.5+(clearance)*2,1],rounding=0.5,p1=[0,0]);
		translate([WallThickness,WallThickness+10,-2]) cuboid([15+(clearance)*4,10+(clearance)*2,5],rounding=0.5,p1=[0,0]);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
