clear
outfiles = dir('out_ess_estimates/*.out');
system('rm -r out_converted');
system('mkdir out_converted');
for i = 1 : length(outfiles)
    disp(i)
        
    subsample = 1000;
    
    f = fopen(['out_ess_estimates/' outfiles(i).name]);
    g = fopen(['out_converted/' outfiles(i).name], 'w');
    
    start=false;
    j=0;
    while ~feof(f)
        line = fgets(f);
        if contains(line, 'sample	swapsColdCain	swapProbability')
            start = true;
            fprintf(g, 'sample\tswapsColdCain\tswapProbability\tTemperature\n');
        elseif start
            if strcmp(line(1), '	') && ~strcmp(line(2), 'a')
                if mod(j,10)==0
                    tmp = strsplit(strtrim(line));
                    fprintf(g, '%s\t%s\t%s\t%s\n', tmp{1}, tmp{2}, tmp{3}, tmp{4});
                end
                j = j+1;
            end
        end
    end
    fclose('all');
end
