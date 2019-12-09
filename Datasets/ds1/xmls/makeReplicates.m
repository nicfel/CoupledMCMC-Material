clear
system('rm -r replicates');
system('mkdir replicates');

xmls = dir('*.xml');
for i = 1 : length(xmls)
    for r = 1 : 5
        f = fopen(xmls(i).name);
        g = fopen(['replicates/' strrep(xmls(i).name, 'xml', sprintf('rep%d.xml', r))], 'w');
        while ~feof(f)
            fprintf(g, fgets(f));
        end
        fclose(f);
        fclose(g)
    end
    
end