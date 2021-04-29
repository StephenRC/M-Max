///////////////////////////////////////////////////////////////////////////////////////////////////
// PipeToTubing.scad -- mount a silencer on the brad air pump inlet
//////////////////////////////////////////////////////////////////////////////////////////////////
// C:4/18/21
// L:4/22/21
/////////////////////////////////////////////////////////////////////////////////////////////////
include <BOSL2/std.scad>
include <BOSL2/threading.scad>
//////////////////////////////////////////////////////////////////////////////////////////////////////
LayerThickness=0.4;
//////////////////////////////////////////////////////////////////////////////////////////////////////

PipeToTubing(3/8); // 3/8" pipe threades

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module PipeToTubing(Size=3/8) {
	difference() {
		union() {
			translate([0,0,-7]) color("blue") cylinder(h=17,d=25,$fn=6);
			color("plum") cylinder(h=25,d=6,$fn=100);
		}
		color("cyan") npt_threaded_rod(size=Size, $fn=72);
		translate([0,0,0]) color("red") cylinder(h=30,d=4.5,$fn=100);
		//translate([-10,0,-10]) cube([25,25,25]);   // to see cross section
		translate([0,0,-14.5]) cylinder(h=10,r1=20,r2=5,$fn=100); // bevel thread start
	}
	translate([0,0,7.625]) color("white") cylinder(h=LayerThickness,d=18);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
