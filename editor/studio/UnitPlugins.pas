unit UnitPlugins;

interface

uses SysUtils, Classes, Windows, Messages, Forms, ComCtrls;

type TCodeSnippetClick = function (pTitle, pCategory: PChar; pCode: PChar): Integer; cdecl;
     TFileAction = function (pFilename: PChar): Integer; cdecl;
     TDocChange = function (pIndex: Integer; pFilename: PChar; pHighlighter: PChar; pRestoreCaret: Boolean): Integer; cdecl;
     TProjectsChange = function (pOldIndex, pNewIndex: Integer): Integer; cdecl;
     TCreateNewFile = function (Item: Byte): Integer; cdecl;
     TDisplaySearch = function (pSearchList: PChar; pSelected: PChar): Integer; cdecl;
     TSearch = function (pExpression, pSearchList: PChar; pCaseSensivity, pWholeWords, pSearchFromCaret, pSelectedOnly, pRegEx, pForward: Boolean): Integer; cdecl;
     TSearchReplace = function (pExpression, pReplace, pExpList, pRepList: PChar; pCaseSensivity, pWholeWords, pSearchFromCaret, pSelectedOnly, pRegEx, pForward: Boolean): Integer; cdecl;
     TVisibleControlChange = function (pControl: Integer; pShow: Boolean): Integer; cdecl;
     TCompile = function (pCompileType: Integer; Lang, Filename: PChar): Integer; cdecl;
     TShowHelp = function (pHelpType: Integer): Integer; cdecl;
     TCustomItemClick = function (pCaption: PChar): Integer; cdecl;
     TThemeChanged = function (pTheme: PChar): Integer; cdecl;

     TModified = function (pModifiedText: PChar): Integer; cdecl;
     TKeyPress = function (pKey: PChar): Integer; cdecl;
     TEditorClick = function: Integer; cdecl;
     TUpdateSel = function (pSelStart, pSelLength, pFirstVisibleLine: Integer): Integer; cdecl;
     TCallTipShow = function (pList: PChar): Integer; cdecl;
     TCallTipClick = function (pPosition: Integer): Integer; cdecl;
     TAutoCompleteShow = function (pList: PChar): Integer; cdecl;
     TAutoCompleteSelect = function (pText: PChar): Integer; cdecl;

     TAppMsg = function (pHwnd: HWND; pMessage: Integer; pWParam, pLParam: Integer; pTime: Integer; pPt: TPoint): Integer; cdecl;
     TUpdateCodeTools = function (pLang, pFilename, pCurrProjects: PChar): Integer; cdecl;
     TOutputEvent = function (pItemIndex: Integer): Integer; cdecl;
     TShortcutEvent = function (pCharCode, pKeyData: Integer): Integer; cdecl;

type TIntegerArray = array of Integer;

type TLoadInfo = record
  { Plugin values }
  sPluginName: PChar;
  sPluginDescription: PChar;
  { Form Handles }
  hAllFilesForm: PHandle;
  hAutoIndent: PHandle;
  hClose: PHandle;
  hConnGen: PHandle;
  hGoToLine: PHandle;
  hHTMLPreview: PHandle;
  hHudMsgGenerator: PHandle;
  hInfo: PHandle;
  hIRCPaster: PHandle;
  hMainForm: PHandle;
  hMenuGenerator: PHandle;
  hMOTDGen: PHandle;
  hPluginsIniEditor: PHandle;
  hReplace: PHandle;
  hSearch: PHandle;
  hSelectColor: PHandle;
  hSettings: PHandle;
  hSocketsTerminal: PHandle;
  hParamEdit: PHandle;
  { Important Control Handles }
  hOutput: PHandle;
  hCodeExplorer: PHandle;
  hCodeInspector: PHandle; // even if it won't be useful
  hNotes: PHandle;
  { Other }
  pApplication: Pointer; // this is only useful for Delphi developers
end;

type PLoadInfo = ^TLoadInfo;
     TLoadPlugin = procedure (LoadInfo: PLoadInfo); cdecl;
     TUnloadPlugin = procedure; cdecl;

function SendStudioMsg(eMessage: Integer; eData: String; eIntData: Integer): Integer;

function LoadPlugin(ListItem: TListItem): Boolean;
procedure UnloadPlugin(ListItem: TListItem);

