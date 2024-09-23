clear;

if ispc
    nasPath = 'Z:/nas1_data/';
    nas3Path = 'Y:/nas3_data/';
    devDataPath = 'W:/data/';
elseif isunix
    nasPath = '/home/nas/';
    nas3Path = '/home/nas3/';
    devDataPath = '/home/dev60-data-mount/';
else
    disp('Unknown operating system.');
end

WSJ_dir = [nasPath 'user/byungjoon/DB/REVERB/wsjcam0/']
REVERB_dir = [nasPath 'user/byungjoon/DB/REVERB/']

tic
CreateREVERB2MIX(WSJ_dir, REVERB_dir)
toc