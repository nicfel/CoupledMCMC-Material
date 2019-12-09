clear
system('rm -r xmlsmascot');
system('mkdir xmlsmascot');

% define the start values for the temperature
start_values = logspace(-4,-1,4);
target_values = [0.117 0.234 0.468];
swap_values = [100 1000];


for a = 1 : length(start_values)
    for b = 1 : length(target_values)
        for c = 1 : length(swap_values)
            % open the template
            f = fopen('mascot_template.xml');

            g = fopen(sprintf('xmlsmascot/mascot_%d_%d_%d.xml',a ,b ,c ), 'w');
            while ~feof(f)
                line = fgets(f);
                if contains(line, 'insert_initial')
                    fprintf(g, strrep(line, 'insert_initial', num2str(start_values(a))));
                elseif contains(line, 'insert_target')
                    fprintf(g, strrep(line, 'insert_target', num2str(target_values(b))));
                elseif contains(line, 'insert_swap')
                    fprintf(g, strrep(line, 'insert_swap', num2str(swap_values(c))));
                else
                    fprintf(g, line);
                end
            end
            fclose(f);fclose(g);
        end
    end
end
    
