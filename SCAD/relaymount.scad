///////////////////////////////////////////////////////////////////////////////
// relaymount.scad - something to mount a relay board onto 2020
///////////////////////////////////////////////////////////////////////////////
// created 2/13/16
// last update 6/5/20
///////////////////////////////////////////////////////////////////////////////
// 2/24/16	- added zip tie option
// 5/17/16	- changed to use CubeX and the corrected the math for the mount holes
//			  added zip tie thickness and the option to have screw & zip mount
// 8/18/16	- Added x,y vars for pc board holes
// 5/10/19	- made the mount() parametric via the passed variables
// 4/21/20	- added 3mm brass inserts
// 6/1/20	- Added 24v relay module (FC-86) from Amazon
// 6/5/20	- Added 24vdc to 12vdc convertor
///////////////////////////////////////////////////////////////////////////////
use <inc/cubex.scad>
include <inc/screwsizes.scad>
include <inc/brassinserts.scad>
$fn=50;
///////////////////////////////////////////////////////////////////////////////
// vars
///////////////////////////////////////////////////////////////////////////////
//Thickness=6;	// thickness of base plate
BossHeight = 4;		// spacing needed to clear stuff on bottom of board
ZipTieWidth = 4;		// zip tie width
ZipTieThickness = 2;	// zip tie thickness)
Use3mmInsert=1;
LargeInsert=1;
///////////////////////////////////////////////////////////////////////////////

// 1st arg is type: 0 - zip tie mount;1 - screw mount;2 - both;3 - neither
//RelayMount(2,Width,Length,Thickness,Side_dx,Side_dy);
//RelayMount(2,26.2,50,6,2.6,2.6); // 12v relay module from Amazon
RelayMount(2,21.2,43.1,6,6.3,3); // ebay buck convertor
//RelayMount(2,33,49.9,6,3,3); // 24vdc relay module from Amazon
//RelayMount(2,46.7,51.5,6,4,6); // 24vdc to 12vdc convertor

///////////////////////////////////////////////////////////////////////////////

module RelayMount(type,width,length,thickness,side_dx,side_dy) {
	difference() {
		color("cyan") cubeX([length,width,thickness],2);
		boardholes(Yes3mmInsert(Use3mmInsert,LargeInsert),thickness+1,side_dx,side_dy,length,width);
		if(type==0)	zip(width,length,thickness);
		if(type==1) mounthole(screw3,width,length,thickness);
		if(type==2) {
			mounthole(screw5,width,length,thickness);
			zip(width,length,thickness);
		}
		if(type==3) ;	// neither
	}
	boss(Yes3mmInsert(Use3mmInsert,LargeInsert),thickness,side_dx,side_dy,length,width);
}


///////////////////////////////////////////////////////////////////////////////

module boardholes(Screw,thickness,side_dx,side_dy,length,width) { // holes for mounting the relay board
		translate([side_dx,side_dy,-2]) cylinder(h=thickness+8,d=Screw);
		translate([length-side_dx,side_dy,-2]) cylinder(h=thickness+8,d=Screw);
		translate([side_dx,width-side_dy,-2]) cylinder(h=thickness+8,d=Screw);
		translate([length-side_dx,width-side_dy,-2]) cylinder(h=thickness+8,d=Screw);
}
///////////////////////////////////////////////////////////////////////////////

module mounthole(Screw,width,length,thickness) { // hole to mount it to 2020
	translate([length/2,width/2,-2]) cylinder(h=thickness+5,d=Screw);
	// countersink the screw
	translate([length/2,width/2,thickness-1]) cylinder(h=thickness+5,r=screw5hd/2);
	
}

///////////////////////////////////////////////////////////////////////////////

module boss(Screw,thickness,side_dx,side_dy,length,width) {
	difference() {
		translate([side_dx,side_dy,0]) color("red") cylinder(h=thickness+BossHeight,d=Screw*2);
		translate([side_dx,side_dy,-1]) cylinder(h=thickness+8,d=Screw);
	}
	difference() {
		translate([length-side_dx,side_dy,]) color("blue") cylinder(h=thickness+BossHeight,d=Screw*2);
		translate([length-side_dx,side_dy,-1]) cylinder(h=thickness+8,d=Screw);
	}
	difference() {
		translate([side_dx,width-side_dy,0]) color("plum") cylinder(h=thickness+BossHeight,d=Screw*2);
		translate([side_dx,width-side_dy,-1]) cylinder(h=thickness+8,d=Screw);
	}
	difference() {
		translate([length-side_dx,width-side_dy,0]) color("black") cylinder(h=thickness+BossHeight,d=Screw*2);
		translate([length-side_dx,width-side_dy,-1]) cylinder(h=thickness+8, d=Screw);
	}
}

/////////////////////////////////////////////////////////////////////////////////

module zip(width,length,thickness) {
	translate([length/2-ZipTieWidth/2,-1,thickness-ZipTieThickness/2]) cube([ZipTieWidth,60,3]);
}

//////////////////// end of relaymount.scad ///////////////////////////////////