clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.

coverpath ='C:\Users\peze\Desktop\Research\Watermarkingresearch\variedentropy\';
path = 'C:\Users\peze\Desktop\Research\Watermarkingresearch\watermarks\';%C:\Users\peze\Desktop\Research\Watermarkingresearch\research images\512\,
% type='*.jpg';

%Create Image sets for Cover and watermarks
imgSet=imageSet(path);
coverImgSet = imageSet(coverpath);
% Compute the number of images used for cover and watermark respectively
numcoverfiles = coverImgSet.Count;
numfile= imgSet.Count; % Number of Watermark files
% files = dir([path type]);

%Check if directories exists
 if( ~exist(path, 'dir') || numfile <1 )
        display('Directory for Watermark images not found.');
 end
 if( ~exist(coverpath, 'dir') || numfile <1 )
        display('Directory for Cover Images not found.');
 end

 er = zeros(numfile,1);
 mse = zeros(numcoverfiles,numfile);
 psn = zeros(numcoverfiles,numfile);
 ssm = zeros(numcoverfiles,numfile);
  Seq{numfile,1} = [];
  Seq2{numcoverfiles,1} = [];
  out='';
  count=0;
  for idx = 1:numcoverfiles
      img=char(coverImgSet.ImageLocation(idx));
       [pathstr,name,ext] = fileparts(img);
       cfilename =strcat(name,ext);
      for w= 1:numfile
          wm = char(imgSet.ImageLocation(w));
          [m,p,s,e]=LSBEmbed(img,cfilename,wm);
          er(w)=e;
          mse(idx,w)=m;
          psn(idx,w)=p;
          ssm(idx,w)=s;
          
          count = count+1;
      end
      
  end
   disp(er);
  display(mse);
   disp(psn);
   disp(ssm);
  
%fileName='msgimage.png';%untexturedcover.tif,seminontexture512.jpg,mandrill512.tiff,wash-ir512.tif,untexturedcover.png,boat.512.tiff,wash-ir.tiff,textured512.tiff
