// @strict-types

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СинхронизироватьНастройкиИРеквизитыФормы(Истина);
	ОбновитьЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Настройки_ОценкаПроизводительности_ИспользоватьПриИзменении(Элемент)

	ОбновитьЭлементыФормы(ЭтотОбъект);	

КонецПроцедуры

&НаКлиенте
Процедура Настройки_ВариантыОтчетов_ИспользоватьПриИзменении(Элемент)
	
	ОбновитьЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Команда_СохранитьНастройки(Команда)
	
	СохранитьНастройки();
	ДСП_КлиентСервер.НастройкиРасширения(Истина);
	СинхронизироватьНастройкиИРеквизитыФормы(Истина);
	ОбновитьЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Команда_ЗафиксироватьЗамеры(Команда)
	
	//@skip-check undefined-function-or-procedure - Глобальный метод в БСП
	ЗаписатьРезультатыАвто();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Настройки

// Синхронизировать настройки и реквизиты формы.
// 
// Параметры:
//  ИзНастроекВФорму - Булево - Из настроек в форму
//  НастройкиРасширения - Неопределено
//                      - см. ДСП_КлиентСервер.НастройкиРасширения
&НаСервере
Процедура СинхронизироватьНастройкиИРеквизитыФормы(ИзНастроекВФорму, НастройкиРасширения = Неопределено)
	
	ЗначенияРеквизитов = ЗначенияРеквизитовФормы();
	НастройкиРасширения = ДСП_КлиентСервер.НастройкиРасширения(Истина);
	
	КоллекцияНастроек = Новый СписокЗначений; // СписокЗначений из Структура
	КоллекцияНастроек.Добавить(НастройкиРасширения, "Настройки");
	
	Для Каждого ТекущаяКоллекция Из КоллекцияНастроек Цикл 
		
		ТекущиеНастройки = ТекущаяКоллекция.Значение;
		
		Для Каждого КлючИЗначение Из ТекущиеНастройки Цикл
		
			ЗначениеНастройки = КлючИЗначение.Значение;
			
			ИмяРеквизитаФормы = СтрШаблон("%1_%2", ТекущаяКоллекция.Представление, КлючИЗначение.Ключ);
			ЗначениеРеквизита = Неопределено;
			
			Если ТипЗнч(ЗначениеНастройки) = Тип("Структура") Тогда
				
				КоллекцияНастроек.Добавить(ЗначениеНастройки, ИмяРеквизитаФормы);
				
			ИначеЕсли ЗначенияРеквизитов.Свойство(ИмяРеквизитаФормы, ЗначениеРеквизита) Тогда
				
				Если ИзНастроекВФорму Тогда
					ЗаполнитьЗначениеРеквизитаИзЗначенияНастройки(
						ЗначениеНастройки, ЭтотОбъект[ИмяРеквизитаФормы]);
				Иначе
					ЗаполнитьЗначениеНастройкиИзЗначенияРеквизита(
						ТекущиеНастройки[КлючИЗначение.Ключ], ЗначениеРеквизита);
				КонецЕсли;
				
			Иначе
				
				ТекстСообщения = СтрШаблон("Не найден реквизит формы %1", ИмяРеквизитаФормы);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Заполнить значение реквизита из значения настройки.
// 
// Параметры:
//  ЗначениеНастройки - Произвольный - Значение настройки
//  ЗначениеРеквизита - Произвольный - Значение реквизита
&НаСервере
Процедура ЗаполнитьЗначениеРеквизитаИзЗначенияНастройки(ЗначениеНастройки, ЗначениеРеквизита)
	
	Если ТипЗнч(ЗначениеРеквизита) = Тип("ДанныеФормыКоллекция") Тогда
		
		ЗначениеРеквизита.Очистить();
		Если ТипЗнч(ЗначениеНастройки) = Тип("Соответствие")
		    ИЛИ ТипЗнч(ЗначениеНастройки) = Тип("Массив") Тогда
			
			Для Каждого ЗначениеЭлементаНастройки Из ЗначениеНастройки Цикл
				ЗаполнитьЗначенияСвойств(ЗначениеРеквизита.Добавить(), ЗначениеЭлементаНастройки);
			КонецЦикла;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ЗначениеРеквизита) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		
		Если ТипЗнч(ЗначениеНастройки) = Тип("НастройкиКомпоновкиДанных") Тогда
			ЗначениеРеквизита.ЗагрузитьНастройки(ЗначениеНастройки);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ЗначениеРеквизита) = Тип("СписокЗначений") Тогда
		
		Если ТипЗнч(ЗначениеНастройки) = Тип("СписокЗначений") Тогда
			ЗначениеРеквизита = ЗначениеНастройки;
			ЗначениеРеквизита.ТипЗначения = Новый ОписаниеТипов("Строка");
		КонецЕсли;
		
	Иначе
		ЗначениеРеквизита = ЗначениеНастройки;
	КонецЕсли;
	
