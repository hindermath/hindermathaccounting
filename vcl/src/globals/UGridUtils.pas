﻿unit UGridUtils;

interface

uses
    System.Classes
  , DBAdvGrid
  , Vcl.DBGrids
  , Vcl.Graphics
  ;

type
  TGridUtils = class
  public
    class procedure UseDefaultHeaderFont( ACollection: TCollection );
    class procedure UseDefaultFont( ACollection: TCollection );
    class procedure UseMonospaceFont( ACollection: TCollection ); overload;
    class procedure UseMonospaceFont( AColumn: TColumn ); overload;
    class procedure UseMonospaceFont( AColumn: TDBGridColumnItem ); overload;

  end;

implementation
uses
  UAppGlobals
  ;

{ TGridUtils }

class procedure TGridUtils.UseDefaultFont(ACollection: TCollection);
begin
 for var LColumn in ACollection do
  begin
    if LColumn is TDBGridColumnItem then
    begin
      var LGridColumn := LColumn as TDBGridColumnItem;
      LGridColumn.Font.Name := TAppGlobals.DefaultGridFontName;
      LGridColumn.Font.Size := TAppGlobals.DefaultGridFontSize;
    end;

    if LColumn is TColumn then
    begin
      var LGridColumn := LColumn as TColumn;
      LGridColumn.Font.Name := TAppGlobals.DefaultGridFontName;
      LGridColumn.Font.Size := TAppGlobals.DefaultGridFontSize;
    end;
  end;
end;

class procedure TGridUtils.UseDefaultHeaderFont(ACollection: TCollection);
begin
 for var LColumn in ACollection do
  begin
    if LColumn is TDBGridColumnItem then
    begin
      var LGridColumn := LColumn as TDBGridColumnItem;

      LGridColumn.HeaderFont.Name := TAppGlobals.DefaultGridHeaderFontName;
      LGridColumn.HeaderFont.Size := TAppGlobals.DefaultGridHeaderFontSize;
      LGridColumn.HeaderFont.Style := [fsBold];
    end;

    if LColumn is TColumn then
    begin
      var LGridColumn := LColumn as TColumn;
      LGridColumn.Title.Font.Name := TAppGlobals.DefaultGridHeaderFontName;
      LGridColumn.Title.Font.Size := TAppGlobals.DefaultGridHeaderFontSize;
      LGridColumn.Title.Font.Style := [fsBold];
    end;
  end;
end;

class procedure TGridUtils.UseMonospaceFont(AColumn: TDBGridColumnItem);
begin
   AColumn.Font.Name := TAppGlobals.DefaultGridMonospaceFontName;
   AColumn.Font.Size := TAppGlobals.DefaultGridFontSize;
end;

class procedure TGridUtils.UseMonospaceFont(AColumn: TColumn);
begin
  AColumn.Font.Name := TAppGlobals.DefaultGridMonospaceFontName;
  AColumn.Font.Size := TAppGlobals.DefaultGridFontSize;
end;

class procedure TGridUtils.UseMonospaceFont(ACollection: TCollection);
begin
  for var LColumn in ACollection do
  begin
    if LColumn is TDBGridColumnItem then
    begin
      var LGridColumn := LColumn as TDBGridColumnItem;
      UseMonospaceFont(LGridColumn);
    end;

    if LColumn is TColumn then
    begin
      var LGridColumn := LColumn as TColumn;
      UseMonospaceFont(LGridColumn);
    end;
  end;
end;


end.
