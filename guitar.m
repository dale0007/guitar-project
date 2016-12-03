function [data, peaks] = guitar()

close all;

make_plots = 1;

%% Load the ITLL data into a map

data_files = dir('data/itll/*.txt');
data = containers.Map;

for data_file = data_files'
    [path, name, ext] = fileparts(data_file.name);

    % Load all the .txt file data
    
    data(name) = readtable(['data/itll/',data_file.name], ...
            'Delimiter','\t', ...
            'ReadVariableNames',false); 
        
    disp(['Loaded: ', name])
    
    % Rename column headings depending on data
    data_type = name(end-2:end);

    file = data(name);
    if ( data_type == 'amp' )
        file.Properties.VariableNames = {'time' 'amp'};
    else
        file.Properties.VariableNames = {'freq' 'phase'};
    end
    data(name) = file;
end

%% Identify peaks of FFT
% and amplitudes at the peaks

numPeaks = 10; % how many peaks to look for in each trial
peaks = containers.Map;

for trial = data.keys
    
    trial_data = data(char(trial));
    
    [pks, locs, wid, prom] = findpeaks(trial_data{:,2},trial_data{:,1});
    sorted_peaks = sortrows([pks, locs, wid, prom], -4);
    
    peaks(char(trial)) = sorted_peaks(1:numPeaks,1:2);
  
end

%% Make plots of all

if make_plots

    n = 2; % subplot height
    m = 3; % subplot width
    i = 1;
    figure

    for trial = data.keys
        
        trial_name = char(trial);
        trial_data = data(trial_name);

        subplot(m,n,i)
        plot(trial_data{:,1},trial_data{:,2})
        title(strrep(trial,'_','\_'));

        % add peaks only on FFT graphs
        if (trial_name(end-2:end) == 'amp')
            trial_peaks = peaks(trial_name);   
            text(trial_peaks(:,2)+0.2,trial_peaks(:,1),num2str(trial_peaks(:,2)));
        end
        
        % graph labels
        xlabel(trial_data.Properties.VariableNames{1});
        ylabel(trial_data.Properties.VariableNames{2});

        if i == m*n
            i = 0;
            figure
        end

        i = i + 1;
    end
    
end

