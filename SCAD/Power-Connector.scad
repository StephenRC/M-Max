////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Power-Connector.scad - uses a pc style power socket with switch
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 7/4/2016
// last update 5/10/19
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/4/16	- Added cover
// 8/5/16	- adjusted cover & 2020 mounting holes
// 1/10/17	- Added colors for easier editing in preview and added mount for a power switch
// 1/11/17	- Added label to power switch mount
// 8/19/18	- OpenSCAD 2018.06.01 for $preview
// 5/10/19	- Added a rear cover for the power switch
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// NOTE: Originally used Digi-Key Part number: CCM1666-ND
//		 http://www.digikey.com/product-detail/en/te-connectivity-corcom-filters/1609112-3/CCM1666-ND/758835
//		 ---------------------------------------------------------------------------------------------------
//		 If the socket hole size changes, then the size & postions of the walls/wings & socket may need adjusting
//		 The power socket uses 3mm screws to mount, drill with 2.5mm and tap after installing the socket
///////////////////////////////////////////////////////////////////////////////////////////////////////////
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
include <inc/screwsizes.scad>
use <BABIND.TTF>	// true type font used for the label
$fn = 50;
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// vars
s_width = 40;	// socket hole width
s_height = 27;	// socket hole height
socket_shift = 0; // move socket left/right
socket_s_shift = 0; // move socket up/down
///////////////////////////////////////////////////////////////////////////////////////////////////////////

