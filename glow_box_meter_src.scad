/* [Box Options] */
// Dimension: Box outer X-Size [mm]
box_Size_X          = 60;
// Dimension: Box outer Y-Size [mm]
box_Size_Y          = 150;
// Dimension: Box Inner height [mm]
box_Inner_Height    = 60
;
// Box bottom/top thickness
box_BottomTop_Thickness =  1.6; // [0.6:0.2:3]
// Edge corner radius 
box_Screw_Corner_Radius =  2; // [2:1:10]
// four outer screw hole diameters
box_Screw_Diameter     =   2.5; // [2:0.2:4]
// Box wall thickness
box_Wall_Thickness     =   3.6; // [0.4:0.2:3.2]
/* [Top Barrier Options] */
// Box barrier thickness
barrier_Thickness  =  1.2; // [0.4:0.2:3.2]
// Box barrier height
barrier_Height     =  3;   // [1.0:0.2:8]
// Additional width on the lid to correct for badly calibrated printers
barrier_Tolerance  =  0.8; // [0.0:0.1:1]
// Add a TPU inset model and lower the barrier accordingly (while keeping the overall "ditch" depth)?
TPU_Inset          =  0.0; // [0:No, 0.2:0.2mm, 0.4:0.4mm, 0.6:0.6mm, 0.8:0.8mm, 1:1.0mm]
// Reduce TPU inset X/Y dimensions for easier installation (Opposite of barrier tolerance above)?
TPU_Inset_XY_reduction =  0.4; // [0.0:0.1:1]
/* [Mouting Screw Nose Options] */
// Number of screw noses
screwnose_Number        = 4; // [0:No noses, 2: one top/one bottom, 4: two top/two bottom]
// Diameter of the noses' screw holes
screwnose_Diameter      = 3; // [2:0.2:8]
// Height of the noses
screwnose_Height        = 3; // [2:0.2:10]
// Wall thickness
screwnose_Wall_Thickness = 2.8; // [2:0.2:5]

// **************************
// ** Calculated globals
// **************************
boxHeight = box_Inner_Height+box_BottomTop_Thickness;

