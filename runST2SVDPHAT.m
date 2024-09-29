function [max_azi,max_ele,val] = runST2SVDPHAT(st_et,stft_init,svdphat_init)
%% Audio load & STFT
nwin = stft_init.nwin;
nfft = stft_init.nfft;
fs = stft_init.fs;
nch = stft_init.nch;
nshift = stft_init.nshift;
nol = stft_init.nol;
nhfft = stft_init.nhfft;
win = stft_init.win;

svdphat_init.gamma = 0;


svdphat = class_SVD_PHAT(svdphat_init);

% st = zeros(nch,nhfft);
% for freq = 1:nhfft
%     st(:,freq) = st_et(:,freq)./st_et(1,freq);
% end

svdphat = GCC(svdphat,st_et);

% [svdphat, ~,idx_val] = SRP(svdphat);
[svdphat,~,idx_val] = SVD_PHAT_nullEle0(svdphat);
[max_azi,max_ele] = svdphat.idx2angle(idx_val);
val = idx_val(2);


end