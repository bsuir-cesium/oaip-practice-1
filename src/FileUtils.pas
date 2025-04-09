unit FileUtils;

interface

uses
  SysUtils, CoreTypes, ListUtils;

procedure LoadAllData(var VacanciesHead: PVacancyNode;
  var CandidatesHead: PCandidateNode; var CompaniesHead: PCompanyNode);
procedure SaveAllData(VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode; var CompaniesHead: PCompanyNode);

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
    Writeln(F, LastCompanyID);
  finally
    CloseFile(F);
  end;
end;

procedure LoadIDsFromFile;
var
  F: TextFile;
begin
  if not FileExists('ids.dat') then
    Exit;

  AssignFile(F, 'ids.dat');
  try
    Reset(F);
    Readln(F, LastVacancyID);
    Readln(F, LastCandidateID);
    Readln(F, LastCompanyID);
  finally
    CloseFile(F);
  end;
end;

procedure LoadAllData(var VacanciesHead: PVacancyNode;
  var CandidatesHead: PCandidateNode; var CompaniesHead: PCompanyNode);
var
  FVacancies: file of TVacancy;
  FCandidates: file of TCandidate;
  FCompanies: file of TCompany;
  Vacancy: TVacancy;
  Candidate: TCandidate;
  Company: TCompany;
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
        AppendVacancy(VacanciesHead, Vacancy);
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
        AppendCandidate(CandidatesHead, Candidate);
      end;
    finally
      CloseFile(FCandidates);
    end;
  end;

  if FileExists('companies.TCompany') then
  begin
    AssignFile(FCompanies, 'companies.TCompany');
    try
      Reset(FCompanies);
      while not Eof(FCompanies) do
      begin
        Read(FCompanies, Company);
        AppendCompany(CompaniesHead, Company);
      end;
    finally
      CloseFile(FCompanies);
    end;
  end;
end;

procedure SaveAllData(VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode; var CompaniesHead: PCompanyNode);
var
  FVacancies: file of TVacancy;
  FCandidates: file of TCandidate;
  FCompanies: file of TCompany;
  CurrentVacancy: PVacancyNode;
  CurrentCandidate: PCandidateNode;
  CurrentCompany: PCompanyNode;
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

  AssignFile(FCompanies, 'companies.TCompany');
  try
    Rewrite(FCompanies);
    CurrentCompany := CompaniesHead;
    while CurrentCompany <> nil do
    begin
      Write(FCompanies, CurrentCompany^.Data^);
      CurrentCompany := CurrentCompany^.Next;
    end;
  finally
    CloseFile(FCompanies);
  end;
end;

end.
