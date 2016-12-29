
fontSize = 12;

nontextured = imread('untexturedcover.png');
[visibleRows, visibleColumns, numberOfColorChannels] = size(nontextured);
if numberOfColorChannels > 1
	% If it's color, extract the red channel.
	nontextured = nontextured(:,:,1);
end
nontextured = addborder(nontextured,30,0,'center');

lowtextured = imread('seminontexture512.jpg');
[visibleRows, visibleColumns, numberOfColorChannels] = size(lowtextured);
if numberOfColorChannels > 1
	% If it's color, extract the red channel.
	lowtextured = lowtextured(:,:,1);
end

mandril=imread('mandrill512.tiff');
[visibleRows, visibleColumns, numberOfColorChannels] = size(mandril);
if numberOfColorChannels > 1
	% If it's color, extract the red channel.
	mandril = mandril(:,:,1);
end

textured=imread('wash-ir.tiff');
[visibleRows, visibleColumns, numberOfColorChannels] = size(textured);
if numberOfColorChannels > 1
	% If it's color, extract the red channel.
	textured = textured(:,:,1);
end

subplot(2,4,1)
imshow(nontextured )
title('Non-textured Cover');

subplot(2,4,2)
imshow(lowtextured)
title('Low Textured Cover');

subplot(2,4,3)
imshow(mandril)
title('Mandril Cover');

subplot(2,4,4)
imshow(textured)
title('Textured Cover');

% Histogram of Non-Textured.
[pixelCount, grayLevels] = imhist(nontextured);
subplot(2,4, 5); 
bar(pixelCount);
title('Histogram', 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
grid on;

% Histogram of Low-Textured.
[pixelCount, grayLevels] = imhist(lowtextured);
subplot(2,4, 6); 
bar(pixelCount);
title('Histogram', 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
grid on;

% Histogram of Mandril.
[pixelCount, grayLevels] = imhist(mandril);
subplot(2,4, 7); 
bar(pixelCount);
title('Histogram', 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
grid on;

% Histogram of Textured Cover.
[pixelCount, grayLevels] = imhist(textured);
subplot(2,4, 8); 
bar(pixelCount);
title('Histogram', 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
grid on;