module box() {
	barrier_Thickness = box_Wall_Thickness-barrier_Thickness;
	difference() {
		union() {
			// solid round box, corners
			translate([box_Screw_Corner_Radius, box_Screw_Corner_Radius, 0]) cylinder(r=box_Screw_Corner_Radius, h=boxHeight, $fn=50); // bottom left
			translate([box_Size_X-box_Screw_Corner_Radius, box_Screw_Corner_Radius, 0]) cylinder(r=box_Screw_Corner_Radius, h=boxHeight, $fn=50); // bottom right
			translate([box_Screw_Corner_Radius, box_Size_Y-box_Screw_Corner_Radius, 0]) cylinder(r=box_Screw_Corner_Radius, h=boxHeight, $fn=50); // top left
			translate([box_Size_X-box_Screw_Corner_Radius, box_Size_Y-box_Screw_Corner_Radius, 0]) cylinder(r=box_Screw_Corner_Radius, h=boxHeight, $fn=50); // bottom right
			// solid round box, inner filling
			translate([0, box_Screw_Corner_Radius, 0]) cube([box_Size_X, box_Size_Y-2*box_Screw_Corner_Radius, boxHeight]);
			translate([box_Screw_Corner_Radius, 0, 0]) cube([box_Size_X-2*box_Screw_Corner_Radius, box_Size_Y, boxHeight]);
			// solid round box, top border
			translate([barrier_Thickness, box_Screw_Corner_Radius+barrier_Thickness, 0]) cube([box_Size_X-2*barrier_Thickness, box_Size_Y-2*box_Screw_Corner_Radius-2*barrier_Thickness, max(boxHeight+barrier_Height-TPU_Inset, 0)]);
			translate([box_Screw_Corner_Radius+barrier_Thickness, barrier_Thickness, 0]) cube([box_Size_X-2*box_Screw_Corner_Radius-2*barrier_Thickness, box_Size_Y-2*barrier_Thickness, max(boxHeight+barrier_Height-TPU_Inset, 0)]);
		}
		// inner cut-out
		translate([box_Wall_Thickness, box_Screw_Corner_Radius+box_Wall_Thickness, box_BottomTop_Thickness]) cube([box_Size_X-2*box_Wall_Thickness, box_Size_Y-2*box_Screw_Corner_Radius-2*box_Wall_Thickness, boxHeight+barrier_Height]);
		translate([box_Screw_Corner_Radius+box_Wall_Thickness, box_Wall_Thickness, box_BottomTop_Thickness]) cube([box_Size_X-2*box_Screw_Corner_Radius-2*box_Wall_Thickness, box_Size_Y-2*box_Wall_Thickness, boxHeight+barrier_Height]);
		// Screw holes
		translate([(box_Screw_Corner_Radius+box_Wall_Thickness)/2,(box_Screw_Corner_Radius+box_Wall_Thickness)/2,-1]) cylinder(r=box_Screw_Diameter/2, h=boxHeight+2, $fn=20);
		translate([(box_Screw_Corner_Radius+box_Wall_Thickness)/2,box_Size_Y-(box_Screw_Corner_Radius+box_Wall_Thickness)/2,-1]) cylinder(r=box_Screw_Diameter/2, h=boxHeight+2, $fn=20);
		translate([box_Size_X-(box_Screw_Corner_Radius+box_Wall_Thickness)/2,(box_Screw_Corner_Radius+box_Wall_Thickness)/2,-1]) cylinder(r=box_Screw_Diameter/2, h=boxHeight+2, $fn=20);
		translate([box_Size_X-(box_Screw_Corner_Radius+box_Wall_Thickness)/2,box_Size_Y-(box_Screw_Corner_Radius+box_Wall_Thickness)/2,-1]) cylinder(r=box_Screw_Diameter/2, h=boxHeight+2, $fn=20);
		// **************************
		// ** YOUR OWN CUTOUTS HERE!
		// **************************
		cRadius = 0.0;
		translate([box_Size_X/2+8,(box_Wall_Thickness+0.1), box_Wall_Thickness+((boxHeight-box_Wall_Thickness)/2)]) rotate([90,00,0]) cylinder(r=cRadius2, h=box_Wall_Thickness+0.2,$fn=50);
		cRadius2 = 0.0;
		translate([box_Size_X/2-8,(box_Wall_Thickness+0.1), box_Wall_Thickness+((boxHeight-box_Wall_Thickness)/2)]) rotate([90,00,0]) cylinder(r=cRadius, h=box_Wall_Thickness+0.2,$fn=50);
		// **************************
		// ** / CUTOUTS
		// **************************
	}
	// Lower nose(s)
	if (screwnose_Number==2) translate([box_Size_X/2, 0.001, 0]) mirror([0,1,0]) screwNose(screwnose_Diameter, screwnose_Height);
	if (screwnose_Number==4) {
		translate([box_Size_X*0.25, 0.001, 0]) mirror([0,1,0]) screwNose(screwnose_Diameter, screwnose_Height);
		translate([box_Size_X*0.75, 0.001, 0]) mirror([0,1,0]) screwNose(screwnose_Diameter, screwnose_Height);
	}
	// Upper nose(s)
	if (screwnose_Number==2) translate([box_Size_X/2, box_Size_Y-0.001, 0]) screwNose(screwnose_Diameter, screwnose_Height);
	if (screwnose_Number==4) {
		translate([box_Size_X*0.25, box_Size_Y-0.001, 0]) screwNose(screwnose_Diameter, screwnose_Height);
		translate([box_Size_X*0.75, box_Size_Y-0.001, 0]) screwNose(screwnose_Diameter, screwnose_Height);
	}
}

