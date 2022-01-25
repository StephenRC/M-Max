////////////////////////////////////////////////////////////////////////////////////////
// Endstops.scad
//////////////////////////////////////////////////////////////////////////////////////////
// created 12/10/20
// last update 1/6/22
//////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 12/10/20	- Put endstops into a seperate file
// 2/20/21	- Added a 2020 X endstop mount
// 1/6/22	- BOSL2
/////////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <inc/NEMA17.scad>
include <inc/brassinserts.scad>
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
Use2mmInsert=1;
Use3mmInsert=1;
Use5mmInsert=1;
LargeInsert=1;
//---------------------------------------------
Switch_ht=20;	// height of holder
Switch_thk=4;	// thickness of holder
Switch_thk2=7;	// thickness of spacer
HolderWidth=34;	// width of holder
SwitchShift=6;	// move switch mounting holes along width
LayerThickness=0.3;
TextFont="AdLib BT:style=Regular"; // "StarTrek Film BT:style=Regular";
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//XEndStop(10,0,8,Yes2mmInsert(Use2mmInsert),8,0); // black microswitch inline mount
//XEndStop(9.7,0,8,Yes2mmInsert(Use2mmInsert),8,0); // green microswitch inline mount
//XEndStop(22,10,8,Yes3mmInsert(Use3mmInsert,LargeInsert),screw5,11.5); // CN0097
//XEndStopV2(9.7,0,0,Yes2mmInsert(Use2mmInsert),8,0); // green microswitch inline mount
//XEndStopV2(10,0,8,screw2,8,0); // black microswitch inline mount
XEndStop2020(9.7,0,8,Yes2mmInsert(Use2mmInsert)); // green microswitch inline mount
//XEndStop2020(22,10,8,Yes3mmInsert(Use3mmInsert,LargeInsert)); // CN0097
//XEndStop2020(10,0,8,Yes2mmInsert(Use2mmInsert)); // black microswitch inline mount
//XEndStopV2(22,10,8,Yes3mmInsert(Use3mmInsert,LargeInsert),8,0); // CN0097
//YEndStop(9.7,0,8,Yes2mmInsert(Use2mmInsert),screw5,2.3,1); // green microswitch
//YEndStop(10,0,8,Yes2mmInsert(Use2mmInsert),screw5,2.3,1); // Black microswitch
//YEndStop(22,10,8,Yes3mmInsert(Use3mmInsert,LargeInsert),screw5,11.5); // CN0097
//YEndStopMS(9.7,0,8,Yes2mmInsert(Use2mmInsert),2.3,1); // green microswitch
translate([40,9,2.5])
	YEndStopMS(10,0,8,Yes2mmInsert(Use2mmInsert),11.5); // black microswitch
