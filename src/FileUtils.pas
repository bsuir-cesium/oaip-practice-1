unit FileUtils;

interface

uses
  SysUtils, CoreTypes;

procedure LoadAllData(var VacanciesHead: PVacancyNode; var CandidatesHead: PCandidateNode);
procedure SaveAllData(VacanciesHead: PVacancyNode; CandidatesHead: PCandidateNode);

implementation

procedure LoadAllData(var VacanciesHead: PVacancyNode; var CandidatesHead: PCandidateNode);
var
  FVacancies: file of TVacancy;
  FCandidates: file of TCandidate;
  Vacancy: TVacancy;
  Candidate: TCandidate;
  NewVacancyNode: PVacancyNode;
  NewCandidateNode: PCandidateNode;
begin
  // Загрузка вакансий
  if FileExists('vacancies.TVacancy') then
  begin
    AssignFile(FVacancies, 'vacancies.TVacancy');
    try
      Reset(FVacancies);
      while not Eof(FVacancies) do
      begin
        Read(FVacancies, Vacancy);

        // Создание узла
        New(NewVacancyNode);
        New(NewVacancyNode^.Data);  // Выделяем память для данных
        NewVacancyNode^.Data^ := Vacancy;
        NewVacancyNode^.Next := VacanciesHead;
        VacanciesHead := NewVacancyNode;
      end;
    finally
      CloseFile(FVacancies);
    end;
  end;

  // Загрузка кандидатов
  if FileExists('candidates.TCandidate') then
  begin
    AssignFile(FCandidates, 'candidates.TCandidate');
    try
      Reset(FCandidates);
      while not Eof(FCandidates) do
      begin
        Read(FCandidates, Candidate);

        // Создание узла
        New(NewCandidateNode);
        New(NewCandidateNode^.Data);  // Выделяем память для данных
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
  // Сохранение вакансий
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

  // Сохранение кандидатов
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
