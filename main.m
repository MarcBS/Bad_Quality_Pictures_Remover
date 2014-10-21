function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 17-Sep-2014 12:57:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);

warning('off', 'all');

%% Parameters
addpath('Blurriness');
global resizeTests;
resizeTests = 5;

global handlesGlob;

global nRows;
global nColumns;
nRows = 2;
nColumns = 6;

global borderWidth;
global borderColor;
borderWidth = 5;
borderColor = [200 0 0];

global heightImage;
heightImage = 125;

%% Create gui
handlesGlob = handles;
initGUI();


function initGUI()
    global handlesGlob;
    global heightImage;

    set(handlesGlob.pathField, 'Enable', 'on');
    set(handlesGlob.formatField, 'Enable', 'on');
    set(handlesGlob.searchButton, 'Enable', 'on');
    
    set(handlesGlob.removeButton, 'Enable', 'off');

    % Initializes the imagesAxes
    img = uint8(zeros(heightImage*2, 1000, 3));
    axes(handlesGlob.imagesAxes);
    imshow(img);



% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function pathField_Callback(hObject, eventdata, handles)
% hObject    handle to pathField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pathField as text
%        str2double(get(hObject,'String')) returns contents of pathField as a double


% --- Executes during object creation, after setting all properties.
function pathField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pathField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in searchButton.
function searchButton_Callback(hObject, eventdata, handles)
% hObject    handle to searchButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
%% Get data from fields
path = get(handles.pathField, 'String');
format = get(handles.formatField, 'String');

if(checkThresholds())
    %% Get images from folder
    try
        if(~strcmp(format(1), '.'))
            format = ['.' format];
        end
        images = dir([path '/*' format]);
    catch
        run incorrectPathWindow
    end

    if(length(images) == 0)
        run incorrectPathWindow
    else
        prepareAxes(images, handles, path);
    end
end



% --- Executes on button press in removeButton.
function removeButton_Callback(hObject, eventdata, handles)
% hObject    handle to removeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global lastPosID;
global imagesList;
global handlesGlob;
global pathImages;
global indices;
global toDeleteGlob;

if(checkThresholds())
    count = 1;
    for ind = indices
        if(toDeleteGlob(count))
            delete([pathImages '/' imagesList(ind).name]);
        end
        count = count+1;
    end

    %% Check if we have finished removing
    if(lastPosID == length(imagesList))
        initGUI();
        run finishedWindow
    else
        % Show next set
        nextImages(imagesList, handlesGlob, pathImages, lastPosID);
    end
end


function check = checkThresholds()
    global thresholdBlur;
    global thresholdDark;
    global handlesGlob;

    check = false;
    error = false;
    
    % Check correct thresholds
    thresholdBlur = get(handlesGlob.thresBlur, 'String');
    thresholdDark = get(handlesGlob.thresDark, 'String');
    
    %% Check thresholds
    try
        thresholdBlur = str2double(thresholdBlur);
        thresholdDark = str2double(thresholdDark);
        if(isnan(thresholdBlur) || isnan(thresholdDark))
            run incorrectThresholds
            error = true;
        end
    catch
        run incorrectThresholds
        error = true;
    end
    
    if(thresholdBlur < 0 || thresholdBlur > 1 || thresholdDark < 0 || thresholdDark > 1)
        run incorrectThresholds
    elseif(~error)
        check = true;
        thresholdDark = 1-thresholdDark;
    end
    

function formatField_Callback(hObject, eventdata, handles)
% hObject    handle to formatField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of formatField as text
%        str2double(get(hObject,'String')) returns contents of formatField as a double


% --- Executes during object creation, after setting all properties.
function formatField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to formatField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Prepares the axes for inserting images
function prepareAxes(images, handles, path)
    
    global nRows;
    global nColumns;
    global borderWidth;
    global heightImage;
    global widthImage;
    global lastPosID;
    global imagesList;
    global pathImages;
    global handlesGlob;
    lastPosID = 0;
    imagesList = images;
    pathImages = path;
    
    set(handles.pathField, 'Enable', 'off');
    set(handles.formatField, 'Enable', 'off');
    set(handles.searchButton, 'Enable', 'off');
    set(handles.removeButton, 'Enable', 'on');
    
    im = imread([path '/' images(1).name]);
    widthImage = round(size(im, 2)/size(im, 1) * heightImage);
    
    % Re-Initializes the imagesAxes
    img = uint8(zeros(heightImage*nRows+borderWidth*nRows*2, widthImage*nColumns+borderWidth*nColumns*2, 3));
    axes(handles.imagesAxes);
    imshow(img);
    
    
    nextImages(images, handles, path, lastPosID);
    
%     path = 	D:\Video Summarization Project Data Sets\TEST remove images
    

function nextImages(images, handles, path, lastPos)
    
    global nRows;
    global nColumns;
    global indices;
    global lastPosID;
    global thresholdBlur;
    global thresholdDark;
    global imagesCell;
    global imagesList;
    global pathImages;
    global heightImage;
    global widthImage;
    global resizeTests;
    
    n = nRows * nColumns;
    
    % TODO: Modify selecting the next blurry/dark images
    indices = []; imagesCell = {}; i = 0;
    lastPos = lastPos+1;
    while(i < n && lastPos <= length(imagesList))
        % Load image
        im = imread([pathImages '/' imagesList(lastPos).name]);
        props = size(im) / resizeTests;
        im2 = imresize(im, props(1:2));
        
        % Check blurriness
        blur = mean(extractBlurriness(im2, 9, [9 9]));
        % Check darkness
        dark = mean(mean(mean(im2)))/255;
        if(blur > thresholdBlur || dark < thresholdDark)
            disp([num2str(i+1) ' ' imagesList(lastPos).name '   blur:' num2str(blur) ' dark:' num2str(1-dark)]);
            im = imresize(im, [heightImage widthImage]);
            indices = [indices lastPos];
            i = i+1;
            imagesCell{i} = im;
        end
        lastPos = lastPos+1;
    end
    disp(' ');
    if(lastPos >= length(imagesList) && i == 0)
        % Finish search
        initGUI();
        run finishedWindow
    end
    
