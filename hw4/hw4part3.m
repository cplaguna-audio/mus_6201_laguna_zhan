[x, fs] = audioread('03-Sargon-Waiting For Silence.mp3');
WINDOW_SIZE = 4 * fs;
HOP_SIZE = 3/4 * WINDOW_SIZE;

x = mean(x, 2);
x = x(1:end);
x_spec = spectrogram(x, WINDOW_SIZE, WINDOW_SIZE - HOP_SIZE);
x_mag = abs(x_spec);

mfccs = FeatureSpectralMfccs(x_mag, fs);
chromas = FeatureSpectralPitchChroma(x_mag, fs);

sdm_m = computeSelfDistMat(mfccs);
sdm_c = computeSelfDistMat(chromas);

R_m = computeLagDistMatrix(sdm_m);

figure();
imagesc(R_m);
title('Lag matrix mfcc');

R_c = computeLagDistMatrix(sdm_c);

figure();
imagesc(R_c);
title('Lag matrix pitch chroma');

% Enhance.
M_QUANTILE = 0.505;
m_thresh = quantile(quantile(R_m, M_QUANTILE), M_QUANTILE);
bin_m = computeBinSdm(R_m, m_thresh);

C_QUANTILE = 0.51;

c_thresh = quantile(quantile(R_c, C_QUANTILE), C_QUANTILE);
bin_c = computeBinSdm(R_c, c_thresh);

figure();
imagesc(bin_m);
title('Binary matrix mfcc');

figure();
imagesc(bin_c);
title('Binary matrix pitch chroma');

M_MIN_LINE_LENGTH = 3;
C_MIN_LINE_LENGTH = 6;

final_m = erodeDilate(bin_m, M_MIN_LINE_LENGTH);
final_c = erodeDilate(bin_c, C_MIN_LINE_LENGTH);

figure();
imagesc(final_m);
title('Final matrix mfcc');

figure();
imagesc(final_c);
title('Final matrix pitch chroma');

