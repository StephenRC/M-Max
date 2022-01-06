////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Power.scad - uses a pc style power socket with switch
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 7/4/2016
// last update 1/6/22
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/4/16	- Added cover
// 8/5/16	- adjusted cover & 2020 mounting holes
// 1/10/17	- Added colors for easier editing in preview and added mount for a power switch
// 1/11/17	- Added label to power switch mount
// 8/19/18	- OpenSCAD 2018.06.01 for $preview
// 5/10/19	- Added a rear cover for the power switch
// 5/11/19	- Added a power cover with rounded edges and square edges
// 5/16/19	- Merged power supply mount into here and renamed this file
// 5/28/19	- Added a housing version with seperate power plug and switch, added M5 countersinks to housing
// 7/24/19	- Adjusted cover() screw holes
// 10/31/20	- Added a mount for a Mean Well RS 15 5 power supply
// 2/11/21	- Simplfied the power housing mount and changed power socket to same as on the CXY-MSv1, added coountersinks
//			  to poweri inlet conver for M3 countersunk screws, added meanwell 5vdc mout to all()
// 4/18/21	- Added a Power switch mouont for a toggle switch
// 1/6/22	- BOSL2
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// If the socket hole size changes, then the size & postions of the walls & socket may need adjusting
// The power socket uses 3mm screws and brass inserts to mount
///////////////////////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <inc/screwsizes.scad>
include <inc/brassinserts.scad>
$fn = 50;
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// vars
Use3mmInsert=1;
LargeInsert=1;
SwitchSocketWidth=39;	// socket hole width
SwitchSocketHeight=27;	// socket hole height
PowerSwitchSocketWidth=13;	// socket hole width
PowerSwitchSocketHeight = 19.5;	// socket hole height
SocketShiftLR = 0; // move socket left/right
SocketShiftUD = 0; // move socket up/down
PowerSupplyCoverClearance = 1;
PowerSupplyCoverWidth=115+PowerSupplyCoverClearance;
PowerSupplyCoverHeight=50+PowerSupplyCoverClearance;
PowerSupplyCoverDepth=55;
//PowerSupplyCoverTab=24;
PowerSupplyAdjust=2;
PowerSupplySideMountingScrewSpacing=25;
Length = 113;
Width = 13;
Thickness = 10;
LayerThickness = 0.4;
SocketPlugWidth=SwitchSocketWidth;
SocketPlugHeight=SwitchSocketHeight;
ToggleSwitchLength=30;
TogglwSwitchWidth=16;
ToggleSwitchHeight=26;
ToggleOffsetHoleSize=22;
Clearance=0.7;  // clearance for hole
///////////////////////////////////////////////////////////////////////////////////////////////////////////

