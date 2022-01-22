unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls;

type
  TAnalizator = class(TForm)
    ProgramText_: TRichEdit;
    Table_: TStringGrid;
    DlgOpen_: TOpenDialog;
    Load_: TButton;
    StartWork_: TButton;
    Exit_: TButton;
    procedure Exit_Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Load_Click(Sender: TObject);
    procedure StartWork_Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Analizator: TAnalizator;

implementation

{$R *.dfm}

procedure TAnalizator.FormCreate(Sender: TObject);
begin
  Table_.Cells[0, 0] := 'Количество условных операторов: ';
  Table_.Cells[0, 1] := 'Общее количество операторов: ';
  Table_.Cells[0, 2] := 'Насыщенность программы условными операторами: ';
  Table_.Cells[0, 3] := 'Максимальный уровень вложенности условного оператора: ';
end;

procedure TAnalizator.Load_Click(Sender: TObject);
var
  i : integer;

begin
  if DlgOpen_.Execute(Handle) then
    begin
      ProgramText_.Lines.LoadFromFile(DlgOpen_.FileName);
      for i := 0 to Table_.RowCount - 1 do
        Table_.Cells[1, i] := '';
    end
  else
    exit;
end;

procedure Analyze(var TotalOperatorsCount, ConditionalOperatorsCount, MaxLevel : integer);
const
  N_MAX = 57;

type
  TArray = array [1..N_MAX] of string[20];

  TOperator = record
    CurrOperator : string;
    CurrCondition : integer;
  end;

  StekElement = ^TStek;

  TStek = record
    Elem : TOperator;
    Next : StekElement;
  end;

Procedure AddStek (var st : StekElement; value : TOperator);
var
  x : StekElement;

begin
  new(x);
  x^.Elem := value;
  x^.next := st;
  st := x;
end;

function GetStek(var st : StekElement) : TOperator;
begin
  if st <> nil then
    begin
      GetStek := st^.Elem;
      st := st^.next;
    end
end;

var
  i, j, k, temp, qFlag : integer;
  buf : string;
  F : TextFile;
  OperatorsArray : TArray;
  Operators : TOperator;
  st : StekElement;

