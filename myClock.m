%% Myclock
% first edited  in 10/04/2013 Wednesday .
% Add a digital clock and time numbers were added-in 14/04/2013 Sunday.
%  by oren berkovtich ver 0.2.
function myClock()

fig=figure(1);
set(fig,'renderer','opengl',...
    'menubar','none','name','Clock Clasic','numbertitle','off',...
    'visible','on','units','normalized','toolbar','none')
handles.axes = axes;
ylim(handles.axes,[-2 2]);
xlim(handles.axes,[-2 2]);

axis(handles.axes,'off')
hold(handles.axes,'on')

% Setting the time component
handles.clock = timer;
set(handles.clock,'executionmode','fixedrate','Period',1);
set(handles.clock,'timerfcn',@(h,e)StartTimer(h,e,guidata(fig)));
set(handles.clock,'StopFcn',@(h,e)StopTimer(guidata(h),e));

% stop and delete the timer when the figure is closed
set(fig, 'closerequestfcn',@StopTimer);
% function of the timer
% clock frame
rectangle('Position',[-1.15,-1.2,2.4,2.4],'Curvature',[1,1],...
    'FaceColor', [0.101961 0.680392 0.7],'linewidth',2.7);
% number on the clock
for n = 1:12
    text(1.1*cos((90-n* 30)*2*pi/360),1.1*sin((90-n* 30)*2*pi/360),sprintf('%d',n),'fontname','ravie')
end
handles.dialSecond = patch(nan,nan,'r','LineWidth',1);
handles.dialMinutes = patch(nan,nan,'w','LineWidth',2.6);
handles.dialHoure =  patch(nan,nan,'w','LineWidth',3);
handles.digitalClock = text(0.4,0.4,'','units','normalized',...
    'visible','on',...
    'fontsize',16,...
    'fontname','freestyle script','color','y');

guidata(fig,handles)
start(handles.clock);

end

function StartTimer(~,~,handles)

hhmmss =   datestr(now, 'HH:MM:SS');
% second
ss=str2num(hhmmss(7:8)); %#ok<ST2NM>
sxdata=[0, cos((90-ss*6)*2*pi/360)];
sydata=[0, sin((90-ss*6)*2*pi/360)];
set(handles.dialSecond,'xdata',sxdata,'ydata',sydata)
%Minutes
mm=str2num(hhmmss(4:5)); %#ok<ST2NM>

mxdata=[0, 0.8*cos((90-mm*6-ss*0.1)*2*pi/360)];
mydata=[0, 0.8*sin((90-mm*6-ss*0.1)*2*pi/360)];
set(handles.dialMinutes,'xdata',mxdata,'ydata',mydata)
% houre
hh=str2num(hhmmss(1:2)); %#ok<ST2NM>

hxdata=[0, 0.6*cos((90-hh* 30-mm*.5-ss/120)*2*pi/360)];
hydata=[0, 0.6*sin((90-hh*30-mm*.5-ss/120)*2*pi/360)];
set(handles.dialHoure,'xdata',hxdata,'ydata',hydata)
%digital clock
set(handles.digitalClock ,'string',hhmmss);
end

function StopTimer(fig,~)

handles = guidata(fig);
try
stop(handles.clock);
delete(handles.clock);
delete(fig)
catch err
    disp(err)
end
end