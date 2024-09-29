function gen_label_wav(ii,K,et,dt,rev_root,revmix_root,revmix_root_et,revmix_root_dt,stft_init,svdphat_init)

sfreq = 16000;
nMic = 8;

akey = K{ii};
disp(['Processing: ' num2str(ii) '/' num2str(length(K))]);
[x_mix,x_et,x_dt] = addwav(readwav(et, akey, rev_root), readwav(dt, akey, rev_root));

[x_wpe_et, st_et] = runWPE(x_et,stft_init);
[x_wpe_dt, st_dt] = runWPE(x_dt,stft_init);

[azi_et,~] = runSVDPHAT(x_wpe_et,stft_init,svdphat_init);
[azi_dt,~] = runSVDPHAT(x_wpe_dt,stft_init,svdphat_init);

[azi_st_et,~,svdval_et] = runST2SVDPHAT(st_et,stft_init,svdphat_init);
[azi_st_dt,~,svdval_dt] = runST2SVDPHAT(st_dt,stft_init,svdphat_init);


savewav(x_mix, [revmix_root et{1}(akey)], sfreq);
savewav(x_et, [revmix_root_et et{1}(akey)], sfreq);
savewav(x_dt, [revmix_root_dt et{1}(akey)], sfreq);

save(strrep([revmix_root_et et{1}(akey)],'.wav','.mat'),'azi_et','st_et','azi_st_et','svdval_et')
save(strrep([revmix_root_dt et{1}(akey)],'.wav','.mat'),'azi_dt','st_dt','azi_st_dt','svdval_dt')


%%%%%%%%%%%%%%%%%%%%%%%%%
function x = readwav(wavscps, akey, rootdir)

x = soundread([rootdir wavscps{1}(akey)]);
xlen = length(x);
for ii=2:length(wavscps)
  x = [x soundread([rootdir wavscps{ii}(akey)])];
end


function x = soundread(fname)
  fname = strrep(fname, 'MC_WSJ_AV_Dev', 'REVERB_Real_dt_et');
  fname = strrep(fname, 'MC_WSJ_AV_Eval', 'REVERB_Real_dt_et');
  % disp(['Reading: ',fname]);    
  x = audioread(fname);

  %%%%%%%%%%%%%%%%%%%%%%%%%
function [x_mix,x_et,x_dt] = addwav(x_et, x_dt)
if length(x_et) > length(x_dt)
  % x_et = x_et(1:length(x_dt),:);
  x_dt = [x_dt; zeros(length(x_et)-length(x_dt),size(x_dt,2))];
else
  x_dt = x_dt(1:length(x_et),:);
end
x_mix=x_et+x_dt;

%%%%%%%%%%%%%%%%%%%%%%%%%
function savewav(x, fname, sfreq)

fprintf(1,'Saving %s\n', fname);
path = fileparts(fname);
if isempty(dir(path))
  mkdir(path);
end
audiowrite(fname, x, sfreq);