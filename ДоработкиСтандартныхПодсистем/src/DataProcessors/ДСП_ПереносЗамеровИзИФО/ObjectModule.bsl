// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ТехническиеДанные; //см. НовыеТехническиеДанные

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

//Интерфейс для внешнего воздействия
Процедура ВыполнитьДействияОбработки() Экспорт
	
	Сообщения.Очистить();
	
	ДобавитьСообщение("Начало выполнения обработки");
	
	Если НЕ ЗначениеЗаполнено(КлючевыеОперации) Тогда
		ЗаполнитьДанные();
	КонецЕсли;
	
	ВыполнитьЗаполнениеЗамеровИзИстории();
	
	ДобавитьСообщение("Выполнение обработки завершено");

	ТекстСообщения = "";
	ТекстСообщенияОшибки = "";
	
КонецПроцедуры

// Заголовок инструмента.
// 
// Возвращаемое значение:
//  Строка
Функция ЗаголовокИнструмента() Экспорт
	
	Возврат СтрШаблон("%1 (%2)",
		Метаданные().Представление(),
		НомерВерсииИнструмента());
	 
КонецФункции

// Заполнить ключевые операции.
Процедура ЗаполнитьКлючевыеОперации() Экспорт
	
	ЗаполнитьДанные();
	
КонецПроцедуры

// см. ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке
Функция СведенияОВнешнейОбработке() Экспорт
    
    ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке();
    ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();
    ПараметрыРегистрации.Версия = НомерВерсииИнструмента();
    ПараметрыРегистрации.БезопасныйРежим = Ложь;
    
    Команда = ПараметрыРегистрации.Команды.Добавить();
    Команда.Представление = Метаданные().Представление();
    Команда.Идентификатор = Метаданные().Имя;
    Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
    Команда.ПоказыватьОповещение = Ложь;
    
    Возврат ПараметрыРегистрации; 
    
КонецФункции

// Номер версии инструмента.
// 
// Возвращаемое значение:
//  Строка
Функция НомерВерсииИнструмента() Экспорт
    
    Возврат "1.1.1";
		
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Выполнение

Процедура ВыполнитьЗаполнениеЗамеровИзИстории()
	
	ДанныеЗамера = НачатьЗамерВыполнения();
	
	Успешно = 0;
	ВПроцессе = 0;
	Ошибок = 0;
	
	Выборка = ВыборкаЗамеровИзИстории();
	Пока Выборка.Следующий() Цикл
		
		Если ВПроцессе = 0 Тогда
			НачатьТранзакцию();
		КонецЕсли;
		
		ВПроцессе = ВПроцессе + 1;
		
		ДобавитьЗаписьРегистраЗамеров(Выборка);
		
		ЗафиксироватьТранзакциюПриНеобходимости(ВПроцессе, Успешно, Ошибок, Ложь);
		
	КонецЦикла;
	
	ЗафиксироватьТранзакциюПриНеобходимости(ВПроцессе, Успешно, Ошибок, Истина);
	
	Если Успешно + Ошибок = 0 Тогда
		ТекстСообщения = "Нет данных для обработки";
	Иначе
		ТекстСообщения = СтрШаблон("Успешно обработано: %1, Ошибок: %2", Успешно, Ошибок);
	КонецЕсли;
	ДобавитьСообщение(ТекстСообщения);
	
	ЗавершитьЗамерВыполнения(ДанныеЗамера, "Выполнение");
	
КонецПроцедуры

Процедура ЗафиксироватьТранзакциюПриНеобходимости(ВПроцессе, Успешно, Ошибок, ЭтоКонец)
	
	Если (ЭтоКонец ИЛИ ВПроцессе >= ТехническиеДанные.КоличествоВТранзакции)
		И ТранзакцияАктивна() Тогда
		
		Попытка
	        ЗафиксироватьТранзакцию();
			Успешно = Успешно + ВПроцессе;
		Исключение
			ОтменитьТранзакцию();
	        Ошибок = Ошибок + ВПроцессе;
		КонецПопытки;
		
		ВПроцессе = 0;
			
	КонецЕсли;
		
