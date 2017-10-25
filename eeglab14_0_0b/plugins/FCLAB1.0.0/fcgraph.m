function outEEG=fcgraph(inEEG)
metric=inEEG.FC.graph_prop.metric;
disp('>> FCLAB: Computing graph theoretical parameters')
eval(['bands=fieldnames(inEEG.FC.' metric ');']);

if(inEEG.FC.graph_prop.plus_minus)
    %SEPERATE THE NETWORKS
    for i=1:length(bands)
         eval(['A=inEEG.FC.' metric '.' bands{i} '.adj_matrix;']);
         Amin=A;
         Apl=A;
         Amin(Amin>0)=0;
         Amin=-Amin;
         Apl(Apl<0)=0;
         eval(['inEEG.FC.' metric '.' bands{i} '.adj_matrix_plus=Apl;']);
         eval(['inEEG.FC.' metric '.' bands{i} '.adj_matrix_minus=Amin;']);
         eval(['inEEG.FC.' metric '.' bands{i} '.adj_matrix_plus_GP=fclab_graphproperties(inEEG.FC.'...
             metric '.' bands{i} '.adj_matrix_plus, bands{i});']);
         eval(['inEEG.FC.' metric '.' bands{i} '.adj_matrix_minus_GP=fclab_graphproperties(inEEG.FC.'...
             metric '.' bands{i} '.adj_matrix_minus, bands{i});']);
         if(inEEG.FC.graph_prop.mst)
             eval(['[inEEG.FC.' metric '.' bands{i}...
                 '.adj_matrix_minus_MST, inEEG.FC.' metric '.' bands{i}...
                 '.adj_matrix_minus_MST_GP]=fclab_MST(inEEG.FC.'...
                 metric '.' bands{i} '.adj_matrix_minus, bands{i});']);
             eval(['[inEEG.FC.' metric '.' bands{i}...
                 '.adj_matrix_plus_MST, inEEG.FC.' metric '.' bands{i}...
                 '.adj_matrix_plus_MST_GP]=fclab_MST(inEEG.FC.'...
                 metric '.' bands{i} '.adj_matrix_plus, bands{i});']);
         end
    end
    
    if(inEEG.FC.graph_prop.symmetrize)
         for i=1:length(bands)
             eval(['inEEG.FC.' metric '.' bands{i} '.adj_matrix_plus_sym=symmetrize(inEEG.FC.' metric '.' bands{i} '.adj_matrix_plus);']);
             eval(['inEEG.FC.' metric '.' bands{i} '.adj_matrix_minus_sym=symmetrize(inEEG.FC.' metric '.' bands{i} '.adj_matrix_minus);']);
      
             eval(['inEEG.FC.' metric '.' bands{i} '.adj_matrix_plus_sym_GP=fclab_graphproperties(inEEG.FC.'...
             metric '.' bands{i} '.adj_matrix_plus_sym, bands{i});']);
         
            
            eval(['inEEG.FC.' metric '.' bands{i} '.adj_matrix_minus_sym_GP=fclab_graphproperties(inEEG.FC.'...
             metric '.' bands{i} '.adj_matrix_minus_sym, bands{i});']);
         
             if(inEEG.FC.graph_prop.mst)
                 eval(['[inEEG.FC.' metric '.' bands{i}...
                     '.adj_matrix_minus_sym_MST, inEEG.FC.' metric '.' bands{i}...
                     '.adj_matrix_minus_sym_MST_GP]=fclab_MST(inEEG.FC.'...
                     metric '.' bands{i} '.adj_matrix_minus_sym, bands{i});']);
                 eval(['[inEEG.FC.' metric '.' bands{i}...
                     '.adj_matrix_plus_sym_MST, inEEG.FC.' metric '.' bands{i}...
                     '.adj_matrix_plus_sym_MST_GP]=fclab_MST(inEEG.FC.'...
                     metric '.' bands{i} '.adj_matrix_plus_sym, bands{i});']);
             end
         end   
    end