//translate([0,25,0])
//	YEndStopStrike();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module YEndStopMS(Sep,DiagOffset,Offset,ScrewS=Yes2mmInsert(Use2mmInsert),Adjust=0,Thickness=Switch_thk2) {
	difference() {
		if(DiagOffset) translate([7,7,0]) color("cyan") cuboid([33,35,5],rounding=2);
		else color("cyan") cuboid([25,20,5],rounding=2);
		if(DiagOffset) {
			color("red") cyl(h=20,d=screw5);
			translate([0,0,4]) color("blue") cyl(h=5,d=screw5hd);
		} else {
			translate([-4,0,0]) color("red") cyl(h=20,d=screw5);
			translate([-4,0,4]) color("blue") cyl(h=5,d=screw5hd);
		}
		translate([8, SwitchShift-11,-1]) color("purple") cyl(h = 20, d=ScrewS);
		translate([8+DiagOffset, SwitchShift+Sep-11,-1]) color("black") cyl(h = 20, d=ScrewS);
	}
	translate([2,-1,2]) printchar("Y");
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module YEndStopStrike(Screw=Yes5mmInsert(Use5mmInsert)) {
	difference() {
		color("cyan") cuboid([20,20,5],rounding=1);
		color("red") cyl(h=20,d=Screw);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XEndStop2020(Sep,DiagOffset,Offset,ScrewS,Adjust=0,Thickness=Switch_thk2) {
	difference() {
		if(Sep>20) color("cyan") cuboid([20,32,Switch_thk2],rounding=2,p1=[0,0]);
		else color("cyan") cuboid([20,20,Switch_thk2],rounding=2,p1=[0,0]);
		translate([10,10,-1])  color("red") cylinder(h=Thickness*2,d=screw5);
		translate([10,10,Thickness-3])  color("green") cylinder(h=5,d=screw5hd);
		translate([4, SwitchShift-1,-1]) color("purple") cylinder(h = 11, d=ScrewS);
		translate([4+DiagOffset, SwitchShift+Sep-1,-1]) color("black") cylinder(h = 11, d=ScrewS);
	}
	translate([14,2,6.5]) printchar("X");
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module YEndStop(Sep,DiagOffset,Offset,ScrewS,ScrewM=screw5,Adjust,MS=0) {
	difference() {
		union() {
			color("red") cuboid([22,33,5],rounding=2,p1=[0,0]);
			color("purple") cuboid([5,20,17+Adjust],rounding=2,p1=[0,0]);
		}
		YEndStopExtrusionMountingHole(Sep,DiagOffset,Offset,ScrewS,ScrewM,Adjust);
		if(MS) translate([-10,-2,0]) rotate([0,45,0]) color("black") cube([10,40,10]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module YEndStopExtrusionMountingHole(Sep,DiagOffset,Offset,ScrewS,ScrewM,Adjust) {
	translate([12,8,-2]) color("white") cylinder(h=10,d=ScrewM);
	translate([0,-1,0]) EndStopScrewHoles(Sep,DiagOffset,Offset,ScrewS,Adjust);
	translate([12,23,-2]) color("cyan") cylinder(h=10,d=ScrewM);
	translate([0,-1,0]) EndStopScrewHoles(Sep,DiagOffset,Offset,ScrewS,Adjust);
	if(ScrewM==screw5) {
		translate([12,8,4]) color("cyan") cylinder(h=8,d=screw5hd);
		translate([12,23,4]) color("pink") cylinder(h=8,d=screw5hd);
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module EndStopScrewHoles(Sep,DiagOffset,Offset,ScrewT,Adjust) {
	// screw holes for switch
	translate([0,0,Adjust]) {
		rotate([0,90,0]) {		
			translate([-(Switch_ht-Offset), SwitchShift, -2]) {
				color("purple") cylinder(h = 11, r = ScrewT/2, center = false, $fn=100);
			}
		}
		rotate([0,90,0]) {
			translate(v = [-(Switch_ht-Offset)+DiagOffset, SwitchShift+Sep, -2]) {
				color("black") cylinder(h = 11, r = ScrewT/2, center = false, $fn=100);
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module XEndStop(Sep,DiagOffset,Offset,ScrewS,Adjust,Side) {
	base(Sep,DiagOffset,Offset,ScrewS,Adjust);
	mount(screw5,Side);
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module XEndStopV2(Sep,DiagOffset,Offset,ScrewS,Adjust,Side) {
	baseV2(Sep,DiagOffset,Offset,ScrewS,Adjust);
	mount(screw5,Side);
}

////////////////////////////////////////////////////////////////////////////////

module mount(Screw=screw5,Side=0) {
	difference() {
		union() {
			color("cyan") cuboid([22,HolderWidth,Switch_thk2],rounding=2,p1=[0,0]);
			if(Side==0) translate([Screw/2-3,23,Switch_thk2-1]) color("red") 
					cuboid([22,6,2],rounding=2,p1=[0,0]); // slot align
			if(Side==1) translate([Screw/2-3,3,Switch_thk2-1]) color("blue")
					cuboid([22,6,2],rounding=2,p1=[0,0]); // slot align
		}
		translate([10,6,-1])  color("red") cylinder(h=Switch_thk2*2,d=Screw);
		translate([10,26,-1])  color("green") cylinder(h=Switch_thk2*2,d=Screw);
		if(Screw==screw5) {
			translate([10,6,-4])  color("green") cylinder(h=5,d=screw5hd);
			translate([10,26,-4])  color("red") cylinder(h=5,d=screw5hd);
		}
	}
	if(Screw==screw5) {  // support for countersink
		translate([10,6,1])  color("gray") cylinder(h=LayerThickness,d=screw5hd);
		translate([10,26,1])  color("plum") cylinder(h=LayerThickness,d=screw5hd);
	}
}

///////////////////////////////////////////////////////////////////////////////

module base(Sep,DiagOffset,Offset,ScrewT,Adjust) {
	rotate([0,-90,0]) difference() {
		translate([0,0,-4]) color("yellow") cuboid([Switch_thk,HolderWidth,Switch_ht+Offset-Adjust],rounding=2,p1=[0,0]);
		// screw holes for switch
		rotate([0,90,0]) translate([-(Switch_ht-Offset)-0.5, SwitchShift, -1]) color("purple") cylinder(h = 11, d=ScrewT);
		rotate([0,90,0]) translate([-(Switch_ht-Offset)-0.5+DiagOffset, SwitchShift+Sep, -1])
			color("black") cylinder(h = 11, d=ScrewT);
	}
}

//////////////////////////////////////////////////////////////////////////////

module baseV2(Sep,DiagOffset,Offset,ScrewT,Adjust) {
	if(Offset==0) {
		translate([8,31.5,0]) difference() {
			color("yellow") cuboid([Switch_ht-Adjust+2,HolderWidth-2,Switch_thk],rounding=2,p1=[0,0]);
			translate([31,12,0]) {// screw holes for switch	
				translate([-Switch_ht, SwitchShift, -1]) color("purple") cylinder(h = 11, d=ScrewT);
				translate([-Switch_ht+DiagOffset, SwitchShift+Sep, -1]) color("black") cylinder(h = 11, d=ScrewT);
			}
		}
	} else {
		translate([0,31.5,0]) difference() {
			color("yellow") cuboid([Switch_ht+Offset-Adjust+2,HolderWidth-2,Switch_thk],rounding=2,p1=[0,0]);
			translate([20,-1,0]) { // screw holes for switch		
				translate([-(Switch_ht-Offset)-0.5+DiagOffset, SwitchShift, -1]) color("purple") cylinder(h = 11, d=ScrewT);
				translate([-(Switch_ht-Offset)-0.5, SwitchShift+Sep, -1]) color("black") cylinder(h = 11, d=ScrewT);
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////

module printchar(String,TxtHeight=1,TxtSize=3.5) { // print something
	color("darkgray") linear_extrude(height = TxtHeight) text(String,font=TextFont ,size=TxtSize);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