function Plugin_CodeSnippetClick(Title, Category: String; Code: String): Boolean;
function Plugin_FileLoad(Filename: String; Loading: Boolean): Boolean;
function Plugin_FileSave(Filename: String; Saving: Boolean): Boolean;
function Plugin_DocChange(Index: Integer; Filename, Highlighter: String; RestoreCaret, Changing: Boolean): Boolean;
function Plugin_ProjectsChange(OldIndex, NewIndex: Integer; Changing: Boolean): Boolean;
function Plugin_CreateNewFile(Item: Byte; Creating: Boolean): Boolean;
function Plugin_Search(SearchList, Selected: String; Displaying, SearchAgain: Boolean; CaseSensivity, WholeWords, SearchFromCaret, SelectedOnly, RegEx, Forward: Boolean): Boolean;
function Plugin_SearchReplace(Expression, Replace, ExpList, RepList: String; CaseSensivity, WholeWords, SearchFromCaret, SelectedOnly, RegEx, Forward: Boolean): Boolean;
function Plugin_VisibleControlChange(Control: Integer; Show: Boolean): Boolean;
function Plugin_Compile(CompileType: Integer; Lang, Filename: String; Compiling: Boolean): Boolean;
function Plugin_ShowHelp(HelpType: Integer): Boolean;
function Plugin_CustomItemClick(Caption: String): Boolean;
function Plugin_ThemeChange(Theme: String): Boolean;

function Plugin_Modified(ModifiedStr: PAnsiChar): Boolean;
function Plugin_KeyPress(Key: Char): Boolean;
function Plugin_EditorClick(DoubleClick: Boolean): Boolean;
function Plugin_UpdateSel(SelStart, SelLength, FirstVisibleLine: Integer): Boolean;
function Plugin_CallTipShow(List: PChar): Boolean;
function Plugin_CallTipClick(Position: Integer): Boolean;
function Plugin_AutoCompleteShow(List: PChar): Boolean;
function Plugin_AutoCompleteSelect(Text: PChar): Boolean;

function Plugin_AppMsg(hwnd: HWND; Message: Integer; wParam, lParam: Integer; time: Integer; pt: TPoint): Boolean;
function Plugin_UpdateCodeExplorer(Lang, Filename, CurrProjects: String; Updating: Boolean): Boolean;
function Plugin_UpdateCodeInspector(Lang, Filename, CurrProjects: String; Updating: Boolean): Boolean;
function Plugin_OutputDblClick(ItemIndex: Integer): Boolean;
function Plugin_OutputPopup(ItemIndex: Integer): Boolean;
function Plugin_Shortcut(CharCode, KeyData: Integer): Boolean;

const { Return values for dlls }
      PLUGIN_CONTINUE = 0; // continue...
      PLUGIN_STOP = 1; // stop calling funcs and don't handle the command
      PLUGIN_HANDLED = 2; // don't handle the command
      { Compile values }
      COMP_DEFAULT = 0;
      COMP_STARTHL = 1;
      COMP_UPLOAD = 2;
      { Help values }
      HELP_DEFAULT = 0;
      HELP_SEARCH = 1;
      HELP_FORUMS = 2;
      HELP_ABOUT = 3;
      { Controls for visible state }
      CTRL_OUTPUT = 0; // Output list
      CTRL_CODETOOLS_MAIN = 1; // Code-Tools window
      CTRL_CODETOOLS_ITEM = 2; // Code-Tools tab
      CTRL_NOTES = 3; // Notes tab
      { Languages }
      NEW_PAWN_PLUGIN = 0;
      NEW_PAWN_EMPTYPLUGIN = 1;
      NEW_PAWN_HEADER = 2;
      NEW_CPP_MODULE = 3;
      NEW_CPP_UNIT = 4;
      NEW_CPP_HEADER = 5;
      NEW_OTHER_TEXTFILE = 6;
      NEW_OTHER_HTML = 7;
      NEW_OTHER_SQL = 8;
      NEW_OTHER_XML = 9;

