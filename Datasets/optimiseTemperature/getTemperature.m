clear
outfiles = dir('out/*.out');

target_values = [0.1 0.3 0.5 0.7] ;


for i = 1 : length(outfiles)
    disp(i)
    
    tmp = strsplit(outfiles(i).name, '_');
    
    Data(i).target = str2double(tmp{3});
    Data(i).iter = str2double(strrep(tmp{4}, '.out', ''));

    subsample = 10^(3-Data(i).iter);
    
    f = fopen(['out/' outfiles(i).name]);
    
    start=false;
    j=1;k=1;
    while ~feof(f)
        line = fgets(f);
        if contains(line, 'sample	swapsColdCain	swapProbability')
            start = true;
        elseif start
            if mod(j,subsample)==0
                tmp = strsplit(strtrim(line));

                if length(tmp)~=5
                    break;
                end
                Data(i).temp(k) = str2double(tmp{4});
                Data(i).acceptance(k) = str2double(tmp{3});
                k=k+1;
            end
            j = j+1;
        else
        end
    end
    fclose(f);
%     Data(i).temp = Data(i).temp(1:10:end);
%     Data(i).acceptance = Data(i).acceptance(1:10:end);
    
end
%% 
cmap = colormap;
colors = cmap(1:floor(length(colormap)/4):end,:);
% figure()
for i = 1 : length(Data)
    subplot(2,1,Data(i).iter)
    plot(1:length(Data(i).acceptance),Data(i).acceptance,  'Color', colors(Data(i).target,:));hold on
    xlabel('iteration')
    ylabel('acceptance probability')
    title('acceptance probability all')
%     subplot(2,2,2)
%     plot(Data(i).temp, 'Color', colors(Data(i).target,:));hold on
%     xlabel('iteration')
%     title('delta temperature all')
%     ylabel('delta temperature')
%     
%     subplot(2,2,3)
%     plot(Data(i).acceptance(1:100), 'Color', colors(Data(i).target,:));hold on
%     xlabel('iteration')
%     ylabel('acceptance probability')
%     title('acceptance probability only start')
%     subplot(2,2,4)
%     plot(Data(i).temp(1:100), 'Color', colors(Data(i).target,:));hold on
%     xlabel('iteration')
%     title('delta temperature only start')
%     ylabel('delta temperature')


end
