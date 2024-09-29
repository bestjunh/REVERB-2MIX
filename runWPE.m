function [y,st] = runWPE(x,stft_init)

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
    [X_,~,a_,p_] = my_stft(x(:,ch), nfft, win, nol, fs); % [ frame freq mic ]
    X(:,:,ch) = X_.';
    a(:,:,ch) = a_;
    p(:,ch) = p_;
end

%% Process
lpc_coeff = 20;
tap_delay = 3;
tap = 15;

Y = WPE_batch(X,a,p,lpc_coeff,tap_delay,tap);

st = zeros(nch,nhfft);
for freq = 1:nhfft
    Yfreq = squeeze(Y(:,freq,:)).';
    YY = Yfreq*Yfreq';
    YY = 0.5*(YY+YY');
    [V,D] = eig(YY);
    [~,idx] = max(diag(D));
    st(:,freq) = V(:,idx);
end


%% ISTFT
y = zeros(size(x));
for ch = 1 : nch
    y(:,ch) = my_istft(Y(:,:,ch).', size(x,1), win, nol);
end

if 0
    %% Figure
    cmin = -80;
    cmax = 20;
    figure;imagesc(20.*(log10(abs(X(:,:,1).'))));colormap jet;axis xy;colorbar;clim([cmin cmax]);title('X1');
    xlabel('frame index')
    ylabel('freq index')

    figure;imagesc(20.*(log10(abs(Y(:,:,1).'))));colormap jet;axis xy;colorbar;clim([cmin cmax]);title('Y');
    xlabel('frame index')
    ylabel('freq index')
end
end