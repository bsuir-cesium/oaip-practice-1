unit MenuUtils;

interface

uses
  CoreTypes, FileUtils;

procedure ShowMainMenu;

implementation

uses
  SysUtils, Windows;

procedure ClearScreen;
var
  hConsole: THandle;
  cursorPos: TCoord;
begin
  hConsole := GetStdHandle(STD_OUTPUT_HANDLE);
  Write(#27'[2J'#27'[3J');
  cursorPos.X := 0;
  cursorPos.Y := 0;
  SetConsoleCursorPosition(hConsole, cursorPos);
end;

procedure ShowMainMenu;
var
  Choice: Integer;
  VacancyHead: PVacancyNode;
  CandidateHead: PCandidateNode;
begin
  VacancyHead := nil;
  CandidateHead := nil;
  repeat
    ClearScreen;
    Writeln(' 1. ������ ������ �� �����');
    Writeln(' 2. �������� ����� ������');
    Writeln(' 3. ���������� ������');
    Writeln(' 4. ����� ������ � �������������� ��������');
    Writeln(' 5. ���������� ������ � ������');
    Writeln(' 6. �������� ������ �� ������');
    Writeln(' 7. �������������� ������');
    Writeln(' 8. ������ ���������� ��� ���� (��)');
    Writeln(' 9. ����� �� ��������� ��� ���������� ���������');
    Writeln('10. ����� � ����������� ���������');
    Write('�������� ����� ����: ');
    Readln(Choice);

    case Choice of
      1:
        LoadAllData(VacancyHead, CandidateHead);
      2 .. 4:
        Writeln('debug');
      5:
        Writeln('debug');
//        ShowAddRecordMenu(VacancyHead, CandidateHead);
      6 .. 10:
        begin
          Writeln('����������');
          break;
        end
    else
      begin
        Writeln('�������� �����. ������� ����� ������� � ���������� �����.');
        Readln;
      end;
    end;
  until False;
end;

end.
