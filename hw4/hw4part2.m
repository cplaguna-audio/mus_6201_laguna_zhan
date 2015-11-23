
SEGMENTS = {'Silence'
            'Intro';
            'MainRiff';
            'Verse';
            'Bridge';
            'Chorus';
            'Pre-solo';
            'Solo';
            'ProgBreak';
            'Punk';
            'Post-punk';
            'Prog';
            'End'};
          
COLORS = hsv(13);

[x, fs] = audioread('03-Sargon-Waiting For Silence.mp3');
WINDOW_SIZE = 4 * fs;
HOP_SIZE = 3/4 * WINDOW_SIZE;

x = mean(x, 2);
x = x(1:end);
x_spec = spectrogram(x, WINDOW_SIZE, WINDOW_SIZE - HOP_SIZE);
x_mag = abs(x_spec);

mfccs = FeatureSpectralMfccs(x_mag, fs);
chromas = FeatureSpectralPitchChroma(x_mag, fs);

sdm_m = computeSelfDistMat(mfccs);
sdm_c = computeSelfDistMat(chromas);

Ls = [2, 8, 16].';
num_Ls = size(Ls, 1);

m_nvts = cell(num_Ls, 1);
for l_idx = 1:num_Ls
  L = Ls(l_idx);
  m_nvts{l_idx} = computeSdmNovelty(sdm_m, L);
end

c_nvts = cell(num_Ls, 1);
for l_idx = 1:num_Ls
  L = Ls(l_idx);
  c_nvts{l_idx} = computeSdmNovelty(sdm_c, L);
end

fid = fopen('03-Sargon-Waiting For Silence.csv');
annotations = textscan(fid, '%f,%s');

start_secs = annotations{1,1};
start_blocks  = start_secs * (fs / HOP_SIZE);
labels = annotations{1,2};
num_segments = size(labels, 1);


figure();
for l_idx = 1:num_Ls
  L = Ls(l_idx);
  subplot(num_Ls, 1, l_idx);
  plot(m_nvts{l_idx});

  min_y = min(m_nvts{l_idx});
  for segment_idx = 1:num_segments
    cur_segment = labels{segment_idx};
    cur_segment_idx = find(strcmp(SEGMENTS, cur_segment));
    color = COLORS(cur_segment_idx, :);
    line([start_blocks start_blocks], [min_y 0], 'color', color);
  end
  
  title(['Mfcc novelty L = ' num2str(L)]);
end

figure();
for l_idx = 1:num_Ls
  L = Ls(l_idx);
  subplot(num_Ls, 1, l_idx);
  plot(c_nvts{l_idx});
  
  min_y = min(c_nvts{l_idx});
  for segment_idx = 1:num_segments
    cur_segment = labels{segment_idx};
    cur_segment_idx = find(strcmp(SEGMENTS, cur_segment));
    color = COLORS(cur_segment_idx, :);
    line([start_blocks start_blocks], [min_y 0] ,'Color',color);
  end
  
  title(['Pitch chroma novelty L = ' num2str(L)]);
end