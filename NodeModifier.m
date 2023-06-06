%Node Modifier 
%Carlos Ortega
%Uploaded: 6-6-2023


function [coord_update]=NodeModifier(Original_airfoil,Nodes,name)
%Input:airfoil coordinate text file, number of desired nodes, and the name
%of the airfoil(all as an array of characters). Example: 'DAE31.txt'

%Output: updated airfoil coordinates

if (exist('Coordinate.txt','file'))
    delete('Coordinate.txt')
end

if (exist('NodeModifier.txt','file'))
    delete('NodeModifier.txt')
end

%Has xfoil run and update the amount of node that the airfoil and saves it
%as a text file
FID_old=fopen('NodeModifier.txt','w');
fprintf(FID_old,['load ' Original_airfoil '\n']);
fprintf(FID_old,[name '\n']);
fprintf(FID_old,'ppar \n');
fprintf(FID_old,['n ' Nodes '\n'] );
fprintf(FID_old,'\n \n');
fprintf(FID_old,'psav Coordinate.txt \n');
fclose(FID_old);

%Running xfoil program to gather new data points
cmd='xfoil.exe < NodeModifier.txt';
[status,results]=system(cmd);

%Archives the Original version of the airfoil
FID_cor=fopen('Coordinate.txt');
coord_update=textscan(FID_cor,'%f %f','CollectOutput',1,'Delimiter','','HeaderLines',0); 
fclose(FID_cor);
