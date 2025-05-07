unit MenuUtils;

interface

uses
  CoreTypes, FileUtils, InputUtils, OutputUtils, ListUtils, MatchUtils,
  Filters,
  SortUtils;

procedure ShowMainMenu;

implementation

uses
  SysUtils, Windows;

procedure Awaiting;
begin
  Writeln('������� Enter ��� �����������...');
  Readln;
end;

procedure ClearScreen;
var
  hStdOut: THandle;
  csbi: TConsoleScreenBufferInfo;
  dwConSize: DWORD;
  dwCharsWritten: DWORD;
  Origin: TCoord;
begin
  hStdOut := GetStdHandle(STD_OUTPUT_HANDLE);

  if not GetConsoleScreenBufferInfo(hStdOut, csbi) then
    Exit;

  dwConSize := csbi.dwSize.X * csbi.dwSize.Y;

  Origin.X := 0;
  Origin.Y := 0;
  FillConsoleOutputCharacter(hStdOut, ' ', dwConSize, Origin, dwCharsWritten);

  FillConsoleOutputAttribute(hStdOut, csbi.wAttributes, dwConSize, Origin,
    dwCharsWritten);

  SetConsoleCursorPosition(hStdOut, Origin);
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
    Choice := ReadInteger('��������: ');

    case Choice of
      1:
        begin
          ClearScreen;
          ShowAllVacancies(VacanciesHead, CompaniesHead);
          Awaiting;
        end;
      2:
        begin
          ClearScreen;
          ShowAllCandidates(CandidatesHead);
          Awaiting;
        end;
      3:
        begin
          ClearScreen;
          ShowAllCompanies(CompaniesHead);
          Awaiting;
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
    Choice := ReadInteger('��������: ');

    case Choice of
      1:
        begin
          AddNewVacancy(VacanciesHead, CompaniesHead);
          Awaiting;
        end;
      2:
        begin
          AddNewCandidate(CandidatesHead);
          Awaiting;
        end;
      3:
        begin
          AddNewCompany(CompaniesHead);
          Awaiting;
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
    Choice := ReadInteger('��������: ');

    case Choice of
      1:
        begin
          ID := ReadInteger('������� ID ��������: ');
          if DeleteVacancy(VacanciesHead, ID) <> -1 then
            Writeln('�������� ', ID, ' �������!')
          else
            Writeln('�������� �� �������!');
          Awaiting;
        end;
      2:
        begin
          ID := ReadInteger('������� ID ���������: ');
          if DeleteVacancy(VacanciesHead, ID) <> -1 then
            Writeln('�������� ', ID, ' �����!')
          else
            Writeln('�������� �� ������!');
          Awaiting;
        end;
      3:
        begin
          ID := ReadInteger('������� ID ��������: ');
          if DeleteCompany(CompaniesHead, ID, VacanciesHead) <> -1 then
            Writeln('�������� ', ID, ' �������!')
          else
            Writeln('�������� �� �������!');
          Awaiting;
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
    Choice := ReadInteger('��������: ');

    case Choice of
      1:
        begin
          ID := ReadInteger('������� ID ��������: ');
          EditVacancy(VacanciesHead, ID);
          Awaiting;
        end;
      2:
        begin
          ID := ReadInteger('������� ID ���������: ');
          EditCandidate(CandidatesHead, ID);
          Awaiting;
        end;
      3:
        begin
          ID := ReadInteger('������� ID ��������: ');
          EditCompany(CompaniesHead, ID);
          Awaiting;
        end;
      0:
        Exit;
    else
      Writeln('�������� �����!');
      Readln;
    end;
  until False;
end;

procedure ShowVacancyFilters(VacanciesHead: PVacancyNode;
  CompaniesHead: PCompanyNode; var FilteredVacancies: PVacancyNode);
var
  MinSalary: Double;
  RequiresEducation: Boolean;
  MinAge, MaxAge: Integer;
  Specialty: string;
begin
  MinSalary := ReadInteger('����������� �����: ');
  RequiresEducation :=
    ReadBoolean('��������� ������ ����������� (1-��/0-���): ');
  MaxAge := ReadInteger('������������ �������: ');
  MinAge := ReadInteger('����������� �������: ');
  Write('������������� (����� ��������): ');
  Readln(Specialty);

  FilterVacancies(VacanciesHead, MinSalary, RequiresEducation, MinAge, MaxAge,
    Specialty, FilteredVacancies);

  if FilteredVacancies = nil then
    Writeln('��� ���������� ��������')
  else
    ShowAllVacancies(FilteredVacancies, CompaniesHead);
  ClearVacancies(FilteredVacancies);
  Awaiting;