const SCM_SHOWPROGRESS = WM_USER + $100;
      SCM_HIDEPROGRESS = WM_USER + $101;
      SCM_UPDATEPROGRESS = WM_USER + $102;
      SCM_LOADCODESNIPPETS = WM_USER + $103;
      SCM_CODESNIPPETCLICK = WM_USER + $104;
      SCM_MIRC_CMD = 	WM_USER + $105;
      SCM_RELOADINI = WM_USER + $106;
      SCM_SELECTLANGUAGE = WM_USER + $107;
      SCM_LOADFILE = WM_USER + $108;
      SCM_CURRPROJECTS = WM_USER + $109;
      SCM_COMPILE = WM_USER + $110;
      SCM_COMPILE_UPLOAD = WM_USER + $111;
      SCM_COMPILE_STARTHL = WM_USER + $112;
      SCM_MENU_LOADIMAGE = WM_USER + $113;
      SCM_MENU_ADDITEM = WM_USER + $114;
      SCM_MENU_ADDSUBITEM = WM_USER + $115;
      SCM_MENU_FAKECLICK = WM_USER + $116;
      SCM_MENU_SHOWITEM = WM_USER + $117;
      SCM_MENU_HIDEITEM = WM_USER + $118;
      SCM_PLUGIN_LOAD = 	WM_USER + $119;
      SCM_PLUGIN_UNLOAD = WM_USER + $120;
      SCM_SETTINGS_CREATEPAGE = WM_USER + $121;
      SCM_SETTINGS_REMOVEPAGE = WM_USER + $194;
      SCM_CODEINSPECTOR_CLEAR = WM_USER + $122;
      SCM_CODEINSPECTOR_ADD = WM_USER + $123;
      SCM_CODEINSPECTOR_ADDCOMBO = WM_USER + $124;
      SCM_CODEINSPECTOR_SETVALUE = WM_USER + $125;
      SCM_CODEINSPECTOR_SETNAME = WM_USER + $126;
      SCM_CODEINSPECTOR_GETVALUE = WM_USER + $127;
      SCM_CODEINSPECTOR_GETNAME = WM_USER + $128;
      SCM_CODEINSPECTOR_COUNT = WM_USER + $129;
      SCM_CODEINSPECTOR_BEGINUPDATE	= WM_USER + $130;
      SCM_CODEINSPECTOR_ENDUPDATE = WM_USER + $131;
      SCM_CODEINSPECTOR_DELETE = WM_USER + $132;

      SCM_PAWN_NEWFILE = WM_USER + $133;
      SCM_PAWN_SAVEFILE = WM_USER + $134;
      SCM_PAWN_CLOSEFILE = WM_USER + $135;
      SCM_PAWN_ISUNTITLED = WM_USER + $136;
      SCM_PAWN_ACTIVATE = WM_USER + $137;
      SCM_PAWN_ACTIVATEDOC = WM_USER + $138;
      SCM_PAWN_GETNOTES = WM_USER + $139;
      SCM_PAWN_SETNOTES = WM_USER + $140;
      SCM_PAWN_GETFILENAME = WM_USER + $141;
      SCM_PAWN_FILECOUNT = WM_USER + $195;
      SCM_PAWN_SETFILENAME = WM_USER + $142;
      SCM_PAWN_GETTEXT = WM_USER + $143;
      SCM_PAWN_SETTEXT = WM_USER + $144;

      SCM_CPP_NEWFILE = WM_USER + $145;
      SCM_CPP_SAVEFILE = WM_USER + $146;
      SCM_CPP_CLOSEFILE = WM_USER + $147;
      SCM_CPP_ISUNTITLED = WM_USER + $148;
      SCM_CPP_ACTIVATE = WM_USER + $149;
      SCM_CPP_ACTIVATEDOC = WM_USER + $150;
      SCM_CPP_ACTIVATEIDE = WM_USER + $151;
      SCM_CPP_GETNOTES = WM_USER + $152;
      SCM_CPP_SETNOTES = WM_USER + $153;
      SCM_CPP_GETFILENAME = WM_USER + $154;
      SCM_CPP_FILECOUNT = WM_USER + $196;
      SCM_CPP_SETFILENAME = WM_USER + $155;
      SCM_CPP_GETTEXT = 	WM_USER + $156;
      SCM_CPP_SETTEXT = 	WM_USER + $157;

      SCM_OTHER_NEWFILE = WM_USER + $158;
      SCM_OTHER_SAVEFILE = WM_USER + $159;
      SCM_OTHER_CLOSEFILE = WM_USER + $160;
      SCM_OTHER_ISUNTITLED = WM_USER + $161;
      SCM_OTHER_ACTIVATE = WM_USER + $162;
      SCM_OTHER_ACTIVATEDOC = WM_USER + $163;
      SCM_OTHER_GETNOTES = WM_USER + $164;
      SCM_OTHER_SETNOTES = WM_USER + $165;
      SCM_OTHER_GETFILENAME = WM_USER + $166;
      SCM_OTHER_FILECOUNT = WM_USER + $197;
      SCM_OTHER_SETFILENAME = WM_USER + $167;
      SCM_OTHER_GETTEXT = WM_USER + $168;
      SCM_OTHER_SETTEXT = WM_USER + $169;

      SCM_OUTPUT_SHOW = WM_USER + $170;
      SCM_OUTPUT_HIDE = WM_USER + $171;
      SCM_OUTPUT_ADD = 	WM_USER + $172;
      SCM_OUTPUT_CLEAR = WM_USER + $173;
      SCM_OUTPUT_DELETE = WM_USER + $174;
      SCM_OUTPUT_GETTEXT = WM_USER + $175;
      SCM_OUTPUT_GETITEM = WM_USER + $176;
      SCM_OUTPUT_INDEXOF = WM_USER + $177;
      SCM_ACTIVE_DOCUMENT = WM_USER + $178;
      SCM_ACTIVE_PROJECTS = WM_USER + $179;
      SCM_EDITOR_SETTEXT = WM_USER + $180;
      SCM_EDITOR_GETTEXT = WM_USER + $181;
      SCM_EDTIOR_SETCALLTIPS = WM_USER + $182;
      SCM_EDITOR_SHOWCALLTIP = WM_USER + $183;
      SCM_EDITOR_SETAUTOCOMPLETE = WM_USER + $184;
      SCM_EDITOR_SHOWAUTOCOMPLETE = WM_USER + $185;
      SCM_EDITOR_GETSELSTART = WM_USER + $186;
      SCM_EDITOR_GETSELLENGTH = WM_USER + $187;
      SCM_EDITOR_SETSELSTART = WM_USER + $188;
      SCM_EDITOR_SETSELLENGH = WM_USER + $189;

      SCM_REMOVE_MENUITEM = WM_USER + $190;
      SCM_REMOVE_IMAGE = WM_USER + $191;
      SCM_SETTHEME = WM_USER + $192;
      SCM_GETTHEME = WM_USER + $193;

