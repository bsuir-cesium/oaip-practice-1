unit MatchUtils;

interface

uses
  CoreTypes, ListUtils, SysUtils;

procedure FindAndSaveMatches(VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode; CompaniesHead: PCompanyNode);

procedure FindDeficitSpecialties(
  VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode;
  var ResultHead: PDeficitStat
);

implementation

uses
  DateUtils;

function IsMatch(Vacancy: PVacancy; Candidate: PCandidate): Boolean;
var
  Age: Integer;
begin
  Age := YearsBetween(Date, Candidate^.BirthDate);
  Result := (LowerCase(Vacancy^.Specialty) = LowerCase(Candidate^.Specialty)) and
    (LowerCase(Vacancy^.Position) = LowerCase(Candidate^.DesiredPosition)) and
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
    Writeln('Ошибка: Нет данных для анализа');
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
      Writeln('Вакансия: ', CompanyName, ', ID компании: ',
        CurrentVacancy^.Data^.CompanyID, ' / ', CurrentVacancy^.Data^.Position,
        ', ID вакансии: ', CurrentVacancy^.Data.ID);
      Writeln(F, 'Вакансия: ', CompanyName, ', ID компании: ',
        CurrentVacancy^.Data^.CompanyID, ' / ', CurrentVacancy^.Data^.Position,
        ', ID вакансии: ', CurrentVacancy^.Data.ID);

      MatchCount := 0;
      CurrentCandidate := CandidatesHead;

      while CurrentCandidate <> nil do
      begin
        if IsMatch(CurrentVacancy^.Data, CurrentCandidate^.Data) then
        begin
          Inc(MatchCount);

          Writeln('  Кандидат ', MatchCount, ': ',
            CurrentCandidate^.Data^.FullName, ', ID: ',
            CurrentCandidate^.Data^.ID, ' (Возраст: ',
            YearsBetween(Date, CurrentCandidate^.Data^.BirthDate),
            ', Ожидания: ', CurrentCandidate^.Data^.MinSalary:0:2, ')');

          Writeln(F, '  Кандидат ', MatchCount, ': ',
            CurrentCandidate^.Data^.FullName, ', ID: ',
            CurrentCandidate^.Data^.ID, ' (Возраст: ',
            YearsBetween(Date, CurrentCandidate^.Data^.BirthDate),
            ', Ожидания: ', CurrentCandidate^.Data^.MinSalary:0:2, ')');
        end;
        CurrentCandidate := CurrentCandidate^.Next;
      end;

      if MatchCount = 0 then
      begin
        Writeln('  Нет подходящих кандидатов');
        Writeln(F, '  Нет подходящих кандидатов');
      end;

      Writeln;
      Writeln(F);
      CurrentVacancy := CurrentVacancy^.Next;
    end;

  finally
    CloseFile(F);
  end;
end;

procedure FindDeficitSpecialties(
  VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode;
  var ResultHead: PDeficitStat
);
var
  CurrentVacancy, CurrentCandidate: Pointer;
  CurrentStat, NewStat, PrevStat: PDeficitStat;
  Key, CurrentKey: string;
  Found: Boolean;
begin
  ResultHead := nil;

  CurrentVacancy := VacanciesHead;
  while CurrentVacancy <> nil do
  begin
    Key := LowerCase(PVacancyNode(CurrentVacancy)^.Data^.Position + '|' +
                     PVacancyNode(CurrentVacancy)^.Data^.Specialty);

    CurrentStat := ResultHead;
    PrevStat := nil;
    Found := False;

    while CurrentStat <> nil do
    begin
      CurrentKey := LowerCase(CurrentStat^.Position + '|' + CurrentStat^.Specialty);
      if CurrentKey = Key then
      begin
        Inc(CurrentStat^.VacancyCount);
        Found := True;
        Break;
      end;
      PrevStat := CurrentStat;
      CurrentStat := CurrentStat^.Next;
    end;

    if not Found then
    begin
      New(NewStat);
      NewStat^.Position := PVacancyNode(CurrentVacancy)^.Data^.Position;
      NewStat^.Specialty := PVacancyNode(CurrentVacancy)^.Data^.Specialty;
      NewStat^.VacancyCount := 1;
      NewStat^.CandidateCount := 0;
      NewStat^.Next := nil;

      if ResultHead = nil then
        ResultHead := NewStat
      else
        PrevStat^.Next := NewStat;
    end;

    CurrentVacancy := PVacancyNode(CurrentVacancy)^.Next;
  end;

  CurrentCandidate := CandidatesHead;
  while CurrentCandidate <> nil do
  begin
    Key := LowerCase(PCandidateNode(CurrentCandidate)^.Data^.DesiredPosition + '|' +
                     PCandidateNode(CurrentCandidate)^.Data^.Specialty);

    CurrentStat := ResultHead;
    while CurrentStat <> nil do
    begin
      CurrentKey := LowerCase(CurrentStat^.Position + '|' + CurrentStat^.Specialty);
      if CurrentKey = Key then
      begin
        Inc(CurrentStat^.CandidateCount);
        Break;
      end;
      CurrentStat := CurrentStat^.Next;
    end;

    CurrentCandidate := PCandidateNode(CurrentCandidate)^.Next;
  end;

  CurrentStat := ResultHead;
  PrevStat := nil;

  while CurrentStat <> nil do
  begin
    if (CurrentStat^.CandidateCount >= CurrentStat^.VacancyCount * 0.1) or
       (CurrentStat^.VacancyCount = 0) then
    begin
      if PrevStat = nil then
        ResultHead := CurrentStat^.Next
      else
        PrevStat^.Next := CurrentStat^.Next;

      Dispose(CurrentStat);
      CurrentStat := PrevStat^.Next;
    end
    else
    begin
      PrevStat := CurrentStat;
      CurrentStat := CurrentStat^.Next;
    end;
  end;
end;

end.
