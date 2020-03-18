// Title: ThicknessTool
// First version: 1.0 - 03/18/2020 

// Description: This macro performs retina nuclear layer segmentation and thickness profile from cryosections. 
//
//------------------------------------
// Authors: Daniel E. Maidana, M.D. and Demetrios G. Vavvas, M.D., Ph.D.
// Massachusetts Eye and Ear Infirmary
// Harvard Medical School
// 243 Charles Street, Boston MA (02114)
// Unites States of America
// GitHub: https://github.com/DanielMaidana/ThicknessTool
// Web: https://imagej.net/RETINA_Analysis_Toolkit
//------------------------------------
// Note: Please review istructions before use!

// Copyright (C) <2020>  <Daniel E. Maidana, MD and Demetrios G. Vavvas, MD, PhD>

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
    
//------------------------------------------------------------------------------------------------------------------------------------------------------
//VARIABLES

// DIALOG
var Native_w; 	
var Native_h;
var w;
var h;
var Image_Res;
var Input_Image;
var Mic_Res;
var Native_Re;
var Native_Spatial_Scale;
var Downscaled_Res;
var Pixel_Spacer;
var Edge_Cut_Off_Margin;
var Skeleton_Cut_Off_Margin;
var Area_To_Measure_I;
var Image_to_Analyze;
var Nuclear_Layer;
var Layer_Segmentation;
var Downscaling_Factor;
var Downscaled_Spatial_Scale;
var Magnification;
var Area_To_Measure;
var Segmentation_Sensitivity;
var Stain;
var Skeleton_Gaussian;
var Tolerance;

//MACRO
var ONL_Thickness_Array = newArray();
var INL_Thickness_Array = newArray();

// SETUP
var new;
var dir;
var name; 
var path; 
var path2;
var Stack_ID;
var Manual_Freehand_ID;
var Merged_ID;
var Green_ID; 
var Red_ID; 
var Blue_ID; 
var Blue_For_ONL_ID;
var Blue_For_INL_ID;
var Mean;
var Mask_Area_ID;
var User_Defined_ID;
var User_Defined_Area_ID;

//ONL Layer	
var Objects_Count;
var Area_Array_Concat;
var Objects_Array;
var Thresholded_Area;
var Area_Array_Concat;
var Area_Larger;
var Area_Sorting;
var Rank_Max;
var Larger_Area_ID;
var ONL_Area_Final_ID;
var ONL_Area_ID;
var ONL_Area;
var	ONL_BIX;
var	ONL_BIY;
var	ONL_BXF;
var	ONL_BYF;

//INL Layer
var Blue_For_INL_ID2;
var Blue_For_INL_ID3;
var Smaller_Area_ID;
var INL_Area_ID;
var INL_Area_Final_ID;
var INL_Area;
var	INL_BIX;
var	INL_BIY;
var	INL_BXF;
var	INL_BYF;

//Manual Layer
var Manual_Area_Value;
var Manual_Area_ID;	
var Area;
var BIX;
var BIY;
var BXF;
var BYF;

var User_Defined_Mask_ID;

//Calipers
var Caliper_Number = 0; // Results equals to all
var Grid = 200; // 10x10 pixels grid
var Thickness_Array = newArray();
var Local_Thickness = newArray();
var w = getWidth;
var h = getHeight;
var Hypotenuse = 1;
var X0_F;
var Y0_F;
var X1_F;
var Y1_F;

var Square_Size = 400;
var Pixel_Distance;
var Gap = 50;
var Random = "";
var Angle = 0;
var	SpacerI_X = 1;
var SpacerI_Y = 1;
var	SpacerF_X = 1;
var SpacerF_Y = 1;
var	Pixel_Value_I = 1;
var	Pixel_Value_F = 1;
var W_Start;
var H_Start;
var W_End;
var H_End;

/*
//Thickness Profile
var Square_Size = 400;
var Square_Space = 20;
var Pixel_Distance = 20;
var Hypotenuse_Half_Estimated_Thickness = 100;
var W_Count = round(w/(Square_Space-1));
var H_Count = round(h/(Square_Space-1));
var Hypotenuse = 1;
var X0_F;
var Y0_F;
var X1_F;
var Y1_F;

var XY_Start20x = 100;
var W_End20x = w-100;
var H_End20x = h-100;

var XY_Start10x = 50;
var W_End10x = w-50;
var H_End10x = h-50;
	
var Random = "";
var Thickness_Array = newArray();


//function ONL Layer_Thickness(Image_ID) {
var Hypotenuse = 1;
var X0_F;
var Y0_F;
var X1_F;
var Y1_F;
var w = 1344;
var h = 1022;
var W_End = w-100;
var H_End = h-100;

var Square_Size = 400;
var Pixel_Distance = 20;
var Gap;

var Thickness_Array = newArray();

var Random = "";
var Angle = 0;

*/

// Results
var ONL_Area_mm;
var INL_Area_mm;
var Manual_Area_mm;
var Result_Array;

//------------------------------------------------------------------------------------------------------------------------------------------------------