module lid() {
	boxHeight = box_BottomTop_Thickness+barrier_Height;
	difference() {
		union() {
			// solid round box, corners
			translate([box_Screw_Corner_Radius, box_Screw_Corner_Radius, 0]) cylinder(r=box_Screw_Corner_Radius, h=boxHeight, $fn=50); // bottom left
			translate([box_Size_X-box_Screw_Corner_Radius, box_Screw_Corner_Radius, 0]) cylinder(r=box_Screw_Corner_Radius, h=boxHeight, $fn=50); // bottom right
			translate([box_Screw_Corner_Radius, box_Size_Y-box_Screw_Corner_Radius, 0]) cylinder(r=box_Screw_Corner_Radius, h=boxHeight, $fn=50); // top left
			translate([box_Size_X-box_Screw_Corner_Radius, box_Size_Y-box_Screw_Corner_Radius, 0]) cylinder(r=box_Screw_Corner_Radius, h=boxHeight, $fn=50); // bottom right
			// solid round box, inner filling
			translate([0, box_Screw_Corner_Radius, 0]) cube([box_Size_X, box_Size_Y-2*box_Screw_Corner_Radius, boxHeight]);
			translate([box_Screw_Corner_Radius, 0, 0]) cube([box_Size_X-2*box_Screw_Corner_Radius, box_Size_Y, boxHeight]);
			// solid round box, top border
		}
		// inner cut-out X direction
		translate([
			box_Wall_Thickness-(barrier_Thickness+barrier_Tolerance),
			box_Screw_Corner_Radius+box_Wall_Thickness-(barrier_Thickness+barrier_Tolerance),
			box_BottomTop_Thickness
		]) cube([
			box_Size_X-2*(box_Wall_Thickness)+2*(barrier_Thickness+barrier_Tolerance),
			box_Size_Y-2*box_Screw_Corner_Radius-2*(box_Wall_Thickness)+2*(barrier_Thickness+barrier_Tolerance),
			box_BottomTop_Thickness+barrier_Height
		]);
		// inner cut-out Y direction
		translate([
			box_Screw_Corner_Radius+box_Wall_Thickness-(barrier_Thickness+barrier_Tolerance),
			box_Wall_Thickness-(barrier_Thickness+barrier_Tolerance),
			box_BottomTop_Thickness
		]) cube([
			box_Size_X-2*box_Screw_Corner_Radius-2*(box_Wall_Thickness)+2*(barrier_Thickness+barrier_Tolerance),
			box_Size_Y-2*(box_Wall_Thickness)+2*(barrier_Thickness+barrier_Tolerance),
			box_BottomTop_Thickness+barrier_Height
		]);
		
		// Screw holes
		translate([(box_Screw_Corner_Radius+box_Wall_Thickness)/2,(box_Screw_Corner_Radius+box_Wall_Thickness)/2,-1]) cylinder(r=box_Screw_Diameter/2, h=boxHeight+2, $fn=20);
		translate([(box_Screw_Corner_Radius+box_Wall_Thickness)/2,box_Size_Y-(box_Screw_Corner_Radius+box_Wall_Thickness)/2,-1]) cylinder(r=box_Screw_Diameter/2, h=boxHeight+2, $fn=20);
		translate([box_Size_X-(box_Screw_Corner_Radius+box_Wall_Thickness)/2,(box_Screw_Corner_Radius+box_Wall_Thickness)/2,-1]) cylinder(r=box_Screw_Diameter/2, h=boxHeight+2, $fn=20);
		translate([box_Size_X-(box_Screw_Corner_Radius+box_Wall_Thickness)/2,box_Size_Y-(box_Screw_Corner_Radius+box_Wall_Thickness)/2,-1]) cylinder(r=box_Screw_Diameter/2, h=boxHeight+2, $fn=20);

		// Meter cutout: 38mm center hole + 4x 3mm mounting holes on a 31.5mm square pattern
		// Displaced 45mm down from the top edge
		translate([box_Size_X / 2, box_Size_Y - 30, -1]) {
			cylinder(d=38, h=boxHeight + 2, $fn=100);
			translate([-31.5/2, -31.5/2, 0]) cylinder(d=3, h=boxHeight + 2, $fn=30);
			translate([ 31.5/2, -31.5/2, 0]) cylinder(d=3, h=boxHeight + 2, $fn=30);
			translate([-31.5/2,  31.5/2, 0]) cylinder(d=3, h=boxHeight + 2, $fn=30);
			translate([ 31.5/2,  31.5/2, 0]) cylinder(d=3, h=boxHeight + 2, $fn=30);
		}

		// Rectangular Switch Cutout (12mm x 18.5mm)
		translate([box_Size_X / 2 - 12/2- 15, 70, -1]) {
			cube([12, 18.5, boxHeight + 2]);
		}
	}
}

