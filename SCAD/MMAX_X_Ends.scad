//////////////////////////////////////////////////////////////////////////////////////////
// MMAX X Ends.scad - http://creativecommons.org/licenses/by-sa/3.0/
//////////////////////////////////////////////////////////////////////////////////////////
// created 3/1/16
// last update 12/15/18
//////////////////////////////////////////////////////////////////////////////////////////
// 3/1/16	- SCAD version of zClamp_4off.stl & x-bracket_1off.stl
//			  at http://www.thingiverse.com/thing:12609
//			  Not quite identical, but functionally the same
// 3/12/16	- Added guide bars to the makerslide version to help align them
// 3/25/16	- Fixed some module arg names
// 6/10/16	- Moved nema17 mount down 1mm and added info on screws & bearings used
// 8/28/18	- Colorized the preview, added reference bed, ability to  clamping pressure
// 9/3/18	- Removed lm8uu version
// 9/15/18	- Added a full part which both sides of the clamp as one piece and snap in MTSS for makerslide,
//			- two piece version is still available, no lm#uu version
//			- leadscrew hex nut version, the slot is longer than the thickness of the nut
// 9/27/18	- Made left/right versions of clamps, left the third hole to allow motor on either side
// 9/28/18	- Finally found where the extra plastic was coming from in the MTSSR8 slot (connector flange cube)
// 9/30/18	- Added a screw clamp to hold the MTSSR8 in the socket, hole sized for 3mm screw with a tight fit.
// 12/10/18	- Change motor mount to slotted for belt adjustment
// 12/15/18	- Removed znut notch
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Notes:
// Clamps can be made with PLA
// Motormount should be ABS or better, since the X-motor can get hot
// Set zrodd to the diameter of the smooth rod used for the z-axis
//--------------------------------------------------------------------
// Idler: On a 5x50mm screw, first install two 5mm washers,followed by 2 F625ZZ flanged bearings,
// a 5mm washer, 2 makerslide short spacers.
// Motor mount uses 3 5x50mm screws, the two that hold the makerslide need two washers
// The other two screws on the idler side are 5x20mm.
// One 5mm nut is used on each side for the screw not covered by the makerslide.
// It's easier to mount the makerslide if you use spring loaded post install nuts,
// they don't slide easily.
// Each side uses two self-aligning bearings each on the z axis rods.
// Currently set to use Misumi MTSSR8 nuts and SDI/SP #A 7Z41MPSB10M bronze bearings on 10mm z rods.
///////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/cubex.scad>
include <inc/nema17.scad>
include <inc/screwsizes.scad>
///////////////////////////////////////////////////////////////////////////////////////////
//vars
///////////////////////////////////////////////////////////////////////////////////////////
$fn=100; // lower this to speed up rendering
//------------------------------------------------------------
// bearings, change them if you are using a different bearings
AdjustCF = 0.1;	// adjust the clamping force
X_Motor_Bearing_clearance = 15.5;
// bearings, change them if you are using a different bearings
sabbC = 2;					// clearance under self-aligning bronze bearing
sabb_l = 10 + sabbC;		// self-aligning bronze bearing dimensions
sabb_d_clearance = 0.5;		// clearance needed to fit the self-aligning bearing in the pla hole
sabb_d = 16.3 + sabb_d_clearance;	// I used: http://shop.sdp-si.com/catalog/product/?id=A_7Z41MPSB10M
sabb_id = 10;
// exterior zClamp
length = 74;
shellt = 3;			// thickness of shell
bolt_w = 17; 		// width of flat to bolt together
thickness = 5;
bolt_d = 26;		// distance between bolt holes
z_drv = 30;			// distance between z rod and z screw
znutl = 30;			// length of znut section
znutw = 22;			// width of znut section
znutt = 15.2+shellt;// thickness of znut section
znutd = 14.5;		// z-nut diameter (point to point, not flats)
znutdt = 6.4;		// nut thickness
clearance = 1.5;	// clearance around zrod
zrodd = 10 + clearance+AdjustCF;	// z smooth rod diameter
zscrew = 8 + clearance+AdjustCF;	// z screw diameter
mks_slot = 20;	// distance between slots on the rear of makerslide
// motor mount
mmlength = 85;
mmwidth = 44;
mmthickness = 12;
MTSSR8d = 15.5;	// outside diameter of Misumi MTSSR8
MTSSR8l = 21.5;	// length of MTSSR8
BearingShellOffset=16;
/////////////////////////////////////////////////////////////////////

