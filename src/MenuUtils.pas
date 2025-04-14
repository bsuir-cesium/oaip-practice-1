unit MenuUtils;

interface

uses
  CoreTypes, FileUtils, InputUtils, OutputUtils, ListUtils, MatchUtils;

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

procedure ShowViewSubmenu(VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode; CompaniesHead: PCompanyNode);
var
  Choice: Integer;
begin
  repeat
    ClearScreen;
    Writeln('1. �������� ��������');
    Writeln('2. �������� ����������');
    Writeln('3. �������� ��������');
    Writeln('0. �����');
    Write('��������: ');
    Readln(Choice);

    case Choice of
      1:
        begin
          ClearScreen;
          ShowAllVacancies(VacanciesHead, CompaniesHead);
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
        begin
          ClearScreen;
          ShowAllCompanies(CompaniesHead);
          Writeln('������� Enter ��� �����������...');
          Readln;
        end;
      0:
        Exit;
    else
      Writeln('�������� �����!');
      Readln;
    end;
  until False;
end;

procedure ShowAddRecordSubmenu(var VacanciesHead: PVacancyNode;
  var CandidatesHead: PCandidateNode; var CompaniesHead: PCompanyNode);
var
  Choice: Integer;
begin
  repeat
    ClearScreen;
    Writeln('1. �������� ��������');
    Writeln('2. �������� ���������');
    Writeln('3. �������� ��������');
    Writeln('0. �����');
    Write('��������: ');
    Readln(Choice);

    case Choice of
      1:
      begin
        AddNewVacancy(VacanciesHead, CompaniesHead);
        Writeln('������� Enter ��� �����������...');
        Readln;
      end;
      2:
      begin
        AddNewCandidate(CandidatesHead);
        Writeln('������� Enter ��� �����������...');
        Readln;
      end;
      3:
      begin
        AddNewCompany(CompaniesHead);
        Writeln('������� Enter ��� �����������...');
        Readln;
      end;
      0:
        Exit;
    else
      Writeln('�������� �����!');
      Readln;
    end;
  until False;
end;

procedure ShowDeleteSubmenu(var VacanciesHead: PVacancyNode;
  var CandidatesHead: PCandidateNode; var CompaniesHead: PCompanyNode);
var
  Choice, ID: Integer;
begin
  repeat
    ClearScreen;
    Writeln('1. ������� ��������');
    Writeln('2. ������� ���������');
    Writeln('3. ������� ��������');
    Writeln('0. �����');
    Write('��������: ');
    Readln(Choice);

    case Choice of
      1:
        begin
          Write('������� ID ��������: ');
          Readln(ID);
          if DeleteVacancy(VacanciesHead, ID) <> -1 then
            Writeln('�������� ', ID, ' �������!')
          else
            Writeln('�������� �� �������!');
          Writeln('������� Enter ��� �����������...');
          Readln;
        end;
      2:
        begin
          Write('������� ID ���������: ');
          Readln(ID);
          if DeleteVacancy(VacanciesHead, ID) <> -1 then
            Writeln('�������� ', ID, ' �����!')
          else
            Writeln('�������� �� ������!');
          Writeln('������� Enter ��� �����������...');
          Readln;
        end;
      3:
        begin
          Write('������� ID ��������: ');
          Readln(ID);
          if DeleteCompany(CompaniesHead, ID, VacanciesHead) <> -1 then
            Writeln('�������� ', ID, ' �������!')
          else
            Writeln('�������� �� �������!');
          Writeln('������� Enter ��� �����������...');
          Readln;
        end;
      0:
        Exit;
    end;
  until False;
end;

procedure ShowEditSubmenu(var VacanciesHead: PVacancyNode;
  var CandidatesHead: PCandidateNode; var CompaniesHead: PCompanyNode);
var
  Choice, ID: Integer;
begin
  repeat
    ClearScreen;
    Writeln('1. ������������� ��������');
    Writeln('2. ������������� ���������');
    Writeln('3. ������������� ��������');
    Writeln('0. �����');
    Write('��������: ');
    Readln(Choice);

    case Choice of
      1:
      begin
          Write('������� ID ��������: ');
          Readln(ID);
          EditVacancy(VacanciesHead, ID);
          Writeln('������� Enter ��� �����������...');
          Readln;
      end;
      2:
      begin
          Write('������� ID ���������: ');
          Readln(ID);
          EditCandidate(CandidatesHead, ID);
          Writeln('������� Enter ��� �����������...');
          Readln;
      end;
      3:
      begin
          Write('������� ID ��������: ');
          Readln(ID);
          EditCompany(CompaniesHead, ID);
          Writeln('������� Enter ��� �����������...');
          Readln;
      end;
      0:
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
  VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode;
  CompaniesHead: PCompanyNode;
begin
  VacanciesHead := nil;
  CandidatesHead := nil;
  CompaniesHead := nil;
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
        LoadAllData(VacanciesHead, CandidatesHead, CompaniesHead);
      2:
        ShowViewSubmenu(VacanciesHead, CandidatesHead, CompaniesHead);
      3 .. 4:
        Writeln('debug');
      5:
        ShowAddRecordSubmenu(VacanciesHead, CandidatesHead, CompaniesHead);
      6:
        ShowDeleteSubmenu(VacanciesHead, CandidatesHead, CompaniesHead);
      7:
        ShowEditSubmenu(VacanciesHead, CandidatesHead, CompaniesHead);
      8:
      begin
        FindAndSaveMatches(VacanciesHead, CandidatesHead, CompaniesHead);
        Writeln('������� Enter ��� �����������...');
        Readln;
      end;
      9 .. 10:
        begin
          if Choice = 10 then
            SaveAllData(VacanciesHead, CandidatesHead, CompaniesHead);

          ClearVacancies(VacanciesHead);
          ClearCandidates(CandidatesHead);
          ClearCompanies(CompaniesHead);

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