%     first = lastPos + 1;
%     lastPos = lastPos + n;
%     lastPos = min(lastPos, length(images));
%     indices = first:lastPos;
    %%%%%%%%%%%%%%%%%
    
    lastPosID = lastPos;
    toDelete = ones(1,n);
    paint(images, handles, path, toDelete)
    
    
%% Repaints all the images between the given indices (first:lastPos) with
% the border color corresponding to their binary delete status (toDelete)
function paint(images, handles, path, toDelete)

    global nRows;
    global nColumns;
    global borderWidth;
    global heightImage;
    global widthImage;
    global borderColor;
    global lastPosID;
    global indices;
    global imagesCell;
    global toDeleteGlob;
    toDeleteGlob = toDelete;
    
    img = uint8(zeros(heightImage*nRows+borderWidth*nRows*2, widthImage*nColumns+borderWidth*nColumns*2, 3));
    x = 0; y = 0;
    count = 1;
    for i = indices
        
        % Get limits
        top = y*(heightImage+borderWidth*2)+1;
        bottom = (y+1)*(heightImage+borderWidth*2);
        left = x*(widthImage+borderWidth*2)+1;
        right = (x+1)*(widthImage+borderWidth*2);
        
        % Paint border
        if(toDelete(count))
            img(top:bottom , left:right, 1) = borderColor(1);
            img(top:bottom , left:right, 2) = borderColor(2);
            img(top:bottom , left:right, 3) = borderColor(3);
        else
            img(top:bottom , left:right, 1) = 255;
            img(top:bottom , left:right, 2) = 255;
            img(top:bottom , left:right, 3) = 255;
        end
        
        % Paint image
        im = imagesCell{count};
        img(top+borderWidth:bottom-borderWidth , left+borderWidth:right-borderWidth, :) = im;

        x = x+1;
        if(mod(x,nColumns) == 0)
            x = 0;
            y = y+1;
        end
        count = count+1;
    end
    
    % Repaint
    axes(handles.imagesAxes);
    imshow(img);
    
    % Sets the "listeners" for when you click on the imagesAxes
    c = get(handles.imagesAxes, 'children');
    set(c,'ButtonDownFcn',@clickedImages);

    
function clickedImages(src,varargin)
    handles = guidata(src);
    
    pt = get(handles.imagesAxes,'CurrentPoint');
    x = pt(1,1);
    y = pt(1,2);

    repaint([x y]);
    
function repaint(posImage)
    global indices;
    global toDeleteGlob;
    global nRows;
    global nColumns;
    global borderWidth;
    global heightImage;
    global widthImage;
    global borderColor;
    global handlesGlob;
    global pathImages;
    global imagesList;
    
    x = ceil(posImage(1)/ (widthImage + borderWidth*2) );
    y = ceil(posImage(2)/ (heightImage + borderWidth*2) );
    
    % Get selected position
    n = x+(y-1)*nColumns;
    toDeleteGlob(n) = mod(toDeleteGlob(n)+1, 2);
%     toDelete = toDeleteGlob(n);

    paint(imagesList, handlesGlob, pathImages, toDeleteGlob);

%     ind = indices(n);
%     
%     % Get images
% %     img = get(handlesGlob.imagesAxes
%     im = imread([path '/' images(ind).name]);
%         
%     % Get limits
%     top = y*(heightImage+borderWidth*2)+1;
%     bottom = (y+1)*(heightImage+borderWidth*2);
%     left = x*(widthImage+borderWidth*2)+1;
%     right = (x+1)*(widthImage+borderWidth*2);
% 
%     % Paint border
%     if(toDelete)
%         img(top:bottom , left:right, 1) = borderColor(1);
%         img(top:bottom , left:right, 2) = borderColor(2);
%         img(top:bottom , left:right, 3) = borderColor(3);
%     else
%         img(top:bottom , left:right, 1) = 255;
%         img(top:bottom , left:right, 2) = 255;
%         img(top:bottom , left:right, 3) = 255;
%     end
% 
%     % Paint image
%     im = imresize(im, [heightImage widthImage]);
%     img(top+borderWidth:bottom-borderWidth , left+borderWidth:right-borderWidth, :) = im;
% 
%     axes(handles.imagesAxes);
%     imshow(img);
    



function thresBlur_Callback(hObject, eventdata, handles)
% hObject    handle to thresBlur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresBlur as text
%        str2double(get(hObject,'String')) returns contents of thresBlur as a double


% --- Executes during object creation, after setting all properties.
function thresBlur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresBlur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thresDark_Callback(hObject, eventdata, handles)
% hObject    handle to thresDark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresDark as text
%        str2double(get(hObject,'String')) returns contents of thresDark as a double


% --- Executes during object creation, after setting all properties.
function thresDark_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresDark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