//split_clamp(0,1,1,1);
full_clamp(1,0); // arg 1: 0-one clamp (left),1-two clamps,2-right clamp; arg2: 0-no motor mount,1-motor mount,
//motormount();
// 2-to test the fit of the motor mount to clamp
//////////////////////////////////////////////////////////////////////////////////////////////

module full_clamp(Clamp=0,Mount=0) {
	if($preview) %translate([-70,-75,-16]) cube([200,200,5]);
	if(Clamp == 0) rotate([90,0,0]) clamp(0,1,1,1,0); 			// left side
	if(Clamp == 1) { 											// both sides
		rotate([90,0,0]) clamp(0,1,1,1,0);
		translate([0,30,0]) rotate([90,0,0]) clamp(0,1,1,1,1);
	}
	if(Clamp == 2) rotate([90,0,0]) clamp(0,1,1,1,1);			// right side
	if(Mount == 1) translate([0,45,-10]) motormount();
	if(Mount == 2) translate([0,40,-10]) testmotormount();
}

//////////////////////////////////////////////////////////////////////

module split_clamp(Bearing=0,mks=1,mits=1,Mount=1) {
	if($preview) %translate([-30,-90,-5]) cube([200,200,5]);
	clamp(Bearing,mks,mits,0,0);  // mks_spacers
	translate([0,-52,0]) clamp(Bearing,mks,mits,0,1);  //mks_spacers
	translate([78,-52,0]) clamp(Bearing,0,mits,0);  // no mks_spacers
	translate([78,0,0]) clamp(Bearing,0,mits,0);  // no mks_spacers
	if(Mount == 1) translate([0,45,0]) motormount();
	if(Mount == 2) translate([0,45,0]) testmotormount();
}

/////////////////////////////////////////////////////////////////////////////

module testmotormount() {	// for making a test print of the motormount section that
	difference() {			// mounts against the clamp
		motormount();
		translate([25,-30,-5]) cube([100,100,100]);
	}
}

//////////////////////////////////////////////////////////////////////

module motormount(mks=0) { // this holds the stepper motor
	difference() {
		color("cyan") cubeX([mmlength,mmwidth,mmthickness],2);
		translate([mmlength-23,mmwidth/2,-1]) color("red") NEMA17_parallel_holes(mmthickness+2,5);
		mmslot(mks);
		translate([9,2,0]) rotate([0,0,90]) motormountscrewholes();
	}
}

//////////////////////////////////////////////////////////////////////

module mmslot(mks) { // add mount to simpleVX clamp (removes the area the clamp fits into)
	//translate([znutw,-(mmwidth*4)/2+1,0]) rotate([0,0,90]) screwholes(mks);
	translate([z_drv*2-35,mmwidth+1,mmthickness+4.5]) rotate([90,0,0]) color("gray")
		cylinder(h=mmwidth+4,r=(shellt+X_Motor_Bearing_clearance)/2);
	translate([-3.9,mmwidth/4-1.5,mmthickness-4.88]) color("plum") cube([znutl,znutw+2,znutdt]);
}

//////////////////////////////////////////////////////////////////////
module clamp(Bearing=0,mks=0,mits=0,Full=0,Left=0) {  // this version is now broken; simpleVX clamp;
	difference() {
		union() {
			difference() {
				bearingshell();
				bearings();
				zrodhole();
			}
			difference() {
				translate([length/2-znutw/2-0.7,z_drv,0]) znutshell(mits);
				translate([37,30,-10]) cylinder(h=10,d=screw3t);
				translate([length/2-znutw/2-0.7,z_drv,0]) znutscrew(mits);
				//if(Full) {  // notch znut hole on side to let it snap in
					//color("brown") hull() {
					//	translate([24,30,4]) rotate([20,0,0]) cube([MTSSR8l+4,15,1]);
					//	translate([24,30,-5]) rotate([-20,0,0]) cube([MTSSR8l+4,15,1]);
					//}
				//}
			}
			connector(mks,Bearing,mits);
			flange(mks,Bearing,mits);
		}
		cuthalf(Full); // remove everything below Z0
	}
	if(mks) spacers(Left);
}

