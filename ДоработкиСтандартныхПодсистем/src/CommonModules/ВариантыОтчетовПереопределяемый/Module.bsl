
#Область СлужебныеПроцедурыИФункции

&После("НастроитьВариантыОтчетов")
Процедура ДСП_НастроитьВариантыОтчетов(Настройки) Экспорт
	
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДСП_ПримерОтчета);
	
КонецПроцедуры

#КонецОбласти
