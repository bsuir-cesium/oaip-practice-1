unit MenuUtils;

interface

uses
  CoreTypes, FileUtils, InputUtils, OutputUtils, ListUtils, MatchUtils,
  Filters,
  SortUtils;

procedure ShowMainMenu;

implementation

uses
  SysUtils, Windows;

procedure Awaiting;
begin
  Writeln('Нажмите Enter для продолжения...');
  Readln;
end;

procedure ClearScreen;
var
  hStdOut: THandle;
  csbi: TConsoleScreenBufferInfo;
  dwConSize: DWORD;
  dwCharsWritten: DWORD;
  Origin: TCoord;
begin
  hStdOut := GetStdHandle(STD_OUTPUT_HANDLE);

  if not GetConsoleScreenBufferInfo(hStdOut, csbi) then
    Exit;

  dwConSize := csbi.dwSize.X * csbi.dwSize.Y;

  Origin.X := 0;
  Origin.Y := 0;
  FillConsoleOutputCharacter(hStdOut, ' ', dwConSize, Origin, dwCharsWritten);

  FillConsoleOutputAttribute(hStdOut, csbi.wAttributes, dwConSize, Origin,
    dwCharsWritten);

  SetConsoleCursorPosition(hStdOut, Origin);
end;

procedure ShowViewSubmenu(VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode; CompaniesHead: PCompanyNode);
var
  Choice: Integer;
begin
  repeat
    ClearScreen;
    Writeln('1. Просмотр вакансий');
    Writeln('2. Просмотр кандидатов');
    Writeln('3. Просмотр компаний');
    Writeln('0. Назад');
    Choice := ReadInteger('Выберите: ');

    case Choice of
      1:
        begin
          ClearScreen;
          ShowAllVacancies(VacanciesHead, CompaniesHead);
          Awaiting;
        end;
      2:
        begin
          ClearScreen;
          ShowAllCandidates(CandidatesHead);
          Awaiting;
        end;
      3:
        begin
          ClearScreen;
          ShowAllCompanies(CompaniesHead);
          Awaiting;
        end;
      0:
        Exit;
    else
      Writeln('Неверный выбор!');
      Readln;
    end;
  until False;
end;

procedure ShowAddRecordSubmenu(var VacanciesHead: PVacancyNode;
  var CandidatesHead: PCandidateNode; var CompaniesHead: PCompanyNode);
var
  Choice: Integer;
begin
  repeat
    ClearScreen;
    Writeln('1. Добавить вакансию');
    Writeln('2. Добавить кандидата');
    Writeln('3. Добавить компанию');
    Writeln('0. Назад');
    Choice := ReadInteger('Выберите: ');

    case Choice of
      1:
        begin
          AddNewVacancy(VacanciesHead, CompaniesHead);
          Awaiting;
        end;
      2:
        begin
          AddNewCandidate(CandidatesHead);
          Awaiting;
        end;
      3:
        begin
          AddNewCompany(CompaniesHead);
          Awaiting;
        end;
      0:
        Exit;
    else
      Writeln('Неверный выбор!');
      Readln;
    end;
  until False;
end;

procedure ShowDeleteSubmenu(var VacanciesHead: PVacancyNode;
  var CandidatesHead: PCandidateNode; var CompaniesHead: PCompanyNode);
var
  Choice, ID: Integer;
begin
  repeat
    ClearScreen;
    Writeln('1. Удалить вакансию');
    Writeln('2. Удалить кандидата');
    Writeln('3. Удалить компанию');
    Writeln('0. Назад');
    Choice := ReadInteger('Выберите: ');

    case Choice of
      1:
        begin
          ID := ReadInteger('Введите ID вакансии: ');
          if DeleteVacancy(VacanciesHead, ID) <> -1 then
            Writeln('Вакансия ', ID, ' удалена!')
          else
            Writeln('Вакансия не найдена!');
          Awaiting;
        end;
      2:
        begin
          ID := ReadInteger('Введите ID кандидата: ');
          if DeleteVacancy(VacanciesHead, ID) <> -1 then
            Writeln('Кандидат ', ID, ' удалён!')
          else
            Writeln('Кандидат не найден!');
          Awaiting;
        end;
      3:
        begin
          ID := ReadInteger('Введите ID компании: ');
          if DeleteCompany(CompaniesHead, ID, VacanciesHead) <> -1 then
            Writeln('Компания ', ID, ' удалена!')
          else
            Writeln('Компания не найдена!');
          Awaiting;
        end;
      0:
        Exit;
    end;
  until False;