else % no plus minus
    %just a check
    if((inEEG.FC.graph_prop.threshold==1) && isempty(inEEG.FC.graph_prop.absthr) && isempty(inEEG.FC.graph_prop.propthr))
        error('No Value for Threshold'); return;
    end
    
    if (inEEG.FC.graph_prop.threshold==1)
        % Absolute threshold
        if (~isempty(inEEG.FC.graph_prop.absthr))
            if (inEEG.FC.graph_prop.binarize==0)
                if (inEEG.FC.graph_prop.symmetrize==0)
                    for i=1:length(bands)
                        eval(['inEEG.FC.' metric '.' bands{i} '.absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                            '=threshold_absolute(inEEG.FC.' metric '.' bands{i}...
                            '.adj_matrix,' inEEG.FC.graph_prop.absthr ');']);

                        eval(['inEEG.FC.' metric '.' bands{i} '.absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                            '_GP=fclab_graphproperties(inEEG.FC.' metric '.' bands{i} '.absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_') ', bands{i});']);

                        if(inEEG.FC.graph_prop.mst)
                            eval(['[inEEG.FC.' metric '.' bands{i}...
                             '.absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                            '_MST, inEEG.FC.' metric '.' bands{i}...
                             '.absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                            '_MST_GP]=fclab_MST(inEEG.FC.'...
                             metric '.' bands{i} '.absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_') ', bands{i});']);
                        end
                    end
                else %abs threshold binarize no symmetrize yes
                    for i=1:length(bands)
                        eval(['inEEG.FC.' metric '.' bands{i} '.absthr_'...
                                strrep(inEEG.FC.graph_prop.absthr,'.','_') '_sym=symmetrize(inEEG.FC.' metric '.' bands{i} '.absthr_'...
                                strrep(inEEG.FC.graph_prop.absthr,'.','_') ';']);

                            eval(['inEEG.FC.' metric '.' bands{i} '.absthr_'...
                                strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                                '_sym_GP=fclab_graphproperties(inEEG.FC.' metric '.' bands{i} '.absthr_'...
                                strrep(inEEG.FC.graph_prop.absthr,'.','_') '_sym, bands{i});']);

                            if(inEEG.FC.graph_prop.mst)
                                eval(['[inEEG.FC.' metric '.' bands{i}...
                                 '.absthr_'...
                                strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                                '_sym_MST, inEEG.FC.' metric '.' bands{i}...
                                 '.absthr_'...
                                strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                                '_sym_MST_GP]=fclab_MST(inEEG.FC.'...
                                 metric '.' bands{i} '.absthr_'...
                                strrep(inEEG.FC.graph_prop.absthr,'.','_') '_sym, bands{i});']);
                            end
                    end
                end
            else % binary
                if (inEEG.FC.graph_prop.symmetrize==0)
                    for i=1:length(bands)
                        eval(['A=threshold_absolute(inEEG.FC.' metric '.' bands{i} ...
                            '.adj_matrix,' inEEG.FC.graph_prop.absthr ');']);
                        A(A~=0)=1;
                        eval(['inEEG.FC.' metric '.' bands{i} '.bin_absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_') '=A;']);
                        
                        eval(['[inEEG.FC.' metric '.' bands{i} '.bin_absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                            '_GP]=fclab_graphproperties(inEEG.FC.' metric '.' bands{i} '.bin_absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_') ', bands{i});']);
                        clear A;
                        
                        if(inEEG.FC.graph_prop.mst)
                                eval(['[inEEG.FC.' metric '.' bands{i}...
                                 '.bin_absthr_'...
                                strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                                '_MST, inEEG.FC.' metric '.' bands{i}...
                                 '.bin_absthr_'...
                                strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                                '_MST_GP]=fclab_MST(inEEG.FC.'...
                                 metric '.' bands{i} '.bin_absthr_'...
                                strrep(inEEG.FC.graph_prop.absthr,'.','_') ', bands{i});']);
                        end
                    end
                else % binary symmetric
                    for i=1:length(bands)
                        eval(['A=threshold_absolute(inEEG.FC.' metric '.' bands{i} ...
                            '.adj_matrix,' inEEG.FC.graph_prop.absthr ');']);
                        A(A~=0)=1;
                        eval(['inEEG.FC.' metric '.' bands{i} '.bin_absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_') '_sym=symmetrize(A);']);

                        eval(['inEEG.FC.' metric '.' bands{i} '.bin_absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                            '_sym_GP=fclab_graphproperties(inEEG.FC.' metric '.' bands{i} '.bin_absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_') '_sym, bands{i});']);
                        clear A;
                                                
                        if(inEEG.FC.graph_prop.mst)
                                eval(['[inEEG.FC.' metric '.' bands{i}...
                                 '.bin_absthr_'...
                                strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                                '_sym_MST, inEEG.FC.' metric '.' bands{i}...
                                 '.bin_absthr_'...
                                strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                                '_sym_MST_GP]=fclab_MST(inEEG.FC.'...
                                 metric '.' bands{i} '.bin_absthr_'...
                                strrep(inEEG.FC.graph_prop.absthr,'.','_') '_sym, bands{i});']);
                        end
                    end
                end
            end
        end
        
        if(~isempty(inEEG.FC.graph_prop.propthr))
                if (inEEG.FC.graph_prop.binarize==0)
                    if (inEEG.FC.graph_prop.symmetrize==0)
                        for i=1:length(bands)
                        
                            eval(['inEEG.FC.' metric '.' bands{i} '.propthr_'...
                            inEEG.FC.graph_prop.propthr ...
                            '=threshold_proportional(inEEG.FC.' metric '.'...
                            bands{i} '.adj_matrix,' ...
                            num2str(str2num(inEEG.FC.graph_prop.propthr)/100) ');']);
                            
                            eval(['inEEG.FC.' metric '.' bands{i} '.propthr_'...
                            inEEG.FC.graph_prop.propthr '_GP=fclab_graphproperties(inEEG.FC.'...
                            metric '.' bands{i} '.propthr_'...
                            inEEG.FC.graph_prop.propthr ', bands{i});']);
                        
                        
                            if(inEEG.FC.graph_prop.mst)
                                eval(['[inEEG.FC.' metric '.' bands{i}...
                                 '.propthr_'...
                                inEEG.FC.graph_prop.propthr...
                                '_MST, inEEG.FC.' metric '.' bands{i}...
                                 '.propthr_'...
                                inEEG.FC.graph_prop.propthr...
                                '_MST_GP]=fclab_MST(inEEG.FC.'...
                                 metric '.' bands{i} '.propthr_'...
                                inEEG.FC.graph_prop.propthr ', bands{i});']);
                            end
                        
                        end
                    
                    else %prop threshold binarize no symmetrize yes
                        for i=1:length(bands)
                        
                            eval(['inEEG.FC.' metric '.' bands{i} '.propthr_'...
                            inEEG.FC.graph_prop.propthr ...
                            '=threshold_proportional(inEEG.FC.' metric '.'...
                            bands{i} '.adj_matrix,' ...
                            num2str(str2num(inEEG.FC.graph_prop.propthr)/100) '_sym);']);
                            
                            eval(['inEEG.FC.' metric '.' bands{i} '.propthr_'...
                            inEEG.FC.graph_prop.propthr '_sym_GP=fclab_graphproperties(inEEG.FC.'...
                            metric '.' bands{i} '.propthr_'...
                            inEEG.FC.graph_prop.propthr '_sym, bands{i});']);
                        
                        
                            if(inEEG.FC.graph_prop.mst)
                                eval(['[inEEG.FC.' metric '.' bands{i}...
                                 '.propthr_'...
                                inEEG.FC.graph_prop.propthr...
                                '_sym_MST, inEEG.FC.' metric '.' bands{i}...
                                 '.propthr_'...
                                inEEG.FC.graph_prop.propthr...
                                '_sym_MST_GP]=fclab_MST(inEEG.FC.'...
                                 metric '.' bands{i} '.propthr_'...
                                inEEG.FC.graph_prop.propthr '_sym, bands{i});']);
                            end
                        
                        end
                    
                    end
                
                else % binary
                   if (inEEG.FC.graph_prop.symmetrize==0)
                    for i=1:length(bands)
                        eval(['A=threshold_proportional(inEEG.FC.' metric '.' bands{i} ...
                            '.adj_matrix,' num2str(str2num(inEEG.FC.graph_prop.propthr)/100) ');']);
                        A(A~=0)=1;
                        eval(['inEEG.FC.' metric '.' bands{i} '.bin_propthr_'...
                            inEEG.FC.graph_prop.propthr '=A;']);
                        
                        eval(['inEEG.FC.' metric '.' bands{i} '.bin_propthr_'...
                            inEEG.FC.graph_prop.propthr '_GP=fclab_graphproperties(A, bands{i});']);
                        clear A;

                        if(inEEG.FC.graph_prop.mst)
                                    eval(['[inEEG.FC.' metric '.' bands{i}...
                                     '.bin_propthr_'...
                                    inEEG.FC.graph_prop.propthr...
                                    '_MST, inEEG.FC.' metric '.' bands{i}...
                                     '.propthr_'...
                                    inEEG.FC.graph_prop.propthr...
                                    '_MST_GP]=fclab_MST(inEEG.FC.'...
                                     metric '.' bands{i} '.bin_propthr_'...
                                    inEEG.FC.graph_prop.propthr ', bands{i});']);   
                        end
                    end
                    
                   else %prop threshold binarize yes symmetrize yes
                    for i=1:length(bands)
                        eval(['A=threshold_proportional(inEEG.FC.' metric '.' bands{i} ...
                            '.adj_matrix,' num2str(str2num(inEEG.FC.graph_prop.propthr)/100) ');']);
                        A(A~=0)=1;
                        A=symmetrize(A);
                        eval(['inEEG.FC.' metric '.' bands{i} '.bin_propthr_'...
                            inEEG.FC.graph_prop.propthr '_sym=A;']);
                        
                        eval(['inEEG.FC.' metric '.' bands{i} '.bin_propthr_'...
                            inEEG.FC.graph_prop.propthr '_sym_GP=fclab_graphproperties(A, bands{i});']);
                        clear A;

                        if(inEEG.FC.graph_prop.mst)
                                    eval(['[inEEG.FC.' metric '.' bands{i}...
                                     '.bin_propthr_'...
                                    inEEG.FC.graph_prop.propthr...
                                    '_sym_MST, inEEG.FC.' metric '.' bands{i}...
                                     '.propthr_'...
                                    inEEG.FC.graph_prop.propthr...
                                    '_sym_MST_GP]=fclab_MST(inEEG.FC.'...
                                     metric '.' bands{i} '.bin_propthr_'...
                                    inEEG.FC.graph_prop.propthr '_sym, bands{i});']);   
                        end
                    end

                    
                   end
                end   
        end
    else % no thresholding
        if (inEEG.FC.graph_prop.binarize==0)
                    
            if (inEEG.FC.graph_prop.symmetrize==1)
                         
                for i=1:length(bands)
                            eval(['inEEG.FC.' metric '.' bands{i} ...
                                '.adj_matrix_sym=symmetrize(inEEG.FC.' metric '.' bands{i} ...
                                '.adj_matrix);']);

                            eval(['inEEG.FC.' metric '.' bands{i} ...
                                '.adj_matrix_sym_GP=fclab_graphproperties(inEEG.FC.'...
                                metric '.' bands{i} ...
                                '.adj_matrix_sym, bands{i});']);

                            
                            if(inEEG.FC.graph_prop.mst)
                                        eval(['[inEEG.FC.' metric '.' bands{i}...
                                         '.adj_matrix_sym_MST, inEEG.FC.' metric '.' bands{i}...
                                         '.adj_matrix_sym_MST_GP]=fclab_MST(inEEG.FC.'...
                                         metric '.' bands{i} '.adj_matrix_sym, bands{i})']);   
                            
                            end
                            
                end
                
            else
                
                for i=1:length(bands)
                            eval(['inEEG.FC.' metric '.' bands{i} ...
                                '.adj_matrix_GP=fclab_graphproperties(inEEG.FC.'...
                                metric '.' bands{i} ...
                                '.adj_matrix, bands{i});']);

                            
                            if(inEEG.FC.graph_prop.mst)
                                        eval(['[inEEG.FC.' metric '.' bands{i}...
                                         '.adj_matrix_MST, inEEG.FC.' metric '.' bands{i}...
                                         '.adj_matrix_MST_GP]=fclab_MST(inEEG.FC.'...
                                         metric '.' bands{i} '.adj_matrix, bands{i});']);   
                            end
                            
                end
                
            end
            
            
        else
            error('FCLAB>>Cannot Binarize Without Threshold');
            return;
        end
    end
    
end
outEEG=inEEG;


