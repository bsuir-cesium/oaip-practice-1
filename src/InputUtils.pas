unit InputUtils;

interface

uses
  CoreTypes, ListUtils, SysUtils;

procedure AddNewVacancy(var VacanciesHead: PVacancyNode;
  CompaniesHead: PCompanyNode);
procedure AddNewCandidate(var CandidatesHead: PCandidateNode);
procedure AddNewCompany(var CompaniesHead: PCompanyNode);
procedure EditVacancy(VacanciesHead: PVacancyNode; ID: Integer);
procedure EditCandidate(CandidatesHead: PCandidateNode; ID: Integer);
procedure EditCompany(CompaniesHead: PCompanyNode; ID: Integer);
function ReadBoolean(const Prompt: string): Boolean;

implementation

function ReadBoolean(const Prompt: string): Boolean;
var
  InputStr: string;
  InputFlag: Integer;
begin
  repeat
    Write(Prompt);
    Readln(InputStr);
  until TryStrToInt(InputStr, InputFlag) and
    ((InputFlag = 0) or (InputFlag = 1));
  Result := Boolean(InputFlag);
end;

procedure AddNewVacancy(var VacanciesHead: PVacancyNode;
  CompaniesHead: PCompanyNode);
var
  NewVacancy: TVacancy;
  CompanyID: Integer;
begin
  NewVacancy.ID := GetNextVacancyID();
  Write('������� ID ��������: ');
  Readln(CompanyID);

  if not CompanyExists(CompaniesHead, CompanyID) then
  begin
    Writeln('������! �������� �� ����������!');
    Exit;
  end;
  Write('�������������: ');
  Readln(NewVacancy.Specialty);
  Write('���������: ');
  Readln(NewVacancy.Position);
  Write('�����: ');
  Readln(NewVacancy.Salary);
  Write('���� �������: ');
  Readln(NewVacancy.VacationDays);
  NewVacancy.RequiresHigherEducation :=
    ReadBoolean('��������� ������ ����������� (1-��/0-���): ');
  Write('����������� �������: ');
  Readln(NewVacancy.MinAge);
  Write('������������ �������: ');
  Readln(NewVacancy.MaxAge);

  NewVacancy.CompanyID := CompanyID;
  AppendVacancy(VacanciesHead, NewVacancy);
  Write('�������� � ID: ');
  Write(NewVacancy.CompanyID);
  Writeln(' ���� ������� �������!');
end;

procedure AddNewCandidate(var CandidatesHead: PCandidateNode);
var
  NewCandidate: TCandidate;
  DateStr: string;
  DateValue: TDateTime;
begin
  NewCandidate.ID := GetNextCandidateID;
  Write('��� ���������: ');
  Readln(NewCandidate.FullName);
  repeat
    Write('���� �������� (��.��.����): ');
    Readln(DateStr);
  until TryStrToDate(DateStr, DateValue);
  NewCandidate.BirthDate := DateValue;

  Write('�������������: ');
  Readln(NewCandidate.Specialty);
  NewCandidate.HasHigherEducation :=
    ReadBoolean('������� ������� ����������� (1-��/0-���): ');
  Write('�������� ���������: ');
  Readln(NewCandidate.DesiredPosition);
  Write('����������� �����: ');
  Readln(NewCandidate.MinSalary);

  AppendCandidate(CandidatesHead, NewCandidate);
  Write('�������� ' + NewCandidate.FullName + ' � ID: ');
  Write(NewCandidate.ID);
  Writeln(' ��� ������� ������!');
end;

procedure AddNewCompany(var CompaniesHead: PCompanyNode);
var
  NewCompany: TCompany;
begin
  NewCompany.ID := GetNextCompanyID();
  Write('�������� ��������: ');
  Readln(NewCompany.Name);

  AppendCompany(CompaniesHead, NewCompany);
  Write('�������� ' + NewCompany.Name + ' � ID: ');
  Write(NewCompany.ID);
  Writeln(' ���� ������� �������!');
end;

procedure EditVacancy(VacanciesHead: PVacancyNode; ID: Integer);
var
  isFinded: Boolean;
begin
  isFinded := False;

  while VacanciesHead <> nil do
  begin
    if VacanciesHead^.Data^.ID = ID then
    begin
      isFinded := True;
      Write('�������������: ');
      Readln(VacanciesHead^.Data^.Specialty);
      Write('���������: ');
      Readln(VacanciesHead^.Data^.Position);
      Write('�����: ');
      Readln(VacanciesHead^.Data^.Salary);
      Write('���� �������: ');
      Readln(VacanciesHead^.Data^.VacationDays);
      VacanciesHead^.Data^.RequiresHigherEducation :=
        ReadBoolean('��������� ������ ����������� (1-��/0-���): ');
      Write('����������� �������: ');
      Readln(VacanciesHead^.Data^.MinAge);
      Write('������������ �������: ');
      Readln(VacanciesHead^.Data^.MaxAge);
    end;
    VacanciesHead := VacanciesHead^.Next;
  end;

  if not isFinded then
    Writeln('�������� � ID: ', ID, ' �� �������.');
end;

procedure EditCandidate(CandidatesHead: PCandidateNode; ID: Integer);
var
  isFinded: Boolean;
  DateStr: string;
  DateValue: TDateTime;
begin
  isFinded := False;

  while CandidatesHead <> nil do
  begin
    if CandidatesHead^.Data^.ID = ID then
    begin
      isFinded := False;
      Write('��� ���������: ');
      Readln(CandidatesHead^.Data^.FullName);
      repeat
        Write('���� �������� (��.��.����): ');
        Readln(DateStr);
      until TryStrToDate(DateStr, DateValue);
      CandidatesHead^.Data^.BirthDate := DateValue;

      Write('�������������: ');
      Readln(CandidatesHead^.Data^.Specialty);
      CandidatesHead^.Data^.HasHigherEducation :=
        ReadBoolean('������� ������� ����������� (1-��/0-���): ');
      Write('�������� ���������: ');
      Readln(CandidatesHead^.Data^.DesiredPosition);
      Write('����������� �����: ');
      Readln(CandidatesHead^.Data^.MinSalary);
    end;
    CandidatesHead := CandidatesHead^.Next;
  end;

  if not isFinded then
    Writeln('�������� � ID: ', ID, ' �� ������.');
end;

procedure EditCompany(CompaniesHead: PCompanyNode; ID: Integer);
var
  isFinded: Boolean;
begin
  isFinded := False;

  while CompaniesHead <> nil do
  begin
    if CompaniesHead^.Data^.ID = ID then
    begin
      isFinded := True;
      Write('�������� ��������: ');
      Readln(CompaniesHead^.Data^.Name);
    end;
    CompaniesHead := CompaniesHead^.Next;
  end;

  if not isFinded then
    Writeln('�������� � ID: ', ID, ' �� �������.');

end;

end.
