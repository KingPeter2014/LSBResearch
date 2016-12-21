function result  = NaiveLSBFunction(coverImage,messageImage )
%NaiveLSB  - this embedds grayscale image into grayscale cover
%   coverimage - filename of image to be used as cover
%   messageImage - The message whose gray version will be embedded into the
%   cover

% Written by Eze Peter U., Ph.D Student at Department of Computing and
% Information Systems, University of Melbourne, Australia.
% Date: 21st December 2016

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
% clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
fontSize = 12;

% Read in the image what will have another image hidden into it.

originalImage = imread(coverImage);

% Get the number of rows and columns in the original image.
[visibleRows, visibleColumns, numberOfColorChannels] = size(originalImage);
if numberOfColorChannels > 1
	% If it's color, extract the red channel.
	originalImage = originalImage(:,:,1);
end

% read the message image you want to hide in the cover image
messageFileName='helicopter.gif'; %'dtcx64.gif';
hiddenImage = imread(messageImage);

% Get the number of rows and columns in the hidden image.
[hiddenRows, hiddenColumns, numberOfColorChannels] = size(hiddenImage);
if numberOfColorChannels > 1
	% If it's color, extract the red channel.
	hiddenImage = hiddenImage(:,:,1);
end

extraMetadata = 48;% row of watermark,column of watermark and number of bitplanes to use
binaryWatermarkSize = hiddenRows*hiddenColumns;% uses only MSB of watermark pixels
grayWatermarkSize = binaryWatermarkSize * 8;% uses entire 8bits of image pixel
embedsize = grayWatermarkSize + extraMetadata;
vectorWatermark = zeros(embedsize,1,'uint8');

rowStringBits = dec2bin(hiddenRows,16)';% Convert to string binary and get the transpose
colStringBits = dec2bin(hiddenColumns,16)';% Column of message

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
maximumBitCapacityOfCover = bitToSet*visibleRows*visibleColumns;

% If image to be hidden is bigger than the original image multiplied by selected no of bitplanes, abort process.
if embedsize > maximumBitCapacityOfCover 
	 warning('Watermark size is too big. Increase number of bit planes or reduce watermark size. Program aborted!')
    return  
end

bitplaneStringBits = dec2bin(bitToSet,16)';% Convert to string binary and get the transpose

%Covert  the meta data into binary integers
for i = 1:16
    if(rowStringBits(i) == '1')
        vectorWatermark(i) = 1;% bits for no of rows
    else
        vectorWatermark(i) = 0;
    end
    
    if(colStringBits(i) == '1')
        vectorWatermark(i+16) = 1;% bits for no of cols
    else
        vectorWatermark(i+16) = 0;
    end
    
    if(bitplaneStringBits(i) == '1')
        vectorWatermark(i+32) = 1;% bits for no of bitplanes of embedding
    else
        vectorWatermark(i+32) = 0;
    end
end


stego = originalImage; % make a copy of the original cover image
image(uint8(stego));
sizeOF_STEGO = size(stego);
stegopixels = sizeOF_STEGO(1)*sizeOF_STEGO(2);

embeddingrate=0;

% Embed  the metadata in only the LSBs of pixels 1 to 48 of cover
for cols=1:16
   stego(1,cols) =bitset(stego(1,cols),1, vectorWatermark(cols));% Embeds number of rows of watermark
   stego(1,cols+16) =bitset(stego(1,cols+16),1, vectorWatermark(cols+16));% Embeds number of cols of watermark
   stego(1,cols+32) =bitset(stego(1,cols+32),1, vectorWatermark(cols+32));% Embeds number of bitplanes to use
end
%Convert the grayscale watermark to a binary vector array
count = 49;
for i=1:hiddenRows
    for j= 1 : hiddenColumns
       
        thisByteArray = transpose(dec2bin(uint8(hiddenImage(i,j)),8));% convert each pixel value to byte value
%         thisByteArray = thisByteArray(:);
        N = length(thisByteArray);% Get the length of the byte array
        for k = 1:N %extract each bit of pixel
            if(thisByteArray(k) == '1')
               vectorWatermark(count) = 1;
               
            else
               vectorWatermark(count) = 0;
            end
            count = count+1;%increment to the next bit of watermark
        end
        
    end
end

% 
% one=0;zero=0;
% for a = 49:embedsize
%     if vectorWatermark(a)==1
%         one=one+1;
%     else
%         zero=zero+1;
%     end
% end
% one
% zero
a=49;
for row=1:visibleRows
    for col=49 :visibleColumns
        if a < embedsize
            for bitplane= 1:bitToSet
                stego(row,col) = bitset(stego(row,col),bitplane, vectorWatermark(a));% Set the LSB of stego to the each row,col and no of bitplanes to use                         
                a=a+1;
            end
        end        
    end
    embeddingrate = embedsize/stegopixels;  
end

% Mean Square Error btw stego and cover
mse = immse(originalImage,stego);

p=psnr(originalImage,stego);%  Compute PSNR between cover and stego images

% MSSIM
%[mssim,map] = ssim(originalcover,cover);
[mssim,map] = ssim(double(originalImage),double(stego));
mssim;
result= strcat('S-Histogram:','MSE=',num2str(mse),',PSNR=',num2str(p),',SSIM=',num2str(mssim),', Bpp=',num2str(embeddingrate))


%=============================================================================================
% Watermark Recovery

%First, extract all the metadata from pixels 1 -48 of stego image
watermarkrow='';watermarkcol='';btp='';
for cols=1:16
   a =bitget(stego(1,cols),1);% Get LSB of Stego
   watermarkrow = strcat(watermarkrow,num2str(a));
   
   b =bitget(stego(1,cols+16),1);% Get LSB of Stego
   watermarkcol = strcat(watermarkcol,num2str(b));
   
   c =bitget(stego(1,cols+32),1);% Get LSB of Stego
  btp = strcat(btp,num2str(c));
end
hiddenrows = bin2dec(watermarkrow);
hiddencols = bin2dec(watermarkcol);
bitplane =  bin2dec(btp);
wtmkvectorsize = hiddenrows*hiddencols*8;
%Extract message binary bits from stego and save in a vector binary array
vectwmk = zeros(wtmkvectorsize,1,'uint8');
sizest = size(stego);
count=1;
r = sizest(1);l=sizest(2);
for a = 1:r
    for b=49:l
      for c = 1:bitplane
          if count <=wtmkvectorsize
            vectwmk(count) = bitget(stego(a,b),bitplane);
            count=count+1;
          else
              break;
          end
      end
    end
    
end
% display('Computing extracted zeros and ones')
% one=0;zero=0;
% for a = 1:wtmkvectorsize
%     if  vectwmk(a)==1
%         one=one+1;
%     else
%         zero=zero+1;
%     end
% end
% one
% zero

% 
% 

Watermark1 = zeros(hiddenrows,hiddencols,'uint8');
x=0;dec=0;
for a=1:hiddenrows
  for b=1:hiddencols
      for ii=1:8
          dec = dec  + vectwmk(x + ii) * (2^(ii-1));
        
      end
      dec;
      Watermark1(a,b)=uint8(dec);
      dec=0;
      x=x+8;
  end
end
image(uint8(Watermark1));
% =============================================================================================
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

% Display the recovered watermark.
subplot(3, 3, 7);
imshow(Watermark1, []);
title('Recovered Watermark', 'FontSize', fontSize);


end

