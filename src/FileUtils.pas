unit FileUtils;

interface

uses
  SysUtils, CoreTypes;

procedure LoadAllData(var VacanciesHead: PVacancyNode; var CandidatesHead: PCandidateNode);
procedure SaveAllData(VacanciesHead: PVacancyNode; CandidatesHead: PCandidateNode);

implementation

procedure SaveIDsToFile;
var
  F: TextFile;
begin
  AssignFile(F, 'ids.dat');
  try
    Rewrite(F);
    Writeln(F, LastVacancyID);
    Writeln(F, LastCandidateID);
  finally
    CloseFile(F);
  end;
end;

procedure LoadIDsFromFile;
var
  F: TextFile;
begin
  if not FileExists('ids.dat') then Exit;

  AssignFile(F, 'ids.dat');
  try
    Reset(F);
    Readln(F, LastVacancyID);
    Readln(F, LastCandidateID);
  finally
    CloseFile(F);
  end;
end;

procedure LoadAllData(var VacanciesHead: PVacancyNode; var CandidatesHead: PCandidateNode);
var
  FVacancies: file of TVacancy;
  FCandidates: file of TCandidate;
  Vacancy: TVacancy;
  Candidate: TCandidate;
  NewVacancyNode: PVacancyNode;
  NewCandidateNode: PCandidateNode;
begin
  LoadIDsFromFile;
  if FileExists('vacancies.TVacancy') then
  begin
    AssignFile(FVacancies, 'vacancies.TVacancy');
    try
      Reset(FVacancies);
      while not Eof(FVacancies) do
      begin
        Read(FVacancies, Vacancy);

        New(NewVacancyNode);
        New(NewVacancyNode^.Data);
        NewVacancyNode^.Data^ := Vacancy;
        NewVacancyNode^.Next := VacanciesHead;
        VacanciesHead := NewVacancyNode;
      end;
    finally
      CloseFile(FVacancies);
    end;
  end;

  if FileExists('candidates.TCandidate') then
  begin
    AssignFile(FCandidates, 'candidates.TCandidate');
    try
      Reset(FCandidates);
      while not Eof(FCandidates) do
      begin
        Read(FCandidates, Candidate);

        New(NewCandidateNode);
        New(NewCandidateNode^.Data);
        NewCandidateNode^.Data^ := Candidate;
        NewCandidateNode^.Next := CandidatesHead;
        CandidatesHead := NewCandidateNode;
      end;
    finally
      CloseFile(FCandidates);
    end;
  end;
end;

procedure SaveAllData(VacanciesHead: PVacancyNode; CandidatesHead: PCandidateNode);
var
  FVacancies: file of TVacancy;
  FCandidates: file of TCandidate;
  CurrentVacancy: PVacancyNode;
  CurrentCandidate: PCandidateNode;
begin
  SaveIDsToFile();
  AssignFile(FVacancies, 'vacancies.TVacancy');
  try
    Rewrite(FVacancies);
    CurrentVacancy := VacanciesHead;
    while CurrentVacancy <> nil do
    begin
      Write(FVacancies, CurrentVacancy^.Data^);
      CurrentVacancy := CurrentVacancy^.Next;
    end;
  finally
    CloseFile(FVacancies);
  end;

  AssignFile(FCandidates, 'candidates.TCandidate');
  try
    Rewrite(FCandidates);
    CurrentCandidate := CandidatesHead;
    while CurrentCandidate <> nil do
    begin
      Write(FCandidates, CurrentCandidate^.Data^);
      CurrentCandidate := CurrentCandidate^.Next;
    end;
  finally
    CloseFile(FCandidates);
  end;
end;

end.
