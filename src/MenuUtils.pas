unit MenuUtils;

interface

uses
  CoreTypes, FileUtils, InputUtils, OutputUtils, ListUtils, MatchUtils;

procedure ShowMainMenu;

implementation

uses
  SysUtils, Windows;

procedure ClearScreen;
var
  hConsole: THandle;
  cursorPos: TCoord;
begin
  hConsole := GetStdHandle(STD_OUTPUT_HANDLE);
  Write(#27'[2J'#27'[3J');
  cursorPos.X := 0;
  cursorPos.Y := 0;
  SetConsoleCursorPosition(hConsole, cursorPos);
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
    Write('Выберите: ');
    Readln(Choice);

    case Choice of
      1:
        begin
          ClearScreen;
          ShowAllVacancies(VacanciesHead, CompaniesHead);
          Writeln('Нажмите Enter для продолжения...');
          Readln;
        end;
      2:
        begin
          ClearScreen;
          ShowAllCandidates(CandidatesHead);
          Writeln('Нажмите Enter для продолжения...');
          Readln;
        end;
      3:
        begin
          ClearScreen;
          ShowAllCompanies(CompaniesHead);
          Writeln('Нажмите Enter для продолжения...');
          Readln;
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
    Write('Выберите: ');
    Readln(Choice);

    case Choice of
      1:
      begin
        AddNewVacancy(VacanciesHead, CompaniesHead);
        Writeln('Нажмите Enter для продолжения...');
        Readln;
      end;
      2:
      begin
        AddNewCandidate(CandidatesHead);
        Writeln('Нажмите Enter для продолжения...');
        Readln;
      end;
      3:
      begin
        AddNewCompany(CompaniesHead);
        Writeln('Нажмите Enter для продолжения...');
        Readln;
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
    Write('Выберите: ');
    Readln(Choice);

    case Choice of
      1:
        begin
          Write('Введите ID вакансии: ');
          Readln(ID);
          if DeleteVacancy(VacanciesHead, ID) <> -1 then
            Writeln('Вакансия ', ID, ' удалена!')
          else
            Writeln('Вакансия не найдена!');
          Writeln('Нажмите Enter для продолжения...');
          Readln;
        end;
      2:
        begin
          Write('Введите ID кандидата: ');
          Readln(ID);
          if DeleteVacancy(VacanciesHead, ID) <> -1 then
            Writeln('Кандидат ', ID, ' удалён!')
          else
            Writeln('Кандидат не найден!');
          Writeln('Нажмите Enter для продолжения...');
          Readln;
        end;
      3:
        begin
          Write('Введите ID компании: ');
          Readln(ID);
          if DeleteCompany(CompaniesHead, ID, VacanciesHead) <> -1 then
            Writeln('Компания ', ID, ' удалена!')
          else
            Writeln('Компания не найдена!');
          Writeln('Нажмите Enter для продолжения...');
          Readln;
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
    Write('Выберите: ');
    Readln(Choice);

    case Choice of
      1:
      begin
          Write('Введите ID вакансии: ');
          Readln(ID);
          EditVacancy(VacanciesHead, ID);
          Writeln('Нажмите Enter для продолжения...');
          Readln;
      end;
      2:
      begin
          Write('Введите ID кандидата: ');
          Readln(ID);
          EditCandidate(CandidatesHead, ID);
          Writeln('Нажмите Enter для продолжения...');
          Readln;
      end;
      3:
      begin
          Write('Введите ID вакансии: ');
          Readln(ID);
          EditCompany(CompaniesHead, ID);
          Writeln('Нажмите Enter для продолжения...');
          Readln;
      end;
      0:
        Exit;
    else
      Writeln('Неверный выбор!');
      Readln;
    end;
  until False;
end;

procedure ShowMainMenu;
var
  Choice: Integer;
  VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode;
  CompaniesHead: PCompanyNode;
begin
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
    Write('Выберите пункт меню: ');
    Readln(Choice);

    case Choice of
      1:
        LoadAllData(VacanciesHead, CandidatesHead, CompaniesHead);
      2:
        ShowViewSubmenu(VacanciesHead, CandidatesHead, CompaniesHead);
      3 .. 4:
        Writeln('debug');
      5:
        ShowAddRecordSubmenu(VacanciesHead, CandidatesHead, CompaniesHead);
      6:
        ShowDeleteSubmenu(VacanciesHead, CandidatesHead, CompaniesHead);
      7:
        ShowEditSubmenu(VacanciesHead, CandidatesHead, CompaniesHead);
      8:
      begin
        FindAndSaveMatches(VacanciesHead, CandidatesHead, CompaniesHead);
        Writeln('Нажмите Enter для продолжения...');
        Readln;
      end;
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
