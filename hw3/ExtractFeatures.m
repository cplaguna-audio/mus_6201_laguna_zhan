function features = ExtractFeatures(audio, fs, window_size, hop_size)
  NUM_FEATURES = 10;
  features = zeros(NUM_FEATURES, 1);
  
  blocked_audio = BlockSignal(audio, window_size, hop_size);
  
  % Extract instantaneous features.
  centroids = SpectralCentroid(blocked_audio);
  fluxs = SpectralFlux(blocked_audio);
  crests = SpectralCrest(blocked_audio);
  zcrs = ZeroCrossingRate(blocked_audio);
  max_envelopes = MaximumEnvelope(blocked_audio);
  
  % Aggregate features.
  centroid_mean = mean(centroids);
  centroid_std = std(centroids);
  flux_mean = mean(fluxs);
  flux_std = std(fluxs);
  crest_mean = mean(crests);
  crest_std = std(crests);
  zcr_mean = mean(zcrs);
  zcr_std = std(zcrs);
  max_envelope_mean = mean(max_envelopes);
  max_envelope_std = std(max_envelopes);
  
  features = [centroid_mean; centroid_std; flux_mean; flux_std; ...
              crest_mean; crest_std; zcr_mean; zcr_std; ...
              max_envelope_mean; max_envelope_std];

end