/////////////////////////////////////////////////////////////////////////
msl=32;			// guide for makerslide
msw=screw5-0.1;	//    ""
mst=2;			//    ""
mss = 4.4; 		// spacer thickness

module spacers(Left=0) { // spacers for the makerslide side, so the clamps sit flat
	if(Left) {
		difference() {
			color("yellow") hull() {
				translate([mks_slot-3,bolt_w/1.1,mss-1]) cylinder(h=thickness+1.5,r=(screw5+6)/2);
				translate([mks_slot-3,bolt_w/1.1-10,mss-1]) cylinder(h=thickness+1.5,r=(screw5+6)/2);
			}
			zrodhole();
			translate([-1,0,0]) rotate([0,90,0]) sabb();
			translate([mks_slot-3,bolt_w/1.1,-znutdt/2]) cylinder(h=thickness*5,r=screw5/2);
		}
	} else {
		difference() {
			color("plum")	hull() {
				translate([mks_slot*3-3,bolt_w/1.1,mss-1]) cylinder(h=thickness+1.4,r=(screw5+6)/2);
				translate([mks_slot*3-3,bolt_w/1.1-10,mss-1]) cylinder(h=thickness+1.4,r=(screw5+6)/2);
			}
			zrodhole();
			translate([length-sabb_l,0,0]) rotate([0,90,0]) sabb();
			translate([mks_slot*3-3,bolt_w/1.1,-znutdt/2]) cylinder(h=thickness*5,r=screw5/2);
		}
	}
	// guide slot for makerslide
	difference() {
		translate([length/2-screw5/2+0.05,-0.5,9]) color("gray") cube([msw,msl,mst]);
		translate([length/2-screw5/2-1,-5,4]) rotate([45,0,0]) color("pink") cube([msw+2,msl,mst+1]);
		screwholes(1);
	}
	if(Left) {
		difference() {
			translate([mks_slot-screw5-0.2,bolt_w/1.6-10,9]) color("blue") cube([msw,msl-13,mst]);
			translate([mks_slot-screw5-1.2,bolt_w/1.6-15,4]) rotate([45,0,0]) color("gold") cube([msw+2,msl,mst]);
			screwholes(1);
		}
	} else {
		difference() {
			translate([mks_slot*3-screw5-0.2,bolt_w/1.6-10,9]) color("red") cube([msw,msl-13,mst]);
			translate([mks_slot*3-screw5-1.2,bolt_w/1.6-15,4]) rotate([45,0,0]) color("brown") cube([msw+2,msl,mst]);
			screwholes(1);
		}
	}
}

//////////////////////////////////////////////////////////////////////

module cuthalf(Full=0) {	// remove everything below Z0
	if(!Full) translate([-1,-15,-20+AdjustCF]) color("cyan") cube([length+2,length-15,20]);
}

//////////////////////////////////////////////////////////////////////

module flange(mks,Bearing,mits) {  // the part that holds it together
	difference() {
		translate([0,zrodd/2,-(thickness)]) color("red") cube([length,bolt_w,thickness*2]);
		screwholes(mks);
		zrodhole();
		bearings();	
		translate([length/2-znutw/2-0.7,z_drv,0]) znutscrew(mits);
	}
	translate([37,30,-9]) {
		difference() {
			color("brown") hull() {
				cylinder(h=1,d=screw3*2);
				translate([0,0,-3]) cylinder(h=1,d=screw3);
			}
			translate([0,0,-5]) cylinder(h=10,d=screw3t);
		}
	}
}

////////////////////////////////////////////////////////////////////////

