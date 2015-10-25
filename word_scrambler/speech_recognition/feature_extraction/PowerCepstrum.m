function y = PowerCepstrum(x)
  x_power = abs(fft(x)).^2;
  y = abs(ifft(log(x_power))).^2;
end



