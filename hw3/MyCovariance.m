function c = MyCovariance(e)
  N = size(e, 2);
  M = size(e, 1);
  
  means = mean(e, 2);
  
  c = zeros(M, M);
  for n = 1:N
    for i = 1:M
      for j = 1:M
        cur_cov = (e(i, n) - means(i)) * (e(j, n) - means(j));
        c(i, j) = c(i, j) + cur_cov;
      end
    end
  end
  c = c / (N - 1);

end

