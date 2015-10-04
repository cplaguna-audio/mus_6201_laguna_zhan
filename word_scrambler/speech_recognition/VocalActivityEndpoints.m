function [start, stop] = VocalActivityEndpoints(audio)
  THRESHOLD_DB = -40;
  threshold_rms = 10^(THRESHOLD_DB/10);
  BLOCK_SIZE = 512;
  HOP_SIZE = 256;
  
  % Generate the envelope.
  blocked_audio = BlockSignal(audio, BLOCK_SIZE, HOP_SIZE);
  num_blocks = size(blocked_audio, 1);
  envelope = zeros(num_blocks, 1);
  start_block = -1;
  stop_block = -1;
  for block_idx = 1:num_blocks
    cur_rms = rms(blocked_audio(block_idx, :));
    envelope(block_idx) = cur_rms;
  end
  
  % If we need to use any envelope processing to improve accuracy, that
  % can go here.
  
  % Find the start of vocal activity.
  for block_idx = 1:num_blocks
    if(envelope(block_idx) > threshold_rms)
      start_block = block_idx;
      break;
    end
  end
  
  if(start_block < 0)
    error('Did not find the start block.');
  end
  
  for block_idx = num_blocks:-1:1
    if(envelope(block_idx) > threshold_rms)
      stop_block = block_idx;
      break;
    end
  end
  
  if(stop_block < 0)
    error('Did not find the stop block.');
  end
  
  % Calculate sample index from block index.
  start = ((start_block - 1) * HOP_SIZE) + 1;
  stop = ((stop_block - 1) * HOP_SIZE) + 1; 
end