КонецПроцедуры

// Заполнить значение настройки из значения реквизита.
// 
// Параметры:
//  ЗначениеНастройки - Произвольный - Значение настройки
//  ЗначениеРеквизита - Произвольный - Значение реквизита
&НаСервере
Процедура ЗаполнитьЗначениеНастройкиИзЗначенияРеквизита(ЗначениеНастройки, ЗначениеРеквизита)
	
	ТипЗначенияНастройки = ТипЗнч(ЗначениеНастройки);
	ТипЗначенияРеквизита = ТипЗнч(ЗначениеРеквизита);
	
	Если ТипЗначенияРеквизита = Тип("ДанныеФормыКоллекция") Тогда
		
		Если ТипЗначенияНастройки = Тип("Соответствие") Тогда
			
			ЗначениеНастройкиСоответствием = ЗначениеНастройки; //Соответствие
			ЗначениеРеквизитаСоответствием = ЗначениеРеквизита; //Соответствие
			
			ЗначениеНастройкиСоответствием.Очистить();
			Для Каждого СрокаРеквизита Из ЗначениеРеквизитаСоответствием Цикл
				ЗначениеНастройкиСоответствием.Вставить(СрокаРеквизита.Ключ, СрокаРеквизита.Значение);
			КонецЦикла;
		
		ИначеЕсли ТипЗначенияНастройки = Тип("Массив") Тогда
			
			ТаблицаРеквизита  = ЗначениеРеквизита; //ДанныеФормыКоллекция
			ЗначениеНастройки = ОбщегоНазначения.ТаблицаЗначенийВМассив(ТаблицаРеквизита.Выгрузить());
			
		КонецЕсли;
		
	ИначеЕсли ТипЗначенияНастройки = Тип("НастройкиКомпоновкиДанных") Тогда
		
		Если ТипЗначенияРеквизита = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
			КомпоновщикНастроек = ЗначениеРеквизита; //КомпоновщикНастроекКомпоновкиДанных
			ЗначениеНастройки = КомпоновщикНастроек.Настройки; //НастройкиКомпоновкиДанных
		КонецЕсли;
		
	Иначе
		
		ЗначениеНастройки = ЗначениеРеквизита;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗначенияРеквизитовФормы()
	
	РеквизитыФормы     = ПолучитьРеквизиты();
	ЗначенияРеквизитов = Новый Структура;
	
	Для Каждого РеквизитФормы Из РеквизитыФормы Цикл
		ЗначенияРеквизитов.Вставить(РеквизитФормы.Имя, ЭтотОбъект[РеквизитФормы.Имя]);
	КонецЦикла;
	
	Возврат ЗначенияРеквизитов;
	
КонецФункции

// Настройки расширения из формы.
// 
// Возвращаемое значение:
//  см. СинхронизироватьНастройкиИРеквизитыФормы.НастройкиРасширения
&НаСервере
Функция НастройкиРасширенияИзФормы()
	
	НастройкиРасширения = Неопределено;
	СинхронизироватьНастройкиИРеквизитыФормы(Ложь, НастройкиРасширения);
	Возврат НастройкиРасширения;
	
КонецФункции

&НаСервере
Процедура СохранитьНастройки()
	
	НастройкиРасширения = НастройкиРасширенияИзФормы();
	ДСП_Сервер.ЗаписатьНастройкиРасширения(НастройкиРасширения);
	
КонецПроцедуры

#КонецОбласти

#Область Отображение

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЭлементыФормы(Форма)
	
	Элементы = Форма.Элементы;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, 
		"ГруппаОценкаПроизводительностиНастройки", 
		"ТолькоПросмотр", 
		НЕ Форма.Настройки_ОценкаПроизводительности_Использовать);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, 
		"ГруппаВариантыОтчетовНастройки", 
		"ТолькоПросмотр",
		НЕ Форма.Настройки_ВариантыОтчетов_Использовать);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти