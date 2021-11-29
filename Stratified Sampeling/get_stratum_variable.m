function [var] = get_stratum_variable(u,wisdom,magic,stratum)
% Call normal function and then change values due to strata
var = get_random_variable(u);

% Propabilities Wisdom and Magic
p = wisdom/100;
q = magic/100;

% Strata
[y_clues,y_portal,y_cluetype] = get_strata_settings(stratum);

switch y_clues
    case "<wisdom"
        var.y_clue = u(1:4)*wisdom;
    case ">=wisdom"
        var.y_clue = wisdom+u(1:4)*(100-wisdom);
    case "Else"
        % Find numbers of "<wisdom"
        nums_leq_wisdom = 1:3;
        prob_num_leq_wisdom = binopdf(nums_leq_wisdom,3,p);
        prob_num_leq_wisdom = prob_num_leq_wisdom/sum(prob_num_leq_wisdom); %scale to 1
        num_leq_wisdom = datasample(nums_leq_wisdom,1,'Weights',prob_num_leq_wisdom);
        
        % Find position in vector y_clue of "<wisdom"
        positions = 1:4;
        pos_leq_wisdom = positions(randperm(4, num_leq_wisdom));
        
        for ii = 1:4
            % "<wisdom"
            if any(ii==pos_leq_wisdom)
                var.y_clue(ii) = u(ii)*wisdom;
                
            else % ">=wisdom"
                var.y_clue(ii) = wisdom+u(ii)*(100-wisdom);
            end
        end

end

switch y_portal
    case "<magic"
        var.y_portal        = u(29)*magic;
    case ">=magic"
        var.y_portal        = magic+u(29)*(100-magic);
end

% Clues and their probability
clues = {'trap','scroll','book','artefact','friend'};
clue_prob = [0.2 0.4 0.25 0.10 0.05];
switch y_cluetype

    case "noTrap"
        % Delete Trap as possible clue
        clues = {'scroll','book','artefact','friend'};
        clue_prob = [0.4 0.25 0.10 0.05];
        % Scale to probability to 1 without trap
        clue_prob = clue_prob/sum(clue_prob); 
        for ii = 5:8
            u_clue = u(ii);
            clue = give_clue(clues,clue_prob,u_clue);
            var.y_clue_type(ii-4) = clue;
        end


    case "Trap"
        
        % Find numbers of traps
        num_traps = 1:4;
        prob_num_traps = binopdf(num_traps,4,0.2);
        prob_num_traps= prob_num_traps/sum(prob_num_traps);
        num_trap = datasample(num_traps,1,'Weights',prob_num_traps);
        
        % Find position in vector y_clue_type of the traps
        positions = 1:4;
        pos_traps = positions(randperm(4, num_trap));
        
        % Set selection of random clue without trap
        clues = {'scroll','book','artefact','friend'};
        clue_prob = [0.4 0.25 0.10 0.05];
        clue_prob = clue_prob/sum(clue_prob); % Scale to 1 without trap

        for ii = 5:8
            idx = ii-4;
            if any(idx == pos_traps)
                % Clue should be trap
                var.y_clue_type(idx) = {'trap'};
            else
                % Clue should be something else
                u_clue = u(ii);
                clue = give_clue(clues,clue_prob,u_clue);
                var.y_clue_type(idx) = clue;
            end
        end


    case "None"
        for ii = 5:8
            u_clue = u(ii);
            clue = give_clue(clues,clue_prob,u_clue);
            var.y_clue_type(ii-4) = clue;
        end
end


end

function [clue] = give_clue(clues,clue_prob,u_clue)
idx = 1;
for prob = cumsum(clue_prob)
    if u_clue <= prob
        break;
    end
    idx = idx +1;
end
clue = clues(idx);
end