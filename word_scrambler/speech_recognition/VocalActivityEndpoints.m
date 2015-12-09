function [start, stop] = VocalActivityEndpoints(audio)
  threshold_rms = 0.026;
  BLOCK_SIZE = 1024;
  HOP_SIZE = 128;
  
  % Generate the envelope.
  blocked_audio = BlockSignal(audio, BLOCK_SIZE, HOP_SIZE);
  num_blocks = size(blocked_audio, 1);
  envelope = zeros(num_blocks, 1);
  
  blocked_mags = abs(fft(blocked_audio.'));
  flux_novelty = QMaxSpectralFlux(blocked_mags, 0.1);
  
  start_block = -1;
  stop_block = -1;
  for block_idx = 1:num_blocks
    cur_rms = rms(blocked_audio(block_idx, :));
    envelope(block_idx) = cur_rms;
  end
  
  % If we need to use any envelope processing to improve accuracy, that
  % can go here.
  novelty = flux_novelty + envelope;
  
  % Find the start of vocal activity.
  for block_idx = 1:num_blocks
    if(novelty(block_idx) > threshold_rms)
      start_block = block_idx;
      break;
    end
  end
  
  if(start_block < 0)
    start = -1;
    stop = -1;
    disp('Did not find the start block.');
    return;
  end
  
  for block_idx = num_blocks:-1:1
    if(novelty(block_idx) > threshold_rms)
      stop_block = block_idx;
      break;
    end
  end
  
  if(stop_block < 0)
    error('Did not find the stop block.');
  end
  start_block = start_block - 1;
  stop_block = stop_block + 5;
  
  % Calculate sample index from block index.
  start = max(((start_block - 1) * HOP_SIZE) + 1, 1);
  stop = min(((stop_block - 1) * HOP_SIZE) + 1, size(audio, 1)); 
end

