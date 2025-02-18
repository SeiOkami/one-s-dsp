// @strict-types

#Область СлужебныйПрограммныйИнтерфейс

&После("ПослеФормирования")
Процедура ДСП_ПослеФормирования(ФормаОтчета, ОтчетСформирован) Экспорт
	
	Объект = ДСП_ОбъектВыполненияКлиентскогоСобытия(ФормаОтчета, "ПослеФормирования");
	Если НЕ Объект = Неопределено Тогда
		Объект.ДСП_ПослеФормирования(ФормаОтчета, ОтчетСформирован);
	КонецЕсли;
	
КонецПроцедуры

&После("ОбработкаРасшифровки")
Процедура ДСП_ОбработкаРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт

	Объект = ДСП_ОбъектВыполненияКлиентскогоСобытия(ФормаОтчета, "ОбработкаРасшифровки");
	Если НЕ Объект = Неопределено Тогда
		Объект.ДСП_ОбработкаРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка);
	КонецЕсли;

КонецПроцедуры

&После("ОбработкаДополнительнойРасшифровки")
Процедура ДСП_ОбработкаДополнительнойРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	
	Объект = ДСП_ОбъектВыполненияКлиентскогоСобытия(ФормаОтчета, "ОбработкаДополнительнойРасшифровки");
	Если НЕ Объект = Неопределено Тогда
		Объект.ДСП_ОбработкаДополнительнойРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&После("ОбработчикКоманды")
Процедура ДСП_ОбработчикКоманды(ФормаОтчета, Команда, Результат) Экспорт

	Объект = ДСП_ОбъектВыполненияКлиентскогоСобытия(ФормаОтчета, "ОбработчикКоманды");
	Если НЕ Объект = Неопределено Тогда
		Объект.ДСП_ОбработчикКоманды(ФормаОтчета, Команда, Результат);
	КонецЕсли;

КонецПроцедуры

&После("ПриНачалеВыбораЗначений")
Процедура ДСП_ПриНачалеВыбораЗначений(ФормаОтчета, УсловияВыбора, ОповещениеОЗакрытии, СтандартнаяОбработка) Экспорт

	Объект = ДСП_ОбъектВыполненияКлиентскогоСобытия(ФормаОтчета, "ПриНачалеВыбораЗначений");
	Если НЕ Объект = Неопределено Тогда
		Объект.ДСП_ПриНачалеВыбораЗначений(ФормаОтчета, УсловияВыбора, ОповещениеОЗакрытии, СтандартнаяОбработка);
	КонецЕсли;

КонецПроцедуры

&После("ОбработкаВыбора")
Процедура ДСП_ОбработкаВыбора(ФормаОтчета, ВыбранноеЗначение, ИсточникВыбора, Результат) Экспорт

	Объект = ДСП_ОбъектВыполненияКлиентскогоСобытия(ФормаОтчета, "ОбработкаВыбора");
	Если НЕ Объект = Неопределено Тогда
		Объект.ДСП_ОбработкаВыбора(ФормаОтчета, ВыбранноеЗначение, ИсточникВыбора, Результат);
	КонецЕсли;

КонецПроцедуры

&После("ОбработкаВыбораТабличногоДокумента")
Процедура ДСП_ОбработкаВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка) Экспорт
	
	Объект = ДСП_ОбъектВыполненияКлиентскогоСобытия(ФормаОтчета, "ОбработкаВыбораТабличногоДокумента");
	Если НЕ Объект = Неопределено Тогда
		Объект.ДСП_ОбработкаВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&После("ОбработкаОповещения")
Процедура ДСП_ОбработкаОповещения(ФормаОтчета, ИмяСобытия, Параметр, Источник, ОповещениеОбработано) Экспорт
	
	Объект = ДСП_ОбъектВыполненияКлиентскогоСобытия(ФормаОтчета, "ОбработкаОповещения");
	Если НЕ Объект = Неопределено Тогда
		Объект.ДСП_ОбработкаОповещения(ФормаОтчета, ИмяСобытия, Параметр, Источник, ОповещениеОбработано);
	КонецЕсли;
	
КонецПроцедуры

&После("ПриНажатииКнопкиВыбораПериода")
Процедура ДСП_ПриНажатииКнопкиВыбораПериода(ФормаОтчета, Период, СтандартнаяОбработка, ОбработчикРезультата) Экспорт

	Объект = ДСП_ОбъектВыполненияКлиентскогоСобытия(ФормаОтчета, "ПриНажатииКнопкиВыбораПериода");
	Если НЕ Объект = Неопределено Тогда
		Объект.ДСП_ПриНажатииКнопкиВыбораПериода(ФормаОтчета, Период, СтандартнаяОбработка, ОбработчикРезультата);
	КонецЕсли;

КонецПроцедуры

// Описание общей формы отчета.
// @skip-check module-unused-method - интерфейс формы
// 
// Возвращаемое значение:
//  ФормаКлиентскогоПриложения:
//  * НастройкиОтчета - см. ВариантыОтчетов.НастройкиФормыОтчета
//
Функция ДСП_ОписаниеОбщейФормыОтчета() Экспорт
	
	Возврат ОткрытьФорму("ОбщаяФорма.ФормаОтчета");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Объект выполнения клиентского события
// В качестве вовзращаемого значения в описании указан текущий модуль, чтобы ЕДТ видела доступные методы событий
// 
// Параметры:
//  ФормаОтчета - см. ДСП_ОписаниеОбщейФормыОтчета
//  ИмяОбработчика - Строка
// 
// Возвращаемое значение:
//  CommonModule.ОтчетыКлиентПереопределяемый
Функция ДСП_ОбъектВыполненияКлиентскогоСобытия(ФормаОтчета, ИмяОбработчика)
	
	НастройкиОтчета = ВариантыОтчетовКлиентСервер.ДСП_НастройкиОтчета(ФормаОтчета);
	Если НастройкиОтчета = Неопределено
		ИЛИ НЕ ЗначениеЗаполнено(НастройкиОтчета.ФормаКлиентскихСобытий) 
		ИЛИ НЕ НастройкиОтчета.События[ИмяОбработчика] Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПолноеИмяФормы = СтрШаблон("%1.Форма.%2", 
		ФормаОтчета.НастройкиОтчета.ПолноеИмя, 
		НастройкиОтчета.ФормаКлиентскихСобытий);
	
	//@skip-check use-non-recommended-method - форма не открывается и используется как обработчик событий
	Возврат ПолучитьФорму(ПолноеИмяФормы,,ФормаОтчета);
	
КонецФункции

#КонецОбласти