КонецПроцедуры

Процедура ДобавитьЗаписьРегистраЗамеров(Выборка)
	
	ЗаписьРегистра = РегистрыСведений.ЗамерыВремени.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(ЗаписьРегистра, Выборка);
	ЗаписьРегистра.Комментарий = ТехническиеДанные.Комментарий;
	ЗаписьРегистра.ВесЗамера = 1;
	ЗаписьРегистра.ДатаОкончания = ЗаписьРегистра.ДатаНачалаЗамера 
		+ (ЗаписьРегистра.ВремяВыполнения * 1000);
	ЗаписьРегистра.ДатаЗаписиЛокальная = ЗаписьРегистра.ДатаЗаписи;
	ЗаписьРегистра.Записать();
	
КонецПроцедуры

Функция ВыборкаЗамеровИзИстории()
	
	СхемаКомпоновкиДанных = ПолучитьМакет("ВыборкаЗамеров");
	УстановитьРегистрИсторииВЗапросеСКД(СхемаКомпоновкиДанных);
	
	ВременныйКомпоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	ВременныйКомпоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	ВременныйКомпоновщик.ЗагрузитьНастройки(КомпоновщикНастроек.ПолучитьНастройки());
	ВременныйКомпоновщик.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.Полное);
	
	ВыбранныеПоля = ВременныйКомпоновщик.Настройки.Выбор.Элементы;
	ВыбранныеПоля.Очистить();
	
	Для Каждого ПолеНабора Из СхемаКомпоновкиДанных.НаборыДанных.Получить(0).Поля Цикл
		
		Если ПолеНабора.ОграничениеИспользования.Поле Тогда
			Продолжить;
		КонецЕсли;
		
		ВыбранноеПоле = ВыбранныеПоля.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));		
		ВыбранноеПоле.Использование = Истина;
		ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных(ПолеНабора.ПутьКДанным);
		
	КонецЦикла;
	
	Таблицы = Новый Структура("ВТ_КлючевыеОперации", 
		КлючевыеОперации.Выгрузить(Новый Структура("Пометка", Истина)));
		
	Запрос = ЗапросИзСхемыКомпоновки(СхемаКомпоновкиДанных, ВременныйКомпоновщик.ПолучитьНастройки(), Таблицы);
	Запрос.УстановитьПараметр("ПоправкаЧасовогоПояса", ТекущаяДатаСеанса() - УниверсальноеВремя(ТекущаяДатаСеанса()));
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

#КонецОбласти

#Область Заполнение

Процедура ЗаполнитьДанные()
	
	ДанныеЗамера = НачатьЗамерВыполнения();
	
	КлючевыеОперации.Очистить();
	КлючевыеОперацииИзБазы = КлючевыеОперацииИзБазы();
	КлючевыеОперации.Загрузить(КлючевыеОперацииИзБазы);
	
	ЗавершитьЗамерВыполнения(ДанныеЗамера, "Заполнение");
	
КонецПроцедуры

Функция КлючевыеОперацииИзБазы()
	
	СКД = ПолучитьМакет("ВыборкаКО"); //СхемаКомпоновкиДанных
	ДанныеКО = Новый ТаблицаЗначений;
	СкомпоноватьРезультатОтчета(ДанныеКО, СКД, КомпоновщикНастроек.ПолучитьНастройки());
	
	ТаблицыМенеджера = Новый Структура("ВТ_КлючевыеОперации", ДанныеКО);
	
	СКД = ПолучитьМакет("ВыборкаОбщихДанных"); //СхемаКомпоновкиДанных
	УстановитьРегистрИсторииВЗапросеСКД(СКД);
	Результат = Новый ТаблицаЗначений();
	СкомпоноватьРезультатОтчета(Результат, СКД, КомпоновщикНастроек.ПолучитьНастройки(),,ТаблицыМенеджера);
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ЗамерВремени