end;

procedure ShowCandidateFilters(CandidatesHead: PCandidateNode;
  CompaniesHead: PCompanyNode; var FilteredCandidates: PCandidateNode);
var
  MinSalary: Double;
  HasEducation: Boolean;
  MinAge, MaxAge: Integer;
  Specialty: string;
begin
  MinSalary := ReadInteger('����������� �������� �����: ');
  HasEducation := ReadBoolean('������� ������� ����������� (1-��/0-���): ');
  MaxAge := ReadInteger('������������ �������: ');
  MinAge := ReadInteger('����������� �������: ');
  Write('������������� (����� ��������): ');
  Readln(Specialty);

  Filters.FilterCandidates(CandidatesHead, MinSalary, HasEducation, MinAge,
    MaxAge, Specialty, FilteredCandidates);

  if FilteredCandidates = nil then
    Writeln('��� ���������� ����������')
  else
    ShowAllCandidates(FilteredCandidates);
  ClearCandidates(FilteredCandidates);
  Awaiting;
end;

procedure ShowFilterSubmenu(const VacanciesHead: PVacancyNode;
  const CandidatesHead: PCandidateNode; const CompaniesHead: PCompanyNode);
var
  Choice: Integer;
  FilteredVacancies: PVacancyNode;
  FilteredCandidates: PCandidateNode;
begin
  FilteredVacancies := nil;
  FilteredCandidates := nil;
  repeat
    ClearScreen;
    Writeln('1. ����������� ��������');
    Writeln('2. ����������� ����������');
    Writeln('0. �����');
    Choice := ReadInteger('��������: ');

    case Choice of
      1:
        ShowVacancyFilters(VacanciesHead, CompaniesHead, FilteredVacancies);
      2:
        ShowCandidateFilters(CandidatesHead, CompaniesHead, FilteredCandidates);
      0:
        Exit;
    else
      Writeln('�������� �����!');
    end;
  until False;
end;

procedure ShowSortMenu(var VacanciesHead: PVacancyNode;
  var CandidatesHead: PCandidateNode; const CompaniesHead: PCompanyNode);
var
  Choice, FieldChoice, OrderChoice: Integer;
  Order: TSortOrder;
  CompareVacancyFunc: TCompareVacancyFunc;
  CompareCandidateFunc: TCompareCandidateFunc;
begin
  repeat
    ClearScreen;
    Writeln('1. ����������� ��������');
    Writeln('2. ����������� ����������');
    Writeln('0. �����');
    Choice := ReadInteger('��������: ');

    case Choice of
      1:
        begin
          repeat
            ClearScreen;
            Writeln('���������� �������� ��:');
            Writeln('1. ������');
            Writeln('2. ������������� ��������');
            Writeln('3. ������������ ��������');
            Writeln('0. �����');            
            FieldChoice := ReadInteger('�������� ����: ');

            if FieldChoice = 0 then
              Exit;

            Writeln('1. �� �����������');
            Writeln('2. �� ��������');
            OrderChoice := ReadInteger('�������� �������: ');
            Order := TSortOrder(OrderChoice - 1);

            case FieldChoice of
              1:
                CompareVacancyFunc := CompareVacancyBySalary;
              2:
                CompareVacancyFunc := CompareVacancyByMaxAge;
              3:
                CompareVacancyFunc := CompareVacancyByMinAge;
            else
              begin
                Writeln('���������� ����� ���� ����������');
              end;
            end;
            if (FieldChoice >= 1) and (FieldChoice <= 4) then
            begin
              SortUtils.SortVacancies(VacanciesHead, CompareVacancyFunc, Order);
              OutputUtils.ShowAllVacancies(VacanciesHead, CompaniesHead);
            end;
            Awaiting;
          until False;
        end;

      2:
        begin
          repeat
            ClearScreen;
            Writeln('���������� ���������� ��:');
            Writeln('1. ������� �����');
            Writeln('2. ���� ��������');
            Writeln('0. �����');
            FieldChoice := ReadInteger('�������� ����: ');

            if FieldChoice = 0 then
              Exit;

            Writeln('1. �� �����������');
            Writeln('2. �� ��������');
            OrderChoice := ReadInteger('�������� �������: ');
            Order := TSortOrder(OrderChoice - 1);

            case FieldChoice of
              1:
                CompareCandidateFunc := CompareCandidateByFullName;
              2:
                CompareCandidateFunc := CompareCandidateByBirthDate;
            else
              begin
                Writeln('���������� ����� ���� ����������');
              end;
            end;
            if (FieldChoice >= 1) and (FieldChoice <= 2) then
            begin
              SortUtils.SortCandidates(CandidatesHead,
                CompareCandidateFunc, Order);
              OutputUtils.ShowAllCandidates(CandidatesHead);
            end;
            Awaiting;
          until False;
        end;
    end;
  until False;
