// Set the width and height of the photo to build a 'platform' for the spectrogram to give it rigidity
imgwidthpixels=827;
imgheightpixels=686;
// Set how big the distance is between white and black as a scaling factor
vscalefactor=1;
// Adjust how far from zero the 'platform' is depending on the Z-height of the spectrogram (vscalefactor)
platformoffset=-119;
// Adjust the thickness of the platform
platformthickness=20;

// Combine the two pieces (spectrogram and platform)
union(){
    // Create and scale the surface. Adjust the file path below to locate your picture.
    scale([1, 1, vscalefactor]) surface(file = "/home/wstyler/Documents/cad/noise_15perc.png", invert = true);
    // Create and move the platform#
    translate([0,0,platformoffset]) cube([imgwidthpixels,imgheightpixels,platformthickness]);
}
