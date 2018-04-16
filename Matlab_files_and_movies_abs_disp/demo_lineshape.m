%demo phase
clear all

sw=20;
dw=1/sw;

t=0:dw:10000;
lb=1/2;
nu=0;
height=[0.99 0.9 sqrt(2)/2 0.5 ];
%height=[ sqrt(2) ];

heightfirst=[ 0.5 0.1 0.02  ];
heightfirstd=[ 0.1 0.02 ];
for anglet=[0 -2*360/22],
    figure((anglet==0)*2+1)
    clf
    plot([-sw/2 sw/2],[0 0 ],'k-');hold on
    phase=cos(anglet/360*2*pi)+j*sin(anglet/360*2*pi);%as complex number
    phase=phase/(abs(phase));
    fid=(phase)*exp(j*2*pi*((t)*nu)).*exp(-t*2*pi*lb);
    
    other_method=1;
    if other_method,
        offset=0;
        fid(1)=fid(1)/2;
    else
        offset=sum(sum(abs(fid)))*(1/2*pi)*(1/sw);%%% important !!
    end
    %
    %
    %
    %fid=fid-offset;
    
    
    spectrum=fftshift(fft((fid)));
    spectrum=spectrum-offset;
    (num2str(real(spectrum(1,1))))
    spectrum=spectrum;
    top=max(max(abs(spectrum)));
    spectrum=spectrum/top;
    incsw=sw/size(t,2);
    
    scale=-sw/2+incsw/2:incsw :sw/2-incsw/2;
    
    plot(scale,abs(spectrum),'k-','LineWidth',2);hold on
    plot(scale,imag(spectrum),'k--');
    plot(scale,real(spectrum),'k-');
  %  plot(scale,power((abs(spectrum)),2),'k:');
    for loop=1:size(heightfirst,2),%plot line width at different heights
        what=real(spectrum);
        tmp=(what(1,1:size(what,2)-1)-heightfirst(1,loop)).*(what(1,2:size(what,2)-0)-heightfirst(1,loop));
        list_i= find(tmp < 0);
        inc=0;a=0;b=0;ii=i;
        for i=list_i,
            
            a=scale(1,i)*0.5+0.5*scale(1,i+1);
            b=real(what(1,i))*0.5+0.5*real(what(1,i+1));
            inc=inc+1;
            if inc==2;
                plot([a aa] ,[ b bb],'k-') ;
                text(aa,bb,[num2str(heightfirst(1,loop)*100,'%.0f') '% ' num2str( abs( scale(1,i)-scale(1,ii)),'%.1f') ' Hz']);
            end
            aa=a;bb=b;ii=i;
            
        end
    end
    for loop=1:size(heightfirstd,2),%plot line disp
        what=imag(spectrum);
        tmp=(what(1,1:size(what,2)-1)-heightfirstd(1,loop)).*(what(1,2:size(what,2)-0)-heightfirstd(1,loop));
        list_i= find(tmp < 0);
 %       [del ii]=max(what);
         inc=0;a=0;b=0;ii=i;
        for i=list_i,
            
            a=scale(1,i)*0.5+0.5*scale(1,i+1);
            b=real(what(1,i))*0.5+0.5*real(what(1,i+1));
           inc=inc+1;
            if inc==2;
                plot([a aa] ,[ b bb],'k--') ;
                text(aa,bb,[num2str(heightfirstd(1,loop)*100,'%.0f') '% ' num2str( abs( scale(1,i)-scale(1,ii)),'%.1f') ' Hz']);
            end
                        aa=a;bb=b;ii=i;

        end
    end
    
    print('-depsc','-tiff','-r2400',[ './fig_phase_demo_' num2str((anglet==0)*2+1) '.eps']);
    figure((anglet==0)*2+2)
    
    clf
    where_projy=sw/2;
    where_projx=-1;
    
    plot3(where_projy+0*scale,imag(spectrum),real(spectrum),'k-'); hold on
    plot3(where_projy+0*scale,imag(spectrum),real(spectrum),'k-'); hold on
    plot3(scale,1+0*imag(spectrum),real(spectrum),'k-','LineWidth',2); hold on
    plot3(scale,imag(spectrum),real(spectrum),'k-'); hold on
    %plot3(scale,0*imag(spectrum),1*real(spectrum),'LineWidth',2); hold on
    plot3(scale,1*imag(spectrum),0*real(spectrum),'k-','LineWidth',2); hold on
    plot3(sw/2*[-1 1],[ 0 0],[ 0 0],'k-')
    plot3(sw/2*[-1 1],1+[ 0 0],[ 0 0],'k-')
    plot3(sw/2*[1 1],[ 1 -1],[ 0 0],'k-')
    %axis([ where_projy*[-1 1] -1 1 0 1])
    
    for loop=1:size(height,2),
        what=abs(spectrum);
        tmp=(what(1,1:size(what,2)-1)-height(1,loop)).*(what(1,2:size(what,2)-0)-height(1,loop));
        list_i= find(tmp < 0);
        [a b]=max(what);
        [a c]=max(abs(spectrum));
        list_i=[list_i b c];
        for i=list_i,
            plot3(scale(1,i)*[1 1],[ imag(spectrum(1,i)) 0],[ real(spectrum(1,i)) 0],'k:')
           
            av_al=angle(real(spectrum(1,i))+j*imag(spectrum(1,i)))   *0.5 + 0.5* angle(real(spectrum(1,i+1))+j*imag(spectrum(1,i+1)));
            delta=angle(real(spectrum(1,i))+j*imag(spectrum(1,i)))  - angle(real(spectrum(1,i+1))+j*imag(spectrum(1,i+1)));
            %text(where_projy*[1],[ imag(spectrum(1,i)) ],[ real(spectrum(1,i)) ],[num2str(360/(2*pi)*av_al,'%.1f') '(' num2str(360/(2*pi)*delta,'%.1f')  ')']);
            addtext=[num2str(height(1,loop)*100,'%.0f') '% '] ;
            signal_me=0;
            if i==c,
                addtext='max(abs) ';
                av_al=angle(real(spectrum(1,i))+j*imag(spectrum(1,i)))  ;
                signal_me=1;
            end
            if i==b,
                addtext='max(real) ';
                av_al=angle(real(spectrum(1,i))+j*imag(spectrum(1,i)))  ;
                
            end
            if i==b && i==c,
                addtext='max(real & abs) ';
                av_al=angle(real(spectrum(1,i))+j*imag(spectrum(1,i)))  ;
                signal_me=1;
            end
            if signal_me,
                 plot3(where_projy*[1 1],[ imag(spectrum(1,i)) 0],[ real(spectrum(1,i)) 0],'k:','LineWidth',2)
            else
                 plot3(where_projy*[1 1],[ imag(spectrum(1,i)) 0],[ real(spectrum(1,i)) 0],'k:')
            end
            
            text(where_projy*[1],[ imag(spectrum(1,i)) ],[ real(spectrum(1,i)) ],[addtext num2str(360/(2*pi)*av_al,'%.1f') ]);
            text(scale(1,i)*[1],[ imag(spectrum(1,i)) ],[ real(spectrum(1,i)) ],[addtext num2str(360/(2*pi)*av_al,'%.1f') ]);
        end
    end
    plot3([sw/2 sw/2],[0 0 ],[0 1 ],'k','LineWidth',2);
    plot3([-sw/2 -sw/2],[-1 1 ],[0 0 ],'k');
    plot3([-sw/2 sw/2],[-1 -1 ],[0 0 ],'k');
    view([-24,22])
    print('-depsc','-tiff','-r2400',[ './fig_phase_demo_' num2str((anglet==0)*2+2) '.eps']);
    
end