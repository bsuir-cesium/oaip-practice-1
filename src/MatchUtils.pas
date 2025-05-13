unit MatchUtils;

interface

uses
  CoreTypes, ListUtils, SysUtils;

procedure FindAndSaveMatches(VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode; CompaniesHead: PCompanyNode);

procedure FindDeficitSpecialties(VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode; var ResultHead: PDeficitStat);

implementation

uses
  DateUtils;

function IsMatch(Vacancy: PVacancy; Candidate: PCandidate): Boolean;
var
  Age: Integer;
begin
  Age := YearsBetween(Date, Candidate^.BirthDate);
  Result := (LowerCase(Vacancy^.Specialty) = LowerCase(Candidate^.Specialty))
    and (LowerCase(Vacancy^.Position) = LowerCase(Candidate^.DesiredPosition))
    and (Candidate^.HasHigherEducation >= Vacancy^.RequiresHigherEducation) and
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
      Writeln('Вакансия от ', CompanyName, ', ID компании: ',
        CurrentVacancy^.Data^.CompanyID, ' | Специальность: ',
        CurrentVacancy^.Data^.Specialty, ', должность: ',
        CurrentVacancy^.Data^.Position, ', ID вакансии: ',
        CurrentVacancy^.Data.ID);
      Writeln(F, 'Вакансия от ', CompanyName, ', ID компании: ',
        CurrentVacancy^.Data^.CompanyID, ' | Специальность: ',
        CurrentVacancy^.Data^.Specialty, ', должность: ',
        CurrentVacancy^.Data^.Position, ', ID вакансии: ',
        CurrentVacancy^.Data.ID);

      MatchCount := 0;
      CurrentCandidate := CandidatesHead;

      while CurrentCandidate <> nil do
      begin
        if IsMatch(CurrentVacancy^.Data, CurrentCandidate^.Data) then
        begin
          Inc(MatchCount);

          Writeln('  Кандидат №', MatchCount, ', ФИО: ',
            CurrentCandidate^.Data^.FullName, ', ID: ',
            CurrentCandidate^.Data^.ID, ', Возраст: ',
            YearsBetween(Date, CurrentCandidate^.Data^.BirthDate),
            ', Ожидания: ', CurrentCandidate^.Data^.MinSalary:0:2);

          Writeln(F, '  Кандидат №', MatchCount, ', ФИО: ',
            CurrentCandidate^.Data^.FullName, ', ID: ',
            CurrentCandidate^.Data^.ID, ', Возраст: ',
            YearsBetween(Date, CurrentCandidate^.Data^.BirthDate),
            ', Ожидания: ', CurrentCandidate^.Data^.MinSalary:0:2);
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

procedure FindDeficitSpecialties(VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode; var ResultHead: PDeficitStat);
var
  CurrentVacancy: PVacancyNode;
  CurrentCandidate: PCandidateNode;
  CurrentStat, NewStat, PrevStat: PDeficitStat;
  Key: string;
  Found: Boolean;
begin
  ResultHead := nil;

  CurrentVacancy := VacanciesHead;
  while CurrentVacancy <> nil do
  begin
    Key := LowerCase(CurrentVacancy^.Data^.Position + '|' +
      CurrentVacancy^.Data^.Specialty);
    Found := False;
    CurrentStat := ResultHead;
    PrevStat := nil;

    while CurrentStat <> nil do
    begin
      if LowerCase(CurrentStat^.Position + '|' + CurrentStat^.Specialty) = Key
      then
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
      NewStat^.Position := CurrentVacancy^.Data^.Position;
      NewStat^.Specialty := CurrentVacancy^.Data^.Specialty;
      NewStat^.VacancyCount := 1;
      NewStat^.CandidateCount := 0;
      NewStat^.Next := nil;

      if ResultHead = nil then
        ResultHead := NewStat
      else
        PrevStat^.Next := NewStat;
    end;

    CurrentVacancy := CurrentVacancy^.Next;
  end;

  CurrentCandidate := CandidatesHead;
  while CurrentCandidate <> nil do
  begin
    Key := LowerCase(CurrentCandidate^.Data^.DesiredPosition + '|' +
      CurrentCandidate^.Data^.Specialty);
    CurrentStat := ResultHead;

    while CurrentStat <> nil do
    begin
      if LowerCase(CurrentStat^.Position + '|' + CurrentStat^.Specialty) = Key
      then
      begin
        Inc(CurrentStat^.CandidateCount);
        Break;
      end;
      CurrentStat := CurrentStat^.Next;
    end;

    CurrentCandidate := CurrentCandidate^.Next;
  end;

  CurrentStat := ResultHead;
  PrevStat := nil;

  while CurrentStat <> nil do
  begin
    if (CurrentStat^.VacancyCount = 0) or
      (CurrentStat^.CandidateCount >= CurrentStat^.VacancyCount * 0.1) then
    begin
      if PrevStat = nil then
      begin
        ResultHead := CurrentStat^.Next;
        Dispose(CurrentStat);
        CurrentStat := ResultHead;
      end
      else
      begin
        PrevStat^.Next := CurrentStat^.Next;
        Dispose(CurrentStat);
        CurrentStat := PrevStat^.Next;
      end;
    end
    else
    begin
      PrevStat := CurrentStat;
      CurrentStat := CurrentStat^.Next;
    end;
  end;
end;

end.