end;

procedure ShowEditSubmenu(var VacanciesHead: PVacancyNode;
  var CandidatesHead: PCandidateNode; var CompaniesHead: PCompanyNode);
var
  Choice, ID: Integer;
begin
  repeat
    ClearScreen;
    Writeln('1. Редактировать вакансию');
    Writeln('2. Редактировать кандидата');
    Writeln('3. Редактировать компанию');
    Writeln('0. Назад');
    Choice := ReadInteger('Выберите: ');

    case Choice of
      1:
        begin
          ID := ReadInteger('Введите ID вакансии: ');
          EditVacancy(VacanciesHead, ID);
          Awaiting;
        end;
      2:
        begin
          ID := ReadInteger('Введите ID кандидата: ');
          EditCandidate(CandidatesHead, ID);
          Awaiting;
        end;
      3:
        begin
          ID := ReadInteger('Введите ID вакансии: ');
          EditCompany(CompaniesHead, ID);
          Awaiting;
        end;
      0:
        Exit;
    else
      Writeln('Неверный выбор!');
      Readln;
    end;
  until False;
end;

procedure ShowVacancyFilters(VacanciesHead: PVacancyNode;
  CompaniesHead: PCompanyNode; var FilteredVacancies: PVacancyNode);
var
  MinSalary: Double;
  RequiresEducation: Boolean;
  MinAge, MaxAge: Integer;
  Specialty: string;
begin
  MinSalary := ReadInteger('Минимальный оклад: ');
  RequiresEducation :=
    ReadBoolean('Требуется высшее образование (1-Да/0-Нет): ');
  MaxAge := ReadInteger('Максимальный возраст: ');
  MinAge := ReadInteger('Минимальный возраст: ');
  Write('Специальность (часть названия): ');
  Readln(Specialty);

  FilterVacancies(VacanciesHead, MinSalary, RequiresEducation, MinAge, MaxAge,
    Specialty, FilteredVacancies);

  if FilteredVacancies = nil then
    Writeln('Нет подходящих вакансий')
  else
    ShowAllVacancies(FilteredVacancies, CompaniesHead);
  ClearVacancies(FilteredVacancies);
  Awaiting;
end;

procedure ShowCandidateFilters(CandidatesHead: PCandidateNode;
  CompaniesHead: PCompanyNode; var FilteredCandidates: PCandidateNode);
var
  MinSalary: Double;
  HasEducation: Boolean;
  MinAge, MaxAge: Integer;
  Specialty: string;
begin
  MinSalary := ReadInteger('Минимальный желаемый оклад: ');
  HasEducation := ReadBoolean('Наличие высшего образования (1-Да/0-Нет): ');
  MaxAge := ReadInteger('Максимальный возраст: ');
  MinAge := ReadInteger('Минимальный возраст: ');
  Write('Специальность (часть названия): ');
  Readln(Specialty);

  Filters.FilterCandidates(CandidatesHead, MinSalary, HasEducation, MinAge,
    MaxAge, Specialty, FilteredCandidates);

  if FilteredCandidates = nil then
    Writeln('Нет подходящих кандидатов')
  else
    ShowAllCandidates(FilteredCandidates);
  ClearCandidates(FilteredCandidates);
  Awaiting;
end;

procedure ShowFilterSubmenu(const VacanciesHead: PVacancyNode;
  const CandidatesHead: PCandidateNode; const CompaniesHead: PCompanyNode);
var
  Choice: Integer;
  FilteredVacancies: PVacancyNode;
  FilteredCandidates: PCandidateNode;
begin
  FilteredVacancies := nil;
  FilteredCandidates := nil;
  repeat
    ClearScreen;
    Writeln('1. Фильтровать вакансии');
    Writeln('2. Фильтровать кандидатов');
    Writeln('0. Назад');
    Choice := ReadInteger('Выберите: ');

    case Choice of
      1:
        ShowVacancyFilters(VacanciesHead, CompaniesHead, FilteredVacancies);
      2:
        ShowCandidateFilters(CandidatesHead, CompaniesHead, FilteredCandidates);
      0:
        Exit;
    else
      Writeln('Неверный выбор!');
    end;
  until False;
