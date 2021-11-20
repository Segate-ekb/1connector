// BSLLS:ExportVariables-off
Перем ПулСоединений; // Объект для хранения пула соединений
Перем МаксимальноеВремяПростоя; // Время неиспользования соединения, после которого оно удаляется из пула
// BSLLS:ExportVariables-on

Процедура ПриСозданииОбъекта()

	ПулСоединений = Новый Соответствие;

	МаксимальноеВремяПростоя = 60;

КонецПроцедуры

Функция Получить(ПараметрыСоединения) Экспорт

	ИдентификаторСоединения = ИдентификаторСоединения(ПараметрыСоединения);

	Если ПулСоединений.Получить(ИдентификаторСоединения) = Неопределено Тогда
		Соединение = Новый HTTPСоединение(
			ПараметрыСоединения.Схема + "://" + ПараметрыСоединения.Сервер,
			ПараметрыСоединения.Порт,
			ПараметрыСоединения.Пользователь, ПараметрыСоединения.Пароль,
			ПараметрыСоединения.Прокси, 
			ПараметрыСоединения.Таймаут);
		Соединение.РазрешитьАвтоматическоеПеренаправление = Ложь;
		
		НовоеСоединение = Новый Структура("Соединение, Использовано", Соединение, ТекущаяУниверсальнаяДата());
		ПулСоединений.Вставить(ИдентификаторСоединения, НовоеСоединение);
	Иначе
		Соединение = ПулСоединений[ИдентификаторСоединения].Соединение;
		ПулСоединений[ИдентификаторСоединения].Использовано = ТекущаяУниверсальнаяДата();
	КонецЕсли;

	ЗакрытьСтарыеСоединения();

	Возврат Соединение;

КонецФункции

Процедура ЗакрытьСтарыеСоединения()

	КлючиДляУдаления = Новый Массив;
	ТекущееВремя = ТекущаяУниверсальнаяДата();
	Для Каждого КлючЗначение Из ПулСоединений Цикл
		Если (ТекущееВремя - КлючЗначение.Значение.Использовано) > МаксимальноеВремяПростоя Тогда
			КлючиДляУдаления.Добавить(КлючЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;

	Для Каждого Ключ Из КлючиДляУдаления Цикл
		ПулСоединений.Удалить(Ключ);
	КонецЦикла;

КонецПроцедуры

Функция ИдентификаторСоединения(ПараметрыСоединения)
	
	ПараметрыДляРасчета = Новый Массив;
	ПараметрыДляРасчета.Добавить(ПараметрыСоединения.Схема + "://" + ПараметрыСоединения.Сервер);
	ПараметрыДляРасчета.Добавить(ПараметрыСоединения.Порт);
	ПараметрыДляРасчета.Добавить(ПараметрыСоединения.Пользователь);
	ПараметрыДляРасчета.Добавить(ПараметрыСоединения.Пароль);
	Если ТипЗнч(ПараметрыСоединения.Прокси) = Тип("ИнтернетПрокси") Тогда
		ПараметрыДляРасчета.Добавить(СтрСоединить(ПараметрыСоединения.Прокси.НеИспользоватьПроксиДляАдресов, ""));
		ПараметрыДляРасчета.Добавить(XMLСтрока(ПараметрыСоединения.Прокси.НеИспользоватьПроксиДляЛокальныхАдресов));
		ПараметрыДляРасчета.Добавить(ПараметрыСоединения.Прокси.Пользователь);
		ПараметрыДляРасчета.Добавить(ПараметрыСоединения.Прокси.Пароль);
	Иначе
		ПараметрыДляРасчета.Добавить(ПараметрыСоединения.Прокси);
	КонецЕсли;
	ПараметрыДляРасчета.Добавить(ПараметрыСоединения.Таймаут);
	
	Возврат КоннекторHTTPСлужебный.ХешированиеДанных(ХешФункция.MD5, СтрСоединить(ПараметрыДляРасчета, ""));
	
КонецФункции