Native_w = getWidth; 	
Native_h = getHeight; 
Width_S = ""+Native_w;
Height_S = ""+Native_h;
Image_Res = Width_S + " x " + Height_S + " pixels";

Downscaling_Factor_1 = Native_w/1344;
Downscaling_Factor_2 = Native_w/1200;

Downscaled_Width_1 = Native_w/Downscaling_Factor_1;
Downscaled_Height_1 = Native_h/Downscaling_Factor_1;
Downscaled_Width_1_S = ""+Downscaled_Width_1;
Downscaled_Height_1_S = ""+Downscaled_Height_1;
Downscaling_Res_1 = Downscaled_Width_1_S + " x " + Downscaled_Height_1_S + " pixels";

Downscaled_Width_2 = Native_w/Downscaling_Factor_2;
Downscaled_Height_2 = Native_h/Downscaling_Factor_2;
Downscaled_Width_2_S = ""+Downscaled_Width_2;
Downscaled_Height_2_S = ""+Downscaled_Height_2;
Downscaling_Res_2 = Downscaled_Width_2_S + " x " + Downscaled_Height_2_S + " pixels";

Html = "<html>"
     +"Visit us at: <h1>http://imagej.net/RETINA_Analysis_Toolkit</h1>"
	
Dialog.create("RETINA Thickness Profiler");
Dialog.addChoice("Image Type (20x)", newArray("Single Frame", "Tiles"));
Dialog.addChoice("Image Native Resolution", newArray(Image_Res, ""));
Dialog.addNumber("        Image Native Spatial Scale (pixels/microns):", 3.096);
Dialog.addChoice("Image Rescaling Options", newArray(Downscaling_Res_1, Downscaling_Res_2));
Dialog.addSlider("Caliper Interval (pixels):", 1, 500, 10);
Dialog.addSlider("Edge Cut-Off Margin (pixels):", 0, 300, 30);
Dialog.addSlider("Skeleton Cut-Off Margin (pixels):", 0, 300, 30);
Dialog.addSlider("Skeleton Gaussian Smoothing (Sigma):", 0, 300, 80);
Dialog.addChoice("Retina Area Selection", newArray("Automated ONL & INL", "Manual Freehand Selection", "Mask", "User Defined Thresholding"));
Dialog.addNumber("        Tolerance:", 30);
Dialog.addChoice("Layer Segmentation", newArray("Fit", "Wide"));
Dialog.addHelp(Html);
Dialog.show();

Mic_Res = Dialog.getChoice();
Native_Res = Dialog.getChoice();
Native_Spatial_Scale = Dialog.getNumber();
Downscaled_Res = Dialog.getChoice()
Pixel_Spacer = Dialog.getNumber();
Edge_Cut_Off_Margin = Dialog.getNumber();
Skeleton_Cut_Off_Margin = Dialog.getNumber();
Skeleton_Gaussian = Dialog.getNumber();
Area_To_Measure_I = Dialog.getChoice();
Tolerance = Dialog.getNumber();
Layer_Segmentation = Dialog.getChoice();


//------------------------------------------------------------------------------------------------------------------------------------------------------

if (Downscaled_Res == Downscaling_Res_1) {
	Downscaling_Factor = Downscaling_Factor_1;
} else {	
	Downscaling_Factor = Downscaling_Factor_2;
}
Downscaled_Spatial_Scale = Native_Spatial_Scale/Downscaling_Factor;

if (Mic_Res == "Single Frame") {
	Magnification = 1;
} else {
	Magnification = 0;
}

if (Area_To_Measure_I == "Automated ONL & INL") {
	Area_To_Measure = 0;
} else if (Area_To_Measure_I == "Manual Freehand Selection") {
	Area_To_Measure = 1;
} else if (Area_To_Measure_I == "Mask") {
	Area_To_Measure = 2;
} else {	
	Area_To_Measure = 3;
}  

if (Layer_Segmentation == "Fit") {
	Segmentation_Sensitivity = 1;
} else {
	Segmentation_Sensitivity = 0;
}
//------------------------------------------------------------------------------------------------------------------------------------------------------

setBatchMode(true);

macro "RETINA Thickness Profile" {

// Automated ONL & INL
if ((Magnification == 1) && (Area_To_Measure == 0)) {  
	Setup();
	ONL_Segmentation();
	INL_Segmentation();
	ONL_Thickness_Array = Calipers(ONL_Area_Final_ID, ONL_BIX, ONL_BIY, ONL_BXF, ONL_BYF);
	Thickness_Array = newArray();
	INL_Thickness_Array = Calipers(INL_Area_Final_ID, INL_BIX, INL_BIY, INL_BXF, INL_BYF);
	Results_Array(ONL_Thickness_Array,INL_Thickness_Array);
	
// Manual Freehand Selection	
} else if ((Magnification == 1) && (Area_To_Measure == 1)) {  
	Setup();
	Manual_Selection();
	Thickness_Array = Calipers(Manual_Area_ID,BIX,BIY,BXF,BYF);
	Thickness_Array2 = Thickness_Array;
	Results_Array(Thickness_Array, Thickness_Array2);
	
// Mask
} else if ((Magnification == 1) && (Area_To_Measure == 2)) {  
	Mask_Function();
	Thickness_Array = Calipers(Mask_Area_ID,BIX,BIY,BXF,BYF);
	Thickness_Array2 = Thickness_Array;
	Results_Array(Thickness_Array, Thickness_Array2);	
	
// User Defined Thresholding -> Pending
} else if  ((Magnification == 1) && (Area_To_Measure == 3)) {  
	Setup();
	User_Defined_Thresholding();
	Thickness_Array = Calipers(User_Defined_Mask_ID,BIX,BIY,BXF,BYF);
	Thickness_Array2 = Thickness_Array;
	Results_Array(Thickness_Array, Thickness_Array2);
}
}

