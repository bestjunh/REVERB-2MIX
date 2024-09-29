clear all;
close all;
%%
restoredefaultpath
addpath('STFT-ISTFT_batch')
addpath('MSVD-PHAT/MATLAB/class/')
addpath('MSVD-PHAT/MATLAB/common/')
addpath('WPE-batch/src/')
%%
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
%%
WSJ_dir = [nasPath 'user/byungjoon/DB/REVERB/wsjcam0/']
REVERB_dir = [nasPath 'user/byungjoon/DB/REVERB/']
REVERB2MIX_dir = [devDataPath '/albert/DB/REVERB-2MIX_et_dt_v2/']

%%
nwin = 512;
nfft = nwin;
fs = 16000;
nch = 8;
nshift = fix(nwin/4);
% By-product
nol = nwin-nshift; nhfft = nfft/2+1;
if nwin/nshift == 2
    win = sin(pi*([0:1:nwin-1]'+0.5)/nwin); %1/2 shift
elseif nwin/nshift == 4
    win = hanning(nwin,'periodic');
    win = win./sqrt(sum(win.^2)/nshift);%1/4shift
end
stft_init.nwin = nwin;
stft_init.nfft = nfft;
stft_init.fs = fs;
stft_init.nch = nch;
stft_init.nshift = nshift;
stft_init.nol = nol;
stft_init.nhfft = nhfft;
stft_init.win = win;

locSensors = zeros(nch,3);
for i =1:nch    
    locSensors(i,:) = 0.1.*[cos((i-1)*pi/4) sin((i-1)*pi/4) 0];
end
centerSensors = [0 0 0];

aziResol = -180:1:179; % Azimuths
eleResol = 90; % Elevations
distSources = 100; %Distance. for far-field 100m
[locationSource,aziRange,eleRange] = setlocationsourceAE(distSources,aziResol,eleResol,centerSensors);
Q = size(locationSource,1); %Numberof potential sources

svdphat_init.nfft = nfft;
svdphat_init.fs = fs;
svdphat_init.nch = nch;
svdphat_init.locationSource = locationSource;
svdphat_init.aziRange = aziRange;
svdphat_init.eleRange = eleRange;
svdphat_init.locSensors = locSensors;
svdphat_init.gamma = 0.6;
svdphat_init.epsi = 1E-8;
svdphat_init.freqIdxRange = 1:1:svdphat_init.nfft/2+1;
svdphat_init.delta = 1e-10;
svdphat_init.Nmax = 1;
svdphat_init.thr = [0.0];%[0.6 0.6 1 1];
svdphat_init.nullval = 10000;
svdphat_init.nullEle0 = 0;
svdphat_init.SS = 343.3;
svdphat_init.phat_opt = 1;
svdphat_init.rm_angle = 10;

%%

tic
CreateREVERB2MIX(WSJ_dir, REVERB_dir, REVERB2MIX_dir, stft_init,svdphat_init)
toc