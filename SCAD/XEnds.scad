//////////////////////////////////////////////////////////////////////////////////////////
// MMAX-X-Ends.scad - http://creativecommons.org/licenses/by-sa/3.0/
//////////////////////////////////////////////////////////////////////////////////////////
// created 3/1/16
// last update 5/15/21
//////////////////////////////////////////////////////////////////////////////////////////
// 3/1/16	- SCAD version of zXEnd_4off.stl & x-bracket_1off.stl
//			  at http://www.thingiverse.com/thing:12609
//			  Not quite identical, but functionally the same
// 3/12/16	- Added guide bars to the makerslide version to help align them
// 3/25/16	- Fixed some module arg names
// 6/10/16	- Moved nema17 mount down 1mm and added info on screws & bearings used
// 8/28/18	- Colorized the preview, added reference bed, ability to  clamping pressure
// 9/3/18	- Removed lm8uu version
// 9/15/18	- Added a full part which both sides of the XEnd as one piece and snap in MTSS for makerslide,
//			- two piece version is still available, no lm#uu version
//			- leadscrew hex nut version, the slot is longer than the thickness of the nut
// 9/27/18	- Made left/right versions of XEnds, left the third hole to allow motor on either side
// 9/28/18	- Finally found where the extra plastic was coming from in the MTSSR8 slot (connector flange cube)
// 9/30/18	- Added a screw XEnd to hold the MTSSR8 in the socket, hole sized for 3mm screw with a tight fit.
// 12/10/18	- Change motor mount to slotted for belt adjustment
// 12/15/18	- Removed znut notch, the MTSSR8 now slides in
// 12/21/18	- Began TR8 leadscrew version
// 12/23/18	- TR8 version replaces the hex nut version
// 12/26/18	- Slide in MTSSR8 version fits fine, the M3 screw isn't needed.   Leaving the M3 tappable screw hole in case
//			  it's needed in the future.
// 5/27/19	- Fixed TR8 version and made the motor mount to mount on left side only, see Line 284, comment out the
//			  if(!Left) to allow either side
// 4/14/20	- Added ability to use brass inserts
// 3.2.21	- Added ability to have 2020 & 2020 at each mounting hole, no longer left/right versions
// 5/15/21	- Added a clamp screw to help hold the bearings, rounded the xends, renamed variables for a better description
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Notes:
// Print full_XEnds with a brim
// XEnds can be made with PLA
// Motormount should be ABS or better, since the X-motor can get hot
// Set ZRodDiameter to the diameter of the smooth rod used for the z-axis
//--------------------------------------------------------------------
// Idler: On a 5x50mm screw, first install two 5mm washers,followed by 2 F625ZZ flanged bearings,
// a 5mm washer, 2 makerslide short spacers.
// Motor mount uses 3 5x50mm screws, the two that hold the makerslide need two washers
// The other two screws on the idler side are 5x20mm.
// One 5mm nut is used on each side for the screw not covered by the makerslide.
// It's easier to mount the makerslide if you use spring loaded post install nuts,
// they don't slide easily.
// Each side uses two self-aligning bearings each on the z axis rods.
// Currently set to use Misumi MTSSR8 nuts and SDI/SP 3A 7Z41MPSB10M bronze bearings on 10mm z rods.
///////////////////////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <inc/nema17.scad>
include <inc/screwsizes.scad>
include <inc/brassinserts.scad>
///////////////////////////////////////////////////////////////////////////////////////////
//vars
///////////////////////////////////////////////////////////////////////////////////////////
$fn=100; // lower this to speed up rendering
Use3mmInsert=1;
LargeInsert=1;
//------------------------------------------------------------
// bearings, change them if you are using a different bearings
AdjustCF = 0.1;	// adjust the clamping force
X_Motor_Bearing_clearance = 15.5;
// bearings, change them if you are using a different bearings
SABBClearance = 2;					// clearance under self-aligning bronze bearing
SABBLength = 10 + SABBClearance;		// self-aligning bronze bearing dimensions
SABBDiameterClearance = 0.5;		// clearance needed to fit the self-aligning bearing in the pla hole
SABBDiameter = 16.3 + SABBDiameterClearance;	// I used: http://shop.sdp-si.com/catalog/product/?id=A_7Z41MPSB10M
length = 74;
ShellThickness = 3;			// thickness of shell
BoltFlatWidth = 17; 		// width of flat to bolt together
thickness = 5;
ZDriveOffset = 30;			// distance between z rod and z screw
ZNutLength = 30;			// length of znut section
ZNutWidth = 22;			// width of znut section
ZNutThickness = 15.2+ShellThickness;// thickness of znut section
znutd = 14.5;		// z-nut diameter (point to point, not flats)
znutdt = 6.4;		// nut thickness
clearance = 1.5;	// clearance around zrod
ZRodDiameter = 10 + clearance+AdjustCF;	// z smooth rod diameter
ZScrewDiameter = 8 + clearance+AdjustCF;	// z screw diameter
ExtrusionSlotDistance = 20;	// distance between slots on the rear extrusion
ExtrusionSlotLength=32;			// guide for extrusion
ExtrusionSlotWidth=screw5-0.1;
ExtrusionSlotThickness=2;
ExtrusionSpacerThickness = 4.4;
// motor mount
MotorMountLength = 85;
MotorMountWidth = 44;
MotorMountThickness = 12;
MTSSR8d = 15.5;	// outside diameter of Misumi MTSSR8
MTSSR8l = 21.5;	// length of MTSSR8
BearingShellOffset=16;
//--------------------------------
TR8_ht=34;
TR8_clearance=0.5;
TR8_small_dia=10.1+TR8_clearance;
TR8_flange_dia=21.9+TR8_clearance;
TR8_flange_thickness=4;
TR8_mounting_holes_offset=16;
/////////////////////////////////////////////////////////////////////

