object Analizator: TAnalizator
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #1040#1085#1072#1083#1080#1079#1072#1090#1086#1088
  ClientHeight = 781
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Lucida Console'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 12
  object ProgramText_: TRichEdit
    Left = 10
    Top = 10
    Width = 500
    Height = 500
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Lucida Console'
    Font.Style = [fsBold]
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    WantTabs = True
    Zoom = 100
  end
  object Table_: TStringGrid
    Left = 10
    Top = 520
    Width = 500
    Height = 131
    ColCount = 2
    DefaultColWidth = 400
    DefaultRowHeight = 31
    DoubleBuffered = False
    FixedCols = 0
    RowCount = 4
    FixedRows = 0
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -10
    Font.Name = 'Lucida Console'
    Font.Style = [fsBold]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowMoving, goRowSelect]
    ParentDoubleBuffered = False
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Load_: TButton
    Left = 10
    Top = 661
    Width = 500
    Height = 50
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1086#1076' '#1080#1079' '#1092#1072#1081#1083#1072
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Lucida Console'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = Load_Click
  end
  object StartWork_: TButton
    Left = 10
    Top = 721
    Width = 247
    Height = 50
    Caption = #1040#1085#1072#1083#1080#1079
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Lucida Console'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = StartWork_Click
  end
  object Exit_: TButton
    Left = 263
    Top = 721
    Width = 247
    Height = 50
    Caption = ' '#1042#1099#1093#1086#1076' '
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Lucida Console'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = Exit_Click
  end
  object DlgOpen_: TOpenDialog
    Title = #1042#1099#1073#1077#1088#1080#1090#1077' '#1092#1072#1081#1083
    Left = 472
    Top = 16
  end
end
