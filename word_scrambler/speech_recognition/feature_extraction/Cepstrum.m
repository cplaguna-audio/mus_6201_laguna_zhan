function y = Cepstrum(x)
  x_freq = fft(x);
  y = real(ifft(log(x_freq)));
end

