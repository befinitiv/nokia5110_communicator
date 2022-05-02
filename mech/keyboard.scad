KEY_X = 5;
KEY_Y = 3;
KEY_Z = 3;

KEY_SP_X = 1.5;
KEY_SP_Y = 2;

BASE_X = 87;
BASE_Y = 33;

module key_shape_2d(keyspan=1) {
    square([KEY_X+(KEY_X+KEY_SP_X)*(keyspan-1), KEY_Y], center=true);
}


module key(label, keyspan=1) {
    color("#303030")linear_extrude(KEY_Z)key_shape_2d(keyspan);
    color("white")translate([0,0,KEY_Z])linear_extrude(0.2)text(label, size=KEY_Y*0.8,valign="center", halign="center");
    
}

module place_keyseq(keyseq) {
for (i = [0:len(keyseq)-1]) {
    translate([(KEY_X+KEY_SP_X)*i,0,0])key(keyseq[i]);
}
}

translate([5,6*(KEY_Y+KEY_SP_Y)-1,0])place_keyseq("E123456789012");
translate([5,5*(KEY_Y+KEY_SP_Y)-1,0])place_keyseq("1234567890-=B");
translate([5,4*(KEY_Y+KEY_SP_Y)-1,0])place_keyseq("TQWERTZUIOP[]");
translate([5,3*(KEY_Y+KEY_SP_Y)-1,0])place_keyseq("CASDFGHJKL;,\\");
translate([5,2*(KEY_Y+KEY_SP_Y)-1,0]) {
    place_keyseq("SYXCVBNM,./");
    translate([11.5*(KEY_X+KEY_SP_X),0,0])key("E", keyspan=2);
}
translate([5,1*(KEY_Y+KEY_SP_Y)-1,0])
{
    place_keyseq("SMA");
    translate([5*(KEY_X+KEY_SP_X),0,0])key(" ", keyspan=4);
    translate([8*(KEY_X+KEY_SP_X),0,0])place_keyseq("LRUD");
}

cube([BASE_X, BASE_Y, 1]);