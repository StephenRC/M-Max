////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PlainLEDStripHolderEXO.scad
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 2/13/21
// last update 4/6/21
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 3/4/21	- Added a cover fot hte neo strip, needs to be print in a transparent filament
// 3/5/21	- Added a strip holder for a plain strip of leds 100mm long to mount on the bottom
// 3/6/21	- PlainLEDStripHolder() can now use two strips
// 4/3/21	- Added hole for NEOPixelCover() if a non-transparent filametnt is used.  Added labels.
// 4/4/21	- Widden the plain led strip holder to get the leds closer to the hotend and can install two strips
//			  Converted to use BOSL2
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
include <inc/brassinserts.scad>
include <BOSL2/std.scad> //inc/cubex.scad>
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// For https://www.adafruit.com/product/1426
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
LEDStripWidth=8.5;
LayerThickness=0.3;
/////////////////////////////////////////////////////////////////////////////////////////////////

PlainLEDStripHolder();

///////////////////////////////////////////////////////////////////////////////////////////////////////

module PlainLEDStripHolder(DoTabs=1) {
	difference() {
		translate([0,-10,0]) color("cyan") cuboid([110,45,4],rounding=2);
		translate([-20,15,0]) {
			translate([0,-10,-3])color("red") cylinder(h=10,d=screw4);
			translate([40,-10,-3]) color("blue") cylinder(h=10,d=screw4);
			translate([0,-10,1.5])color("blue") cylinder(h=5,d=screw4hd);
			translate([40,-10,1.5]) color("red") cylinder(h=5,d=screw4hd);
		}
		translate([0,10,0]) ZipTieHoleSlot();
		translate([-50,10,0]) ZipTieHoleSlot();
		translate([-99,10,0]) ZipTieHoleSlot();
		translate([0,25,0]) {
			ZipTieHoleSlot();
			translate([-50,0,0]) ZipTieHoleSlot();
			translate([-99,0,0]) ZipTieHoleSlot();
		}
	}
	if(DoTabs) {
		translate([52,-30,-2]) color("red") cylinder(h=LayerThickness,d=10);
		translate([-52,-30,-2]) color("blue") cylinder(h=LayerThickness,d=10);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZipTieHoleSlot(TwoStrips=0) { // the sticky back on the led strip doesn't hold very good
	translate([-54,-40,0]) {
		translate([103,11,-3]) color("black") cylinder(h=10,d=3.5);
		translate([103,11-LEDStripWidth,-3]) color("gray") cylinder(h=10,d=3.5);
		translate([103.11,6,-1.5]) color("lightgray") cuboid([5,14,4],rounding=2);
	}
}