// Начать замер выполнения.
// 
// Возвращаемое значение:
//  Структура:
// * НачалоЗамера - см. ОценкаПроизводительности.НачатьЗамерВремени 
// * ДанныеКомментария - Соответствие из КлючИЗначение:
// ** Ключ - Произвольный
// ** Значение - Произвольный
Функция НачатьЗамерВыполнения()
	
	НачалоЗамера = ОценкаПроизводительности.НачатьЗамерВремени();
	ДанныеКомментария = Новый Соответствие;
	
	Результат = Новый Структура;
	Результат.Вставить("НачалоЗамера", НачалоЗамера);
	Результат.Вставить("ДанныеКомментария", ДанныеКомментария);
	
	Возврат Результат;	
	
КонецФункции

// Завершить замер выполнения.
// 
// Параметры:
//  ДанныеЗамера - см. НачатьЗамерВыполнения
//  ТекущееДействие - Строка
Процедура ЗавершитьЗамерВыполнения(ДанныеЗамера, ТекущееДействие)
	
	КлючеваяОперация = СтрШаблон("%1:%2", ТехническиеДанные.КлючеваяОперация, ТекущееДействие); 
	
	ОценкаПроизводительности.ЗакончитьЗамерВремени(
		КлючеваяОперация, 
		ДанныеЗамера.НачалоЗамера,,
		ДанныеЗамера.ДанныеКомментария);
	
КонецПроцедуры

#КонецОбласти

#Область Вспомогательные

Процедура УстановитьРегистрИсторииВЗапросеСКД(СКД)
	
	Для Каждого НаборДанных Из СКД.НаборыДанных Цикл
		
		Если ТипЗнч(НаборДанных) = Тип("НаборДанныхЗапросСхемыКомпоновкиДанных") Тогда
			
			НаборДанных.Запрос = СтрЗаменить(НаборДанных.Запрос, "_РегистрИФО_", "РегистрСведений.ИТМ_ИсторияФормированияОтчетов");
			
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры

// Функция возвращает запрос из схемы компоновки с учетом настроек и менеджера
//
// Параметры:
//  СхемаКомпоновкиДанных	 - СхемаКомпоновкиДанных - Выполняемые схема
//  НастройкиКомпоновки		 - НастройкиКомпоновкиДанных - Выполняемые настройки
//  ТаблицыМенеджера	     - МенеджерВременныхТаблиц, Структура, Неопределено - Менеджер, контекст которого должен быть доступен в СКД
//  ИмяНабора                - Строка
// 
// Возвращаемое значение:
//  Запрос - Запрос, готовый к выполнению
//
Функция ЗапросИзСхемыКомпоновки(Знач СхемаКомпоновкиДанных, 
	Знач НастройкиКомпоновки, Знач ТаблицыМенеджера, Знач ИмяНабора = "НаборДанных1")
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;     
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновки);
	НаборДанных = МакетКомпоновки.НаборыДанных.Найти(ИмяНабора);
	
	Запрос = Новый Запрос;
	Запрос.Текст = НаборДанных.Запрос;
	
	КоллекцииПараметров = Новый Массив; // Массив из ЗначенияПараметровМакетаКомпоновкиДанных
	КоллекцииПараметров.Добавить(МакетКомпоновки.ЗначенияПараметров);
	КоллекцииПараметров.Добавить(НаборДанных.ЗначенияПараметров);
	
	Для Каждого КоллекцияПараметров Из КоллекцииПараметров Цикл
		Для Каждого ЗначениеПараметра Из КоллекцияПараметров Цикл
			Запрос.УстановитьПараметр(ЗначениеПараметра.Имя, ЗначениеПараметра.Значение);
		КонецЦикла;
	КонецЦикла;
	
	Если ТипЗнч(ТаблицыМенеджера) = Тип("Структура") Тогда
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		Для Каждого КлючИЗначение Из ТаблицыМенеджера Цикл
			ТаблицаЗначений = КлючИЗначение.Значение; //ТаблицаЗначений
			//@skip-check query-in-loop
			ДобавитьТаблицуВМенеджерВременныхТаблиц(Запрос.МенеджерВременныхТаблиц, 
				КлючИЗначение.Ключ, ТаблицаЗначений);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Запрос;
		