//split_XEnd(0,1,1,1);
XEndSet(0,0,1,1);
//motormount();
// 2-to test the fit of the motor mount to XEnd
//difference() {
//	TR8_nut();
//	TR8_mounting_holes();
//}
//XEnd(0,1,0,1,0); // Bearing=0,mks=0,mits=0,Full=0,Left=0

//////////////////////////////////////////////////////////////////////////////////////////////

module XEndSet(Bearing=0,mks=0,mits=0,Full=0) {
	if(mits) {
		rotate([90,0,0]) XEnd(Bearing,mks,1,Full,0);
		translate([0,25,0]) rotate([90,0,0]) XEnd(Bearing,mks,1,Full,1);
	} else {
		rotate([90,0,0]) XEnd(Bearing,mks,0,Full,0);
		translate([0,25,0]) rotate([90,0,0]) XEnd(Bearing,mks,0,Full,1);
	}
}

//////////////////////////////////////////////////////////////////////

module split_XEnd(Bearing=0,mks=1,mits=1,Mount=1) {
	if($preview) %translate([-30,-90,-5]) cube([200,200,5]);
	XEnd(Bearing,mks,mits,0,0);  // mks_spacers
	translate([0,-52,0]) XEnd(Bearing,mks,mits,0,1);  //mks_spacers
	translate([78,-52,0]) XEnd(Bearing,0,mits,0);  // no mks_spacers
	translate([78,0,0]) XEnd(Bearing,0,mits,0);  // no mks_spacers
	if(Mount == 1) translate([0,45,0]) motormount();
	if(Mount == 2) translate([0,45,0]) testmotormount();
}

/////////////////////////////////////////////////////////////////////////////

module testmotormount() {	// for making a test print of the motormount section that
	difference() {			// mounts against the XEnd
		motormount();
		translate([25,-30,-5]) cube([100,100,100]);
	}
}

//////////////////////////////////////////////////////////////////////

module motormount(mks=0) { // this holds the stepper motor
	difference() {
		color("cyan") cuboid([MotorMountLength,MotorMountWidth,MotorMountThickness],roundng=2,p1=[0,0]);
		translate([MotorMountLength-23,MotorMountWidth/2,-1]) color("red") NEMA17_parallel_holes(MotorMountThickness+2,5);
		mmslot(mks);
		translate([9,2,0]) rotate([0,0,90]) motormountscrewholes();
	}
}

//////////////////////////////////////////////////////////////////////

module mmslot(mks) { // add mount to simpleVX XEnd (removes the area the XEnd fits into)
	translate([ZDriveOffset*2-35,MotorMountWidth+1,MotorMountThickness+4.5]) rotate([90,0,0]) color("gray")
		cylinder(h=MotorMountWidth+4,r=(ShellThickness+X_Motor_Bearing_clearance)/2);
	translate([-2.9,MotorMountWidth/4-1.5,MotorMountThickness-5.5]) color("plum") cube([ZNutLength,ZNutWidth+2,znutdt]);
}

