function y = Cepstrum(x)
  x_freq = fft(x);
  log_x_freq = log(x_freq);
  log_x_freq(x_freq == 0) = 0;
  y = real(ifft(log_x_freq));
end