КонецФункции

// Выполняет компоновку СКД по переданным настройкам
//
// Параметры:
//  Результат               - ТабличныйДокумент, ТаблицаЗначений -
//  СхемаКомпоновки         - СхемаКомпоновкиДанных, Строка - 
//  НастройкиКомпоновки     - НастройкиКомпоновкиДанных
//  ВнешниеНаборыДанных     - Структура, Неопределено -
//  ТаблицыМенеджера        - Структура
Процедура СкомпоноватьРезультатОтчета(Результат, 
	Знач СхемаКомпоновки, Знач НастройкиКомпоновки, 
	Знач ВнешниеНаборыДанных = Неопределено,
	Знач ТаблицыМенеджера = Неопределено)
    
	//Определяем тип генератора
	Если ТипЗнч(Результат) = Тип("ТаблицаЗначений") Тогда
		ВыводВКоллекциюЗначений = Истина;
		ТипГенератораВывода     = Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений");
	Иначе
		ВыводВКоллекциюЗначений = Ложь;
		ТипГенератораВывода     = Тип("ГенераторМакетаКомпоновкиДанных");
	КонецЕсли;
    
    ВременныйКомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных();
    ВременныйКомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновки));
    ВременныйКомпоновщикНастроек.ЗагрузитьНастройки(НастройкиКомпоновки);
    ВременныйКомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.Полное);
	
	Если ТипЗнч(ТаблицыМенеджера) = Тип("Структура") Тогда
		МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		Для Каждого КлючИЗначение Из ТаблицыМенеджера Цикл
			ТаблицаЗначений = КлючИЗначение.Значение; // ТаблицаЗначений
			//@skip-check query-in-loop
			ДобавитьТаблицуВМенеджерВременныхТаблиц(МенеджерВременныхТаблиц, КлючИЗначение.Ключ, ТаблицаЗначений);
		КонецЦикла;
	Иначе
		МенеджерВременныхТаблиц = Неопределено;
	КонецЕсли;
	
    НастройкиКомпоновки = ВременныйКомпоновщикНастроек.ПолучитьНастройки();
    
	//Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
    
	//Передаем в макет компоновки схему, настройки и данные расшифровки
	МакетКомпоновки = КомпоновщикМакета.Выполнить(
		СхемаКомпоновки, НастройкиКомпоновки,,, ТипГенератораВывода);
    
	//Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных,,,,МенеджерВременныхТаблиц);
    
    //Выводим результат
	ПроцессорВывода = Неопределено;
    Если ВыводВКоллекциюЗначений Тогда
		ПроцессорВывода    = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
		ПроцессорВывода.УстановитьОбъект(Результат);
	Иначе
		ПроцессорВывода    = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
		ПроцессорВывода.УстановитьДокумент(Результат);
	КонецЕсли;
    
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);

КонецПроцедуры

// Процедура добавляет таблицу в менеджер временных таблиц
//
// Параметры:
//  МенеджерВременныхТаблиц	 - МенеджерВременныхТаблиц - Менеджер, в который нужно добавить таблицу
//  ИмяТаблицы				 - Строка - Имя временной таблицы
//  ДанныеТаблицы			 - ТаблицаЗначений - Данные таблицы
//
Процедура ДобавитьТаблицуВМенеджерВременныхТаблиц(МенеджерВременныхТаблиц, ИмяТаблицы, ДанныеТаблицы) Экспорт
	
	ИменаКолонок = Новый Массив; //Массив из Строка
	Для Каждого Колонка Из ДанныеТаблицы.Колонки Цикл
		ИменаКолонок.Добавить(Колонка.Имя);
	КонецЦикла;
	//@skip-check statement-type-change
	ИменаКолонок = СтрСоединить(ИменаКолонок, ",");
	
	ТекстЗапроса = "ВЫБРАТЬ %1 ПОМЕСТИТЬ %2 ИЗ &ТЗ КАК ТЗ";
	ТекстЗапроса = СтрШаблон(ТекстЗапроса, ИменаКолонок, ИмяТаблицы);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТЗ", ДанныеТаблицы);
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти

