clear
outfiles = dir('out/*.out');
system('rm -r out_converted');
system('mkdir out_converted');
for i = 1 : length(outfiles)
    disp(i)
    
    tmp = strsplit(outfiles(i).name, '_');
    
    subsample = 10^(3-str2double(strrep(tmp{4}, '.out', '')));
    
    f = fopen(['out/' outfiles(i).name]);
    g = fopen(['out_converted/' outfiles(i).name], 'w');
    
    start=false;
    j=1;k=1;
    while ~feof(f)
        line = fgets(f);
        if contains(line, 'sample	swapsColdCain	swapProbability')
            start = true;
            fprintf(g, 'sample\tswapsColdCain\tswapProbability\tTemperature\n');
        elseif start
            if mod(j,subsample)==0
                tmp = strsplit(strtrim(line));
                if length(tmp)~=5
                    break;
                end
                fprintf(g, '%s\t%s\t%s\t%s\n', tmp{1}, tmp{2}, tmp{3}, tmp{4});
            end
            j = j+1;
        end
    end
    fclose('all');
end

%% make the same for the mascot files
clear
outfiles = dir('out_mascot/*.out');
system('rm -r out_mascotconverted');
system('mkdir out_mascotconverted');
for i = 1 : length(outfiles)
    disp(i)
    
    tmp = strsplit(outfiles(i).name, '_');
    
    subsample = 10^(3-str2double(strrep(tmp{4}, '.out', '')));
    
    f = fopen(['out_mascot/' outfiles(i).name]);
    g = fopen(['out_mascotconverted/' outfiles(i).name], 'w');
    
    start=false;
    j=1;k=1;
    while ~feof(f)
        line = fgets(f);
        if contains(line, 'sample	swapsColdCain	swapProbability')
            start = true;
            fprintf(g, 'sample\tswapsColdCain\tswapProbability\tTemperature\n');
        elseif start
            if mod(j,subsample)==0
                tmp = strsplit(strtrim(line));
                if length(tmp)~=5
                    break;
                end
                fprintf(g, '%s\t%s\t%s\t%s\n', tmp{1}, tmp{2}, tmp{3}, tmp{4});
            end
            j = j+1;
        end
    end
    fclose('all');
end