setBatchMode(false);

//------------------------------------------------------------------------------------------------------------------------------------------------------

function Setup() {
	new = getImageID();
	dir = getDirectory("image");
	name = getTitle; 
	path = dir+name;
	path2 = path+" Files";
	File.makeDirectory(path2);
	run("ROI Manager...");
	run("Labels...", "color=white font=14 draw bold");
	run("Clear Results");
	run("Colors...", "foreground=white background=black selection=red");
	//run("Set Scale...", "distance=0");
	run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
	//run("Scale...", "x=&Downscaling_Factor_Ratio y=&Downscaling_Factor_Ratio width=&New_W height=&New_W interpolation=Bilinear average create");
	New_W = w/Downscaling_Factor;
	New_H = h/Downscaling_Factor;
	Downscaling_Factor_Ratio = 1/Downscaling_Factor;
	Downscaled_Image_ID = getImageID();
	selectImage(Downscaled_Image_ID);
	saveAs("jpeg", path2+"/Downscaled Original Image.jpg");
	w = getWidth; 	
	h = getHeight; 
  	run("Profile Plot Options...", "width=450 height=200 font=12 minimum=0 maximum=0 draw draw_ticks interpolate sub-pixel");
	//run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
	run("Duplicate...", "title=STACK");
	Stack_ID = getImageID();
	run("Duplicate...", "title=FREEHAND");
	Manual_Freehand_ID = getImageID();
	run("Duplicate...", "title=USER_DEFINED");
	User_Defined_ID = getImageID();
	run("Duplicate...", "title=MERGED");
	Merged_ID = getImageID(); 
	selectImage(Stack_ID);
	run("RGB Stack");
	run("Stack to Images");
	selectImage("Green");
	Green_ID = getImageID(); 
	selectImage("Red");
	Red_ID = getImageID(); 
	selectImage("Blue");
	Blue_ID = getImageID(); 
	run("Duplicate...", "Blue_For_ONL_ID");
	Blue_For_ONL_ID = getImageID();
	run("Duplicate...", "Blue_For_INL_ID");
	Blue_For_INL_ID = getImageID();
	selectImage(Blue_ID);
	run("Set Measurements...", "area mean min centroid display redirect=None decimal=9");
	//selectImage(Blue_ID); 
	//run("Measure");
	//Mean = getResult("Mean", 0);
}

function ONL_Segmentation() {
	selectImage(Blue_ID);
	run("Gaussian Blur...", "sigma=6");
	setAutoThreshold("Moments dark");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	for (i=0 ; i<10; i++) {
		run("Erode");
	}
	run("Remove Outliers...", "radius=20 threshold=1 which=Dark");
	run("Fill Holes");
	
	// Detect ALL
	run("Set Measurements...", "area bounding display redirect=None decimal=9");
	run("Analyze Particles...", "display clear add");
	Objects_Count = nResults;
	Area_Array_Concat = newArray();
	Objects_Array = newArray();

	for (i=0; i<Objects_Count; i++) {
		Thresholded_Area = getResult("Area",i);
	    Area_Array_Concat = Array.concat(Objects_Array,Thresholded_Area);
	    Objects_Array = Area_Array_Concat;    
	}
	Array.getStatistics(Objects_Array, min, max, mean, std);
	Area_Larger = max;

	for (i=0; i<Objects_Count; i++) {
		Area_Sorting = getResult("Area",i);
	if (Area_Sorting == Area_Larger) {
	 	Rank_Max = i;
	} else {
	}	   
	}
	//print(Rank_Max);
	newImage("Larger_Area", "8-bit white", w,h, 1);
	Larger_Area_ID = getImageID();
	selectImage(Larger_Area_ID);
	setBackgroundColor(0,0,0);
	roiManager("Select", Rank_Max);
	run("Enlarge...", "enlarge=40");
	run("Clear", "slice");
	run("Make Binary");
	//run("Invert");
	imageCalculator("Subtract create",Blue_For_ONL_ID,Larger_Area_ID);
	ONL_Area_ID = getImageID();
	selectImage(ONL_Area_ID);
	run("Maximum...", "radius=5");
	run("Gaussian Blur...", "sigma=8");
	setAutoThreshold("Intermodes dark");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	run("Fill Holes");
	//for (i=0 ; i<3; i++) {
	//	run("Dilate");
	//}
	roiManager("Reset");
	run("Analyze Particles...", "size=100000-Infinity display clear add");
	ONL_Area_Final_ID = getImageID();
	ONL_Area = getResult("Area", 0);
	ONL_BIX = getResult("BX", 0);
	ONL_BIY = getResult("BY", 0);
	ONL_BXF = getResult("Width", 0);
	ONL_BYF = getResult("Height", 0);
	//print(ONL_Area);
	selectImage(Merged_ID);
	roiManager("Select", 0);
	roiManager("Save", path2+"/ONL Area.zip");
	roiManager("Select", 0);
	run("Add Selection...");
	//run("Flatten");
	Merged_ID = getImageID();
}

