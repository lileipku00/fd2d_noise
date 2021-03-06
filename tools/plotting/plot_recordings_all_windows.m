% plot_recordings_all(u,t,veldis,color,a)
%
% u: displacement recordings
% t: time axis
% mode: 'dis' for displacement, 'vel' for velocity
% color
% additional relative offset in y direction, usually a=0

function h1 = plot_recordings_all_windows(u,t,veldis,color,a,left,right)

% close all

%==========================================================================
%- plot recordings, ordered according to distance from the first source ---
%==========================================================================

%- initialisations and parameters -----------------------------------------

spacing=2;
sort=0;

%- read input -------------------------------------------------------------

[Lx,Lz,nx,nz,dt,nt,order,model_type] = input_parameters();

%- make distance vector and sort ------------------------------------------

% if (sort==1)
% 
%     d = sqrt((rec_x-src_x).^2+(rec_z-src_z).^2);
%     [dummy,idx] = sort(d);
% 
% else
%     
%     idx = 1:length(rec_x);
%     
% end

%- convert to velocity if wanted ------------------------------------------

if strcmp(veldis,'vel')

    nt=length(t);
    v=zeros(size(u,1),nt-1);
    
    for k=1:size(u,1)
        v(k,:)=diff(u(k,:))/(t(2)-t(1));
    end
    
    t=t(1:nt-1);
    u=v;

%     v = 0.0*u;
%     index_zero = find( t==0 );
%     v(:,2:index_zero) = fliplr( diff(fliplr( u(:,1:index_zero) ),1,2) ) / dt; 
%     v(:,index_zero:end-1) = diff( u(:,index_zero:end),1,2 ) / dt; 
%     
%     u = v;

end

%- plot recordings with ascending distance from the first source ----------

% figure
set(gca,'FontSize',20)
hold on

for k=1:size(u,1)
    
    m = max(abs(u(k,:)));
    h1 = plot(t,spacing*(k-1+a)+u(k,:)/m,color,'LineWidth',1);
    
    h2 = plot([left(k,1) left(k,1)], [spacing*(k-2+a)+0.5 spacing*(k+a)-0.5],'b--');
    h3 = plot([right(k,1) right(k,1)], [spacing*(k-2+a)+0.5 spacing*(k+a)-0.5],'b--');
    
    tmp = left;
    left = -right;
    right = -tmp;
    clear tmp;
    
    h4 = plot([left(k,1) left(k,1)], [spacing*(k-2+a)+0.5 spacing*(k+a)-0.5],'b--');
    h5 = plot([right(k,1) right(k,1)], [spacing*(k-2+a)+0.5 spacing*(k+a)-0.5],'b--');
    
    drawnow
    % if mod(k,2)
        % plot(t,spacing*(k-1+a)+u(idx(k),:)/m,color,'LineWidth',1)
        % plot(t,spacing*(k-1)+zeros(1,length(t)),strcat(color(1),'--'),'LineWidth',1)
    % else
        % plot(t,spacing*(k-1)+u(idx(k),:)/m,color,'LineWidth',1)
    % end
    
%     if (max(rec_x)<=1000)
%         text(min(t)-(t(end)-t(1))/6,spacing*(k-1)+0.3,['x=' num2str(rec_x(idx(k))) ' m, z=' num2str(rec_z(idx(k))) ' m'],'FontSize',14)
%     else
%         text(min(t)-(t(end)-t(1))/6,spacing*(k-1)+0.3,['x=' num2str(rec_x(idx(k))/1000) ' km, z=' num2str(rec_z(idx(k))/1000) ' km'],'FontSize',14)
%     end
%     
end

xlabel('time [s]','FontSize',20);
ylabel('normalised traces','FontSize',20);
% set(gca, 'YTick', []);
% axis([min(t)-(t(end)-t(1))/5 max(t)+(t(end)-t(1))/10 -1.5 spacing*length(rec_x)+1])
