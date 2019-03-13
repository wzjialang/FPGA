%% Instrument Connection

% Find a serial port object.
obj1 = instrfind('Type', 'serial', 'Port', 'COM4', 'Tag', '');

% Create the serial port object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = serial('COM4');
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Connect to instrument object, obj1.
fopen(obj1);

%% Instrument Configuration and Control
% Communicating with instrument object, obj1.
i=1;
while(1)
    data1 = fscanf(obj1);
    data{i,1}=data1;
    i=i+1;
    xlswrite('E:\data.xls',data);
end

