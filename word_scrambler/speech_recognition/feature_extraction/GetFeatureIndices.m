function [start stop] = GetFeatureIndices(feature_type)
  NUM_MFCCS = 13;
  NUM_SPECTRAL_FEATURES = 12;
  NUM_MFCC_FEATURES = NUM_MFCCS * 2;

  spect_start = 1;
  spect_stop = spect_start + NUM_SPECTRAL_FEATURES - 1;

  mfcc_start = spect_stop + 1;
  mfcc_stop = mfcc_start + NUM_MFCC_FEATURES - 1;

  if(strcmp(feature_type, 'spectral'))
    start = spect_start;
    stop = spect_stop;
  elseif(strcmp(feature_type, 'mfcc'))
    start = mfcc_start;
    stop = mfcc_stop;
  end

end 