//////////////////////////////////////////////////////////////////////

module XEnd(Bearing=0,mks=0,mits=0,Full=0,Left=0) {  // this version is now broken; simpleVX XEnd;
	difference() {
		union() {
			difference() { // z rod section
				bearingshell();
				bearings();
				zrodhole();
				FlangeBearingClamp();
			}
			difference() {
				translate([length/2-ZNutWidth/2-0.5,ZDriveOffset,0]) znutshell(mits,1);
				if(Left) rotate([0,180,0]) translate([-length/2-ZNutWidth/2-1,ZDriveOffset,0]) color("gray")
							znutscrew(mits);
				else  translate([-length/2-ZNutWidth/2+74.5,ZDriveOffset,0]) znutscrew(mits);
				if(!mits) {
					translate([length/2-ZNutWidth/2,ZDriveOffset,0]) color("white") znutscrew(mits);
					if(!mits) translate([length/2-ZNutWidth/2,ZDriveOffset,0]) rotate([0,90,0]) TR8_mounting_holes();
				}
				if(mits) translate([37,45,0]) rotate([90,0,0]) color("pink")
					cylinder(h=10,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
			}
			difference() {
				connector(mks,Bearing,mits);
				if(Left) translate([length/2-ZNutWidth/2+ZNutWidth,ZDriveOffset,0]) rotate([0,180,0]) znutscrew(mits);
				else translate([length/2-ZNutWidth/2-2.7,ZDriveOffset,0]) znutscrew(mits);
				if(!mits) translate([length/2-ZNutWidth/2,ZDriveOffset,0]) rotate([0,90,0]) TR8_mounting_holes();
			}
		}
	}
	difference() {
		flange(mks,Bearing,mits,Left);
		if(!mits) translate([length/2-ZNutWidth/2-0.7,ZDriveOffset,0]) rotate([0,90,0]) TR8_mounting_holes();
		FlangeBearingClamp();
	}
	cuthalf(Full); // remove everything below Z0
	if(mks) {
		difference() {
			spacers(Left,mks,Bearing,mits);
			bearings();
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FlangeBearingClamp() {
	// use m3 screw to help hold in the bearings
	translate([70,25,0]) color("blue") rotate([90,0,0]) cylinder(h=20,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
	translate([70,35,0]) color("green") rotate([90,0,0]) cylinder(h=20,d=screw3hd+0.1);
	translate([5,25,0]) color("green") rotate([90,0,0]) cylinder(h=20,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
	translate([5,35,0]) color("blue") rotate([90,0,0]) cylinder(h=20,d=screw3hd+0.1);
}

/////////////////////////////////////////////////////////////////////////

module spacers(Left=0,mks=0,Bearing=0,mits=0) { // spacers for the makerslide side, so the XEnds sit flat
	if(Left) {
		difference() {
			color("yellow") hull() {
				translate([ExtrusionSlotDistance-3,BoltFlatWidth/1.1,ExtrusionSpacerThickness+1.5])
					cyl(h=thickness+3.5,d=screw5+6,rounding=2);
				translate([ExtrusionSlotDistance-3,BoltFlatWidth/1.1-10,ExtrusionSpacerThickness+1.5])
					cyl(h=thickness+3.5,d=screw5+6,rounding=2);
			}
			zrodhole();
			translate([-1,0,0]) rotate([0,90,0]) sabb();
			translate([ExtrusionSlotDistance-3,BoltFlatWidth/1.1,-znutdt/2]) cylinder(h=thickness*5,r=screw5/2);
			translate([length/2-ZNutWidth/2,ZDriveOffset,0]) color("white") znutscrew(mits);
		}
		translate([40,0,0]) difference() {
			color("lightgray") hull() {
				translate([ExtrusionSlotDistance-3,BoltFlatWidth/1.1,ExtrusionSpacerThickness+1])
					cyl(h=thickness+3.5,d=screw5+6,rounding=2);
				translate([ExtrusionSlotDistance-3,BoltFlatWidth/1.1-10,ExtrusionSpacerThickness+1])
					cyl(h=thickness+3.5,d=screw5+6,rounding=2);
			}
			translate([-40,0,0]) zrodhole();
			translate([-1,0,0]) rotate([0,90,0]) sabb();
			translate([ExtrusionSlotDistance-3,BoltFlatWidth/1.1,-znutdt/2]) cylinder(h=thickness*5,r=screw5/2);
		}
	} else {
		difference() {
			color("plum")	hull() {
				translate([ExtrusionSlotDistance*3-3,BoltFlatWidth/1.1,ExtrusionSpacerThickness+1])
					cyl(l=thickness+3.4, d=screw5+6, rounding=2);
				translate([ExtrusionSlotDistance*3-3,BoltFlatWidth/1.1-10,ExtrusionSpacerThickness+1])
					cyl(h=thickness+3.4,d=screw5+6,rounding=2);
			}
			zrodhole();
			translate([length-SABBLength,0,0]) rotate([0,90,0]) sabb();
			translate([ExtrusionSlotDistance*3-3,BoltFlatWidth/1.1,-znutdt/2]) cylinder(h=thickness*5,r=screw5/2);
			rotate([0,180,0]) translate([-length/2-ZNutWidth/2,ZDriveOffset,0]) color("gray") znutscrew(mits);
		}
		translate([-40,0,0]) difference() {
			color("purple")	hull() {
				translate([ExtrusionSlotDistance*3-3,BoltFlatWidth/1.1,ExtrusionSpacerThickness+1])
					cyl(h=thickness+3.4,d=screw5+6,rounding=2);
				translate([ExtrusionSlotDistance*3-3,BoltFlatWidth/1.1-10,ExtrusionSpacerThickness+1])
					cyl(h=thickness+3.4,d=screw5+6,rounding=2);
			}
			translate([40,0,0]) zrodhole();
			translate([ExtrusionSlotDistance*3-3,BoltFlatWidth/1.1,-znutdt/2]) cylinder(h=thickness*5,r=screw5/2);
		}
	}
	// guide slot for extrusion
	difference() {
		translate([length/2-screw5/2+0.05,-0.5,9]) color("gray")
			cuboid([ExtrusionSlotWidth,ExtrusionSlotLength,ExtrusionSlotThickness],rounding=0.5,p1=[0,0]);
		translate([length/2-screw5/2-1,-5,4]) rotate([45,0,0]) color("pink")
			cube([ExtrusionSlotWidth+2,ExtrusionSlotLength,ExtrusionSlotThickness+1]);
		screwholes(1,Left);
	}
	if(Left) {
		difference() {
			union() {
				translate([ExtrusionSlotDistance-screw5,BoltFlatWidth/1.6-10,9]) color("blue")
					cuboid([ExtrusionSlotWidth,ExtrusionSlotLength-13,ExtrusionSlotThickness],rounding=0.5,p1=[0,0]);
				translate([ExtrusionSlotDistance-screw5+40,BoltFlatWidth/1.6-10,9]) color("white")
					cuboid([ExtrusionSlotWidth,ExtrusionSlotLength-13,ExtrusionSlotThickness],rounding=0.5,p1=[0,0]);
			}
			translate([ExtrusionSlotDistance-screw5-1.2,BoltFlatWidth/1.6-15,4]) rotate([45,0,0]) color("gold")
				cube([ExtrusionSlotWidth+2,ExtrusionSlotLength,ExtrusionSlotThickness]);
			screwholes(1,Left);
		}
	} else {
		difference() {
			union() {
				translate([ExtrusionSlotDistance*3-screw5,BoltFlatWidth/1.6-10,9]) color("red")
					cuboid([ExtrusionSlotWidth,ExtrusionSlotLength-13,ExtrusionSlotThickness],rounding=0.5,p1=[0,0]);
				translate([ExtrusionSlotDistance*3-screw5-40,BoltFlatWidth/1.6-10,9]) color("green")
					cuboid([ExtrusionSlotWidth,ExtrusionSlotLength-13,ExtrusionSlotThickness],rounding=0.5,p1=[0,0]);
			}
			translate([ExtrusionSlotDistance*3-screw5-1.2,BoltFlatWidth/1.6-15,4]) rotate([45,0,0]) color("white")
				cuboid([ExtrusionSlotWidth+2,ExtrusionSlotLength,ExtrusionSlotThickness],rounding=0.5,,p1=[0,0]);
			translate([ExtrusionSlotDistance*3-screw5-40.5,BoltFlatWidth/1.6-15,4]) rotate([45,0,0]) color("plum")
				cuboid([ExtrusionSlotWidth+2,ExtrusionSlotLength,ExtrusionSlotThickness],rounding=0.5,p1=[0,0]);
			screwholes(1,Left);
		}
	}
}

//////////////////////////////////////////////////////////////////////

module cuthalf(Full=0) {	// remove everything below Z0
	if(!Full) translate([-1,-15,-20+AdjustCF]) color("cyan") cube([length+2,length-15,20]);
}

//////////////////////////////////////////////////////////////////////

module flange(mks,Bearing,mits,Left=0) {  // the part that holds it together
	difference() {
		translate([0,ZRodDiameter/2,-(thickness)]) color("red")
			cuboid([length,BoltFlatWidth-0.7,thickness*2],rounding=2,p1=[0,0]);
		screwholes(mks,Left);
		zrodhole();
		bearings();	
		translate([length/2-ZNutWidth/2-0.7+ZNutWidth,ZDriveOffset,0])  rotate([0,180,0]) znutscrew(mits);
		translate([length/2-ZNutWidth/2+1,ZDriveOffset,0])znutscrew(mits);
	}
	if(mits) translate([37,38,0]) {
		difference() {
			rotate([90,0,0]) color("brown") hull() {
				cylinder(h=1,d=screw3*2.5);
				translate([0,0,-3]) cyl(h=1,d=screw3*2,rounding=0.5);
			
			}
			translate([0,5,0]) rotate([90,0,0]) color("blue") cylinder(h=10,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
		}
	}
}

////////////////////////////////////////////////////////////////////////

module motormountscrewholes() {
	color("cyan") hull() {
		translate([0,0,0]) cylinder(h=thickness*5,r=screw5/2);
		translate([-5,0,0]) cylinder(h=thickness*5,r=screw5/2);
	}
	translate([ExtrusionSlotDistance,0,0]) color("white") cylinder(h=thickness*5,r=screw5/2);
	color("white") hull() {
		translate([ExtrusionSlotDistance*2,0,0]) color("white") cylinder(h=thickness*5,r=screw5/2);
		translate([ExtrusionSlotDistance*2+5,0,0]) color("white") cylinder(h=thickness*5,r=screw5/2);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module screwholes(mks=1,Left=0) { // screw holes for makerslide or the round rod XEnds
	translate([ExtrusionSlotDistance-3,BoltFlatWidth/1.1,-ZNutThickness/2-5]) color("gray")
		cylinder(h=thickness*6,r=screw5/2);
	translate([(ExtrusionSlotDistance*2)-3,BoltFlatWidth/1.1,-ZNutThickness/2-5]) color("lightblue")
		cylinder(h=thickness*6,r=screw5/2);
	//if(!Left)
	translate([ExtrusionSlotDistance*3-3,BoltFlatWidth/1.1,-ZNutThickness/2-5]) color("plum")
		cylinder(h=thickness*6,r=screw5/2);
}

///////////////////////////////////////////////////////////////////////

module connector(mks,Bearing,mits) { // connect bearing and ZScrewDiameter sections
	difference() {
		connectorflat(mks,mits);
		bearings();
		zrodhole();
		znutscrew(Bearing);
		screwholes(mks);
	}
}

//////////////////////////////////////////////////////////////////////////////

module connectorflat(mks,mits) { // raised section between z rod and z nut
	if(!mits) {
		if(mks) {
			translate([(length/2-ZNutWidth/2),ZNutWidth/6-2,-ZNutThickness/2-0.9]) color("ivory")
				cube([ZNutWidth-1,ZNutLength-1,ZNutThickness+1.7]);
			translate([length/2-ZNutWidth/2-0.7,ZDriveOffset,0]) znutshell(mits,1);
		} else {
			difference() {
				translate([(length/2-ZNutWidth/2),ZNutWidth/6-2,-ZNutThickness/2-1.9]) color("ivory")
					cuboid([ZNutWidth,ZNutLength,ZNutThickness+3.5],rounding=2,p1=[0,0]);
				translate([length/2-ZNutWidth/2,ZDriveOffset,0]) znutscrew(mits);
			}
		}
	} else {
		difference() {
			if(mks) {
				translate([(length/2-ZNutWidth/2),ZNutWidth/6-2,-ZNutThickness/2-0.9]) color("pink")
					cuboid([ZNutWidth,ZNutLength,ZNutThickness+1.7],rounding=1,p1=[0,0]);
			} else
				translate([(length/2-ZNutWidth/2),ZNutWidth/6-2,-ZNutThickness/2-0.9]) color("cyan")
					cuboid([ZNutWidth,ZNutLength,ZNutThickness+1.5],rounding=2,p1=[0,0]);
			translate([length/2-ZNutWidth/2,ZDriveOffset,0]) znutscrew(mits);
			translate([(length/2-ZNutWidth/2)-5,ZNutWidth/6+ZNutWidth+4.5,-ZNutThickness/2+9]) rotate([0,90,0])
				color("ivory") cylinder(h=35,d=MTSSR8d+0.5); // remove connectorflat main cube from z nut hole
		}
		
	}
}

//////////////////////////////////////////////////////////////////////////////

module zrodhole() { // through hole for the z rod
	translate([-2,0,0]) rotate([0,90,0]) color("orange") cylinder(h = length+4,r=ZRodDiameter/2);
}

/////////////////////////////////////////////////////////////////////////

module znutshell(mits,TR8=0) { // part to hold the z nut
	if(!mits) {
		translate([11.5,0,0]) rotate([0,90,0]) color("salmon") cyl(h=ZNutWidth,d=znutd+ShellThickness+4.9,rounding=2);
	} else
		translate([11.5,0,0]) rotate([0,90,0]) color("khaki") cyl(h=MTSSR8l+2.5, d=MTSSR8d+ShellThickness+0.5,rounding=2);
}

/////////////////////////////////////////////////////////////////////

module bearingshell() { // part to hold the z rod bearings
	translate([37,0,0]) rotate([0,90,0]) color("white") cyl(h=length,d=ShellThickness+SABBDiameter,rounding=2);
}

///////////////////////////////////////////////////////////////////////

module znut() { // z nut, no hole
	color("gray") cylinder(h = ZNutThickness, r=znutd/2,$fn=6);
}

//////////////////////////////////////////////////////////////////////

module sabb() { // self-aligning bronze bearing, no hole
	color("brown") cylinder(h=SABBLength+1,r=SABBDiameter/2);
}

///////////////////////////////////////////////////////////////////////

module bearings() { // dual bearings on z rod
	translate([-1,0,0]) rotate([0,90,0]) sabb();
	translate([length-SABBLength,0,0]) rotate([0,90,0]) sabb();
}

////////////////////////////////////////////////////////////////////////

module znutscrew(mits) { // z-nut section
	if(!mits) {
		translate([-5,0,0])rotate([0,90,0]) TR8_nut();
		//translate([-1,0,0])rotate([0,90,0]) color("blue") cylinder(h=ZNutWidth+2,r= ZScrewDiameter/2);
		//translate([ZNutWidth/2- ZNutThickness/2,0,0]) rotate([0,90,0]) znut(); // slot for znut
	} else {
		translate([-3,0,0])rotate([0,90,0]) color("gray") cylinder(h=MTSSR8l+40,r= ZScrewDiameter/2);
		translate([1.5,0,0])rotate([0,90,0]) color("cyan") cylinder(h=MTSSR8l+31.6,r= MTSSR8d/2);
		// was translate([0.5,0,0])rotate([0,90,0]) color("cyan") cylinder(h=MTSSR8l+1.6,r= MTSSR8d/2);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////

module TR8_nut() {
	color("cyan") cylinder(h=TR8_ht,d=TR8_small_dia,$fn=100); // center nut
	//translate([0,0,2]) color("pink") cylinder(h=TR8_flange_thickness,d=TR8_flange_dia,$fn=100);
	translate([0,0,-24]) color("plum") cylinder(h=30,d=TR8_flange_dia,$fn=100);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module TR8_mounting_holes() {
	translate([0,TR8_mounting_holes_offset/2,-2]) color("blue") cylinder(h=30,d=screw3,$fn=100);
	translate([0,-TR8_mounting_holes_offset/2,-2]) color("cyan") cylinder(h=30,d=screw3,$fn=100);
	translate([TR8_mounting_holes_offset/2,0,-2]) color("gray") cylinder(h=30,d=screw3,$fn=100);
	translate([-TR8_mounting_holes_offset/2,0,-2]) color("white") cylinder(h=30,d=screw3,$fn=100);
}


///////////// end of simpleVX.scad ////////////////////////////////////
