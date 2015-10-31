function y = PowerCepstrum(x)
  x_power = abs(fft(x)).^2;
  log_x_power = log(x_power);
  log_x_power(x_power == 0) = 0;
  y = abs(ifft(log_x_power)).^2;
end



