%Creator:Carlos Ortega 
%Date Started: 6/1/2023

if (exist('Coordinate.txt','file'))
    delete('Coordinate.txt')
end

if (exist('NodeModifier.txt','file'))
    delete('NodeModifier.txt')
end

%Loading Original airfoil and setting inital parameters
Original_airfoil=input('Enter text file of the original airfoil:');
Nodes=input('enter desired amount of nodes as a string:');
name=input('Enter airfoil name as a string:');
%iterations=input('Enter desired iteration as a string:');
%Re=input('Enter Reynolds number as a string:');

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
aero_coordinates=textscan(FID_cor,'%f %f','CollectOutput',1,'Delimiter','','HeaderLines',0); 
fclose(FID_cor);

figure(1)
plot(aero_coordinates{1}(:,1),aero_coordinates{1}(:,2),'-*')
axis equal
oldcoor=aero_coordinates{1};
text(aero_coordinates{1}(:,1),aero_coordinates{1}(:,2),string(1:length(oldcoor)))

%plotting modified airfoil
x1=aero_coordinates{1}(:,1);
y1=aero_coordinates{1}(:,2);

%Plotting unretrained Modification
x2=aero_coordinates{1}(:,1);
y2=aero_coordinates{1}(:,2);

figure(2)
p=plot(x1,y1,'-o','Color','b');
%hold on 
%plot(oldcoor(:,1),oldcoor(:,2),'-o')
%hold off
axis equal
title('Constrained')


figure(3)
j=plot(x2,y2,'-*','Color','r');
hold on 
plot(oldcoor(:,1),oldcoor(:,2),'-o')
hold off
axis equal 
title('Not Contrained')

p.XDataSource='x1';
p.YDataSource='y1';
j.XDataSource='x2';
j.YDataSource='y2';


%Practice for making one random point on the airfoil move by a small amount
n=str2double(Nodes);
s=1;
while s<300
%Restricting the amount of points that can be 
col=randi([1 n],1);
if col==1 || col==200
    continue 
elseif (col>1&&col<=9) || (col<200 && col>192) %This section moves the trailing edge
                                      %as one 
topTrail=aero_coordinates{1}(2:9,:);
botTrail=aero_coordinates{1}(192:199,:);
xmove=(randi([-1 1],1)/randi([50 100],1));
ymove=(randi([-1 1],1)/randi([50 100],1));

newtopTrail(:,1)=topTrail(:,1)+xmove;
newtopTrail(:,2)=topTrail(:,2)+ymove;
newbotTrail(:,1)=botTrail(:,1)+xmove;
newbotTrail(:,2)=botTrail(:,2)+ymove;

x1(2:9)=newtopTrail(:,1);
y1(2:9)=newtopTrail(:,2);
x1(192:199)=newbotTrail(:,1);
y1(192:199)=newbotTrail(:,2);
drawnow
refreshdata
%This section will attempt to make sure the point at the trailing edge dont
%intersect 
a2=191;
b2=10;
A2=[botTrail(8,1) x1(a2);botTrail(8,2) y1(a)];
B2=[topTrail(8,1) x1(b2);topTrail(8,2) y1(b2)];

for t=1:8
 %This sections checks whether line segments to the left and right of
    %the point that was move intersect other line segments 
    [point5]=polyxpoly(A2(1,:),A2(2,:),[x1(a2-t),x1(a2-1-t)],[y1(a2-t),y1(a2-1-t)]);
    [point6]=polyxpoly(B2(1,:),B2(2,:),[x1(b2+t),x1(b2+1+t)],[y1(b2+t),y1(b2+1+t)]);
    [point7]=polyxpoly(B2(1,:),B2(2,:),[x1(a2-t+1),x1(a2-1-t+1)],[y1(a2-t+1),y1(a2-1-t+1)]);
    [point8]=polyxpoly(A2(1,:),A2(2,:),[x1(b2+t-1),x1(b2+1+t-1)],[y1(b2+t-1),y1(b2+1+t-1)]);


    if isempty(point5)&&isempty(point6)&&isempty(point7)&&isempty(point8)
        continue   
    else
        x1(2:9)=topTrail(:,1);
        y1(2:9)=topTrail(:,2);
        x1(192:199)=botTrail(:,1);
        y1(192:199)=botTrail(:,2);
        break
    end
end

else 
point=aero_coordinates{1}(col,:);
pointnew(1)=point(1)+(randi([-1 1],1)/randi([50 100],1));
pointnew(2)=point(2)+(randi([-1 1],1)/randi([50 100],1));

x1(col)=pointnew(1);
y1(col)=pointnew(2);

x2(col)=pointnew(1);
y2(col)=pointnew(2);
drawnow 
refreshdata
end 


%Line segments with the two point right next to the point moved 
if col>=199 || col<=1
    continue
else
a=col-1;
b=col+1;
end
A=[x1(col) x1(a);y1(col) y1(a)];
B=[x1(col) x1(b);y1(col) y1(b)];

%Attempting to retrain the points from intercepting during the iterations 
for t=1:8
    if col>=187 || col<=13 %Ignoring points that will cause a index error 
       break
    else 
  
    %This sections checks whether line segments to the left and right of
    %the point that was move intersect other line segments 
    [point1]=polyxpoly(A(1,:),A(2,:),[x1(a-t),x1(a-1-t)],[y1(a-t),y1(a-1-t)]);
    [point2]=polyxpoly(B(1,:),B(2,:),[x1(b+t),x1(b+1+t)],[y1(b+t),y1(b+1+t)]);
    [point3]=polyxpoly(B(1,:),B(2,:),[x1(a-t+1),x1(a-1-t+1)],[y1(a-t+1),y1(a-1-t+1)]);
    [point4]=polyxpoly(A(1,:),A(2,:),[x1(b+t-1),x1(b+1+t-1)],[y1(b+t-1),y1(b+1+t-1)]);
    
    if isempty(point1)&&isempty(point2)&&isempty(point3)&&isempty(point4)
        continue   
    else
        x1(col)=point(1);
        y1(col)=point(2);
        break
    end
    end
end
refreshdata
drawnow
s=s+1;
end 

text(x1,y1,string(1:length(x1)))
