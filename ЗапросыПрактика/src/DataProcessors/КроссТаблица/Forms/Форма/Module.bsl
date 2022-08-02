
&НаСервере
Процедура ПоказатьНаСервере(ТабДок)
	Макет = РеквизитФормыВЗначение("Объект").ПолучитьМакет("Макет");
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПродажиОбороты.Период КАК Месяц,
	|	ПродажиОбороты.Контрагент КАК Контрагент,
	|	ПродажиОбороты.СуммаОборот КАК Сумма,
	|	ПРЕДСТАВЛЕНИЕ(ПродажиОбороты.Контрагент) КАК КонтрагентПредставление
	|ИЗ
	|	РегистрНакопления.Продажи.Обороты(, , Месяц, ) КАК ПродажиОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	Месяц
	|ИТОГИ
	|	СУММА(Сумма)
	|ПО
	|	ОБЩИЕ,
	|	Контрагент,
	|	Месяц ПЕРИОДАМИ(МЕСЯЦ, , )";
	РезультатЗапроса = Запрос.Выполнить();
	
	ОбластьШапкаМесяц = Макет.ПолучитьОбласть("Шапка|Месяц");
	ОбластьШапкаКонтрагент = Макет.ПолучитьОбласть("Шапка|Контрагент");
	ОбластьШапкаИтог = Макет.ПолучитьОбласть("Шапка|Итог");
	ОбластьСтрокаМесяц = Макет.ПолучитьОбласть("Строка|Месяц");
	ОбластьСтрокаКонтрагент = Макет.ПолучитьОбласть("Строка|Контрагент");
	ОбластьСтрокаИтог = Макет.ПолучитьОбласть("Строка|Итог");
	ОбластьПодвалМесяц =  Макет.ПолучитьОбласть("Подвал|Месяц");
	ОбластьПодвалКонтрагент = Макет.ПолучитьОбласть("Подвал|Контрагент");
	ОбластьПодвалИтог = Макет.ПолучитьОбласть("Подвал|Итог");
	ТабДок.Вывести(ОбластьШапкаКонтрагент);
	ВыборкаШапкаМесяц = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Месяц", "ВСЕ");
	Пока ВыборкаШапкаМесяц.Следующий() Цикл
		ОбластьШапкаМесяц.Параметры.Заполнить(ВыборкаШапкаМесяц);
		ТабДок.Присоединить(ОбластьШапкаМесяц);
	КОнецЦикла;
	ТабДок.Присоединить(ОбластьШапкаИтог);
	ВыборкаКонтрагент = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Контрагент");
	Пока ВыборкаКонтрагент.Следующий() Цикл
		ОбластьСтрокаКонтрагент.Параметры.Заполнить(ВыборкаКонтрагент);
		ТабДок.Вывести(ОбластьСтрокаКонтрагент);
		ВыборкаМесяц = ВыборкаКонтрагент.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Месяц", "ВСЕ");
		Пока ВыборкаМесяц.Следующий() Цикл
			ОбластьСтрокаМесяц.Параметры.Заполнить(ВыборкаМесяц);
			ТабДок.Присоединить(ОбластьСтрокаМесяц);
			
		КонецЦикла;
		ОбластьСтрокаИтог.Параметры.Заполнить(ВыборкаКонтрагент);
		ТабДок.Присоединить(ОбластьСтрокаИтог);
	КонецЦикла;
	
	ТабДок.Вывести(ОбластьПодвалКонтрагент);
	ВыборкаШапкаМесяц.Сбросить();
	Пока ВыборкаШапкаМесяц.Следующий() Цикл
		
		ОбластьПодвалМесяц.Параметры.Заполнить(ВыборкаШапкаМесяц);
		ТабДок.Присоединить(ОбластьПодвалМесяц);
	КонецЦикла;
	
	ВыборкаОбщийИтог = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Если ВыборкаОбщийИтог.Следующий() Тогда
		ОбластьПодвалИтог.Параметры.Заполнить(ВыборкаОбщийИтог);
		ТабДок.Присоединить(ОбластьПодвалИтог);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Показать(Команда)
	ТабДок = Новый ТабличныйДокумент;
	ПоказатьНаСервере(ТабДок);
	ТабДок.Показать();
КонецПроцедуры
