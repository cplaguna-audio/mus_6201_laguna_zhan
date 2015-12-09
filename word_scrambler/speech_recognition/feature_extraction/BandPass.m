% Band pass filter, for use before pitch detection in time-series methods.
function y = BandPass(x, Fs, low_cutoff_hz, high_cutoff_hz)

FILTER_ORDER = 6;

d = fdesign.bandpass('N,Fc1,Fc2', FILTER_ORDER, low_cutoff_hz, ...
                     high_cutoff_hz, Fs);
h = design(d);
y = filter(h,x);

end
