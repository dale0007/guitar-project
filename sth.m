function [pks, locs, wid, prom] = sth()

clear all;
close all;

make_figures = 1;
    
%freq_tbl = readtable('data/freq_table.csv');
    
%guitar_strings = [
%       freq_tbl(3,{'E'}),
%      freq_tbl(3,{'A'}),
%    freq_tbl(4,{'D'}),
%   freq_tbl(4,{'G'}),
%  freq_tbl(4,{'B'}),
% freq_tbl(5,{'E'}) ]
    
%% load sth wav file
    
sth_file = 'data/sth-intro.wav';
[sth_y, sth_fs] = audioread(sth_file);
sth_t=[ 1/sth_fs : 1/sth_fs : length(sth_y)/sth_fs ];

sth_y = sth_y(:,1); % only look at the first channel of audio

% sth_y is amplitude
% sth_fs is sampling rate in Hz (44.1 kHz)

%% find peaks

numPeaks = 26; % how many peaks to look for in each trial


[pks, locs, wid, prom] = findpeaks(sth_y, sth_t, ...
                                   'MinPeakDistance', 0.36);

sorted_peaks = sortrows([pks, locs', wid', prom], -4);
top_peaks = sorted_peaks(1:numPeaks,:);
top_peaks = sortrows(top_peaks, 2);


%% extract range of sound around each peak
sampleWidth = .1 * sth_fs;

i = 1;
peak_samples = cell(1, length(top_peaks));

for peak = top_peaks'
    
    peak_idx    = int32(sth_fs * peak(2));
    peak_range  = [peak_idx-(sampleWidth/2):1:peak_idx+(sampleWidth/2)]';
    peak_sample = sth_y(peak_idx-(sampleWidth/2):peak_idx+ ...
                        (sampleWidth/2),:);
    
    peak_samples{i} = { peak_range peak_sample };
    
    %player = audioplayer(peak_sample, sth_fs)
    %play(player);
    %pause(.5);
    
    i = i+1;
    
end

%% compute fft of sound ranges and find peak

numFFTPeaks = 10;

n = 2; % subplot height
m = 3; % subplot width
i = 1;

figure;

for peak = peak_samples

    % peak{1}{2} is the wave data for each sample
    % peak{1}{1} is the time where each sample is
    
    sample_len   = length(peak{1}{2});
    sample_fft   = abs(fft(peak{1}{2}, sample_len));
    sample_fft   = sample_fft(1:floor(sample_len/2));
    
    sample_freq  = sth_fs*(0:(sample_len/2)-1)/sample_len;
    
    [pks, locs, wid, prom] = findpeaks(sample_fft, sample_freq);
    locs = locs';
    wid = wid';
    
    % Plot original waveform
    subplot(m,n,i);
    plot(peak{1}{1}, peak{1}{2});
    
    i = i + 1;
    
    % Plot fft
    subplot(m,n,i);
    plot(sample_freq, sample_fft);
    
    
    text(locs(1:numFFTPeaks,1), pks(1:numFFTPeaks,1), num2str(locs(1:numFFTPeaks,1)));
    
    if i == m*n
        i = 0;
        figure;
    end
    
    i = i + 1;
    
    %sorted_peaks = sortrows([pks, locs', wid', prom], -1);
    %top_peak = sorted_peaks(1,:)
    
    %freq = sth_fs/sample_len*( (0:sample_len-1) - ceil((sample_len-1)/2));
    
end

% stem plot

if make_figures
    
    % Raw waveform plot
    
    figure; hold on;

    title('Stairway to Heaven');
    ylabel('Amplitude');
    xlabel(['Seconds (s)']);

    plot(sth_t, sth_y) % plot waveform

    figure; hold on;
    
    % Waveform peaks plot

    plot(sth_t, sth_y); % plot waveform
    plot(top_peaks(:,2), top_peaks(:,1), 'x');
    text(top_peaks(:,2), top_peaks(:,1), num2str(top_peaks(:,1))); % peaks

    figure; hold on;
    
    % Peaks range plot
    
    for sample = peak_samples
        
        plot(sample{1}{1}, sample{1}{2});
        
    end
    
    % FFT plots
    
    for sample = peak_samples
    
        plot(sample{1}{1}, fft(sample{1}{2}));
        
    end
    
    %ylimits = get(gca, 'YLim');
    %plotdata = [ylimits(1):0.1:ylimits(2)];
    %hline = plot(repmat(0, size(plotdata)), plotdata, 'r');

    %player = audioplayer(sth_y, sth_fs);
    %player.TimerFcn = {@plotMarker, player, gcf, plotdata};
    %player.TimerPeriod = 0.01;

    %play(player)
end

end