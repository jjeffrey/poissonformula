function PoissonWidget
    %% Choose bound for k. only 2n + 1 exponentials will be summed.
    n = 1;
    ks = -n:1:n;

    %% Choose the fundamental period.
    period = 5;
    
    %% Function for sum of exponentials
    expSum = @(t, kRange, To) sum(exp(-j*kRange*(2*pi/To)*t));

    %% Create range of times
    tmin = -20;
    dt = 1/100;
    tmax = 20;
    ts = tmin:dt:tmax;
    
    %% Draw plot
    f = figure;
    ax = axes('Parent',f,'position',[0.13 0.39  0.77 0.54]);
    drawPlot(f, period, ts, ks); 
    
    function drawPlot(fig, tPeriod, tRange, kRange)
        output = arrayfun(@(t) abs(expSum(t, kRange, tPeriod)), tRange);

        hold off;
        
        % Plot function
        plot(tRange, output, 'color', 'b');
        
        hold on;

        % Draw vertical lines at points of constructive interference
        for m = [tPeriod:tPeriod:max(tRange)]
            line([m, m], [min(output), 1+(max(output)-1)*1.1], 'color', 'r');
        end

        for m = [0:-tPeriod:min(tRange)]
            line([m, m], [min(output), 1+(max(output)-1)*1.1], 'color', 'r');
        end

        if (numel(kRange)~=1)
            title(['Poisson''s formula using the sum of ', int2str(numel(kRange)), ' exponentials']);
        else
            title(['Poisson''s formula using 1 exponential']);
        end
        xlabel('time')
        ylabel('sum')
    end
    
    %% Unimportant UI stuff for slider.
    % Code for a slider adapted from https://www.mathworks.com/help/control/ug/build-app-with-interactive-plot-updates.html
    b = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],...
                  'value', n, 'min',0, 'max',50);
    bgcolor = f.Color;
    bl1 = uicontrol('Parent',f,'Style','text','Position',[50,54,23,23],...
                    'String','0','BackgroundColor',bgcolor);
    bl2 = uicontrol('Parent',f,'Style','text','Position',[500,54,23,23],...
                    'String','50','BackgroundColor',bgcolor);
    bl3 = uicontrol('Parent',f,'Style','text','Position',[240,25,100,23],...
                    'String','Using 2n + 1 exponentials','BackgroundColor',bgcolor);

    function updatePlot(es, ed)
        figure(f);
        clear axes;
        
        m = ceil(es.Value);
        drawPlot(f, period, ts, -m:1:m); 
    end
    
    b.Callback = @updatePlot; 
end
