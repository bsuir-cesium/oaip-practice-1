unit SortUtils;

interface

uses
  CoreTypes, ListUtils;

type
  TSortOrder = (soAscending, soDescending);
  TCompareVacancyFunc = function(A, B: PVacancy; Order: TSortOrder): Integer;
  TCompareCandidateFunc = function(A, B: PCandidate; Order: TSortOrder)
    : Integer;

function CompareVacancyBySalary(A, B: PVacancy; Order: TSortOrder): Integer;
function CompareVacancyByMaxAge(A, B: PVacancy; Order: TSortOrder): Integer;
function CompareVacancyByMinAge(A, B: PVacancy; Order: TSortOrder): Integer;

function CompareCandidateByFullName(A, B: PCandidate;
  Order: TSortOrder): Integer;
function CompareCandidateByBirthDate(A, B: PCandidate;
  Order: TSortOrder): Integer;

procedure SortVacancies(var Head: PVacancyNode; Compare: TCompareVacancyFunc;
  Order: TSortOrder);
procedure SortCandidates(var Head: PCandidateNode;
  Compare: TCompareCandidateFunc; Order: TSortOrder);

implementation

procedure SortVacancies(var Head: PVacancyNode; Compare: TCompareVacancyFunc;
  Order: TSortOrder);
  procedure SplitList(Source: PVacancyNode; var Front, Back: PVacancyNode);
  var
    Fast, Slow: PVacancyNode;
  begin
    if (Source = nil) or (Source^.Next = nil) then
    begin
      Front := Source;
      Back := nil;
    end
    else
    begin
      Slow := Source;
      Fast := Source^.Next;

      while Fast <> nil do
      begin
        Fast := Fast^.Next;
        if Fast <> nil then
        begin
          Slow := Slow^.Next;
          Fast := Fast^.Next;
        end;
      end;

      Front := Source;
      Back := Slow^.Next;
      Slow^.Next := nil;
    end;
  end;

  function Merge(A, B: PVacancyNode): PVacancyNode;
  var
    ResultList: PVacancyNode;
  begin
    if A = nil then
      Result := B
    else if B = nil then
      Result := A
    else
    begin
      if Compare(A^.Data, B^.Data, Order) <= 0 then
      begin
        ResultList := A;
        ResultList^.Next := Merge(A^.Next, B);
      end
      else
      begin
        ResultList := B;
        ResultList^.Next := Merge(A, B^.Next);
      end;
      Result := ResultList;
    end;
  end;

  procedure MergeSort(var Head: PVacancyNode);
  var
    A, B: PVacancyNode;
  begin
    if (Head = nil) or (Head^.Next = nil) then
      Exit;

    SplitList(Head, A, B);

    MergeSort(A);
    MergeSort(B);

    Head := Merge(A, B);
  end;

begin
  MergeSort(Head);
end;

function CompareVacancyBySalary(A, B: PVacancy; Order: TSortOrder): Integer;
begin
  if A^.Salary > B^.Salary then
    Result := 1
  else if A^.Salary < B^.Salary then
    Result := -1
  else
    Result := 0;

  if Order = soDescending then
    Result := -Result;
end;

function CompareVacancyByMaxAge(A, B: PVacancy; Order: TSortOrder): Integer;
begin
  if A^.MaxAge > B^.MaxAge then
    Result := 1
  else if A^.MaxAge < B^.MaxAge then
    Result := -1
  else
    Result := 0;

  if Order = soDescending then
    Result := -Result;
end;

function CompareVacancyByMinAge(A, B: PVacancy; Order: TSortOrder): Integer;
begin
  if A^.MinAge > B^.MinAge then
    Result := 1
  else if A^.MinAge < B^.MinAge then
    Result := -1
  else
    Result := 0;

  if Order = soDescending then
    Result := -Result;
end;

procedure SortCandidates(var Head: PCandidateNode;
  Compare: TCompareCandidateFunc; Order: TSortOrder);
  procedure SplitList(Source: PCandidateNode; var Front, Back: PCandidateNode);
  var
    Fast, Slow: PCandidateNode;
  begin
    if (Source = nil) or (Source^.Next = nil) then
    begin
      Front := Source;
      Back := nil;
    end
    else
    begin
      Slow := Source;
      Fast := Source^.Next;

      while Fast <> nil do
      begin
        Fast := Fast^.Next;
        if Fast <> nil then
        begin
          Slow := Slow^.Next;
          Fast := Fast^.Next;
        end;
      end;

      Front := Source;
      Back := Slow^.Next;
      Slow^.Next := nil;
    end;
  end;

  function Merge(A, B: PCandidateNode): PCandidateNode;
  var
    ResultList: PCandidateNode;
  begin
    if A = nil then
      Result := B
    else if B = nil then
      Result := A
    else
    begin
      if Compare(A^.Data, B^.Data, Order) <= 0 then
      begin
        ResultList := A;
        ResultList^.Next := Merge(A^.Next, B);
      end
      else
      begin
        ResultList := B;
        ResultList^.Next := Merge(A, B^.Next);
      end;
      Result := ResultList;
    end;
  end;

  procedure MergeSort(var Head: PCandidateNode);
  var
    A, B: PCandidateNode;
  begin
    if (Head = nil) or (Head^.Next = nil) then
      Exit;

    SplitList(Head, A, B);

    MergeSort(A);
    MergeSort(B);

    Head := Merge(A, B);
  end;

begin
  MergeSort(Head);
end;

function CompareCandidateByFullName(A, B: PCandidate;
  Order: TSortOrder): Integer;
begin
  if A^.FullName > B^.FullName then
    Result := 1
  else if A^.FullName < B^.FullName then
    Result := -1
  else
    Result := 0;

  if Order = soDescending then
    Result := -Result;
end;

function CompareCandidateByBirthDate(A, B: PCandidate;
  Order: TSortOrder): Integer;
begin
  if A^.BirthDate > B^.BirthDate then
    Result := 1
  else if A^.BirthDate < B^.BirthDate then
    Result := -1
  else
    Result := 0;

  if Order = soDescending then
    Result := -Result;
end;

end.
