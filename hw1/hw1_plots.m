fs = 44100;
f1 = 441;
f2 = 882;
duration = 2;

window_size = 4096 * 2;
hop_size = 4096;

t = [1:duration * fs].';
x = zeros(size(t));
x(1:fs) = sin(2 * pi * f1 * t(1:fs) / fs);
x(fs + 1:end) = sin(2 * pi * f2 * t(fs + 1:end) / fs);

f0s = myPitchTrack_ACF(x, window_size, hop_size, fs);