end;

procedure ShowSortMenu(var VacanciesHead: PVacancyNode;
  var CandidatesHead: PCandidateNode; const CompaniesHead: PCompanyNode);
var
  Choice, FieldChoice, OrderChoice: Integer;
  Order: TSortOrder;
  CompareVacancyFunc: TCompareVacancyFunc;
  CompareCandidateFunc: TCompareCandidateFunc;
begin
  repeat
    ClearScreen;
    Writeln('1. Сортировать вакансии');
    Writeln('2. Сортировать кандидатов');
    Writeln('0. Назад');
    Choice := ReadInteger('Выберите: ');

    case Choice of
      1:
        begin
          repeat
            ClearScreen;
            Writeln('Сортировка вакансий по:');
            Writeln('1. Окладу');
            Writeln('2. Максимальному возрасту');
            Writeln('3. Минимальному возрасту');
            Writeln('0. Назад');            
            FieldChoice := ReadInteger('Выберите поле: ');

            if FieldChoice = 0 then
              Exit;

            Writeln('1. По возрастанию');
            Writeln('2. По убыванию');
            OrderChoice := ReadInteger('Выберите порядок: ');
            Order := TSortOrder(OrderChoice - 1);

            case FieldChoice of
              1:
                CompareVacancyFunc := CompareVacancyBySalary;
              2:
                CompareVacancyFunc := CompareVacancyByMaxAge;
              3:
                CompareVacancyFunc := CompareVacancyByMinAge;
            else
              begin
                Writeln('Невалидный выбор поля сортировки');
              end;
            end;
            if (FieldChoice >= 1) and (FieldChoice <= 4) then
            begin
              SortUtils.SortVacancies(VacanciesHead, CompareVacancyFunc, Order);
              OutputUtils.ShowAllVacancies(VacanciesHead, CompaniesHead);
            end;
            Awaiting;
          until False;
        end;

      2:
        begin
          repeat
            ClearScreen;
            Writeln('Сортировка кандидатов по:');
            Writeln('1. Полному имени');
            Writeln('2. Дате рождения');
            Writeln('0. Назад');
            FieldChoice := ReadInteger('Выберите поле: ');

            if FieldChoice = 0 then
              Exit;

            Writeln('1. По возрастанию');
            Writeln('2. По убыванию');
            OrderChoice := ReadInteger('Выберите порядок: ');
            Order := TSortOrder(OrderChoice - 1);

            case FieldChoice of
              1:
                CompareCandidateFunc := CompareCandidateByFullName;
              2:
                CompareCandidateFunc := CompareCandidateByBirthDate;
            else
              begin
                Writeln('Невалидный выбор поля сортировки');
              end;
            end;
            if (FieldChoice >= 1) and (FieldChoice <= 2) then
            begin
              SortUtils.SortCandidates(CandidatesHead,
                CompareCandidateFunc, Order);
              OutputUtils.ShowAllCandidates(CandidatesHead);
            end;
            Awaiting;
          until False;
        end;
    end;
  until False;
end;

procedure ShowDeficitSpecialties(VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode);
var
  Deficits, Current: PDeficitStat;
  F: TextFile;
begin
  Deficits := nil;
  try
    MatchUtils.FindDeficitSpecialties(VacanciesHead, CandidatesHead, Deficits);

    if Deficits = nil then
    begin
      Writeln('Дефицитных специальностей не найдено');
      Exit;
    end;

    Writeln('Список дефицитных специалистов:');
    Current := Deficits;
    while Current <> nil do
    begin
      Writeln('Должность: ', Current^.Position);
      Writeln('Специальность: ', Current^.Specialty);
      Writeln('Вакансий: ', Current^.VacancyCount);
      Writeln('Кандидатов: ', Current^.CandidateCount);
      Writeln('------------------------------');
      Current := Current^.Next;
    end;

    AssignFile(F, 'deficit_reports_' + FormatDateTime('yyyy-mm-dd_hh-nn-ss', Now) + '.txt');
    Rewrite(F);
    try
      Current := Deficits;
      while Current <> nil do
      begin
        Writeln(F, 'Должность: ', Current^.Position);
        Writeln(F, 'Специальность: ', Current^.Specialty);
        Writeln(F, 'Вакансий: ', Current^.VacancyCount);
        Writeln(F, 'Кандидатов: ', Current^.CandidateCount);
        Writeln(F, '------------------------------');
        Current := Current^.Next;
      end;
    finally
      CloseFile(F);
    end;

    Writeln('Отчёт сохранён в deficit_report.txt');

  finally
    while Deficits <> nil do
    begin
      Current := Deficits;
      Deficits := Deficits^.Next;
      Dispose(Current);
    end;
  end;
