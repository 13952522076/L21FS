Y=[24	76.75	38.25	67.5	82.5
10.75	54	9	20.75	65.25]';
decline=[0.5521	0.2964	0.7647	0.6926	0.2091]';
Y=[Y decline*100];
bar(Y,0.8);
ylim([0 100])
set(gca,'xticklabel',{'UMM','MCFS','LS','DFS','���㷨'});
xlabel('����ѡ���㷨','fontsize',18);
ylabel('�����Լ��½��� ','fontsize',18);
set(gca,'linewidth',1.5);
set(gca,'FontSize',16);

legend({'ԭʼ����','�����������','�½���(%)'}, 'location','NorthEast','FontSize',17);

