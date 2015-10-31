% % Generate input files.
fs = 44100;
WINDOW_SIZE = 1024;
HOP_SIZE = 512;

t = (0:1/fs:(2 - (1/fs))).';
x1 = zeros(fs * 2, 1);
x1(1:fs) = 0.5 * cos(2 * pi * 441 * t(1:fs));
x1(fs+1:end) = 0.5 * cos(2 * pi * 882 * t(fs+1:end));

x2 = zeros(fs * 2, 1);
x2(1:fs) = 0.5 * cos(2 * pi * 441 * t(1:fs));
x2(fs+1:end) = 0.9 * cos(2 * pi * 441 * t(fs+1:end));
% % 
% % Spectral Flux.
% flux_1 = mySpectralFlux(x1, WINDOW_SIZE, HOP_SIZE);
% flux_2 = mySpectralFlux(x2, WINDOW_SIZE, HOP_SIZE);
% 
% figure();
% subplot(2, 1, 1);
% plot(flux_1);
% title('x1 Spectral Flux');
% subplot(2, 1, 2);
% plot(flux_2);
% title('x2 Spectral Flux');

% % Peak Envelope.
% peak_1 = myPeakEnv(x1, WINDOW_SIZE, HOP_SIZE);
% peak_2 = myPeakEnv(x2, WINDOW_SIZE, HOP_SIZE);
% 
% figure();
% subplot(2, 1, 1);
% plot(peak_1);
% title('x1 Peak Envelope');
% subplot(2, 1, 2);
% plot(peak_2);
% title('x2 Peak Envelope');

% % Weighted Phase Deviation
% wpd_1 = myWPD(x1, WINDOW_SIZE, HOP_SIZE);
% wpd_2 = myWPD(x2, WINDOW_SIZE, HOP_SIZE);
% 
% figure();
% subplot(2, 1, 1);
% plot(wpd_1);
% title('x1 Weighted Phase Deviation');
% subplot(2, 1, 2);
% plot(wpd_2);
% title('x2 Weighted Phase Deviation');

% % Median Filter.
% WINDOW_SIZE = 1024;
% HOP_SIZE = 512;
% [x, fs] = audioread('ODB/audio/2-artificial.wav');
% x = x(1:3 * fs);
% nvt = myPeakEnv(x, WINDOW_SIZE, HOP_SIZE);
% 
% lambda_0 = 0;
% order_1 = 7;
% order_2 = 15;
% order_3 = 27;
% med_1 = myMedianThres(nvt, order_1, lambda_0);
% med_2 = myMedianThres(nvt, order_2, lambda_0);
% med_3 = myMedianThres(nvt, order_3, lambda_0);
% 
% figure();
% ax1 = subplot(3, 1, 1);
% plot(nvt, 'r');
% hold on;
% plot(med_1, 'g');
% title(['Novelty - Red, Threshold - Green. Order = ' num2str(order_1) ...
%        ', Lambda = ' num2str(lambda_0)]);
% 
% ax2 = subplot(3, 1, 2);
% plot(nvt, 'r');
% hold on;
% plot(med_2, 'g');
% title(['Novelty - Red, Threshold - Green. Order = ' num2str(order_2) ...
%        ', Lambda = ' num2str(lambda_0)]);
%      
% ax3 = subplot(3, 1, 3);
% plot(nvt, 'r');
% hold on;
% plot(med_3, 'g');
% title(['Novelty - Red, Threshold - Green. Order = ' num2str(order_3) ...
%        ', Lambda = ' num2str(lambda_0)]);
% linkaxes([ax1, ax2, ax3], 'xy');
% 
% order_0 = 15;
% lambda_1 = -0.1;
% lambda_2 = 0;
% lambda_3 = 0.1;
% med_1 = myMedianThres(nvt, order_0, lambda_1);
% med_2 = myMedianThres(nvt, order_0, lambda_2);
% med_3 = myMedianThres(nvt, order_0, lambda_3);
% 
% figure();
% ax1 = subplot(3, 1, 1);
% plot(nvt, 'r');
% hold on;
% plot(med_1, 'g');
% title(['Novelty - Red, Threshold - Green. Order = ' num2str(order_0) ...
%        ', Lambda = ' num2str(lambda_1)]);
%      
% ax2 = subplot(3, 1, 2);
% plot(nvt, 'r');
% hold on;
% plot(med_2, 'g');
% title(['Novelty - Red, Threshold - Green. Order = ' num2str(order_0) ...
%        ', Lambda = ' num2str(lambda_2)]);
%      
% ax3 = subplot(3, 1, 3);
% plot(nvt, 'r');
% hold on;
% plot(med_3, 'g');
% title(['Novelty - Red, Threshold - Green. Order = ' num2str(order_0) ...
%        ', Lambda = ' num2str(lambda_3)]);
% linkaxes([ax1, ax2, ax3], 'xy');

% % My Onset Detection.
% WINDOW_SIZE = 1024;
% HOP_SIZE = 512;
% ORDER = 15;
% LAMBDA = 0.1;
% nvt_1 = mySpectralFlux(x1, WINDOW_SIZE, HOP_SIZE);
% thres_1 = myMedianThres(nvt_1, ORDER, LAMBDA);
% onsetTimeSecs_1 = myOnsetDetection(nvt_1, fs, WINDOW_SIZE, HOP_SIZE);
% figure();
% plot(nvt_1, 'r');
% hold on;
% plot(thres_1, 'g');
% title('X1 novelty (red), threshold (green)');
% 
% nvt_2 = mySpectralFlux(x2, WINDOW_SIZE, HOP_SIZE);
% thres_2 = myMedianThres(nvt_2, ORDER, LAMBDA);
% onsetTimeSecs_2 = myOnsetDetection(nvt_2, fs, WINDOW_SIZE, HOP_SIZE);
% figure();
% plot(nvt_2, 'r');
% hold on;
% plot(thres_2, 'g');
% title('X2 novelty (red), threshold (green)');

% % Test instantaneous frequency
% fs = 44100;
% WINDOW_SIZE = 1050;
% HOP_SIZE = 500;
% 
% t = (0:1/fs:(2 - (1/fs))).';
% x = zeros(fs, 1);
% x(1:fs) = 0.5 * cos(2 * pi * 438 * t(1:fs));
% 
% x_blocked = blockSignal(x, WINDOW_SIZE, HOP_SIZE).';
% x_freq = fft(x_blocked);
% inst_freq = phaseDiff(x_freq, HOP_SIZE) * (fs / HOP_SIZE) / (2 * pi);
% 
% Evaluate
WINDOW_SIZE = 1024;
HOP_SIZE = 256;
DELTA_TIME = 50;
TEST_PATH = 'ODB';

[p, r, f] = Evaluate(TEST_PATH, WINDOW_SIZE, HOP_SIZE, 'flux', DELTA_TIME);
disp(['Flux Results (P,R,F): ' num2str(p) ', ' num2str(r) ',' num2str(f)]);

[p, r, f] = Evaluate(TEST_PATH, WINDOW_SIZE, HOP_SIZE, 'peak_amp', DELTA_TIME);
disp(['Peak Env Results (P,R,F): ' num2str(p) ', ' num2str(r) ',' num2str(f)]);

[p, r, f] = Evaluate(TEST_PATH, WINDOW_SIZE, HOP_SIZE, 'wpd', DELTA_TIME);
disp(['Weighted Phase Deviation Results (P,R,F): ' num2str(p) ', ' num2str(r) ',' num2str(f)]);