#Область Служебное

Процедура Инициализировать()
	
	ТехническиеДанные = НовыеТехническиеДанные();
	
	ИнициализироватьКомпоновщикНастроек();
	
КонецПроцедуры

Процедура ИнициализироватьКомпоновщикНастроек()
	
	Если ЗначениеЗаполнено(АдресСхемыКомпоновки) Тогда
		Возврат; //Компоновщик уже инициализирован
	КонецЕсли;
	
	СхемаКомпоновкиДанных = ПолучитьМакет("ВыборкаОбщихДанных"); //СхемаКомпоновкиДанных
	АдресСхемыКомпоновки = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновки);
	КомпоновщикНастроек.Инициализировать(ИсточникДоступныхНастроек);
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
КонецПроцедуры

// Новые технические данные.
// 
// Возвращаемое значение:
//  Структура:
// * Метаданные - ОбъектМетаданныхОбработка
// * СобытиеЖР - Строка
// * КлючеваяОперация - Строка
// * Комментарий - Строка
// * КоличествоВТранзакции - Число
Функция НовыеТехническиеДанные()
	
	МетаданныеИнструмента = Метаданные();
	Результат = Новый Структура;
	Результат.Вставить("Метаданные", МетаданныеИнструмента);
	Результат.Вставить("СобытиеЖР", СтрШаблон("Обработка.%1", МетаданныеИнструмента.Имя));
	Результат.Вставить("КлючеваяОперация", МетаданныеИнструмента.ПолноеИмя() + ".Выполнение");
	Результат.Вставить("КоличествоВТранзакции", 100);
	Результат.Вставить("Комментарий", "Заполнение из ИФО инструментом " + МетаданныеИнструмента.Представление());
	
	Возврат Результат;
	
КонецФункции

// Добавить сообщение.
// 
// Параметры:
//  ИсточникКомментария - Строка, ИнформацияОбОшибке - Комментарий
//  ДополнительнаяИнформация - Строка - Дополнительная информация
Процедура ДобавитьСообщение(Знач ИсточникКомментария, Знач ДополнительнаяИнформация = "")
	
	Если ТипЗнч(ИсточникКомментария) = Тип("ИнформацияОбОшибке") Тогда
		ЭтоИсключение = Истина;
		Комментарий = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИсточникКомментария);
	ИначеЕсли ПустаяСтрока(ИсточникКомментария) Тогда
		Возврат;
	Иначе
		ЭтоИсключение = Ложь;
		Комментарий   = СокрЛП(ИсточникКомментария);
	КонецЕсли;
	
	Комментарий = ДополнительнаяИнформация + Комментарий;
		
	УровеньЗаписиЖР = УровеньЖурналаРегистрации[
		?(ЭтоИсключение, "Предупреждение", "Информация")]; // УровеньЖурналаРегистрации
	ЗаписьЖурналаРегистрации(ТехническиеДанные.СобытиеЖР, 
		УровеньЗаписиЖР, ТехническиеДанные.Метаданные,,Комментарий);
			
	ДанныеСообщения = Сообщения.Добавить();
	ДанныеСообщения.Комментарий   = Комментарий;
	ДанныеСообщения.ЭтоИсключение = ЭтоИсключение;
	ДанныеСообщения.Начало    = ТекущаяДатаСеанса();
	
	#Если НЕ ВнешнееСоединение Тогда
		ОбщегоНазначения.СообщитьПользователю(Комментарий);
	#КонецЕсли

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область Инициализация

Инициализировать();

#КонецОбласти

#КонецЕсли