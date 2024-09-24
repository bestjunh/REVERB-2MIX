clear all;

if ispc
    nasPath = 'Z:/nas1_data/';
    nas3Path = 'Y:/nas3_data/';
    devDataPath = 'W:/data/';
elseif isunix
    nasPath = '/home/nas/';
    nas3Path = '/home/nas3/';
    % devDataPath = '/home/dev60-data-mount/';
    devDataPath = '/home/data/'; % for dev60
else
    disp('Unknown operating system.');
end

WSJ_dir = [nasPath 'user/byungjoon/DB/REVERB/wsjcam0/']
REVERB_dir = [nasPath 'user/byungjoon/DB/REVERB/']
REVERB2MIX_dir = [devDataPath '/albert/DB/REVERB_2MIX/']

tic
CreateREVERB2MIX(WSJ_dir, REVERB_dir, REVERB2MIX_dir)
toc