%infected=dlmread('out5.txt');

%gefx=importdata('final10k1.gexf');

cities=length(infected(:,1)); %number of cities in the array
timesteps=length(infected(1,:)); %number of timesteps -> use all timesteps. Minimization done in the storing part

%to be deleted
h=1
q=1;
while q<=timesteps
    infected2(:,h)=infected(:,q);
    q=round(q+cities/100);
    h=h+1;
end
infected=infected2;
timesteps=length(infected(1,:))

%strings needed for search

target='      <node id="1">';
data='          <attvalue for="Infected" value="0000000" start="0000.0" endopen="0000.0"></attvalue>';
findata='          <attvalue for="Infected" value="000000" start="0000.0"></attvalue>';

lgefx2=length(gefx)+cities*timesteps;
gefx2=cell(349000,1);

pos=1;
pos2=1;
while strcmp(target,gefx{pos}) ~= 1
      gefx2{pos2}=gefx{pos};
       pos=pos+1;    %12
       pos2=pos2+1; %12
end

gefx2{pos2}=target;
gefx2{pos2+1}='        <attvalues>';
pos2=pos2+1; %Update to the correct position 13

for i=1:cities
      
       for n=1:timesteps-1
           data2=data; 
           dummy=num2str(infected(i,n));
           d=length(dummy);
           data2(50-d:49)=dummy(1:d);
           dummy=num2str(n);
           d=length(dummy);
           data2(63-d:62)=dummy(1:d);
           dummy=num2str(n+1);
           d=length(dummy);
           data2(80-d:79)=dummy(1:d);
           gefx2{pos2+n}=data2; 
       end
       
       pos2=pos2+timesteps; %34
       
       findata2=findata;
       dummy=num2str(infected(i,timesteps));
       d=length(dummy);
       findata2(49-d:48)=dummy(1:d);
       dummy=num2str(timesteps);
       d=length(dummy);
       findata2(62-d:61)=dummy(1:d);
       
       gefx2{pos2}=findata2; %the infected for the first node are now calculated
       
       pos=pos+3;%15 %24
       
       for t=0:6
           gefx2{pos2+t}=gefx{pos+t}; %21
       end
       
       pos2=pos2+6;%40
       pos=pos+5;%20
   
end
for y=0:length(gefx)-pos
%gefx2{pos2:(pos2+length(gefx)-pos)}=gefx{pos:length(gefx)};
gefx2{pos2+y}=gefx{pos+y};
end

 file_1 = fopen('try.gexf','w');
% % file_2 = fopen('output2.txt','w')
% % 
for u=1:length(gefx2)
    fprintf(file_1,gefx2{u}); 
    fprintf(file_1,'\n');
end
% 
% a=textread('Untitled.gexf')
% fclose(file_1)
% % fclose(file_2)