module motormountscrewholes() {
	color("cyan") hull() {
		translate([0,0,0]) cylinder(h=thickness*5,r=screw5/2);
		translate([-5,0,0]) cylinder(h=thickness*5,r=screw5/2);
	}
	translate([mks_slot,0,0]) color("black") cylinder(h=thickness*5,r=screw5/2);
	color("white") hull() {
		translate([mks_slot*2,0,0]) color("white") cylinder(h=thickness*5,r=screw5/2);
		translate([mks_slot*2+5,0,0]) color("white") cylinder(h=thickness*5,r=screw5/2);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module screwholes(mks=1) { // screw holes for makerslide or the round rod clamps
	translate([mks_slot-3,bolt_w/1.1,-znutt/2-5]) color("gray") cylinder(h=thickness*6,r=screw5/2);
	translate([(mks_slot*2)-3,bolt_w/1.1,-znutt/2-5]) color("lightblue") cylinder(h=thickness*6,r=screw5/2);
	translate([mks_slot*3-3,bolt_w/1.1,-znutt/2-5]) color("plum") cylinder(h=thickness*6,r=screw5/2);
}

///////////////////////////////////////////////////////////////////////

module connector(mks,Bearing,mits) { // connect bearing and zscrew sections
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
			if(mks)
				translate([(length/2-znutw/2),znutw/6-2,-znutt/2-0.9]) color("ivory") cube([znutw,znutl,znutt+0.5]);
			else {
				difference() {
					translate([(length/2-znutw/2),znutw/6-2,-znutt/2-0.9]) color("white") cube([znutw,znutl,znutt+1.5]);
					translate([length/2-znutw/2,z_drv,0]) znutscrew(mits);
				}
			}
		} else {
			difference() {
				if(mks) {
					difference() {
						translate([(length/2-znutw/2),znutw/6-2,-znutt/2-0.9]) color("pink") cube([znutw,znutl,znutt+1.7]);
						translate([37,30,-15]) cylinder(h=20,d=screw3t);
					}
				} else
					translate([(length/2-znutw/2),znutw/6-2,-znutt/2-0.9]) color("cyan") cube([znutw,znutl,znutt+1.5]);
				translate([length/2-znutw/2,z_drv,0]) znutscrew(mits);
				translate([(length/2-znutw/2)-5,znutw/6+znutw+4.5,-znutt/2+9]) rotate([0,90,0])
					color("ivory") cylinder(h=35,d=MTSSR8d+0.5); // remove connectorflat main cube from z nut hole
			}
		}
}

//////////////////////////////////////////////////////////////////////////////

module zrodhole() { // through hole for the z rod
	translate([-2,0,0]) rotate([0,90,0]) color("orange") cylinder(h = length+4,r=zrodd/2);
}

/////////////////////////////////////////////////////////////////////////

module znutshell(mits,Full=0) { // part to hold the z nut
	if(!mits) {
		rotate([0,90,0]) color("salmon") cylinder(h=znutw,r=(znutd+shellt+0.5)/2);
	} else
		rotate([0,90,0]) color("khaki") cylinder(h=MTSSR8l+2.5, r=(MTSSR8d+shellt+0.5)/2);
}

/////////////////////////////////////////////////////////////////////

module bearingshell() { // part to hold the z rod bearings
	rotate([0,90,0]) color("black") cylinder(h=length,r=(shellt+sabb_d)/2);
}

///////////////////////////////////////////////////////////////////////

module znut() { // z nut, no hole
	color("gray") cylinder(h = znutt, r=znutd/2,$fn=6);
}

//////////////////////////////////////////////////////////////////////

module sabb() { // self-aligning bronze bearing, no hole
	color("brown") cylinder(h=sabb_l+1,r=sabb_d/2);
}

///////////////////////////////////////////////////////////////////////

module bearings() { // dual bearings on z rod
	translate([-1,0,0]) rotate([0,90,0]) sabb();
	translate([length-sabb_l,0,0]) rotate([0,90,0]) sabb();
}

////////////////////////////////////////////////////////////////////////

module znutscrew(mits) { // z-nut section
	if(!mits) {
		translate([-1,0,0])rotate([0,90,0]) color("blue") cylinder(h=znutw+2,r= zscrew/2);
		translate([znutw/2- znutt/2,0,0]) rotate([0,90,0]) znut(); // slot for znut
	} else {
		translate([-3,0,0])rotate([0,90,0]) color("gray") cylinder(h=MTSSR8l+8,r= zscrew/2);
		translate([1.5,0,0])rotate([0,90,0]) color("cyan") cylinder(h=MTSSR8l+31.6,r= MTSSR8d/2);
		// was translate([0.5,0,0])rotate([0,90,0]) color("cyan") cylinder(h=MTSSR8l+1.6,r= MTSSR8d/2);
	}
}

///////////// end of simpleVX.scad ////////////////////////////////////