all(0,13,19.5,2);// 1st arg: flip; next 4 args: flip label, width, length, clip thickness; defaults to 0,13,19.5,2
//testfit();	// print part of it to test fit the socket & 2020
//switch();		// 4 args: flip label, width, length, clip thickness; defaults to 0,13,19.5,2
//powersupply_cover();

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module all(flip=0,s_w=13,s_l=19.5,s_t=2) {
	if($preview) %translate([25,20,0]) cube([200,200,2],center=true); // show the 200x200 bed
	translate([0,-12,0]) housing();
	translate([0,-5,45]) rotate([180,0,0]) cover();
	translate([-50,-45,0])	switch(flip,s_w,s_l,s_t);		// 3 args: width, length, clip thickness; defaults to 13,19.5,2
	translate([-30,60,0]) powersupply_cover();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
pwr_c = 1;
pwr_w=115+pwr_c;
pwr_h=50+pwr_c;
pwr_depth=19;
pwr_tab=24;

module powersupply_cover() {
	difference() {
		color("cyan") cubeX([pwr_w+6,pwr_h+3,pwr_depth*2-15],1); // outer box
		translate([3,1.5,1.5]) color("red") cubeX([pwr_w,pwr_h,pwr_depth+10],1); // inner box
		translate([12,17,-2]) color("gray") hull() { // wire access hole
			cylinder(h=10,d=10);
			translate([pwr_w-22,0,0]) cylinder(h=10,d=10);
		}
		translate([11,pwr_h/2+1,-2]) pwrsup_vent(17); // ventilation
	}
	pwrsup_mount(); // mount it to the power supply
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
pwr_mspc=25;
pwr_adj=1;

module pwrsup_mount(Screw=screw4) {
	difference() {
		translate([0.5,0,pwr_depth-1]) color("blue") cubeX([1.5,pwr_h+3,pwr_depth],1);
		pwrsup_screws(screw4);
	}
	difference() {
		translate([pwr_w+4,0,pwr_depth-1]) color("plum") cubeX([1.5,pwr_h+3,pwr_depth],1);
		pwrsup_screws(screw4);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module pwrsup_screws(Screw) {
	translate([-5,pwr_h/4+pwr_adj,pwr_depth*1.5]) rotate([0,90,0]) color("black") cylinder(h=pwr_w+15,d=Screw);
	translate([-5,pwr_h/4+pwr_mspc+pwr_adj,pwr_depth*1.5]) rotate([0,90,0]) color("white") cylinder(h=pwr_w+15,d=Screw);
}


////////////////////////////////////////////////////////////////////////////////////////////////////////

module pwrsup_vent(Qty=1) {
	for(a = [0:Qty-1]) {
		translate([a*6,0,0]) color("black") hull() {
			cylinder(h=10,d=3);
			translate([0,20,0]) cylinder(h=10,d=3);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module housing() {
	if($preview) %translate([-5,18,0]) cube([5,60,5]); // something to show max height
	difference() {
		color("blue") cubeX([s_width+40,s_height+40,5],2); // base
		// socket hole
		translate([s_width/2+socket_shift,s_height/2+14+socket_s_shift,-2]) color("cyan") cube([s_width,s_height,10]);
		translate([s_width,9,-2])  color("green") cylinder(h=10,r=screw5/2); // center 2020 mounting hole
	}
	difference() {
		translate([0,s_height+35,0]) color("red") cubeX([s_width+40,5,40],2); // top wall
		cover_screw_holes();
	}
	difference() {
		translate([0,19,0]) color("black") cubeX([5,s_height+21,40],2); // left wall
		cover_screw_holes();
	}
	difference() {
		translate([s_width+35,19,0]) color("white") cubeX([5,s_height+21,40],2); // right wall
		cover_screw_holes();
	}
	difference() { // right wing
		translate([s_width+35,19,0]) color("lightblue") cubeX([25,5,25],2); // wall
		translate([s_width+50,26,15]) rotate([90,0,0]) color("blue") cylinder(h=10,r=screw5/2); // 2020 mounting hole
	}
	difference() { // left wing
		translate([-20,19,0]) color("tan") cubeX([25,5,25],2); // wall
		translate([-10,26,15]) rotate([90,0,0]) color("brown") cylinder(h=10,r=screw5/2); // 2020 mounting hole
	}
	coverscrewholes();
	difference() {
		translate([-20,0,0]) color("salmon") cubeX([25,23,5],2); // left wing base filler
		translate([-10,9,-2]) color("pink") cylinder(h=10,r=screw5/2); // 2020 mounting hole
	}
	difference() {
		translate([s_width+35,0,0]) color("orange") cubeX([25,23,5],2);	// right wing base filler
		translate([s_width+50,9,-2]) color("khaki") cylinder(h=10,r=screw5/2); // 2020 mounting hole
	}
}

//////////////////////////////////////////////////////////////////

module coverscrewholes() {
	difference() {
		translate([5,40,20]) color("blue") cylinder(h=20,d=screw5); // left
		translate([5,35,13]) rotate([0,-45,0]) color("red") cube([10,10,5]);
		cover_screw_holes();
	}
	difference() {
		translate([s_width+35,40,20]) color("red") cylinder(h=20,d=screw5); // right
		translate([s_width+27,35,22]) rotate([0,45,0]) color("blue") cube([10,10,5]);
		cover_screw_holes();
	}
	difference() {
		translate([s_width,62,20]) color("white") cylinder(h=20,d=screw5); // top screw hole
		translate([s_width-5,55,20]) rotate([-45,0,0]) color("green") cube([10,10,5]);
		cover_screw_holes();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

module cover_screw_holes() {
	translate([5,40,12]) color("white") cylinder(h=35,d=screw3t); // left
	translate([s_width+35,40,12]) color("gray") cylinder(h=35,d=screw3t); // right
	translate([s_width,62,12]) color("hotpink") cylinder(h=35,d=screw3t); // top screw hole
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module testfit() { // may need adjusting if the socket size is changed
	difference() {
		sock();
		translate([-28,-10,-5]) cube([s_width+90,s_height,50]); // walls around socket only
		translate([-28,-2,-2]) cube([s_width+90,s_height+50,5]); // remove some from bottom
		translate([-28,-2,6]) cube([s_width+90,s_height+50,50]); // shorten vertical 2020 wings
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module cover() {
	difference() {
		translate([0,15,40]) color("cyan") cubeX([s_width+40,s_height+27,5],2); // base
		translate([5,42,30]) color("red") cylinder(h=20,d=screw3); // left
		translate([s_width+35,42,30]) color("white") cylinder(h=20,d=screw3); // right
		translate([s_width,64,30]) color("green") cylinder(h=20,d=screw3); // top
	}
	difference() {
		translate([0,15,25]) color("red") cubeX([s_width+40,5,20],2); // base
		color("white") hull() {
			translate([s_width,25,30]) rotate([90,0,0]) cylinder(h=15,d=10);
			translate([s_width,25,25]) rotate([90,0,0]) cylinder(h=15,d=10);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module switch(Flip=0,s_w=13,s_l=19.5,s_t=2) {
	difference() {  // switch front and switch mounting hole
		color("cyan") cubeX([s_l+15,s_w+15,5],2);
		translate([s_l/2-2,s_w/2+1,-2]) color("pink") cube([s_l,s_w,8]);
		translate([s_l/2-3.5,s_w/2+1,s_t]) color("red") cube([s_l+3,s_w,8]);
		switch_label(Flip);
	}
	translate([0,-2,0]) color("blue") cubeX([5,s_l+11,s_w+25],2); // left wall
	translate([s_l+10,-2,0]) color("salmon") cubeX([5,s_l+11,s_w+25],2); // right wall
	translate([s_l-18,s_w+10.5,0]) color("tan") cubeX([s_l+13,5,s_w+15],2); // rear wall
	difference() {
		translate([s_l-18,-2,0]) color("brown") cubeX([s_l+13,5,s_w+25],2); // top wall
		switch_label(Flip);
	}
	translate([0,0,33]) color("plum") cubeX([s_l+15,s_w+15,5],2); // rear cover
	translate([0,-22,0]) sw_mount(Flip,s_l+15);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module sw_mount(Flip=0,Width) {
	difference() {
		color("green") cubeX([Width,27,5],2);
		translate([10,10,-2]) color("red") cylinder(h=10,d=screw5,$fn=100);
		translate([25,10,-2]) color("blue") cylinder(h=10,d=screw5,$fn=100);
		translate([0,22,0]) switch_label(Flip);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module switch_label(Flip=0) {
	if(!Flip) {
		translate([5.5,-2.5,1]) rotate([180,0,0]) printchar("POWER",2,4);
		translate([4,3,1]) rotate([180,0,0]) printchar("ON  OFF",2,4);
	} else translate([29,-2,1]) rotate([0,180,0]) printchar("POWER",2,4);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module printchar(String,Height=1.5,Size=4) { // print something
	color("black") linear_extrude(height = Height) text(String, font = "Babylon Industrial:style=Normal",size=Size);
}

//////////////// end of powersocket.scad /////////////////////////
