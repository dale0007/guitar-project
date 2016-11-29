function data = guitar()

close all;

%% Load all the data into a map

data_files = dir('data/*.txt');
data = containers.Map;

for data_file = data_files'
    [path, name, ext] = fileparts(data_file.name);

    % Load all the .txt file data
    
    data(name) = readtable(['data/',data_file.name], ...
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

%% Make plots of all

m = 3; % subplot height
n = 2; % subplot width
i = 1;
figure
    
for trial = data.keys
    
    trial_data = data(char(trial));
    
    subplot(m,n,i)
    plot(trial_data{:,1},trial_data{:,2})
    title(strrep(trial,'_','\_'));
    
    xlabel(trial_data.Properties.VariableNames{1});
    ylabel(trial_data.Properties.VariableNames{2});
    
    if i == m*n
        i = 0;
        figure
    end
    
    i = i + 1;
end