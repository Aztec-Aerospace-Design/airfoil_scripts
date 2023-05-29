%% create yourself a table of all values from xfoil without breaking a sweat.
% output_array is a cell array of structs. each entry in this array
% represents a single airfoil. 
%
% Each struct has two fields:
%   name:   char vector
%   data:   Table with columns `alpha`, `Cl`, and `Cd`
%
% Recall how to use tables and structs.
%   output_array{1}.data.Cl

function [output_array] = table_maker(airfoil_names, xfoil_output)
    if (length(airfoil_names) ~= length(xfoil_output))
        ME = MException('table_maker:arrayLengthMismatch', ...
            'Expected the length of both inputs to be equal!');

        throw(ME);
    end

    output_array = {};

    for i = 1:length(airfoil_names)
        foil_data = xfoil_output{i};

        foil_table = array2table(foil_data, 'VariableNames', ...
            ["alpha", "Cl", "Cd"]);

        output_array{end + 1} = struct('name', airfoil_names{i}, ...
            'data', foil_table);
    end
end