module TPU_Inset() {
  difference() {
    union() {
      translate([
        box_Wall_Thickness-(barrier_Thickness+barrier_Tolerance-TPU_Inset_XY_reduction),
        box_Screw_Corner_Radius+box_Wall_Thickness-(barrier_Thickness+barrier_Tolerance-TPU_Inset_XY_reduction),
        0
      ]) cube([
        box_Size_X-2*(box_Wall_Thickness)+2*(barrier_Thickness+barrier_Tolerance-TPU_Inset_XY_reduction),
        box_Size_Y-2*box_Screw_Corner_Radius-2*(box_Wall_Thickness)+2*(barrier_Thickness+barrier_Tolerance-TPU_Inset_XY_reduction),
        TPU_Inset
      ]);
      // inner cut-out Y direction
      translate([
        box_Screw_Corner_Radius+box_Wall_Thickness-(barrier_Thickness+barrier_Tolerance-TPU_Inset_XY_reduction),
        box_Wall_Thickness-(barrier_Thickness+barrier_Tolerance-TPU_Inset_XY_reduction),
        0
      ]) cube([
        box_Size_X-2*box_Screw_Corner_Radius-2*(box_Wall_Thickness)+2*(barrier_Thickness+barrier_Tolerance-TPU_Inset_XY_reduction),
        box_Size_Y-2*(box_Wall_Thickness)+2*(barrier_Thickness+barrier_Tolerance-TPU_Inset_XY_reduction),
        TPU_Inset
      ]);
    }
    // inner cutout X direction
    translate([
      box_Wall_Thickness+barrier_Tolerance-TPU_Inset_XY_reduction,
      box_Screw_Corner_Radius+box_Wall_Thickness+barrier_Tolerance-TPU_Inset_XY_reduction, 
      -1
    ]) cube([
      box_Size_X-2*(box_Wall_Thickness+barrier_Tolerance-TPU_Inset_XY_reduction), 
      box_Size_Y-2*(box_Screw_Corner_Radius+box_Wall_Thickness+barrier_Tolerance-TPU_Inset_XY_reduction), 
      TPU_Inset +2
    ]);
    // inner cutout Y direction
    translate([
      box_Screw_Corner_Radius+box_Wall_Thickness+barrier_Tolerance-TPU_Inset_XY_reduction,
      box_Wall_Thickness+barrier_Tolerance-TPU_Inset_XY_reduction,
      -1
    ]) cube([
      box_Size_X-2*(box_Screw_Corner_Radius+box_Wall_Thickness+barrier_Tolerance-TPU_Inset_XY_reduction),
      box_Size_Y-2*(box_Wall_Thickness+barrier_Tolerance-TPU_Inset_XY_reduction),
      TPU_Inset+2
    ]);
  }
}

module screwNose(screwholeDiameter=4, noseHeight=5) {
	additionalDistanceFromWall = 1;
	translate([0,screwholeDiameter/2+screwnose_Wall_Thickness+additionalDistanceFromWall, 0]) difference() {
		union() {
			translate([-(screwholeDiameter/2+screwnose_Wall_Thickness), -(screwholeDiameter/2+screwnose_Wall_Thickness+additionalDistanceFromWall),0]) cube([(screwholeDiameter/2+screwnose_Wall_Thickness)*2, screwholeDiameter/2+screwnose_Wall_Thickness+additionalDistanceFromWall, noseHeight]);
			cylinder(r=(screwholeDiameter/2)+screwnose_Wall_Thickness, h=noseHeight, $fn=60);
		}
		translate([0,0,-1]) cylinder(r=screwholeDiameter/2, h=noseHeight+2, $fn=60);
	}
}
box();
if (box_Size_X>box_Size_Y) {
	translate([0, box_Size_Y+5+screwnose_Diameter+screwnose_Wall_Thickness, 0]) lid();
  if (TPU_Inset > 0) {
    translate([0, (box_Size_Y+5)*2+screwnose_Diameter+screwnose_Wall_Thickness, 0]) TPU_Inset();
  }
} else {
	translate([box_Size_X+5, 0, 0]) lid();	
  if (TPU_Inset > 0) {
    translate([(box_Size_X+5)*2, 0, 0]) TPU_Inset();
  }
}