function INL_Segmentation() {
	roiManager("Reset");
	run("Clear Results");
	run("Set Measurements...", "area mean min centroid display redirect=None decimal=9");
	selectImage(Blue_For_INL_ID); 
	//run("Enhance Contrast...", "saturated=10 normalize");
	imageCalculator("Subtract create",Blue_For_INL_ID,ONL_Area_ID);
	Blue_For_INL_ID2 = getImageID();
	run("Duplicate...", "Blue_For_INL_ID3");
	Blue_For_INL_ID3 = getImageID();
	selectImage(Blue_For_INL_ID2); 
	run("Gaussian Blur...", "sigma=4");
	run("Enhance Contrast...", "saturated=5 normalize");
	setAutoThreshold("Moments dark");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	for (i=0 ; i<2; i++) {
		run("Erode");
	}
	run("Set Measurements...", "area bounding display redirect=None decimal=9");
	run("Analyze Particles...", "display clear add");
	Objects_Count = nResults;
	Area_Array_Concat = newArray();
	Objects_Array = newArray();
	
	for (i=0; i<Objects_Count; i++) {
		Thresholded_Area = getResult("Area",i);
	    //print("Thresholded_Area: " + Thresholded_Area);
	    Area_Array_Concat = Array.concat(Objects_Array,Thresholded_Area);
	    Objects_Array = Area_Array_Concat;    
	}
	Array.getStatistics(Objects_Array, min, max, mean, std);
	Area_Larger = max;
	//print(Area_Larger);

	for (i=0; i<Objects_Count; i++) {
		Area_Sorting = getResult("Area",i);
	if (Area_Sorting == Area_Larger) {
	 	Rank_Max = i;
	} else {
	}	   
	}
	//print(Rank_Max);
	newImage("Smaller_Area", "8-bit white", w,h, 1);
	Smaller_Area_ID = getImageID();
	selectImage(Smaller_Area_ID);
	setBackgroundColor(0,0,0);
	roiManager("Select", Rank_Max);
	run("Enlarge...", "enlarge=20");
	run("Clear", "slice");
	run("Make Binary");
	//run("Invert");
	imageCalculator("Subtract create",Blue_For_INL_ID3,Smaller_Area_ID);
	INL_Area_ID = getImageID();
	selectImage(INL_Area_ID);
	run("Enhance Contrast...", "saturated=5 normalize");
	run("Maximum...", "radius=1");
	run("Gaussian Blur...", "sigma=10");
	setAutoThreshold("Intermodes dark");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	run("Fill Holes");
	roiManager("Reset");
	run("Analyze Particles...", "size=50000-Infinity display clear add");
	INL_Area_Final_ID = getImageID();
	INL_Area = getResult("Area", 0);
	INL_BIX = getResult("BX", 0);
	INL_BIY = getResult("BY", 0);
	INL_BXF = getResult("Width", 0);
	INL_BYF = getResult("Height", 0);
	//print(INL_Area);
	run("Colors...", "foreground=white background=black selection=green");
	selectImage(Merged_ID);
	roiManager("Select", 0);
	roiManager("Save", path2+"/INL Area.zip");
	roiManager("Select", 0);
	run("Add Selection...");
	Merged_ID = getImageID();	
	roiManager("Reset");
	//setBatchMode("show");
	run("Colors...", "foreground=white background=black selection=yellow");
}

function Manual_Selection() {
	roiManager("Reset");
	selectImage(Manual_Freehand_ID);
	run("8-bit");
	run("Colors...", "foreground=white background=black selection=yellow");
	setBatchMode("show");
	setTool("freehand");
	waitForUser("      Manual Freehand Selection", "       Select the area of interest to count cells and press OK        ");
	roiManager("Add");
	roiManager("Select", 0);
	run("Create Mask");
	run("Fill Holes");
	run("Set Measurements...", "area bounding display redirect=None decimal=9");
	run("Analyze Particles...", "size=100-Infinity pixel display");
	Manual_Area_ID = getImageID();
	Area = getResult("Area", 0);
	BIX = getResult("BX", 0);
	BIY = getResult("BY", 0);
	BXF = getResult("Width", 0);
	BYF = getResult("Height", 0);
	roiManager("Select", 0);
	roiManager("Save", path2+"/Manual Area.zip");
	roiManager("Select", 0);
/*
	selectImage(Merged_ID);
	roiManager("Select", 0);
	run("Labels...", "color=white font=14 show use draw bold");
	roiManager("Show All without labels");
	run("Add Selection...");
	//run("Flatten");	
	Merged_ID = getImageID();
	roiManager("Reset");
	selectImage(Manual_Freehand_ID);
	close();
	*/
}

