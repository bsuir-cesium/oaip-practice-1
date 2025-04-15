unit MatchUtils;

interface

uses
  CoreTypes, ListUtils, SysUtils;

procedure FindAndSaveMatches(VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode; CompaniesHead: PCompanyNode);

implementation

uses
  DateUtils;

function IsMatch(Vacancy: PVacancy; Candidate: PCandidate): Boolean;
var
  Age: Integer;
begin
  Age := YearsBetween(Date, Candidate^.BirthDate);
  Result := (Vacancy^.Specialty = Candidate^.Specialty) and
    (Vacancy^.Position = Candidate^.DesiredPosition) and
    (Candidate^.HasHigherEducation >= Vacancy^.RequiresHigherEducation) and
    (Age >= Vacancy^.MinAge) and (Age <= Vacancy^.MaxAge) and
    (Candidate^.MinSalary <= Vacancy^.Salary);
end;

procedure FindAndSaveMatches(VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode; CompaniesHead: PCompanyNode);
var
  F: TextFile;
  CurrentVacancy: PVacancyNode;
  CurrentCandidate: PCandidateNode;
  MatchCount: Integer;
  FileName, CompanyName: String;
begin
  if (VacanciesHead = nil) or (CandidatesHead = nil) then
  begin
    Writeln('������: ��� ������ ��� �������');
    Exit;
  end;
  FileName := 'matches_' + FormatDateTime('yyyy-mm-dd_hh-nn-ss', Now) + '.txt';
  AssignFile(F, FileName);
  try
    Rewrite(F);

    CurrentVacancy := VacanciesHead;

    while CurrentVacancy <> nil do
    begin
      CompanyName := GetCompanyNameByID(CompaniesHead,
        CurrentVacancy^.Data^.CompanyID);
      Writeln('��������: ', CompanyName, ', ID ��������: ',
        CurrentVacancy^.Data^.CompanyID, ' / ', CurrentVacancy^.Data^.Position,
        ', ID ��������: ', CurrentVacancy^.Data.ID);
      Writeln(F, '��������: ', CompanyName, ', ID ��������: ',
        CurrentVacancy^.Data^.CompanyID, ' / ', CurrentVacancy^.Data^.Position,
        ', ID ��������: ', CurrentVacancy^.Data.ID);

      MatchCount := 0;
      CurrentCandidate := CandidatesHead;

      while CurrentCandidate <> nil do
      begin
        if IsMatch(CurrentVacancy^.Data, CurrentCandidate^.Data) then
        begin
          Inc(MatchCount);

          Writeln('  �������� ', MatchCount, ': ',
            CurrentCandidate^.Data^.FullName, ', ID: ',
            CurrentCandidate^.Data^.ID, ' (�������: ',
            YearsBetween(Date, CurrentCandidate^.Data^.BirthDate),
            ', ��������: ', CurrentCandidate^.Data^.MinSalary:0:2, ')');

          Writeln(F, '  �������� ', MatchCount, ': ',
            CurrentCandidate^.Data^.FullName, ', ID: ',
            CurrentCandidate^.Data^.ID, ' (�������: ',
            YearsBetween(Date, CurrentCandidate^.Data^.BirthDate),
            ', ��������: ', CurrentCandidate^.Data^.MinSalary:0:2, ')');
        end;
        CurrentCandidate := CurrentCandidate^.Next;
      end;

      if MatchCount = 0 then
      begin
        Writeln('  ��� ���������� ����������');
        Writeln(F, '  ��� ���������� ����������');
      end;

      Writeln;
      Writeln(F);
      CurrentVacancy := CurrentVacancy^.Next;
    end;

  finally
    CloseFile(F);
  end;
end;

end.
