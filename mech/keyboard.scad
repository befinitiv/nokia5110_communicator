KEY_X = 5;
KEY_Y = 3;
$fn = 16;

KEY_Z = 3;

KEY_SP_X = 1.5;
KEY_SP_Y = 2;

BASE_X = 87;
BASE_Y = 33;

KEY_LABEL = false;

KEY_WALL_TH = 0.3;
KEY_CONTACT_D = 1.5;
KEY_CONTACT_Z = KEY_Z-0.3;
KEY_CONTACT_SPACING = 0;//0.5;

KEY_MAT_Z = 0.6;
KEY_MAT_SPACER_Z = 0.5;
KEY_COVER_Z = 1;

module key_shape_2d(keyspan=1, dimin=0) {
    square([KEY_X+(KEY_X+KEY_SP_X)*(keyspan-1)-dimin, KEY_Y-dimin], center=true);
}


module key(keyspan=1) {

    color("#303030")
        difference() {
            linear_extrude(KEY_Z)key_shape_2d(keyspan);
            translate([0,0,-0.1])linear_extrude(KEY_CONTACT_Z)key_shape_2d(keyspan, dimin=KEY_WALL_TH*2);
        }
        
        for(i = [-(keyspan-1)/2:(keyspan-1)/2]) {
            translate([i*(KEY_X+KEY_SP_X),0,KEY_CONTACT_SPACING])cylinder(d=KEY_CONTACT_D, h=KEY_Z-KEY_CONTACT_SPACING);
        } 
}

module place_keyseq(keyseq) {
for (i = [0:len(keyseq)-1]) {
    translate([(KEY_X+KEY_SP_X)*i,0,0]) {
        children();
        if(KEY_LABEL)color("white")translate([0,0,KEY_Z])linear_extrude(0.2)text(keyseq[i], size=KEY_Y*0.6,valign="center", halign="center");
    }
}
}

module key_placement() {
    translate([5,6*(KEY_Y+KEY_SP_Y)-1,0])place_keyseq("E123456789012")children(0);
    translate([5,5*(KEY_Y+KEY_SP_Y)-1,0])place_keyseq("1234567890-=B")children(0);
    translate([5,4*(KEY_Y+KEY_SP_Y)-1,0])place_keyseq("TQWERTZUIOP[]")children(0);
    translate([5,3*(KEY_Y+KEY_SP_Y)-1,0])place_keyseq("CASDFGHJKL;,\\")children(0);
    translate([5,2*(KEY_Y+KEY_SP_Y)-1,0]) {
        place_keyseq("SYXCVBNM,./")children(0);
        translate([11.5*(KEY_X+KEY_SP_X),0,0])children(1);
    }
    translate([5,1*(KEY_Y+KEY_SP_Y)-1,0])
    {
        place_keyseq("SMA")children(0);
        translate([5*(KEY_X+KEY_SP_X),0,0])children(2);
        translate([8*(KEY_X+KEY_SP_X),0,0])place_keyseq("LRUD")children(0);
    } 
}

module test_key_placement() {
    translate([0,0,0])place_keyseq("12")children(0);
    translate([0,(KEY_Y+KEY_SP_Y),0])place_keyseq("34")children(0);
}


module keymat() {
    key_placement() {
        key(); //generic key
        key(keyspan = 2); //enter
        key(keyspan = 4); //space
    }

    difference() {
        translate([1,1,0])cube([BASE_X-2, BASE_Y-2, KEY_MAT_Z]);
            translate([0,0,-0.1])key_placement() {
                linear_extrude(KEY_Z)key_shape_2d(1);
                linear_extrude(KEY_Z)key_shape_2d(2); //enter
                linear_extrude(KEY_Z)key_shape_2d(4); //space
            }
        }
}

module keymatspacer() {
    difference() {
        DIMIN = 1;
        translate([DIMIN/2, DIMIN/2, 0])cube([BASE_X-DIMIN, BASE_Y-DIMIN, KEY_MAT_SPACER_Z]);
            translate([0,0,-0.1])key_placement() {
                linear_extrude(KEY_Z)key_shape_2d(1);
                linear_extrude(KEY_Z)key_shape_2d(2); //enter
                linear_extrude(KEY_Z)key_shape_2d(4); //space
            }
        }

}


module notch() {
    NX = 0.5;
    NY = 5;
    NZ = 0.5;
    translate([NX/2,0,-NZ/2])cube([NX,NY,NZ], center=true);
}

module keycover() {
    ENLARGEMENT = 1;
    TH = 0.38;
    H = 1.8+KEY_COVER_Z+1;
    
    difference() {
        translate([0,0, -KEY_MAT_SPACER_Z/2])cube([BASE_X+ENLARGEMENT, BASE_Y+ENLARGEMENT, KEY_COVER_Z], center=true);
            translate([-BASE_X/2,-BASE_Y/2,-H+KEY_COVER_Z+0.1])key_placement() {
                linear_extrude(KEY_Z)key_shape_2d(1,dimin=-0.9);
                linear_extrude(KEY_Z)key_shape_2d(2,dimin=-0.9); //enter
                linear_extrude(KEY_Z)key_shape_2d(4,dimin=-0.9); //space
            }
        }
        
        //outer border
        difference() {
            translate([0,0,-H/2])cube([BASE_X+ENLARGEMENT+TH*2, BASE_Y+ENLARGEMENT+2*TH, H], center=true);
            cube([BASE_X+ENLARGEMENT, BASE_Y+ENLARGEMENT, 5*H], center=true);
        }
        
        //notches
        translate([-BASE_X/2-ENLARGEMENT+TH,0,-H+0.5])notch();
        translate([+BASE_X/2+ENLARGEMENT-TH,0,-H+0.5])rotate([0,0,180])notch();
        translate([0,+BASE_Y/2+ENLARGEMENT-TH,-H+0.5])rotate([0,0,-90])notch();
        translate([0,-BASE_Y/2-ENLARGEMENT+TH,-H+0.5])rotate([0,0,90])notch();
        
            
}


module testmat() {
    test_key_placement()key(); //generic key

    
    difference() {
        translate([-KEY_X/2, -KEY_Y/2, 0])cube([2*KEY_X+KEY_SP_X, 2*KEY_Y+KEY_SP_Y, KEY_MAT_Z]);
        translate([0,0,-1])test_key_placement()linear_extrude(KEY_Z)key_shape_2d();
    }
}

//testmat();
//keycover();
//keymatspacer();
keymat();