function Mask_Function() {
	new = getImageID();
	dir = getDirectory("image");
	name = getTitle; 
	path = dir+name;
	path2 = path+" Files";
	File.makeDirectory(path2);
	run("ROI Manager...");
	run("Labels...", "color=white font=14 draw bold");
	run("Clear Results");
	run("Colors...", "foreground=white background=black selection=yellow");
	//run("Set Scale...", "distance=0");
	run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
	//run("Scale...", "x=&Downscaling_Factor_Ratio y=&Downscaling_Factor_Ratio width=&New_W height=&New_W interpolation=Bilinear average create");
	New_W = w/Downscaling_Factor;
	New_H = h/Downscaling_Factor;
	Downscaling_Factor_Ratio = 1/Downscaling_Factor;
	Downscaled_Image_ID = getImageID();
	selectImage(Downscaled_Image_ID);
	saveAs("jpeg", path2+"/Downscaled Original Image.jpg");
	w = getWidth; 	
	h = getHeight; 
  	run("Profile Plot Options...", "width=450 height=200 font=12 minimum=0 maximum=0 draw draw_ticks interpolate sub-pixel");
	//run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
	run("Analyze Particles...", "size=100-Infinity display pixel add");
	Mask_Area_ID = getImageID();
	run("Duplicate...", "title=MERGED");
	Merged_ID = getImageID(); 
	roiManager("Select", 0);
	roiManager("Rename", "Mask Area");
	roiManager("Save", path2+"/Mask Area.zip");
}

function User_Defined_Thresholding() {
	roiManager("Reset");
	roiManager("Show None");
	run("Colors...", "foreground=white background=black selection=yellow");
	run("Set Measurements...", "area bounding display redirect=None decimal=9");
	selectImage(User_Defined_ID);
	setBatchMode("show");
	setTool("wand");
	run("Wand Tool...", "tolerance=&Tolerance mode=8-connected");
	waitForUser("      Threshold Selection", "       Select the area of interest to count cells and press OK        ");
	run("Create Mask");
	run("Dilate");
	run("Close-");
	run("Fill Holes");
	run("Analyze Particles...", "size=100-Infinity pixel clear display add");
	User_Defined_Mask_ID = getImageID();
	selectImage(User_Defined_Mask_ID);
	Area = getResult("Area", 0);
	BIX = getResult("BX", 0);
	BIY = getResult("BY", 0);
	BXF = getResult("Width", 0);
	BYF = getResult("Height", 0);
	run("Colors...", "foreground=white background=black selection=yellow");
	selectImage(Merged_ID);
	roiManager("Select", 0);
	roiManager("Save", path2+"/Threshold Selection Area.zip");
	roiManager("Select", 0);
	run("Add Selection...");
	Merged_ID = getImageID();	
	roiManager("Reset");
	//setBatchMode("show");
	run("Colors...", "foreground=white background=black selection=yellow");
	setTool("rectangle");
	}