end;

procedure SFSubMenu(VacanciesHead: PVacancyNode; CandidatesHead: PCandidateNode;
  CompaniesHead: PCompanyNode);
var
  Choice: Integer;
begin
  repeat
    ClearScreen;
    Writeln('1. Подобрать кандидатов к вакансиям.');
    Writeln('2. Найти дефицитных специалистов');
    Writeln('0. Назад');
    Choice := ReadInteger('Выберите специальную функцию: ');
    case Choice of
      1:
        FindAndSaveMatches(VacanciesHead, CandidatesHead, CompaniesHead);
      2:
        ShowDeficitSpecialties(VacanciesHead, CandidatesHead);
      0:
        Exit;
    end;

    Awaiting;
  until False;
end;

procedure ShowMainMenu;
var
  DataLoaded: Boolean;
  Choice: Integer;
  VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode;
  CompaniesHead: PCompanyNode;
begin
  DataLoaded := False;
  VacanciesHead := nil;
  CandidatesHead := nil;
  CompaniesHead := nil;

  repeat
    ClearScreen;
    Writeln(' 1. Чтение данных из файла');
    Writeln(' 2. Просмотр всего списка');
    Writeln(' 3. Сортировка данных');
    Writeln(' 4. Поиск данных с использованием фильтров');
    Writeln(' 5. Добавление данных в список');
    Writeln(' 6. Удаление данных из списка');
    Writeln(' 7. Редактирование данных');
    Writeln(' 8. Подбор кандидатов для фирм (СФ)');
    Writeln(' 9. Выход из программы без сохранения изменений');
    Writeln('10. Выход с сохранением изменений');
    Choice := ReadInteger('Выберите пункт меню: ');

    case Choice of
      1:
        begin
          if not DataLoaded then
          begin
            LoadAllData(VacanciesHead, CandidatesHead, CompaniesHead);
            DataLoaded := True;
            Writeln('Данные успешно загружены');
          end
          else
            Writeln('Данные уже загружены');
          Awaiting;
        end;
      2:
        begin
          if not DataLoaded then
          begin
            Writeln('Для получения доступа к этому пункту меню вам необходимо загрузить данные из файлов.');
            Awaiting;
          end
          else
            ShowViewSubmenu(VacanciesHead, CandidatesHead, CompaniesHead);
        end;
      3:
        ShowSortMenu(VacanciesHead, CandidatesHead, CompaniesHead);
      4:
        ShowFilterSubmenu(VacanciesHead, CandidatesHead, CompaniesHead);
      5:
        if not DataLoaded then
        begin
          Writeln('Для получения доступа к этому пункту меню вам необходимо загрузить данные из файлов.');
          Awaiting;
        end
        else
          ShowAddRecordSubmenu(VacanciesHead, CandidatesHead, CompaniesHead);
      6:
        if not DataLoaded then
        begin
          Writeln('Для получения доступа к этому пункту меню вам необходимо загрузить данные из файлов.');
          Awaiting;
        end
        else
          ShowDeleteSubmenu(VacanciesHead, CandidatesHead, CompaniesHead);
      7:
        if not DataLoaded then
        begin
          Writeln('Для получения доступа к этому пункту меню вам необходимо загрузить данные из файлов.');
          Awaiting;
        end
        else
          ShowEditSubmenu(VacanciesHead, CandidatesHead, CompaniesHead);
      8:
        SFSubMenu(VacanciesHead, CandidatesHead, CompaniesHead);
      9 .. 10:
        begin
          if Choice = 10 then
            SaveAllData(VacanciesHead, CandidatesHead, CompaniesHead);

          ClearVacancies(VacanciesHead);
          ClearCandidates(CandidatesHead);
          ClearCompanies(CompaniesHead);

          Exit;
        end
    else
      begin
        Writeln('Неверный выбор. Нажмите любую клавишу и попробуйте снова.');
        Readln;
      end;
    end;
  until False;
end;

end.
