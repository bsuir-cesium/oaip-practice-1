unit OutputUtils;

interface

uses
  CoreTypes, ListUtils;

procedure ShowVacancyDetailed(Vacancy: PVacancy; CompaniesHead: PCompanyNode);
procedure ShowCandidateDetailed(Candidate: PCandidate);
procedure ShowAllVacancies(VacanciesHead: PVacancyNode; CompaniesHead: PCompanyNode);
procedure ShowAllCandidates(CandidatesHead: PCandidateNode);
procedure ShowAllCompanies(CompaniesHead: PCompanyNode);

implementation

uses
  SysUtils;

function BoolToYesNo(Value: Boolean): string;
begin
  if Value then
    Result := '��'
  else
    Result := '���';
end;

procedure ShowVacancyDetailed(Vacancy: PVacancy; CompaniesHead: PCompanyNode);
begin
  if Vacancy = nil then
    Exit;

  Writeln('ID: ', Vacancy^.ID);
  Writeln('��������: ', GetCompanyNameById(CompaniesHead, Vacancy^.CompanyID));
  Writeln('�������������: ', Vacancy^.Specialty);
  Writeln('���������: ', Vacancy^.Position);
  Writeln('�����: ', Vacancy^.Salary:0:2);
  Writeln('���� �������: ', Vacancy^.VacationDays);
  Writeln('��������� ������: ', BoolToYesNo(Vacancy^.RequiresHigherEducation));
  Writeln('���������� ��������: ', Vacancy^.MinAge, '-', Vacancy^.MaxAge);
  Writeln('======================================');
  Writeln;
end;

procedure ShowCandidateDetailed(Candidate: PCandidate);
begin
  if Candidate = nil then
    Exit;

  Writeln('ID: ', Candidate^.ID);
  Writeln('���: ', Candidate^.FullName);
  Writeln('���� ��������: ', DateToStr(Candidate^.BirthDate));
  Writeln('�������������: ', Candidate^.Specialty);
  Writeln('������ �����������: ', BoolToYesNo(Candidate^.HasHigherEducation));
  Writeln('�������� ���������: ', Candidate^.DesiredPosition);
  Writeln('����������� �����: ', Candidate^.MinSalary:0:2);
  Writeln('======================================');
  Writeln;
end;

procedure ShowCompanyDetailed(Company: PCompany);
begin
  if Company = nil then
    Exit;

  Writeln('ID: ', Company^.ID);
  Writeln('��������: ', Company^.Name);
  Writeln('======================================');
  Writeln;
end;

procedure ShowAllVacancies(VacanciesHead: PVacancyNode; CompaniesHead: PCompanyNode);
var
  Current: PVacancyNode;
begin
  if VacanciesHead = nil then
  begin
    Writeln('������ �������� ����.');
    Exit;
  end;

  Writeln('========== �������� ==========');
  Writeln;

  Current := VacanciesHead;
  while Current <> nil do
  begin
    ShowVacancyDetailed(Current^.Data, CompaniesHead);
    Current := Current^.Next;
  end;
end;

procedure ShowAllCandidates(CandidatesHead: PCandidateNode);
var
  Current: PCandidateNode;
begin
  if CandidatesHead = nil then
  begin
    Writeln('������ ���������� ����.');
    Exit;
  end;

  Writeln('========== ��������� ==========');
  Writeln;

  Current := CandidatesHead;
  while Current <> nil do
  begin
    ShowCandidateDetailed(Current^.Data);
    Current := Current^.Next;
  end;
end;

procedure ShowAllCompanies(CompaniesHead: PCompanyNode);
var
  Current: PCompanyNode;
begin
  if CompaniesHead = nil then
  begin
    Writeln('������ �������� ����.');
    Exit;
  end;

  Writeln('========== �������� ==========');
  Writeln;

  Current := CompaniesHead;
  while Current <> nil do
  begin
    ShowCompanyDetailed(Current^.Data);
    Current := Current^.Next;
  end;
end;

end.