end;

procedure ShowDeficitSpecialties(VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode);
var
  Deficits, Current: PDeficitStat;
  F: TextFile;
begin
  Deficits := nil;
  try
    MatchUtils.FindDeficitSpecialties(VacanciesHead, CandidatesHead, Deficits);

    if Deficits = nil then
    begin
      Writeln('���������� �������������� �� �������');
      Exit;
    end;

    Writeln('������ ���������� ������������:');
    Current := Deficits;
    while Current <> nil do
    begin
      Writeln('���������: ', Current^.Position);
      Writeln('�������������: ', Current^.Specialty);
      Writeln('��������: ', Current^.VacancyCount);
      Writeln('����������: ', Current^.CandidateCount);
      Writeln('------------------------------');
      Current := Current^.Next;
    end;

    AssignFile(F, 'deficit_reports_' + FormatDateTime('yyyy-mm-dd_hh-nn-ss', Now) + '.txt');
    Rewrite(F);
    try
      Current := Deficits;
      while Current <> nil do
      begin
        Writeln(F, '���������: ', Current^.Position);
        Writeln(F, '�������������: ', Current^.Specialty);
        Writeln(F, '��������: ', Current^.VacancyCount);
        Writeln(F, '����������: ', Current^.CandidateCount);
        Writeln(F, '------------------------------');
        Current := Current^.Next;
      end;
    finally
      CloseFile(F);
    end;

    Writeln('����� ������� � deficit_report.txt');

  finally
    while Deficits <> nil do
    begin
      Current := Deficits;
      Deficits := Deficits^.Next;
      Dispose(Current);
    end;
  end;
end;

procedure SFSubMenu(VacanciesHead: PVacancyNode; CandidatesHead: PCandidateNode;
  CompaniesHead: PCompanyNode);
var
  Choice: Integer;
begin
  repeat
    ClearScreen;
    Writeln('1. ��������� ���������� � ���������.');
    Writeln('2. ����� ���������� ������������');
    Writeln('0. �����');
    Choice := ReadInteger('�������� ����������� �������: ');
    case Choice of
      1:
        FindAndSaveMatches(VacanciesHead, CandidatesHead, CompaniesHead);
      2:
        ShowDeficitSpecialties(VacanciesHead, CandidatesHead);
      0:
        Exit;
    end;

    Awaiting;
  until False;
end;

procedure ShowMainMenu;
var
  DataLoaded: Boolean;
  Choice: Integer;
  VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode;
  CompaniesHead: PCompanyNode;
begin
  DataLoaded := False;
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
    Choice := ReadInteger('�������� ����� ����: ');

    case Choice of
      1:
        begin
          if not DataLoaded then
          begin
            LoadAllData(VacanciesHead, CandidatesHead, CompaniesHead);
            DataLoaded := True;
            Writeln('������ ������� ���������');
          end
          else
            Writeln('������ ��� ���������');
          Awaiting;
        end;
      2:
        begin
          if not DataLoaded then
          begin
            Writeln('��� ��������� ������� � ����� ������ ���� ��� ���������� ��������� ������ �� ������.');
            Awaiting;
          end
          else
            ShowViewSubmenu(VacanciesHead, CandidatesHead, CompaniesHead);
        end;
      3:
        ShowSortMenu(VacanciesHead, CandidatesHead, CompaniesHead);
      4:
        ShowFilterSubmenu(VacanciesHead, CandidatesHead, CompaniesHead);
      5:
        if not DataLoaded then
        begin
          Writeln('��� ��������� ������� � ����� ������ ���� ��� ���������� ��������� ������ �� ������.');
          Awaiting;
        end
        else
          ShowAddRecordSubmenu(VacanciesHead, CandidatesHead, CompaniesHead);
      6:
        if not DataLoaded then
        begin
          Writeln('��� ��������� ������� � ����� ������ ���� ��� ���������� ��������� ������ �� ������.');
          Awaiting;
        end
        else
          ShowDeleteSubmenu(VacanciesHead, CandidatesHead, CompaniesHead);
      7:
        if not DataLoaded then
        begin
          Writeln('��� ��������� ������� � ����� ������ ���� ��� ���������� ��������� ������ �� ������.');
          Awaiting;
        end
        else
          ShowEditSubmenu(VacanciesHead, CandidatesHead, CompaniesHead);
      8:
        SFSubMenu(VacanciesHead, CandidatesHead, CompaniesHead);
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
