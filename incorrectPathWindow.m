function varargout = incorrectPathWindow(varargin)
% INCORRECTPATHWINDOW MATLAB code for incorrectPathWindow.fig
%      INCORRECTPATHWINDOW, by itself, creates a new INCORRECTPATHWINDOW or raises the existing
%      singleton*.
%
%      H = INCORRECTPATHWINDOW returns the handle to a new INCORRECTPATHWINDOW or the handle to
%      the existing singleton*.
%
%      INCORRECTPATHWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INCORRECTPATHWINDOW.M with the given input arguments.
%
%      INCORRECTPATHWINDOW('Property','Value',...) creates a new INCORRECTPATHWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before incorrectPathWindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to incorrectPathWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help incorrectPathWindow

% Last Modified by GUIDE v2.5 16-Sep-2014 17:08:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @incorrectPathWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @incorrectPathWindow_OutputFcn, ...
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


% --- Executes just before incorrectPathWindow is made visible.
function incorrectPathWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to incorrectPathWindow (see VARARGIN)

% Choose default command line output for incorrectPathWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes incorrectPathWindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = incorrectPathWindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

