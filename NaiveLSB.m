%NaiveLSB  - this embedds graysace image into grayscale cover

% Written by Eze Peter U., Ph.D Student at Department of Computing and
% Information Systems, University of Melbourne, Australia.
% Date: 20th December 2016

% It embeds the entire 8bits of the watermark into n-bitplanes of the
% cover. The user chooses any number of bitplanes between 1-4 of the LSBs
% of the Cover. The program first of all calculates if the size of the
% watermark can be accomodated into the number of bitplanes of the cover as
% selected by the user. The dimesions of cover and watermark need not be
% equal.

% This program is only for Embedding, next is to design the Recovery
% Algorithm



clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
fontSize = 12;

% Read in the image what will have another image hidden into it.
fileName='moon.tif';
originalImage = imread(fileName);
% Get the number of rows and columns in the original image.
[visibleRows, visibleColumns, numberOfColorChannels] = size(originalImage);
if numberOfColorChannels > 1
	% If it's color, extract the red channel.
	originalImage = originalImage(:,:,1);
end

% read the message image you want to hide in the cover image
messageFileName='300.jpg'; %'dtcx64.gif';
hiddenImage = imread(messageFileName);
% Get the number of rows and columns in the hidden image.
[hiddenRows, hiddenColumns, numberOfColorChannels] = size(hiddenImage);
if numberOfColorChannels > 1
	% If it's color, extract the red channel.
	hiddenImage = hiddenImage(:,:,1);
end


% Get the bit plane to hide the image in.
prompt = 'Enter number of LSB bit planes to use (1 - 4) ';
dialogTitle = 'Enter Bit Plane to Replace';
numberOfLines = 1;
defaultResponse = {'1'};
bitToSet = str2double(cell2mat(inputdlg(prompt, dialogTitle, numberOfLines, defaultResponse)));

if bitToSet > 4
    warning('Maximum of 4 LSB bitplanes can be replaced. Program aborted!')
    return 
end

extraMetadata = 48;% row of watermark,column of watermark and number of bitplanes to use
maximumBitCapacityOfCover = bitToSet*visibleRows*visibleColumns;

binaryWatermarkSize = hiddenRows*hiddenColumns;% uses only MSB of watermark pixels
grayWatermarkSize = binaryWatermarkSize * 8;% uses entire 8bits of image pixel
embedsize = grayWatermarkSize + extraMetadata;
% If image to be hidden is bigger than the original image multiplied by selected no of bitplanes, abort process.
if embedsize > maximumBitCapacityOfCover 
	 warning('Watermark size is too big. Increase number of bit planes or reduce watermark size. Program aborted!')
    return  
end
vectorWatermark = zeros(embedsize,1,'uint8');


%write the meta data to the cover
for i = 1:16
   vectorWatermark(i) = 255*bitget(hiddenRows, i);% bits for no of rows
end
 
for i = 1:16
    vectorWatermark(i+16) = 255*bitget(hiddenColumns, i);% bits for no of cols
end

 
for i = 1:16
    vectorWatermark(i+32) = 255*bitget(bitToSet, i);% bits for no of bitplanes to hide
end

size(vectorWatermark);
count=0;
%Convert the grayscale watermark to a binary vector array
for i=1:hiddenRows
    for j= 1 : hiddenColumns
        thisByteArray = transpose(dec2bin(uint8(hiddenImage(i,j)),8));% convert each pixel value to byte value
        thisByteArray = thisByteArray(:);
        N = length(thisByteArray);% Get the length of the byte array
        for k = 1:N %extract each bit of pixel
            if(thisByteArray(k) == '1')
               vectorWatermark(48+k + count) = 1;
%                vectorWatermark(k+count)
            else
               vectorWatermark(48+k + count) = 0;
            end
        end
        count = count+1;%increment to the next pixel of watermark
    end
end
% return
stego = originalImage; % make a copy of the original cover image
sizeOF_STEGO = size(stego);
msize=size(vectorWatermark);
msize1 = msize(1);
index = 1;row=1;col=1;
embeddingrate=0;

% Embed  the metadata in only the LSBs of pixels 1 to 48 of cover
 a=1;
       i=0;j=0;
        for row=1:visibleRows
            for col=1:visibleColumns
                
                    if a < 49
                        stego(row,col) = bitset(stego(row,col),1, vectorWatermark(a));% Set the LSB of stego to the each row,col and no of bitplanes to use                         
                        a=a+1;
                    else
                        break;
                    end
                    if a == 49
                        break;
                    end
            end
            if a == 49
             break;
            end
        end

col= col+1;

 for row=row:visibleRows
            for col=1:visibleColumns
                
                    if a < msize1
                            for bitplane= 1:bitToSet
                                stego(row,col) = bitset(stego(row,col),1, vectorWatermark(a));% Set the LSB of stego to the each row,col and no of bitplanes to use                         
                                a=a+1;
                            end
                    else
                        break;
                    end
                    if a == msize1
                        break;
                    end
            end
            embeddingrate = embedsize/(visibleRows*visibleColumns);  
            if a == msize1
             break;
            end
end
 
 
% for row=row:visibleRows
%      for col = col:visibleColumns
%         for bitplane= 1:bitToSet
%              if a < msize1
%                  stego(row,col) = bitset(stego(row,col),bitplane, vectorWatermark(a));% Set                         
%                 a = a+1;
%              end       
%          end
%     end
%      embeddingrate = embedsize/(visibleRows*visibleColumns);  
%  end
%             
        
%   a
%   row
%   col  

% Mean Square Error btw stego and cover
mse = immse(originalImage,stego);

p=psnr(originalImage,stego);%  Compute PSNR between cover and stego images

% MSSIM
%[mssim,map] = ssim(originalcover,cover);
[mssim,map] = ssim(double(originalImage),double(stego));
mssim;
result= strcat('S-Histogram:','MSE=',num2str(mse),',PSNR=',num2str(p),',SSIM=',num2str(mssim),', Bpp=',num2str(embeddingrate))


% Display the image.
subplot(3, 3, 1);
imshow(hiddenImage, []);
title('Image to be Hidden', 'FontSize', fontSize);

% Display the original gray scale image.
subplot(3, 3, 2);
imshow(originalImage, []);
title('Original Grayscale Cover Image', 'FontSize', fontSize);

% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
set(gcf,'name','Naive LSB','numbertitle','off') 

% Let's compute and display the histogram.
[pixelCount, grayLevels] = imhist(originalImage);
subplot(3, 3, 3); 
bar(pixelCount);
title('Histogram of Cover Image', 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
grid on;

% Let's compute and display the histogram of Message Watermark.
[pixelCount, grayLevels] = imhist(hiddenImage);
subplot(3, 3, 4); 
bar(pixelCount);
title('Histogram of Watermark Image', 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
grid on;


% Display the Stego image.
subplot(3, 3, 5);
imshow(stego, []);
title('Stego Image', 'FontSize', fontSize);

% Let's compute and display the histogram of stego.
[pixelCount, grayLevels] = imhist(stego);
subplot(3, 3, 6); 
bar(pixelCount);
title(result, 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
grid on;