function Calipers(Layer_Area_ID, BIX, BIY, BXF, BYF) {
	run("Set Measurements...", "bounding centroid display redirect=None decimal=9");
	run("Plots...", "width=450 height=200 font=12 draw draw_ticks minimum=0 maximum=0");
	run("Clear Results");
	run("ROI Manager...");
	roiManager("Reset"); //Added 14:50
	selectImage(Layer_Area_ID);
	run("Duplicate...", "title=[Skeletonize_Area_ID]");
	Skeletonize_Area_ID = getImageID();
	selectImage(Skeletonize_Area_ID);
	run("Convert to Mask");
	run("Median...", "radius=10");
	run("Gaussian Blur...", "sigma=&Skeleton_Gaussian");
	run("Convert to Mask");
	run("Distance Map");
	run("8-bit");
	run("Convert to Mask");
	run("Skeletonize");
	run("Analyze Particles...", "add display");
	Skeletonized_Mask_ID = getImageID();
	roiManager("Select", 0);
	run("To Bounding Box");
	run("Measure");
	Skeleton_X1 = getResult("BX", 0);
	Skeleton_Y1 = getResult("BY", 0);
	Skeleton_X2 = getResult("Width", 0);
	Skeleton_Y2 = getResult("Height", 0);
	Skeleton_XF = Skeleton_X1+Skeleton_X2;
	Skeleton_YF = Skeleton_Y1+Skeleton_Y2;
	roiManager("Reset");
	setBackgroundColor(255, 255, 255);
	selectImage(Skeletonized_Mask_ID);
	//HORIZONTAL vs VERTICAL
	if (Skeleton_X2-Skeleton_X1 > Skeleton_Y2-Skeleton_Y1){
		//print("Skeleton is Horizontal");
		makeRectangle(Skeleton_X1+Skeleton_Cut_Off_Margin, Skeleton_Y1, (Skeleton_XF-Skeleton_X1)-Skeleton_Cut_Off_Margin*2, (Skeleton_YF-Skeleton_Y1));
	} else {
		//print("Skeleton is Vertical");
		makeRectangle(Skeleton_X1, Skeleton_Y1+Skeleton_Cut_Off_Margin, (Skeleton_XF-Skeleton_X1), (Skeleton_YF-Skeleton_Y1)-Skeleton_Cut_Off_Margin*2);
	}
	//makeRectangle(BIX+Edge_Cut_Off_Margin, BIY+Edge_Cut_Off_Margin, BXF-(Edge_Cut_Off_Margin*2), BYF-(Edge_Cut_Off_Margin*2));
	run("Clear Outside");
	run("Convert to Mask");
	run("Analyze Particles...", "add");
	Skeletonized_Trimmed_Mask_ID = getImageID();
	//setBatchMode("show");
	run("Duplicate...", "title=[Skeletonize_Points_ID]");
	Skeletonize_Points_ID = getImageID();

	selectImage(Merged_ID);
	roiManager("Select", 0);
	run("Add Selection...");
	Merged_ID = getImageID();
	
	selectImage(Skeletonize_Points_ID);
	run("Clear Results");
	run("Points from Mask");
	run("Measure");
	//setBatchMode("show");
	Total_Mask_Points = nResults;
	Usable_Mask_Points = floor(Total_Mask_Points/Pixel_Spacer);
	Centroid_X_Array = newArray(nResults/Pixel_Spacer);
	Centroid_Y_Array = newArray(nResults/Pixel_Spacer);
	Angle_Array = newArray(nResults/Pixel_Spacer);
	W_Start = Edge_Cut_Off_Margin;
	H_Start = Edge_Cut_Off_Margin;
	W_End = w-W_Start;
	H_End = h-H_Start;
	setBackgroundColor(0, 0, 0);	

	/*
	
	// CENTROID ARRAY
	for (i=0; i<Usable_Mask_Points; i++) {
		X = getResult("X",i*Pixel_Spacer);
		Y = getResult("Y",i*Pixel_Spacer);
		Centroid_X_Array[i] = X + 1;
		Centroid_Y_Array[i] = Y + 1;
	}
*/

	// CENTROID ARRAY
	for (i=0; i<Usable_Mask_Points; i++) {
		X = getResult("X",i*Pixel_Spacer);
		Y = getResult("Y",i*Pixel_Spacer);
		if ((X >= W_Start) && (Y >= H_Start) && (X <= W_End) && (Y <= H_End)) {
			Centroid_X_Array[i] = X + 1;
			Centroid_Y_Array[i] = Y + 1;
			} else {
			}
	}

	//CENTROID ARRAY CLEANUP
	//Array.show("Centroids", Centroid_X_Array,Centroid_Y_Array);
	Centroid_X_Array_Length = Centroid_X_Array.length;
	Centroid_Y_Array_Length = Centroid_Y_Array.length;

	Centroid_X_Array_Sorted = newArray();
	Centroid_Y_Array_Sorted = newArray();
	//print("Centroid_X_Array_Length =", Centroid_X_Array_Length);
	//print("Centroid_Y_Array_Length =", Centroid_Y_Array_Length);

	//Remove Zeros!!
	for (i=0; i<Centroid_X_Array_Length; i++) {
		Value_X = Centroid_X_Array[i];
		Value_Y = Centroid_Y_Array[i];
		if ((Value_X == 0) | (Value_Y == 0)) {
			//print(i, "th Element Not Included");
		} else {	
			Centroid_X_Array_Sorted = Array.concat(Centroid_X_Array_Sorted, Value_X);
			Centroid_Y_Array_Sorted = Array.concat(Centroid_Y_Array_Sorted, Value_Y);
		}
	}
	Centroid_X_Array_Sorted_Length = Centroid_X_Array_Sorted.length;
	
	// ANGLE ARRAY
	for (i=0; i<Centroid_X_Array_Sorted_Length; i++) {
		run("Set Measurements...", "fit display redirect=None decimal=9");
		run("Clear Results");
		selectImage(Skeletonized_Trimmed_Mask_ID);
		makeRectangle(Centroid_X_Array_Sorted[i]-(Grid/2), Centroid_Y_Array_Sorted[i]-(Grid/2), Grid, Grid);
		roiManager("Add");
		roiManager("Select", newArray(0,1));
		roiManager("AND");
		roiManager("Add");
		roiManager("Deselect");
		roiManager("Select", 1);
		roiManager("Delete");
		roiManager("Select", 1);
		run("Measure");
		Angle = getResult("Angle", 0);
		Angle_Array[i] = Angle;
		roiManager("Select", 1);
		roiManager("Delete");
		run("Clear Results");
		}
		
	roiManager("Reset");
	
	//CALIPER ARRAY
	//newImage("Calipers_ID", "8-bit white", w, h, 1);
	//Calipers_ID = getImageID();
	
	for (i=0; i<Centroid_X_Array_Sorted_Length; i++) {
		Angle = Angle_Array[i];
		Centroid_X = Centroid_X_Array_Sorted[i];
		Centroid_Y = Centroid_Y_Array_Sorted[i];
		
		Angle_A = Angle-90;
		Angle_C = 180-90-Angle_A;
		Angle_C_Radians = Angle_C*(PI/180);
		Angle_Radians = Angle*(PI/180);
		Angle_A_Radians = Angle_A*(PI/180);

		if ((Angle <= 45) && (Angle >= 91) && (Angle <= 135)) {
			X_Step = 1;	
			Y_Step = tan(Angle_Radians);
			Hyp_Step = round(sqrt(1 + (Y_Step*Y_Step)));
		} else {
			Y_Step = 1;	
			X_Step = tan(Angle_A_Radians);
			Hyp_Step = round(sqrt(1 + (Y_Step*Y_Step)));
		}
		
		SpacerI_X = 1;
		SpacerI_Y = 1;
		SpacerF_X = 1;
		SpacerF_Y = 1;
		Pixel_Value_I = 1;
		Pixel_Value_F = 1;
	
		while (Pixel_Value_I >= 1) {
		Pixel_Value_I = 1;
		SpacerI_X = SpacerI_X + Hyp_Step;
		SpacerI_Y = SpacerI_Y + Hyp_Step;
		selectImage(Layer_Area_ID);
		X0 = round(sin(Angle_C_Radians) * SpacerI_X + Centroid_X);
		Y0 = round(Centroid_Y - cos(Angle_C_Radians) * SpacerI_Y);
		Pixel_Value_I = getPixel(round(X0), round(Y0));
		}
	
		while (Pixel_Value_F >= 1) {
		Pixel_Value_F = 1;
		SpacerF_X = SpacerF_X + Hyp_Step;
		SpacerF_Y = SpacerF_Y + Hyp_Step;
		selectImage(Layer_Area_ID);
		X1 = round(Centroid_X - sin(Angle_C_Radians) * SpacerF_X);
		Y1 = round(cos(Angle_C_Radians) * SpacerF_Y + Centroid_Y);
		Pixel_Value_F = getPixel(round(X1), round(Y1));
		}
	
		X0_F = round(sin(Angle_C_Radians) * (SpacerI_X) + Centroid_X);
		Y0_F = round(Centroid_Y - cos(Angle_C_Radians) * (SpacerI_Y));
		X1_F = round(Centroid_X - sin(Angle_C_Radians) * (SpacerF_X-Hyp_Step));
		Y1_F = round(cos(Angle_C_Radians) * (SpacerF_Y-Hyp_Step) + Centroid_Y);

		Pixel_Value_I = getPixel(round(X0_F), round(Y0_F));
		Pixel_Value_F = getPixel(round(X1_F), round(Y1_F));
		'
		//print(Usable_Mask_Points);		
		//print(i);
		
		if ((X0_F >= W_Start) && (X1_F >= W_Start) && (Y1_F >= H_Start) && (Y0_F >= H_Start) && (X0_F <= W_End) && (X1_F <= W_End) && (Y0_F <= H_End) && (Y1_F <= H_End)) {
			Local_Thickness = sqrt ((X1_F - X0_F)*(X1_F - X0_F) + (Y1_F - Y0_F)*(Y1_F - Y0_F));
			//selectImage(Calipers_ID);
			//setBackgroundColor(100,0,0);
			//setBackgroundColor(255,255,0);
			makeLine(X0_F,Y0_F,X1_F,Y1_F);
			roiManager("Add");
			selectImage(Merged_ID);
			roiManager("Select", 0);
			run("Add Selection...");
			Merged_ID = getImageID();
			//run("Clear", "slice");
			roiManager("Select", 0);
			roiManager("Delete");
			Thickness_Array = Array.concat(Thickness_Array,Local_Thickness);
			} else {
			}
		}
		
		//roiManager("Deselect");

		return Thickness_Array;
		
		/*
		Array.getStatistics(Thickness_Array, min, max, mean, std);
		Min_Thickness = min;
		Max_Thickness = max;
		Mean_Thickness = mean;
		SD_Thickness = std;
		Variance_Thickness = SD_Thickness*SD_Thickness;
		ID_Variance = Variance_Thickness/Mean_Thickness;
		ID_SD = SD_Thickness/Mean_Thickness;
		
		print("Mean Thickness: "+ Mean_Thickness);
		print("SD Thickness: "+ SD_Thickness);
		print("Min Thickness: "+ Min_Thickness);
		print("Max Thickness: "+ Max_Thickness);
		print("Variance: "+ Variance_Thickness);
		print("Index of Dispersion (Variance): "+ ID_Variance);
		print("Index of Dispersion (SD): "+ ID_SD);
		*/
	
		//selectImage(Calipers_ID);
		//run("Invert");
		//imageCalculator("Subtract create", Layer_Area_ID,Calipers_ID);
		//Final_ID = getImageID();
		
		selectImage(Merged_ID);
		roiManager("Show All without labels");
		run("Add Selection...");
		Merged_ID = getImageID();
}		


