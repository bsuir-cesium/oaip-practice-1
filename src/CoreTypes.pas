unit CoreTypes;

interface

type
  TCompany = record
    ID: Integer;
    Name: string[50];
  end;

  PCompany = ^TCompany;

  PCompanyNode = ^TCompanyNode;

  TCompanyNode = record
    Data: PCompany;
    Next: PCompanyNode;
  end;

  THasEducation = Boolean;

  TVacancy = record
    ID: Integer;
    CompanyID: Integer;
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
    ID: Integer;
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

  PDeficitStat = ^TDeficitStat;
  TDeficitStat = record
    Position: string;
    Specialty: string;
    VacancyCount: Integer;
    CandidateCount: Integer;
    Next: PDeficitStat;
  end;

var
  LastVacancyID: Integer = 0;
  LastCandidateID: Integer = 0;
  LastCompanyID: Integer = 0;

function GetNextVacancyID: Integer;
function GetNextCandidateID: Integer;
function GetNextCompanyID: Integer;

implementation

function GetNextVacancyID: Integer;
begin
  Inc(LastVacancyID);
  Result := LastVacancyID;
end;

function GetNextCandidateID: Integer;
begin
  Inc(LastCandidateID);
  Result := LastCandidateID;
end;

function GetNextCompanyID: Integer;
begin
  Inc(LastCompanyID);
  Result := LastCompanyID;
end;

end.