implementation

uses UnitfrmSettings, UnitMainTools, UnitfrmAllFilesForm,
  UnitfrmAutoIndent, UnitfrmClose, UnitfrmConnGen, UnitfrmGoToLine,
  UnitfrmHTMLPreview, UnitfrmHudMsgGenerator, UnitfrmInfo, UnitfrmMain,
  UnitfrmMenuGenerator, UnitfrmMOTDGen, UnitfrmPluginsIniEditor,
  UnitfrmReplace, UnitfrmSearch, UnitfrmSelectColor,
  UnitfrmSocketsTerminal, UnitLanguages,UnitCodeExplorerUpdater,
  UnitCodeInspector, UnitCodeSnippets, UnitCodeUtils, UnitCompile,
  UnitfrmIRCPaster, UnitMenuGenerators, UnitReadThread, UnitTextAnalyze,
  UnitfrmParamEdit;

function LoadPlugin(ListItem: TListItem): Boolean;
var eLoadInfo: TLoadInfo;
    LoadInfo: PLoadInfo;
    eHandle: Cardinal;
    eFunc, eFunc2: TLoadPlugin;
begin
  Result := False;

  with eLoadInfo do begin
    sPluginName := 'Untitled';
    sPluginDescription := 'No description';
    { Handles }
    hAllFilesForm := PHandle(frmAllFilesForm.Handle);
    hAutoIndent := PHandle(frmAutoIndent.Handle);
    hClose := PHandle(frmClose.Handle);
    hConnGen := PHandle(frmConnGen.Handle);
    hGoToLine := PHandle(frmGoToLine.Handle);
    if Assigned(frmHTMLPreview) then
      hHTMLPreview := PHandle(frmHTMLPreview.Handle)
    else
      hHTMLPreview := PHandle(0);
    hHudMsgGenerator := PHandle(frmHudMsgGenerator.Handle);
    hInfo := PHandle(frmInfo.Handle);
    hIRCPaster := PHandle(frmIRCPaster.Handle);
    hMainForm := PHandle(frmMain.Handle);
    hMenuGenerator := PHandle(frmMenuGenerator.Handle);
    hMOTDGen := PHandle(frmMOTDGen.Handle);
    hPluginsIniEditor := PHandle(frmPluginsIniEditor.Handle);
    hReplace := PHandle(frmReplace.Handle);
    hSearch := PHandle(frmSearch.Handle);
    hSelectColor := PHandle(frmSelectColor.Handle);
    hSettings := PHandle(frmSettings.Handle);
    hSocketsTerminal := PHandle(frmSocketsTerminal.Handle);
    hParamEdit := PHandle(frmParamEdit.Handle);
    { Important Control Handles }
    hOutput := PHandle(frmMain.lstOutput.Handle);
    hCodeExplorer := PHandle(frmMain.trvExplorer.Handle);
    hCodeInspector := PHandle(frmMain.jviCode.Handle); // even if it won't be useful
    hNotes := PHandle(frmMain.rtfNotes.Handle);
    { Other }
    pApplication := @Application; // this is only useful for Delphi developers
  end;

  eHandle := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + 'plugins\' + ListItem.SubItems[0]));
  if eHandle = 0 then exit;
  @eFunc := GetProcAddress(eHandle, 'PluginLoad');
  @eFunc2 := GetProcAddress(eHandle, 'PluginUnload');
  
  if @eFunc2 <> nil then begin
    if @eFunc <> nil then begin
      try
        LoadInfo := @eLoadInfo;
        eFunc(LoadInfo);
        ListItem.Data := Pointer(eHandle);
        ListItem.Caption := eLoadInfo.sPluginName;
        ListItem.SubItems[1] := eLoadInfo.sPluginDescription;
        ListItem.SubItems[2] := 'Loaded';
      except
        on E: Exception do
          Application.MessageBox(PChar(E.Message), PChar(Application.Title), MB_ICONERROR);
      end;
    end
    else
      MessageBox(Application.Handle, PChar('Error loading plugin:' + #13 + 'PluginLoad function not found.'), PChar(ExtractFileName(ExtractFilePath(ParamStr(0)) + 'plugins\' + ListItem.SubItems[0])), MB_ICONERROR);
  end
  else
    MessageBox(Application.Handle, PChar('Error loading plugin:' + #13 + 'PluginUnload function not found.'), PChar(ExtractFileName(ExtractFilePath(ParamStr(0)) + 'plugins\' + ListItem.SubItems[0])), MB_ICONERROR);
end;

procedure UnloadPlugin(ListItem: TListItem);
var eFunc: TUnloadPlugin;
begin
  @eFunc := GetProcAddress(Cardinal(ListItem.Data), 'PluginUnload');
  if @eFunc <> nil then
    eFunc;
  FreeLibrary(Cardinal(ListItem.Data));
  
  ListItem.Data := nil;
  ListItem.Caption := '-';
  ListItem.SubItems[1] := '-';
  ListItem.SubItems[2] := 'Unloaded';
end;

function SendStudioMsg(eMessage: Integer; eData: String; eIntData: Integer): Integer;
var eStudioHandle: HWND;
    eCopyDataStruct: TCopyDataStruct;
begin
  with eCopyDataStruct do begin
    dwData := eIntData;  
    cbData := Length(eData) + 1;
    lpData := PChar(eData);  
  end;  

  eStudioHandle := FindWindow('TfrmMain', 'AMXX-Studio');
  if eStudioHandle <> 0 then
    Result := SendMessage(eStudioHandle, WM_COPYDATA, eMessage, LongInt(@eCopyDataStruct))
  else
    Result := 0;
end;


function GetDLLHandles: TIntegerArray;
var i, eCount: integer;
begin
  SetLength(Result, 0);
  eCount := 0;

  if not Started then exit;

  for i := 0 to frmSettings.lvPlugins.Items.Count -1 do begin
    if frmSettings.lvPlugins.Items[i].Data <> nil then begin
      SetLength(Result, eCount +1);
      Result[eCount] := Cardinal(frmSettings.lvPlugins.Items[i].Data);
      Inc(eCount, 1);
    end;
  end;
end;

function Plugin_CodeSnippetClick(Title, Category: String; Code: String): Boolean;
var Func: TCodeSnippetClick;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    @Func := GetProcAddress(Handles[i], 'CodeSnippetClick');

    if @Func <> nil then begin
      case Func(PChar(Title), PChar(Category), PChar(Code)) of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_FileLoad(Filename: String; Loading: Boolean): Boolean;
var Func: TFileAction;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    if Loading then
      @Func := GetProcAddress(Handles[i], 'Loading')
    else
      @Func := GetProcAddress(Handles[i], 'Loaded');

    if @Func <> nil then begin
      case Func(PChar(Filename)) of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_FileSave(Filename: String; Saving: Boolean): Boolean;
var Func: TFileAction;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    if Saving then
      @Func := GetProcAddress(Handles[i], 'Saving')
    else
      @Func := GetProcAddress(Handles[i], 'Saved');

    if @Func <> nil then begin
      case Func(PChar(Filename)) of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_DocChange(Index: Integer; Filename, Highlighter: String; RestoreCaret, Changing: Boolean): Boolean;
var Func: TDocChange;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    if Changing then
      @Func := GetProcAddress(Handles[i], 'DocChanging')
    else
      @Func := GetProcAddress(Handles[i], 'DocChanged');

    if @Func <> nil then begin
      case Func(Index, PChar(Filename), PChar(Highlighter), RestoreCaret) of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_ProjectsChange(OldIndex, NewIndex: Integer; Changing: Boolean): Boolean;
var Func: TProjectsChange;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    if Changing then
      @Func := GetProcAddress(Handles[i], 'ProjectsChanging')
    else
      @Func := GetProcAddress(Handles[i], 'ProjectsChanged');

    if @Func <> nil then begin
      case Func(OldIndex, NewIndex) of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_CreateNewFile(Item: Byte; Creating: Boolean): Boolean;
var Func: TCreateNewFile;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    if Creating then
      @Func := GetProcAddress(Handles[i], 'CreatingNewFile')
    else
      @Func := GetProcAddress(Handles[i], 'CreatedNewFile');

    if @Func <> nil then begin
      case Func(Item) of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_Search(SearchList, Selected: String; Displaying, SearchAgain: Boolean; CaseSensivity, WholeWords, SearchFromCaret, SelectedOnly, RegEx, Forward: Boolean): Boolean;
var Func: TSearch;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    if Displaying then
      @Func := GetProcAddress(Handles[i], 'DisplayingSearch')
    else if SearchAgain then
      @Func := GetProcAddress(Handles[i], 'SearchAgain')
    else
      @Func := GetProcAddress(Handles[i], 'Search');

    if @Func <> nil then begin
      case Func(PChar(Selected), PChar(SearchList), CaseSensivity, WholeWords, SearchFromCaret, SelectedOnly, RegEx, Forward) of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_SearchReplace(Expression, Replace, ExpList, RepList: String; CaseSensivity, WholeWords, SearchFromCaret, SelectedOnly, RegEx, Forward: Boolean): Boolean;
var Func: TSearchReplace;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    @Func := GetProcAddress(Handles[i], 'SearchReplace');

    if @Func <> nil then begin
      case Func(PChar(Expression), PChar(Replace), PChar(ExpList), PChar(RepList), CaseSensivity, WholeWords, SearchFromCaret, SelectedOnly, RegEx, Forward)  of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_VisibleControlChange(Control: Integer; Show: Boolean): Boolean;
var Func: TVisibleControlChange;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    @Func := GetProcAddress(Handles[i], 'VisibleControlChange');

    if @Func <> nil then begin
      case Func(Control, Show)  of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_Compile(CompileType: Integer; Lang, Filename: String; Compiling: Boolean): Boolean;
var Func: TCompile;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    if Compiling then
      @Func := GetProcAddress(Handles[i], 'Compiling')
    else
      @Func := GetProcAddress(Handles[i], 'Compile');

    if @Func <> nil then begin
      case Func(CompileType, PChar(Lang), PChar(Filename))  of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_ShowHelp(HelpType: Integer): Boolean;
var Func: TShowHelp;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    @Func := GetProcAddress(Handles[i], 'ShowHelp');

    if @Func <> nil then begin
      case Func(HelpType)  of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_CustomItemClick(Caption: String): Boolean;
var Func: TCustomItemClick;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    @Func := GetProcAddress(Handles[i], 'CustomItemClick');

    if @Func <> nil then begin
      case Func(PChar(Caption))  of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_ThemeChange(Theme: String): Boolean;
var Func: TThemeChanged;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    @Func := GetProcAddress(Handles[i], 'ThemeChanged');

    if @Func <> nil then begin
      case Func(PChar(Theme))  of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_Modified(ModifiedStr: PAnsiChar): Boolean;
var Func: TModified;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    @Func := GetProcAddress(Handles[i], 'Modified');

    if @Func <> nil then begin
      case Func(ModifiedStr)  of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_KeyPress(Key: Char): Boolean;
var Func: TKeyPress;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    @Func := GetProcAddress(Handles[i], 'KeyPress');

    if @Func <> nil then begin
      case Func(PChar(String(Key)))  of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_EditorClick(DoubleClick: Boolean): Boolean;
var Func: TEditorClick;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    if DoubleClick then
      @Func := GetProcAddress(Handles[i], 'DoubleClick')
    else
      @Func := GetProcAddress(Handles[i], 'Click');

    if @Func <> nil then begin
      case Func of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_UpdateSel(SelStart, SelLength, FirstVisibleLine: Integer): Boolean;
var Func: TUpdateSel;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    @Func := GetProcAddress(Handles[i], 'UpdateSel');

    if @Func <> nil then begin
      case Func(SelStart, SelLength, FirstVisibleLine)  of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_CallTipShow(List: PChar): Boolean;
var Func: TCallTipShow;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    @Func := GetProcAddress(Handles[i], 'CallTipShow');

    if @Func <> nil then begin
      case Func(List)  of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_CallTipClick(Position: Integer): Boolean;
var Func: TCallTipClick;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    @Func := GetProcAddress(Handles[i], 'CallTipClick');

    if @Func <> nil then begin
      case Func(Position)  of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_AutoCompleteShow(List: PChar): Boolean;
var Func: TAutoCompleteShow;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    @Func := GetProcAddress(Handles[i], 'AutoCompleteShow');

    if @Func <> nil then begin
      case Func(List)  of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_AutoCompleteSelect(Text: PChar): Boolean;
var Func: TAutoCompleteSelect;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    @Func := GetProcAddress(Handles[i], 'AutoCompleteSelect');

    if @Func <> nil then begin
      case Func(Text)  of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_AppMsg(hwnd: HWND; Message: Integer; wParam, lParam: Integer; time: Integer; pt: TPoint): Boolean;
var Func: TAppMsg;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    @Func := GetProcAddress(Handles[i], 'AppMessage');

    if @Func <> nil then begin
      case Func(hwnd, Message, wParam, lParam, time, pt)  of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_UpdateCodeExplorer(Lang, Filename, CurrProjects: String; Updating: Boolean): Boolean;
var Func: TUpdateCodeTools;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    if Updating then
      @Func := GetProcAddress(Handles[i], 'UpdatingCodeExplorer')
    else
      @Func := GetProcAddress(Handles[i], 'UpdatedCodeExplorer');

    if @Func <> nil then begin
      case Func(PChar(Lang), PChar(Filename), PChar(CurrProjects))  of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_UpdateCodeInspector(Lang, Filename, CurrProjects: String; Updating: Boolean): Boolean;
var Func: TUpdateCodeTools;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    if Updating then
      @Func := GetProcAddress(Handles[i], 'UpdatingCodeInspector')
    else
      @Func := GetProcAddress(Handles[i], 'UpdatedCodeInspector');

    if @Func <> nil then begin
      case Func(PChar(Lang), PChar(Filename), PChar(CurrProjects))  of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_OutputDblClick(ItemIndex: Integer): Boolean;
var Func: TOutputEvent;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    @Func := GetProcAddress(Handles[i], 'OutputDoubleClick');

    if @Func <> nil then begin
      case Func(ItemIndex)  of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_OutputPopup(ItemIndex: Integer): Boolean;
var Func: TOutputEvent;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    @Func := GetProcAddress(Handles[i], 'OutputPopup');

    if @Func <> nil then begin
      case Func(ItemIndex)  of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

function Plugin_Shortcut(CharCode, KeyData: Integer): Boolean;
var Func: TShortcutEvent;
    i: integer;
    Handles: TIntegerArray;
begin
  Result := True;

  Handles := GetDLLHandles;
  for i := 0 to High(Handles) do begin
    @Func := GetProcAddress(Handles[i], 'Shortcut');

    if @Func <> nil then begin
      case Func(CharCode, KeyData)  of
        PLUGIN_HANDLED: Result := False;
        PLUGIN_STOP: begin
          Result := False;
          exit;
        end;
      end;
    end;
  end;
  SetLength(Handles, 0);
  Handles := nil;
end;

end.
