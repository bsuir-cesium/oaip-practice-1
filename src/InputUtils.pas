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
function ReadInteger(const Prompt: String): Integer;
function ReadBoolean(const Prompt: string): Boolean;

implementation

function ReadInteger(const Prompt: String): Integer;
var
  InputStr: String;
  InputValue: Integer;
begin
  repeat
    Write(Prompt);
    Readln(InputStr);
  until TryStrToInt(InputStr, InputValue);
  Result := InputValue;
end;

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

  NewVacancy.Salary := ReadInteger('�����: ');
  NewVacancy.VacationDays := ReadInteger('���� �������: ');

  NewVacancy.RequiresHigherEducation :=
    ReadBoolean('��������� ������ ����������� (1-��/0-���): ');

  NewVacancy.MinAge := ReadInteger('����������� �������: ');
  NewVacancy.MaxAge := ReadInteger('������������ �������: ');

  NewVacancy.CompanyID := CompanyID;
  AppendVacancy(VacanciesHead, NewVacancy);
  Write('�������� � ID: ');
  Write(NewVacancy.ID);
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

  NewCandidate.MinSalary := ReadInteger('����������� �����: ');

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

      VacanciesHead^.Data^.Salary := ReadInteger('�����: ');
      VacanciesHead^.Data^.VacationDays := ReadInteger('���� �������: ');

      VacanciesHead^.Data^.RequiresHigherEducation :=
        ReadBoolean('��������� ������ ����������� (1-��/0-���): ');

      VacanciesHead^.Data^.MinAge := ReadInteger('����������� �������: ');
      VacanciesHead^.Data^.MaxAge := ReadInteger('������������ �������: ');
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
      isFinded := True;
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

      CandidatesHead^.Data^.MinSalary := ReadInteger('����������� �����: ');
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
