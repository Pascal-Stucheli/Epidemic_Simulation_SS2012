%Binomialverteilung kann als normalverteilung approximiert werden, falls
%npq > 9 wobei npq der Varianz entspricht und q der Gegenwkeit (1-p)

%Abgeschlossene Stadt mit 1000 einwohnern jeder Kranke trifft auf 6
%Menschen. Wie viele Kranke braucht es um die Normalverteilung verwenden zu
%können
% I=1;
% tot=1000000;
% vari=0;
% while vari<9
%     I=I+1;
%     q=I/tot;
%     p=1-q;
%     vari = I*6*q*p;
% end
% I %Es braucht 40 Kranke auf 1000 menschen

%Calculate Meetings
I=1;
tot=1000;
N=0
%Assume constant number of meetings
while I<tot
    Ntot=I*6; %Meetings
    P=1-I/tot; %Prob of Meeting healthy Person
    N= binornd(Ntot,P)
    I=I+N/2
end