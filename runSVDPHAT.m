function [max_azi,max_ele] = runSVDPHAT(x,stft_init,svdphat_init)
%% Audio load & STFT
nwin = stft_init.nwin;
nfft = stft_init.nfft;
fs = stft_init.fs;
nch = stft_init.nch;
nshift = stft_init.nshift;
nol = stft_init.nol;
nhfft = stft_init.nhfft;
win = stft_init.win;


nFrame = fix((length(x(:,1))+nwin)/nshift) - 2;
X = zeros(nFrame, nhfft, nch);

for ch = 1 : nch
    X(:,:,ch) = my_stft(x(:,ch), nfft, win, nol, fs).'; % [ frame freq mic ]
end

svdphat = class_SVD_PHAT(svdphat_init);

accMap = zeros(svdphat.Q,1);
debugAzi = zeros(nFrame,1);
debugEle = zeros(nFrame,1);
debugVal = zeros(nFrame,1);

for frame = 1:nFrame

    Xframe = squeeze(X(frame,:,:)).';    
    svdphat = GCC(svdphat,Xframe);

    [svdphat, Y_loc,idx_val] = SRP(svdphat);    
    [max_azi,max_ele] = svdphat.idx2angle(idx_val);

    accMap = accMap + Y_loc;

    debugAzi(frame) = max_azi;
    debugEle(frame) = max_ele;
    debugVal(frame) = idx_val(2);

end

[val,idx] = max(accMap);
[max_azi,max_ele] = svdphat.idx2angle([idx val]);

if 0
    %%
    figure;
    plot(debugAzi,'o');
    title(num2str(max_azi))
    figure;
    stem(debugVal)
    
end
end