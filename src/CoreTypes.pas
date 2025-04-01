unit CoreTypes;

interface

type
  THasEducation = Boolean;

  TVacancy = record
    CompanyName: string[50];
    Specialty: string[50];
    Position: string[50];
    Salary: Double;
    VacationDays: Integer;
    RequiresHigherEducation: THasEducation;
    MinAge: Integer;
    MaxAge: Integer;
  end;
  PVacancy = ^TVacancy;

  TCandidate = record
    FullName: string[50];
    BirthDate: TDate;
    Specialty: string[50];
    HasHigherEducation: THasEducation;
    DesiredPosition: string[50];
    MinSalary: Double;
  end;
  PCandidate = ^TCandidate;

  PVacancyNode = ^TVacancyNode;
  TVacancyNode = record
    Data: PVacancy;
    Next: PVacancyNode;
  end;

  PCandidateNode = ^TCandidateNode;
  TCandidateNode = record
    Data: PCandidate;
    Next: PCandidateNode;
  end;

procedure ClearVacancies(var Head: PVacancyNode);
procedure ClearCandidates(var Head: PCandidateNode);

implementation

procedure ClearVacancies(var Head: PVacancyNode);
var
  Temp: PVacancyNode;
begin
  while Head <> nil do
  begin
    Temp := Head;
    Head := Head^.Next;
    Dispose(Temp^.Data);
    Dispose(Temp);
  end;
end;

procedure ClearCandidates(var Head: PCandidateNode);
var
  Temp: PCandidateNode;
begin
  while Head <> nil do
  begin
    Temp := Head;
    Head := Head^.Next;
    Dispose(Temp^.Data);
    Dispose(Temp);
  end;
end;

end.
