unit CoreTypes;

interface

type
  THasEducation = Boolean;

  TVacancy = record
    CompanyName: string;
    Specialty: string;
    Position: string;
    Salary: Double;
    VacationDays: Integer;
    RequiresHigherEducation: THasEducation;
    MinAge: Integer;
    MaxAge: Integer;
  end;
  PVacancy = ^TVacancy;

  TCandidate = record
    FullName: string;
    BirthDate: TDate;
    Specialty: string;
    HasHigherEducation: THasEducation;
    DesiredPosition: string;
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

implementation

end.
