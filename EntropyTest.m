numfile = 1;
path = 'C:\Users\peze\Desktop\Research\Watermarkingresearch\variedentropy\';%C:\Users\peze\Desktop\Research\Watermarkingresearch\research images\512\,
type='*.jpg';
imgSet=imageSet(path);
read(imgSet,1);
% files = dir([path type]);
numfile= imgSet.Count
%Check if file type or directory exists
 if( ~exist(path, 'dir') || numfile <1 )
        display('Directory not found or no matching images found.');
 end
 
  Seq{numfile,1} = [];
  out='';
  msg='';
  for idx = 1:numfile
%         Seq{idx} = imread([path files(idx).name]);
    Seq{idx} = read(imgSet,idx);
        [visibleRows, visibleColumns, numberOfColorChannels] = size(Seq{idx});
        if numberOfColorChannels > 1
            % If it's color, extract the red channel.
            Seq{idx} = Seq{idx}(:,:,1);
            img=char(imgSet.ImageLocation(idx));
            [pathstr,name,ext] = fileparts(img);
            entp = entropy(Seq{idx});
            msg =strcat(name,ext,',Entropy=',num2str(entp)); 
            disp(msg)
        end
  end
%   display(msg);
%fileName='msgimage.png';%untexturedcover.tif,seminontexture512.jpg,mandrill512.tiff,wash-ir512.tif,untexturedcover.png,boat.512.tiff,wash-ir.tiff,textured512.tiff
