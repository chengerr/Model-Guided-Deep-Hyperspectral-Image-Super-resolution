clear all;
clc;
sf = 8;
kernel_type ='gaussian';
sz = [512,512];
% path = './complete_ms_data';
path = './Data/complete_ms_data';
% path = './HARVARD/train';

% par     =    Parameters_setting( sf, kernel_type, sz );
% par.P           =    create_P();

folders = dir(path);
folders = folders(3:end);
% gt  =  zeros(1,64,64,31);
% pan =  zeros(1,64,64,3);
% ms  =  zeros(1,8,8,31);
gt  =  zeros(1,512,512,31);
pan =  zeros(1,512,512,3);
ms  =  zeros(1,64,64,31);

count = 0;
blur_deltas = [2.0];
% blur_deltas = [1.0,1.1,1.2,1.3,1.4,1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2,2.3,2.4,2.5,2.6,2.7,2.8,2.9,3.0];

for d = blur_deltas
%     mkdir(strcat('/media/work/zhouchen/0/MHF-net/CAVEdata16/blur_X','_',num2str(d),'/'));
    for i =1:length(folders)
        msi = zeros(512,512,31);
        imgs_path = fullfile(path,folders(i).name,folders(i).name);
        imgs = dir(imgs_path);
        imgs = imgs(5:end);
        disp(fullfile(imgs_path));
        for j = 1:length(imgs) 
            img = imread(fullfile(imgs_path,imgs(j).name));
            img = double(img);
            if strcmp(folders(i).name,'watercolors_ms')
                img = img(:,:,1)/255.;
            else
                img = img/65535.;
            end
            msi(:,:,j) = img;
        end
        par     =    Parameters_setting( sf, kernel_type, sz, d);
        par.P           =    create_P();
        [blur_msi, Z]  =  par.H(permute(reshape(msi,512*512,31), [2,1]));
        blur_msi  = reshape(permute(blur_msi, [2,1]),512,512,31);
        Z  = reshape(permute(Z, [2,1]),32,32,31);
        save(strcat('./CAVEdata8/Z/',folders(i).name,'.mat')  ,'Z') ;
    end
end

