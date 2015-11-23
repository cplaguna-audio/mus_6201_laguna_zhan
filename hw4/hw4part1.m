[x, fs] = audioread('03-Sargon-Waiting For Silence.mp3');
WINDOW_SIZE = 4 * fs;
HOP_SIZE = 1/4 * WINDOW_SIZE;

x = mean(x, 2);
x = x(1:end);
x_spec = spectrogram(x, WINDOW_SIZE, HOP_SIZE);
x_mag = abs(x_spec);

mfccs = FeatureSpectralMfccs(x_mag, fs);
chromas = FeatureSpectralPitchChroma(x_mag, fs);

sdm_m = computeSelfDistMat(mfccs);
sdm_c = computeSelfDistMat(chromas);

figure();
imagesc(sdm_m);
title('mfccs');

figure();
imagesc(sdm_c);
title('pitch chroma');