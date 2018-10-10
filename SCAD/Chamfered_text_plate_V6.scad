// https://www.thingiverse.com/thing:3089014
// removed the inlcuded fontlist that wasn't on my pc 9/8/18

//Set the text to render
textstring="M-MAX";

//Font name
fontname= "Old English Text MT:style=Regular"; // pick from font list off of help menu


//type
type="tag"; //[container, tag, hollow]

//where to extrude
shiftit=0.3;

//scaling up
scale=1.7;

//Text height (extrusion) in mm
textheight=6;

//Set font size in mm
textsize=10; 

//wall thickness
wall=1;

//text kerning - in font size
width_factor=.9;

//rim to combine the text
rim=0.5;

//close gaps e.g. to the dot of an i...
delta=0.5;
    


/* [Hidden] */
//-------------------------------------------------------------------------------
function is_monospaced() = 
    (fontname=="Cutive Mono" || fontname=="Droid Sans Mono" ||fontname=="Fira Mono" ||fontname=="Nova Mono" ||fontname=="PT Mono" ||fontname=="Rubik Mono" ||fontname=="Share Tech Mono" ||fontname=="Ubuntu Mono" )? 1 : 0;

echo (is_monospaced()) ;
width_big=textsize*width_factor;
width_small=textsize*width_factor*(is_monospaced()?1:.75);
width_tiny=textsize*width_factor*(is_monospaced()?1:.25);

function is_narrow_letter(c) =
    (c=="t" ||c=="f" || c=="l" || c=="i" || c=="j") ? 1 : 0;
function is_space(c) =
    (c=="." ||c==";" || c==" ") ? 1 : 0;
function width(c,d) = 
    (is_narrow_letter(c)==1 && is_narrow_letter(d)==1) ? width_small/2 : 
    (is_narrow_letter(c)==1 || is_narrow_letter(d)==1) ? width_small : 
    (is_space(c)==1 && is_space(d)==1) ? width_tiny/2 : 
    (is_space(c)==1 || is_space(d)==1) ? width_tiny : 
    width_big;
    
function widthfunction(i) = width(textstring[i-1],textstring[i-2]);
function totalwidthfunction(x) = x < 1 ? 0 : widthfunction(x) + totalwidthfunction(x - 1);
//input = [1, 3, 5, 8];
width = [for (a = [ 1 : len(textstring) ]) totalwidthfunction(a) ];
echo(width); // ECHO: [1, 6, 15, 36]

dummy_cutoutlen=len(textstring)*textsize;

/*
Customizable Text Storage Box
Version 7, November 2017
Written by MC Geisler (mcgenki at gmail dot com)

If you need to store Stuff in letters, this is the way to go.
Each letter and also the dots of 'i' and 'j' are connected together, so after printing it will not fall apart.
Have fun!

License: Attribution 4.0 International (CC BY 4.0)

You are free to:
    Share - copy and redistribute the material in any medium or format
    Adapt - remix, transform, and build upon the material
    for any purpose, even commercially.
*/

    
module writetext(textstr, sizeit)
{
    text(textstr,size=sizeit*.9,font=fontname,halign="center",valign="baseline");
}

module RiseText(textstr, textsize,textheight) 
{
    difference()
    {
        union()
        {
            for(i=[0:1:len(textstr)-1])
            {
                //extruded text
                translate([width[i],0,0])
                    linear_extrude(height=textheight,convexity = 32, scale = scale)
                        translate([0,-textsize*shiftit,0])
                            writetext(textstr[i], textsize);
                               
                //backplane
                if(type=="tag")
                {
                    translate([width[i],0,textheight-0*wall])
                        linear_extrude(height=wall,convexity = 32)
                            scale([scale,scale,1])
                                translate([0,-textsize*shiftit,0])
                                    offset(delta=-delta)   
                                        offset(delta=delta+rim)
                                            writetext(textstr[i], textsize);     


                    translate([width[i],0,textheight-0*wall])
                        linear_extrude(height=wall,convexity = 32)
                                    scale([scale,scale,1])
                                       translate([0,-textsize*shiftit,0])
                                            offset(delta=rim)
                                                writetext(textstr[i], textsize);      
                }
            }

        
        }

        if (type=="container")
        {
            translate([0,0,wall])
                for(i=[0:1:len(textstr)-1])
                {
                    translate([width[i],0,0])
                        linear_extrude(height=textheight,convexity = 32, scale = scale)
                            translate([0,-textsize*shiftit,0])
                                offset(delta=-wall)
                                    writetext(textstr[i], textsize);
                }
        }
    
 
        if (type=="hollow")
        scale([1,1,1])
            translate([0,0,-wall])
                for(i=[0:1:len(textstr)-1])
                {
                    translate([width[i],0,0])
                        linear_extrude(height=textheight,convexity = 32, scale = 0.3)
                            translate([0,-textsize*shiftit,0])
                               //offset(delta=-wall)
                                    writetext(textstr[i], textsize);
                }
    
    
    }
}


if (type=="tag" || type=="hollow")
{
   scale([1,1,-1])
        RiseText(textstring,textsize,textheight);
}
else
{
    RiseText(textstring,textsize,textheight);
}