all(0,PowerSwitchSocketWidth,PowerSwitchSocketHeight,2,1,2,0);
// flip=0,s_w=13,s_l=19.5,s_t=2,Makerslide=1,PBQuantiy=2,Version=0
//testfit();	// print part of it to test fit the socket & 2020
//switch();		// 4 args: flip label, Width, length, clip Thickness; defaults to 0,13,19.5,2
//powersupply_cover(); // for cheap chinese power supply
//powersupply_cover_v2();
//PowerInlet(1);
//PowerInlet(0);
//PowerInletCover();
//MeanWellRS_15_5(); // Mean Well 5vdc power supply
//PowerInletSet(0);
//PowerToggleSwitch();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PowerInletSet(Version=0) {
	PowerInlet(0);
	translate([0,0,45]) rotate([180,0,0]) PowerInletCover();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MeanWellRS_15_5() {
	difference() {
		color("cyan") cuboid([63,52+40,5],rounding=2,p1=[0,0]);
		translate([12,27.4-1.5+20,-5]) {
			color("red") cylinder(h=Thickness*3,d=screw3);
			translate([0,0,3]) color("blue") cylinder(h=5,d=screw3hd);
			translate([41.7-3.5,0,0]) color("blue") cylinder(h=Thickness*3,d=screw3);
			translate([41.7-3.5,0,3]) color("red") cylinder(h=5,d=screw3hd);
		}
		translate([63/4-5,10,-5]) {
			color("green") cylinder(h=Thickness*3,d=screw5);
			translate([0,0,9]) color("lightgray") cylinder(h=5,d=screw5hd);
			translate([0,52+20,0]) color("red") cylinder(h=Thickness*3,d=screw5);
			translate([0,52+20,9]) color("blue") cylinder(h=5,d=screw5hd);
		}
		translate([63/4+20,10,-5]) {
			color("blue") cylinder(h=Thickness*3,d=screw5);
			translate([0,0,9]) color("plum") cylinder(h=5,d=screw5hd);
			translate([0,52+20,0]) color("blue") cylinder(h=Thickness*3,d=screw5);
			translate([0,52+20,9]) color("green") cylinder(h=5,d=screw5hd);
		}
	}
	translate([12,27.4-1.5+20,3]) {
		color("pink") cylinder(h=LayerThickness,d=screw3hd);
		translate([41.7-3,0,0]) color("white") cylinder(h=LayerThickness,d=screw3hd);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module all(flip=0,s_w=13,s_l=19.5,s_t=2,Makerslide=1,PBQuantiy=2,Version=0) {
	//if($preview) %translate([25,20,0]) cube([200,200,2],center=true); // show the 200x200 bed
	translate([0,15,0]) PowerInlet(Version);
	translate([0,20,45]) rotate([180,0,0]) PowerInletCover();
	translate([-45,-45,0]) PowerToggleSwitch();
	//translate([-45,85,0]) powersupply_cover();
	translate([-70,-10,0]) MeanWellRS_15_5();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////

module powersupply_cover_v2() { // square version
	if($preview) {  // verify inside is the right size
		%translate([14,2,5]) cube([5,PowerSupplyCoverHeight,5]);
		%translate([2,14,5]) cube([PowerSupplyCoverWidth,5,5]);
	}
	difference() {
		color("cyan") cube([PowerSupplyCoverWidth+4,PowerSupplyCoverHeight+4,2]); 
		translate([111,PowerSupplyCoverHeight/2+4,-2]) rotate([0,0,180]) pwr_supply_cover_vents(18); // ventilation
	}
	translate([PowerSupplyCoverWidth/5,0.5,PowerSupplyCoverDepth/6]) rotate([90,0,0]) printchar("DANGER HIGH VOLTAGE",1.5,4);
	translate([PowerSupplyCoverWidth/1.2,54.5,PowerSupplyCoverDepth/6]) rotate([90,0,180]) printchar("DANGER HIGH VOLTAGE",1.5,4);
	difference() {
		translate([0,0,0]) color("red") cube([2,PowerSupplyCoverHeight+4,PowerSupplyCoverDepth]);
		pwrc_supply_screws(screw4); // mount it to the power supply
	}
	difference() {
		translate([PowerSupplyCoverWidth+2,0,0]) color("plum") cube([2,PowerSupplyCoverHeight+4,PowerSupplyCoverDepth]);
		pwrc_supply_screws(screw4); // mount it to the power supply
	}
	translate([0,0,0]) color("gray") cuboid([PowerSupplyCoverWidth+4,2,PowerSupplyCoverDepth],rounding=1,p1=[0,0]);
	translate([0,PowerSupplyCoverHeight+2,0]) color("lightgray") cube([PowerSupplyCoverWidth+4,2,PowerSupplyCoverDepth-14]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module powersupply_cover() { // rounded version
	if($preview) {  // verify inside is the right size
		%translate([14,4,5]) cube([5,PowerSupplyCoverHeight,5]);
		%translate([4,14,5]) cube([PowerSupplyCoverWidth,5,5]);
	}
	difference() {
		color("cyan") cuboid([PowerSupplyCoverWidth+8,PowerSupplyCoverHeight+8,4],rounding=1,p1=[0,0]); 
		translate([113,PowerSupplyCoverHeight/2+7,-2]) rotate([0,0,180]) pwr_supply_cover_vents(18); // ventilation
	}
	difference() {
		translate([0,0,0]) color("red") cuboid([4,PowerSupplyCoverHeight+8,PowerSupplyCoverDepth],rounding=1,p1=[0,0]);
		pwrc_supply_screws(screw4); // mount it to the power supply
	}
	difference() {
		translate([PowerSupplyCoverWidth+4,0,0]) color("plum")
			cuboid([4,PowerSupplyCoverHeight+8,PowerSupplyCoverDepth],rounding=1,p1=[0,0]);
		pwrc_supply_screws(screw4); // mount it to the power supply
	}
	translate([0,0,0]) color("gray") cuboid([PowerSupplyCoverWidth+8,4,PowerSupplyCoverDepth],rounding=1,p1=[0,0]);
	translate([0,PowerSupplyCoverHeight+4,0]) color("lightgray")
		cuboid([PowerSupplyCoverWidth+8,4,PowerSupplyCoverDepth-14],rounding=1,p1=[0,0]);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module pwrc_supply_screws(Screw) {
	translate([-5,PowerSupplyCoverHeight/4+PowerSupplyAdjust,PowerSupplyCoverDepth-7]) rotate([0,90,0]) color("black") cylinder(h=PowerSupplyCoverWidth+17,d=Screw);
	translate([-5,PowerSupplyCoverHeight/4+PowerSupplySideMountingScrewSpacing+PowerSupplyAdjust,PowerSupplyCoverDepth-7]) rotate([0,90,0]) color("white") cylinder(h=PowerSupplyCoverWidth+17,d=Screw);
}


////////////////////////////////////////////////////////////////////////////////////////////////////////

module pwr_supply_cover_vents(Qty=1) {
	for(a = [0:Qty-1]) {
		translate([a*6,0,0]) color("black") hull() {
			cylinder(h=10,d=3);
			translate([0,20,0]) cylinder(h=10,d=3);
		}
	}
	translate([2,-11,-2]) color("gray") hull() { // wire access hole
		cylinder(h=10,d=10);
		translate([PowerSupplyCoverWidth-18,0,0]) cylinder(h=10,d=10);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module PowerInlet(Version=1,Screw=Yes3mmInsert(Use3mmInsert)) {
	difference() {
		color("blue") cuboid([SwitchSocketWidth+40,SwitchSocketHeight+40,5],rounding=2,p1=[0,0]); // base
		translate([SwitchSocketWidth-25,9,-2]) color("green") cylinder(h=10,r=screw5/2); // 2020 mounting hole
		translate([SwitchSocketWidth-25,9,-9]) color("lightgreen") cylinder(h=10,d=screw5hd); // 2020 mounting hole
		translate([SwitchSocketWidth+25,9,-2]) color("lightgreen") cylinder(h=10,r=screw5/2); // 2020 mounting hole
		translate([SwitchSocketWidth+25,9,-9]) color("green") cylinder(h=10,d=screw5hd); // 2020 mounting hole
		// socket hole
		if(Version==0) {
			translate([SwitchSocketWidth/2+SocketShiftLR,SwitchSocketHeight/2+14+SocketShiftUD,-2]) color("cyan")
				cube([SwitchSocketWidth,SwitchSocketHeight,10]);
			translate([SwitchSocketWidth/2+SocketShiftLR-4,SwitchSocketHeight/2+14+SocketShiftUD,2]) color("red")
				cube([SwitchSocketWidth+8,SwitchSocketHeight,10]);
			// mounting screws
			translate([SwitchSocketWidth+SocketShiftLR,SwitchSocketHeight+SocketShiftUD-4.5,-3]) color("red")
				cylinder(h=10,d=Screw);
			translate([SwitchSocketWidth+SocketShiftLR,SwitchSocketHeight*2+SocketShiftUD+5.5,-3]) color("cyan")
				cylinder(h=10,d=Screw);
		} else {
			translate([SwitchSocketWidth/2+SocketShiftLR-10,SwitchSocketHeight/2+14+SocketShiftUD,-2]) color("cyan")
				cube([SocketPlugWidth,SocketPlugHeight,10]); // plug socket
			translate([SwitchSocketWidth/2+SocketShiftLR+36,SwitchSocketHeight/2+14.2+SocketShiftUD,-2]) color("pink")
				cube([s_w,s_l,8]); // switch
		}
	}
	difference() {
		translate([0,SwitchSocketHeight+35,0]) color("red")
			cuboid([SwitchSocketWidth+40,5,40],rounding=2,p1=[0,0]); // top wall
		CoverScrewHoles(Yes3mmInsert(Use3mmInsert,LargeInsert));
	}
	difference() {
		translate([0,19,0]) color("black") cuboid([5,SwitchSocketHeight+21,40],rounding=2,p1=[0,0]); // left wall
		CoverScrewHoles(Yes3mmInsert(Use3mmInsert,LargeInsert));
	}
	difference() {
		translate([SwitchSocketWidth+35,19,0]) color("white") 
			cuboid([5,SwitchSocketHeight+21,40],rounding=2,p1=[0,0]); // right wall
		CoverScrewHoles(Yes3mmInsert(Use3mmInsert,LargeInsert));
	}
	PowerInletCoverScrewHoles();
	translate([SwitchSocketWidth-screw5hd/2-25,9-screw5hd/2,1]) ScrewHolesSupport();
	translate([SwitchSocketWidth-screw5hd/2+25,9-screw5hd/2,1]) ScrewHolesSupport();
}

//////////////////////////////////////////////////////////////////

module ScrewHolesSupport() {
	color("plum") cube([screw5hd+1,screw5hd+1,LayerThickness]);
}

module PowerInletCoverScrewHoles() {
	difference() {
		translate([5,40,20]) color("pink") cylinder(h=20,d=screw5+2); // left
		translate([5,35,13]) rotate([0,-50,0]) color("red") cube([15,10,5]);
		CoverScrewHoles(Yes3mmInsert(Use3mmInsert,LargeInsert));
	}
	difference() {
		translate([SwitchSocketWidth+35,40,20]) color("red") cylinder(h=20,d=screw5+2); // right
		translate([SwitchSocketWidth+27,35,22]) rotate([0,50,0]) color("blue") cube([10,15,5]);
		CoverScrewHoles(Yes3mmInsert(Use3mmInsert,LargeInsert));
	}
	difference() {
		translate([SwitchSocketWidth,62,20]) color("white") cylinder(h=20,d=screw5+1); // top screw hole
		translate([SwitchSocketWidth-5,51,26]) rotate([-50,0,0]) color("green") cube([10,15,5]);
		CoverScrewHoles(Yes3mmInsert(Use3mmInsert,LargeInsert));
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

module CoverScrewHoles(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) {
	translate([5,40,33]) color("white") cylinder(h=20,d=Screw); // left
	translate([SwitchSocketWidth+35,40,33]) color("gray") cylinder(h=20,d=Screw); // right
	translate([SwitchSocketWidth,62,33]) color("hotpink") cylinder(h=20,d=Screw); // top screw hole
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module testfit() { // may need adjusting if the socket size is changed
	difference() {
		sock();
		translate([-28,-10,-5]) cube([SwitchSocketWidth+90,SwitchSocketHeight,50]); // walls around socket only
		translate([-28,-2,-2]) cube([SwitchSocketWidth+90,SwitchSocketHeight+50,5]); // remove some from bottom
		translate([-28,-2,6]) cube([SwitchSocketWidth+90,SwitchSocketHeight+50,50]); // shorten vertical 2020 wings
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module PowerInletCover() {
	difference() {
		translate([0,13.8,41]) color("cyan")
			cuboid([SwitchSocketWidth+40,SwitchSocketHeight+27,4],rounding=2,p1=[0,0]); // base
		CoverScrewHoles(screw3);
		CoverScrewSounterSink(screw3);
	}
	difference() {
		translate([0,13.8,25]) color("red") cuboid([SwitchSocketWidth+40,5,20],rounding=2,p1=[0,0]); // base
		color("white") hull() {
			translate([SwitchSocketWidth,25,30]) rotate([90,0,0]) cylinder(h=15,d=10);
			translate([SwitchSocketWidth,25,25]) rotate([90,0,0]) cylinder(h=15,d=10);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

module CoverScrewSounterSink(Screw=screw3) {
	translate([5,40,44.5]) color("hotpink") hull() {  // left
		cylinder(h=0.5,d=Screw+2.4);
		translate([0,0,-2]) cylinder(h=0.5,d=Screw);
	}
	translate([SwitchSocketWidth+35,40,44.5]) color("white") hull()  { // right
		cylinder(h=0.5,d=Screw+2.4); // right
		translate([0,0,-2]) cylinder(h=0.5,d=Screw);
	}
	translate([SwitchSocketWidth,62,44.5]) color("white") hull() {// top screw hole
		cylinder(h=0.5,d=Screw+2.4);
		translate([0,0,-2]) cylinder(h=0.5,d=Screw);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module switch(Flip=0,s_w=13,s_l=19.5,s_t=2) {
	difference() {  // switch front and switch mounting hole
        union() {
            color("cyan") cuboid([s_l+15,s_w+15,5],rounding=2,p1=[0,0]);
            translate([0,-1,0]) color("blue") cuboid([5,s_l+9,s_w+18],rounding=2,p1=[0,0]); // left wall
            translate([s_l+10,-1,0]) color("salmon") cuboid([5,s_l+9,s_w+18],rounding=2,p1=[0,0]); // right wall
			translate([s_l-19.5,s_w+10,0]) color("tan") cuboid([s_l+15,5,s_w+18],rounding=2,p1=[0,0]); // rear wall
			translate([0,-22,0]) sw_mount(Flip,s_l+15);
			translate([0,-1,26]) color("plum") cuboid([s_l+15,s_w+5,5],rounding=2,p1=[0,0]); // rear cover
		}
	    translate([s_l/2-3.5,s_w/2+1,s_t-1.5]) color("red") cube([s_l+3,s_w,5]);
		translate([s_l/2-2,s_w/2+1,-2]) color("pink") cube([s_l,s_w,15]);
        switch_label(Flip);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PowerToggleSwitch(Flip=0,HoleSize=12+Clearance) {
	difference() {  // switch front and switch mounting hole
        union() {
            color("cyan") cuboid([ToggleSwitchLength+10,TogglwSwitchWidth+10,4],rounding=2,p1=[0,0],except_edges=TOP);
			translate([0,0,0]) color("blue")
				cuboid([5,TogglwSwitchWidth+10,ToggleSwitchHeight+10],rounding=2,p1=[0,0]); // left wall
            translate([ToggleSwitchLength+5,0,0]) color("salmon")
				cuboid([5,TogglwSwitchWidth+10,ToggleSwitchHeight+10],rounding=2,p1=[0,0]); // right wall
			translate([0,0,0]) color("tan")
				cuboid([ToggleSwitchLength+10,5,ToggleSwitchHeight+10],rounding=2,p1=[0,0]); // rear wall
			translate([0,TogglwSwitchWidth+5,0]) color("gray")
				cuboid([ToggleSwitchLength+10,5,ToggleSwitchHeight+10],rounding=2,p1=[0,0]); // rear wall
			translate([0,-22,0]) ToggleSwitchExtrusionMount(Flip,ToggleSwitchLength+10);
		}
		translate([(ToggleSwitchLength+10)/2,(TogglwSwitchWidth+10)/2,-3]) color("red") cylinder(h=10,d=HoleSize);
		translate([-3,-4,0]) switch_label(Flip,6);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ToggleSwitchExtrusionMount(Flip=0,Width) {
	difference() {
		color("green") cuboid([Width,27,5],rounding=2,p1=[0,0]);
		translate([10,10,-2]) color("red") cylinder(h=10,d=screw5);
		translate([30,10,-2]) color("blue") cylinder(h=10,d=screw5);
		//translate([10,10,-4]) color("red") cylinder(h=5,d=screw5hd);
		//translate([30,10,-4]) color("blue") cylinder(h=5,d=screw5hd);
	}
	//translate([10,10,1]) color("blue") cylinder(h=LayerThickness,d=screw5hd); // support
	//translate([30,10,1]) color("red") cylinder(h=LayerThickness,d=screw5hd); // support
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module sw_mount(Flip=0,Width) {
	difference() {
		color("green") cuboid([Width,27,5],rounding=2,p1=[0,0]);
		translate([7,10,-2]) color("red") cylinder(h=10,d=screw5,$fn=100);
		translate([26,10,-2]) color("blue") cylinder(h=10,d=screw5,$fn=100);
		//translate([-3,22,0]) switch_label(Flip);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module switch_label(Flip=0,Size=4) {
	if(!Flip) translate([6.5,5,1]) rotate([180,0,0]) printchar("POWER",2,Size);
	else translate([32,-4,1]) rotate([0,180,0]) printchar("POWER",2,Size);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module printchar(String,Height=1.5,Size=4) { // print something
	color("black") linear_extrude(height = Height) text(String, font = "Arial:style=Black",size=Size);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PowerSupplySingleMount(mks=1) {
	difference() {
		color("cyan") cuboid([Length,Width,Thickness],rounding=2,p1=[0,0]);
		// p/s mounting holes
		translate([31.5,Width/2,-2]) rotate([0,0,0]) color("gray") cylinder(h=Thickness*2,r=screw4/2);
		color("black") hull() {
			translate([82.5,Width/2,-2]) rotate([0,0,0]) cylinder(h=Thickness*2,r=screw4/2);
			translate([80.5,Width/2,-2]) rotate([0,0,0]) cylinder(h=Thickness*2,r=screw4/2);
		}
		// countersink the mounting holes
		translate([31.5,Width/2,-14]) rotate([0,0,0]) color("red") cylinder(h=Thickness*2,r=screw4hd/2);
		color("plum") hull() {
			translate([82.5,Width/2,-14]) rotate([0,0,0]) cylinder(h=Thickness*2,r=screw4hd/2);
			translate([80.5,Width/2,-14]) rotate([0,0,0]) cylinder(h=Thickness*2,r=screw4hd/2);
		}
		makerslide_mount(mks);
		// zip tie holes
		translate([5,Width+2,Thickness/2]) rotate([90,0,0]) color("salmon") cylinder(h=Thickness*2,r=screw5/2);
		translate([Length-5,Width+2,Thickness/2]) rotate([90,0,0]) color("blue") cylinder(h=Thickness*2,r=screw5/2);
	}
	Support4mmHoles();
}

//////////////////////////////////////////////////////////////////////////////////////////////////
module Support4mmHoles() {
	translate([31.5,Width/2,6]) color("blue") cylinder(h=LayerThickness,d=screw4hd);
	translate([0,Width/2,6]) color("green") hull() {
		translate([82.5,0,0]) cylinder(h=LayerThickness,d=screw4hd);
		translate([80.5,0,0]) cylinder(h=LayerThickness,d=screw4hd);
	}

}

///////////////////////////////////////////////////////////////////////////////////////////////////

module makerslide_mount(mks) {
	if(mks) {
		// makerslide mounting holes
		translate([Length/2+10,Width/2,-2]) color("gold") cylinder(h=Thickness*2,r=screw5/2);
		translate([Length/2-10,Width/2,-2]) color("pink") cylinder(h=Thickness*2,r=screw5/2);
		translate([Length/2+10,Width/2,Thickness/2]) color("lightgray") cylinder(h=Thickness*2,r=screw5hd/2);
		translate([Length/2-10,Width/2,Thickness/2]) color("black") cylinder(h=Thickness*2,r=screw5hd/2);
	} else {
		translate([Length/2,Width/2,-2]) color("gold") cylinder(h=Thickness*2,r=screw5/2);
		translate([Length/2,Width/2,Thickness/2]) color("lightgray") cylinder(h=Thickness*2,r=screw5hd/2);
		translate([Length/2-screw5hd/2,Width/2-screw5hd/2,Thickness/2]) color("black") cube([screw5hd,screw5hd,LayerThickness]);
	}
}

module mks_mount_support(mks) {
	if(mks) {
		translate([Length/2+10-screw5hd/2,Width/2-screw5hd/2,Thickness/2])
			color("lightgray") cube([screw5hd,screw5hd,LayerThickness]);
		translate([Length/2-10-screw5hd/2,Width/2-screw5hd/2,Thickness/2])
			color("black") cube([screw5hd,screw5hd,LayerThickness]);
	} else
		translate([Length/2-screw5hd/2,Width/2-screw5hd/2,Thickness/2]) color("black") cube([screw5hd,screw5hd,LayerThickness]);
}

//////////////// end of powersocket.scad /////////////////////////
