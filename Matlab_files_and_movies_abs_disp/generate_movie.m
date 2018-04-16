clear all
%for main_ratio=[ 0.01 1 0.5 0.2 0.1],
for main_ratio=[ 1]
for mainlooop=1:11
figure(mainlooop);clf
%Z = peaks;
%surf(Z)

ax = gca;
ax.NextPlot = 'replaceChildren';


writerObj = VideoWriter(['mov' num2str(mainlooop) '.avi']);
open(writerObj);

axis tight
set(gca,'nextplot','replacechildren');
set(gcf,'Renderer','zbuffer');


loops = 360;
F(loops) = struct('cdata',[],'colormap',[]);
counter=1;
for loopj = 1:2:loops
   % X = sin(loopj*pi/10)*Z;
    %surf(X,Z)
   clf
    anglet= loopj-1;
     phase=cos(anglet/360*2*pi)+1i*sin(anglet/360*2*pi);%as complex number
    phase=phase/(abs(phase));
[dist_in_hz erro_in_deg]=shap_fn3d(phase,mainlooop,main_ratio);

if mainlooop==10
    store_dis_in_hz(counter,1)=dist_in_hz;
    store_erro_in_deg(counter,1)=erro_in_deg;
    counter=counter+1;
end
if mainlooop==11
    store_dis_in_hz(counter,2)=dist_in_hz;
    store_erro_in_deg(counter,2)=erro_in_deg;
    counter=counter+1;
end
            set(gcf,'color','w');

axis off
box off


drawnow
    F(loopj) = getframe;
     writeVideo(writerObj,F(loopj));

end

close(writerObj);
%movie(F,2)
end
figure(111)
clf
plot(store_dis_in_hz(:,1),store_erro_in_deg(:,1),'b-');
hold on
plot(store_dis_in_hz(:,2),store_erro_in_deg(:,2),'r-');
     print('-depsc','-tiff','-r600',[ 'Phase_error_nearby_small_signals' num2str(main_ratio)  '.eps']);%here


end
