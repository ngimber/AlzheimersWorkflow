//**********************************************
//**********                          **********
//********** niclas.gimber@charite.de **********
//**********                          **********
//**********************************************





//******************************
//*********enter parameters here 
//******************************


//filetype
extention=".tif"


//enlargement
enlargeFactor=0; //in pixels

//size filters
minDapiSize=100; //in pixels
maxDapiSize=1000; // in pixels
minPlaqueSize=2000; //in pixels

//gaussian blur
DapiSigma=2; //in pixels
plaqueSigma=20; //in pixels


setOption("BlackBackground", true);



//****************prepare IJ for analysis
dir=getDirectory("Choose Directory");
files=getFileList(dir);
subfolder=dir+"\\analysis\\";
File.makeDirectory(subfolder);
File.makeDirectory(subfolder+"ROIs\\");
File.makeDirectory(subfolder+"Binaries\\");
File.makeDirectory(subfolder+"CSVs\\");

roiManager("reset");


run("Set Measurements...", "area mean standard modal min centroid center perimeter fit shape feret's integrated median display redirect=None decimal=9");
run("Input/Output...", "jpeg=85 gif=-1 file=.csv use_file copy_row save_column save_row");


//**************** Main Loop
for (i=0;i<files.length;i++)
	{
	if ((indexOf(files[i], extention)) >= 0) 

		{
		if (File.exists(subfolder+"Binaries\\Plaques_"+files[i]+".tif")==false)
			{
			print(files[i]+" does not exist");
		
			while (nImages>0) 
			{ 
		          selectImage(nImages); 
		          close(); 
		      	} 
			
				
			run("Collect Garbage");
			call("java.lang.System.gc");
	
			run("Bio-Formats", "  open="+dir+files[i]+" color_mode=Default view=Hyperstack stack_order=XYCZT");
			title=getTitle();
	
	
			
			//**********************************************
			//**********Segmentations and Analysis**********
			//**********************************************
	
	
			
			
			//**********Dapi Segmentation**********
				selectWindow(title);
				setSlice(1);
				run("Select All");
				run("Duplicate...", " ");
				run("Select All");
				run("Gaussian Blur...", "sigma="+DapiSigma+"");
				setAutoThreshold("Otsu dark");
				run("Convert to Mask");
				run("Watershed");
				rename("binary");
				run("Select All");
				roiManager("reset");
				selectWindow("binary");
				run("Analyze Particles...", "display clear add");
				run("Analyze Particles...", "size="+minDapiSize+"-"+maxDapiSize+" pixel display clear add");
				selectWindow("binary");
				saveAs("Tiff", subfolder+"Binaries\\Dapi_"+title+".tif");
				close();
				

				if (enlargeFactor>0)
					{
					counts=roiManager("count");
					for(i=0; i<counts; i++) {
					    roiManager("Select", i);
					    run("Enlarge...", "enlarge="+enlargeFactor+" pixel");
					    roiManager("Update");
					}
				}
	
			
				//rename ROIs
				faculty=newArray();
				 n = roiManager("count");
				  for (r=0; r<n; r++) 
				  	{
				  	faculty=Array.concat(faculty,r);
				    roiManager("select", r);  
				    roiManager("Rename", r);
				  	}
			
				  roiManager("Save", subfolder+"ROIs\\Cells_"+title+".zip");
			
			//**********Measure Clec7a **********
			selectWindow(title);
			setSlice(2);
			run("Select All");
			run("Duplicate...", "title=tmp");
			run("Clear Results");
			roiManager("Deselect");
			//roiManager("Select", faculty);
			roiManager("multi-measure measure_all");
			saveAs("Results", ""+subfolder+"CSVs\\"+title+"Clec7.csv");
			close("tmp");
			
			
			//**********Measure Iba1 **********
			selectWindow(title);		
			setSlice(4);
			run("Select All");
			run("Duplicate...", "title=tmp");
			run("Clear Results");
			roiManager("Deselect");
			
			//roiManager("Select", faculty);
			roiManager("multi-measure measure_all");
	
			saveAs("Results", ""+subfolder+"CSVs\\"+title+"Iba1.csv");
			close("tmp");
			
			
			
			//**********Segment Lesions **********
			selectWindow(title);
			setSlice(3);
			run("Select All");
			run("Duplicate...", " ");
			run("Gaussian Blur...", "sigma="+plaqueSigma+"");
			setAutoThreshold("Otsu dark");
			run("Convert to Mask");
			rename("binary");
			run("Select All");
			roiManager("reset");
			selectWindow("binary");
			run("Analyze Particles...", "size="+minPlaqueSize+"-Infinity pixel display clear add slice");
			faculty=newArray();
			n = roiManager("count");
				  for (r=0; r<n; r++) 
				  	{
				  	faculty=Array.concat(faculty,r);
				  	}
			//roiManager("Select", faculty);
			roiManager("Deselect");
			
			run("Clear Results");
			roiManager("multi-measure measure_all");
			saveAs("Results", ""+subfolder+"CSVs\\"+title+"Plaques.csv");
			roiManager("Save", subfolder+"ROIs\\Plaques_"+title+".zip");
			run("Convert to Mask");
			
			selectWindow("binary");
			saveAs("Tiff", subfolder+"Binaries\\Plaques_"+title+".tif");
			close();

			}
		

	}
}
