function [y] = fft_test()

    close all;
    
    fft_data = readtable('data/itll/G_amp.txt', ...
                         'Delimiter', '\t', ...
                         'ReadVariableNames', false);
    
    amp_data = readtable('data/itll/G_FFT.txt', ...
                         'Delimiter', '\t', ...
                         'ReadVariableNames', false);
    
    y = amp_data{:,2};  % data
    fs = 44100;         % sampling rate
    dt = 1/fs;          % time interval
    len = length(y);    % sample length

    t = (1/fs)*(1:len);
    
    y_fft = abs(fft(y));
    y_fft = y_fft(1:(len/2));
    f = fs*(1:(len/2))/len;
    
    plot(f, y_fft/fs);
    
    
    % Our FFT of Amp
    
    %figure;
    %plot(f, abs(ft));
    
    %title('Our FFT of amp');
    
    % FFT graph
    
    figure;
    plot(fft_data{:,1}, fft_data{:,2})
    
    title('Original FFT Graph')
    
    % Amp graph
    
    figure;
    plot(amp_data{:,1}, amp_data{:,2});
    
    title('Original Amp Graph')
    

    

end