function Results_Array(ONL_Array, INL_Array) {
	// REVIEW AREA CALCULATIONS
	ONL_Area_mm = (sqrt(ONL_Area)/Downscaled_Spatial_Scale)*(sqrt(ONL_Area)/Downscaled_Spatial_Scale)/1000000;
	INL_Area_mm = (sqrt(INL_Area)/Downscaled_Spatial_Scale)*(sqrt(INL_Area)/Downscaled_Spatial_Scale)/1000000;
	Manual_Area_mm = (sqrt(Manual_Area_Value)/Downscaled_Spatial_Scale)*(sqrt(Manual_Area_Value)/Downscaled_Spatial_Scale)/1000000;

	Array.getStatistics(ONL_Array, min, max, mean, std);
	ONL_Min_Thickness = min/Native_Spatial_Scale;
	ONL_Max_Thickness = max/Native_Spatial_Scale;
	ONL_Mean_Thickness = mean/Native_Spatial_Scale;
	ONL_SD_Thickness = std/Native_Spatial_Scale;
	ONL_Variance_Thickness = ONL_SD_Thickness*ONL_SD_Thickness;
	ONL_ID_Variance = ONL_Variance_Thickness/ONL_Mean_Thickness;
	ONL_ID_SD = ONL_SD_Thickness/ONL_Mean_Thickness;

	Array.getStatistics(INL_Array, min, max, mean, std);
	INL_Min_Thickness = min/Native_Spatial_Scale;
	INL_Max_Thickness = max/Native_Spatial_Scale;
	INL_Mean_Thickness = mean/Native_Spatial_Scale;
	INL_SD_Thickness = std/Native_Spatial_Scale;
	INL_Variance_Thickness = INL_SD_Thickness*INL_SD_Thickness;
	INL_ID_Variance = INL_Variance_Thickness/INL_Mean_Thickness;
	INL_ID_SD = INL_SD_Thickness/INL_Mean_Thickness;

	ONL_INL_Ratio = ONL_Mean_Thickness/INL_Mean_Thickness;
	
	selectImage(new);
	close();
	selectImage(Merged_ID);
	saveAs("jpeg", path2+"/Processed File.jpg");
	rename(name+" - Processed File");
	roiManager("Deselect");
	setBatchMode("show");
	
	run("Clear Results");
	setResult("Image", 0, name);
	setResult("Native Spatial Scale (pixels/microns)", 0, Native_Spatial_Scale);
	setResult("Caliper Interval (pixels)", 0, Pixel_Spacer);
	setResult("Edge Cut-Off Margin (pixels)", 0, Edge_Cut_Off_Margin);
	setResult("ONL Area (mm2)", 0, ONL_Area_mm);
	setResult("ONL Mean Thickness (µm)", 0, ONL_Mean_Thickness);
	setResult("ONL Min Thickness (µm)", 0, ONL_Min_Thickness);
	setResult("ONL Max Thickness (um)", 0, ONL_Max_Thickness);
	setResult("ONL SD Thickness (µm)", 0, ONL_SD_Thickness);
	setResult("ONL ID Variance", 0, ONL_ID_Variance);
	setResult("INL Area (mm2)", 0, INL_Area_mm);
	setResult("INL Mean Thickness (µm)", 0, INL_Mean_Thickness);
	setResult("INL Min Thickness (µm)", 0, INL_Min_Thickness);
	setResult("INL Max Thickness (µm)", 0, INL_Max_Thickness);
	setResult("INL SD Thickness (µm)", 0, INL_SD_Thickness);
	setResult("INL ID Variance", 0, INL_ID_Variance);
	setResult("Ratio ONL/INL", 0, ONL_INL_Ratio);

	Result_Array = newArray("Image", "Native Spatial Scale (pixels/microns)", "Caliper Interval (pixels)", "Edge Cut-Off Margin (pixels)", "ONL Area (mm2)", "ONL Mean Thickness (µm)", "ONL Min Thickness (µm)", "ONL Max Thickness (µm)", "ONL SD Thickness (µm)", "ONL ID Variance", "INL Area (mm2)", "INL Mean Thickness (µm)", "INL Min Thickness (µm)", "INL Max Thickness (µm)", "INL SD Thickness (µm)", "INL ID Variance", "Ratio ONL/INL)");
	saveAs("Results", path2+"/Results.xls");
	selectWindow("Results");
	//run("Close");
	run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
	roiManager("Reset");
	
	print(name);
	print("ONL Mean Thickness: ", ONL_Mean_Thickness);
	print("ONL Min Thickness: ", ONL_Min_Thickness);
	print("ONL Max Thickness: ", ONL_Max_Thickness);
	print("ONL SD Thickness: ", ONL_SD_Thickness);
	print("ONL ID Variance: ", ONL_ID_Variance);
	print("INL Mean Thickness: ", INL_Mean_Thickness);
	print("INL Min Thickness: ", INL_Min_Thickness);
	print("INL Max Thickness: ", INL_Max_Thickness);
	print("INL SD Thickness: ", INL_SD_Thickness);
	print("INL ID Variance: ", INL_ID_Variance);
	print("Ratio ONL/INL: ", ONL_INL_Ratio);
	
}		
