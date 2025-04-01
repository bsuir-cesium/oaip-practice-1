unit MenuUtils;

interface

uses
  CoreTypes, FileUtils, InputUtils, OutputUtils;

procedure ShowMainMenu;
procedure ShowAddRecordMenu(var VacanciesHead: PVacancyNode;
  var CandidatesHead: PCandidateNode);

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

procedure ShowViewSubmenu(VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode);
var
  Choice: Integer;
begin
  repeat
    ClearScreen;
    Writeln('1. �������� ��������');
    Writeln('2. �������� ����������');
    Writeln('3. �����');
    Write('��������: ');
    Readln(Choice);

    case Choice of
      1:
        begin
          ClearScreen;
          ShowAllVacancies(VacanciesHead);
          Writeln('������� Enter ��� �����������...');
          Readln;
        end;
      2:
        begin
          ClearScreen;
          ShowAllCandidates(CandidatesHead);
          Writeln('������� Enter ��� �����������...');
          Readln;
        end;
      3:
        Exit;
    else
      Writeln('�������� �����!');
      Readln;
    end;
  until False;
end;

procedure ShowAddRecordMenu(var VacanciesHead: PVacancyNode;
  var CandidatesHead: PCandidateNode);
var
  Choice: Integer;
begin
  repeat
    ClearScreen;
    Writeln('1. �������� ��������');
    Writeln('2. �������� ���������');
    Writeln('3. �����');
    Write('��������: ');
    Readln(Choice);

    case Choice of
      1:
        AddNewVacancy(VacanciesHead);
      2:
        AddNewCandidate(CandidatesHead);
      3:
        Exit;
    else
      Writeln('�������� �����!');
      Readln;
    end;
  until False;
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
      2:
        ShowViewSubmenu(VacancyHead, CandidateHead);
      3 .. 4:
        Writeln('debug');
      5:
        ShowAddRecordMenu(VacancyHead, CandidateHead);
      6 .. 8:
        Writeln('debug');
      9 .. 10:
        begin
          if Choice = 10 then
            SaveAllData(VacancyHead, CandidateHead);

          ClearVacancies(VacancyHead);
          ClearCandidates(CandidateHead);

          Exit;
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
