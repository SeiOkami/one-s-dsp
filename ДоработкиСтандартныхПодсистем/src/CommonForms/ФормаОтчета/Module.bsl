
#Область СлужебныеПроцедурыИФункции

&Перед("ПослеФормирования")
&НаКлиенте
Процедура ДСП_ПослеФормирования(Результат, ПараметрыФормирования) Экспорт
	
	//Тот случай, когда БСП теряет замеры при слишком быстром формировании отчета
	Если ФоновоеЗаданиеИдентификатор <> ПараметрыФормирования.ИдентификаторЗадания Или Не Открыта() Тогда
		
		ВыполнятьЗамеры = НастройкиОтчета.ВыполнятьЗамеры И ЗначениеЗаполнено(НастройкиОтчета.КлючЗамеров);
		Если ВыполнятьЗамеры Тогда
			
			НастройкиПодсистемы = ДСП_КлиентСервер.НастройкиРасширения().ОценкаПроизводительности;
			Если НастройкиПодсистемы.Использовать 
				И НастройкиПодсистемы.ФиксироватьБыстрыеФормированияОтчетов Тогда

				МодульОценкаПроизводительностиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиент");
				МодульОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(ИдентификаторЗамера);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