begin
  Assign(F, 'Dictionary.txt');
  Reset(F);
  for i := 1 to N_MAX do
    ReadLn(F, OperatorsArray[i]);
  Close(F);

  TotalOperatorsCount := 0;
  ConditionalOperatorsCount := 0;

  for i := 0 to Analizator.ProgramText_.Lines.Count - 1 do
    begin
      buf := ' ' + Analizator.ProgramText_.Lines[i] + ' ';
      if (buf[2] + buf[3] + buf[4] = 'def') or (buf[2] = '#') then continue;

      for j := 2 to Length(buf) - 1 do
        for k := 1 to 16 do
          if OperatorsArray[k] = buf[j] then
            if OperatorsArray[k] = '?' then
              begin
                if (buf[j - 1] = ' ') and (buf[j + 1] = ' ') then
                  begin
                    inc(TotalOperatorsCount);
                    inc(ConditionalOperatorsCount);
                  end;
              end
            else if ((buf[j - 1] = ' ') and (buf[j + 1] = ' ')) or (buf[j] = '{') or (buf[j] = '[') then inc(TotalOperatorsCount);

      for j := 2 to Length(buf) - 2 do
        for k := 17 to 35 do
          if OperatorsArray[k] = buf[j] + buf[j + 1] then
            if OperatorsArray[k] = 'if' then
              begin
                if (buf[j - 1] = ' ') and (buf[j + 2] = ' ') then
                  begin
                    inc(TotalOperatorsCount);
                    inc(ConditionalOperatorsCount);
                  end;
              end
            else if ((buf[j - 1] = ' ') and (buf[j + 2] = ' ')) then inc(TotalOperatorsCount);

      for j := 2 to Length(buf) - 3 do
        for k := 36 to 42 do
          if OperatorsArray[k] = buf[j] + buf[j + 1] + buf[j + 2] then
            if OperatorsArray[k] = 'for' then
              begin
                if (buf[j - 1] = ' ') and (buf[j + 3] = ' ') then
                  begin
                    inc(TotalOperatorsCount);
                    inc(ConditionalOperatorsCount);
                  end;
              end
            else if (buf[j - 1] = ' ') and (buf[j + 3] = ' ') then inc(TotalOperatorsCount);

      for j := 2 to Length(buf) - 4 do
        for k := 43 to 47 do
          if OperatorsArray[k] = buf[j] + buf[j + 1] + buf[j + 2] + buf[j + 3] then
            if (OperatorsArray[k] = 'when') or (OperatorsArray[k] = 'loop') then
              begin
                if (buf[j - 1] = ' ') and (buf[j + 4] = ' ') then
                  begin
                    inc(TotalOperatorsCount);
                    inc(ConditionalOperatorsCount);
                  end;
              end
            else if (buf[j - 1] = ' ') and (buf[j + 4] = ' ') then inc(TotalOperatorsCount);

      for j := 2 to Length(buf) - 5 do
        for k := 48 to 54 do
          if OperatorsArray[k] = buf[j] + buf[j + 1] + buf[j + 2] + buf[j + 3] + buf[j + 4] then
            if (OperatorsArray[k] = 'elsif') or (OperatorsArray[k] = 'while') or (OperatorsArray[k] = 'until') then
              begin
                if (buf[j - 1] = ' ') and (buf[j + 5] = ' ') then
                  begin
                    inc(TotalOperatorsCount);
                    inc(ConditionalOperatorsCount);
                  end;
              end
            else if (buf[j - 1] = ' ') and (buf[j + 5] = ' ') then inc(TotalOperatorsCount);

      for j := 2 to Length(buf) - 6 do
        for k := 55 to 56 do
          if OperatorsArray[k] = buf[j] + buf[j + 1] + buf[j + 2] + buf[j + 3] + buf[j + 4] + buf[j + 5] then
             if (buf[j - 1] = ' ') and (buf[j + 6] = ' ') then inc(TotalOperatorsCount);

      for j := 2 to Length(buf) - 7 do
        if OperatorsArray[57] = buf[j] + buf[j + 1] + buf[j + 2] + buf[j + 3] + buf[j + 4] + buf[j + 5]
        + buf[j + 6] + buf[j + 7]  then
         if (buf[j - 1] = ' ') and (buf[j + 8] = ' ') then inc(TotalOperatorsCount);
    end;



  MaxLevel := -1;
  temp := -1;
  qFlag := 0;
  st := nil;

  for i := 0 to Analizator.ProgramText_.Lines.Count - 1 do
    begin
      buf := ' ' + Analizator.ProgramText_.Lines[i] + ' ';

      for j := 2 to Length(buf) - 1 do
        if buf[j] = '?' then
          if (buf[j - 1] = ' ') and (buf[j + 1] = ' ') then
            begin
              qFlag := temp;
              inc(temp);
            end;

      for j := 2 to Length(buf) - 2 do
        if buf[j] + buf[j + 1] = 'if' then
          if (buf[j - 1] = ' ') and (buf[j + 2] = ' ') then
            begin
              Operators.CurrOperator := 'if';
              Operators.CurrCondition := temp;
              AddStek(st, Operators);
              inc(temp);
            end;


      for j := 2 to Length(buf) - 3 do
        begin
          if buf[j] + buf[j + 1] + buf[j + 2] = 'def' then
            if (buf[j - 1] = ' ') and (buf[j + 3] = ' ') then
              begin
                Operators.CurrOperator := 'def';
                Operators.CurrCondition := temp;
                AddStek(st, Operators);
              end;
          if buf[j] + buf[j + 1] + buf[j + 2] = 'for' then
            if (buf[j - 1] = ' ') and (buf[j + 3] = ' ') then
              begin
                Operators.CurrOperator := 'for';
                Operators.CurrCondition := temp;
                AddStek(st, Operators);
                inc(temp);
              end;
          if buf[j] + buf[j + 1] + buf[j + 2] = 'end' then
            if (buf[j - 1] = ' ') and (buf[j + 3] = ' ') then
              begin
                Operators := GetStek(st);
                if (Operators.CurrOperator <> 'def') then
                  if temp > MaxLevel then
                    begin
                      MaxLevel := temp;
                      if Operators.CurrOperator = 'case' then temp := Operators.CurrCondition;
                    end;
                dec(temp);
              end;
        end;

      for j := 2 to Length(buf) - 4 do
      begin
        if buf[j] + buf[j + 1] + buf[j + 2] + buf[j + 3]  = 'when' then
          if (buf[j - 1] = ' ') and (buf[j + 4] = ' ') then inc(temp);

        if buf[j] + buf[j + 1] + buf[j + 2] + buf[j + 3]  = 'loop' then
          if (buf[j - 1] = ' ') and (buf[j + 4] = ' ') then
            begin
              Operators.CurrOperator := 'loop';
              Operators.CurrCondition := temp;
              AddStek(st, Operators);
              inc(temp);
            end;
        if buf[j] + buf[j + 1] + buf[j + 2] + buf[j + 3]  = 'case' then
          if (buf[j - 1] = ' ') and (buf[j + 4] = ' ') then
            begin
              Operators.CurrOperator := 'case';
              Operators.CurrCondition := temp;
              AddStek(st, Operators);
            end;
      end;


      for j := 2 to Length(buf) - 5 do
        begin
          if buf[j] + buf[j + 1] + buf[j + 2] + buf[j + 3] + buf[j + 4]  = 'while' then
            begin
              Operators.CurrOperator := 'while';
              Operators.CurrCondition := temp;
              AddStek(st, Operators);
              inc(temp);
            end;
          if buf[j] + buf[j + 1] + buf[j + 2] + buf[j + 3] + buf[j + 4]  = 'until' then
            begin
              Operators.CurrOperator := 'until';
              Operators.CurrCondition := temp;
              AddStek(st, Operators);
              inc(temp);
            end;
          if buf[j] + buf[j + 1] + buf[j + 2] + buf[j + 3] + buf[j + 4]  = 'elsif' then
            begin
              Operators.CurrOperator := 'elsif';
              Operators.CurrCondition := temp;
              AddStek(st, Operators);
              inc(temp);
            end;
        end;

      if qFlag <> 0 then
        begin
          if temp > MaxLevel then MaxLevel := temp;
          temp := qFlag;
          qFlag := 0;
        end;
    end;
end;

procedure TAnalizator.StartWork_Click(Sender: TObject);
var
  i : integer;
  TotalOperatorsCount : integer;
  ConditionalOperatorsCount : integer;
  MaxLevel : integer;

begin
  for i := 0 to Table_.RowCount - 1 do
        Table_.Cells[1, i] := '';
  if ProgramText_.Lines.Count = 0 then ShowMessage('Ошибка! Сначала загрузите анализируемый код...')
  else
    begin
      Analyze(TotalOperatorsCount, ConditionalOperatorsCount, MaxLevel);
      Table_.Cells[1, 0] := IntToStr(ConditionalOperatorsCount);
      Table_.Cells[1, 1] := IntToStr(TotalOperatorsCount);
      if (TotalOperatorsCount = 0) then Table_.Cells[1, 2] := '-'
        else Table_.Cells[1, 2] := FloatToStrF(ConditionalOperatorsCount / TotalOperatorsCount, ffFixed, 3, 2);
      if (MaxLevel = -1) then Table_.Cells[1, 3] := '-'
        else Table_.Cells[1, 3] := IntToStr(MaxLevel);
    end;
end;

procedure TAnalizator.Exit_Click(Sender: TObject);
begin
  Analizator.Close;
end;

end.
