# SNAKE GAME CDM8

	asect 0x00

start:
	setsp 0xaf 
	jsr spawn_apple     # создание яблока в начале игры
	jsr move_head       # перемещение головы
	ldi r3, 0xfd        # установка регистра выбора в 1
	ldi r2, 1
	st r3, r2
	ldi r3, 0xf9        # переключение экрана на основной игровой
	ldi r2, 1
	st r3, r2

main:
	jsr move_head     # работа с головой
	jsr move_tail     # работа с хвостом
	br main           # возврат в начало основного цикла

# подпрограммы
	move_head: # подпрограмма перемещения головы
		# считывание направления
		ldi r2, 0xee
		ld r2, r2
		# сохранение направления в память
		jsr load_direction_to_mem
		# перемещение координат головы
		ldi r3, 0xfa
		st r3, r2
		# проверка, съедено ли яблоко
		if	
			# запрос к Logisim
			ldi r3, 0xef
			ld r3, r3
			tst r3
		is nz # если яблоко съедено
			jsr spawn_apple
			br move_head # возврат к началу подпрограммы
		else
			# проверка столкновения
			ldi r3, 0xff
			ldi r2, 1
			st r3, r2
			ldi r3, 0xff
			ldi r2, 0
			st r3, r2
		fi
		ldi r3, 0xfd    # отрисовка пикселя с новыми координатами
		ldi r2, 0       # установка регистра выбора в 0
		st r3, r2
		rts
		
	move_tail:
		jsr take_direction_from_mem    # считывание направления
		ldi r2, 0xfb                   # перемещение координат хвоста
		st r2, r3
		ldi r3, 0xfd                   # стирание пикселя с текущими координатами хвоста
		ldi r2, 1                      # установка регистра выбора в 1
		st r3, r2
		rts
		
	spawn_apple: # подпрограмма создания яблока
		# запрос к Logisim для генерации новых координат
		ldi r3, 0xfc
		ldi r2, 1
		st r3, r2
		ldi r3, 0xfc
		ldi r2, 0
		st r3, r2
		ldi r3, 0xfd         # отрисовка пикселя-яблока
		ldi r2, 2            # установка регистра выбора в 2
		st r3, r2
		rts
		
	load_direction_to_mem:
		# r2 - направление
		# сохранение в стек
		push r2
		# запрос адреса в памяти у Logisim
		ldi r1, 0xe6
		ld r1, r1
		# сохранение координат в строке памяти
		# очистка направления в ячейке
		ldi r3, 0xea
		ld r3, r3
		# инверсия битов
		not r3
		# маскирование для удаления старого направления
		ld r1, r0
		and r3, r0
		# перемещение направления в нужное место
		ldi r2, 0xec
		ld r2, r2
		# объединение в строке данных
		or r2, r0
		# сохранение в ОЗУ
		st r1, r0
		# восстановление из стека
		pop r2
		rts
		
	take_direction_from_mem:
		# запрос адреса в памяти у Logisim
		ldi r1, 0xe7
		ld r1, r1
		# извлечение направления из строки данных
		ldi r3, 0xeb
		ld r3, r3
		# маскирование лишней информации в строке (через AND)
		ld r1, r0
		and r0, r3
		# загрузка строки данных в Logisim
		ldi r2, 0xfe
		st r2, r3 
		# загрузка направления для хвоста
		ldi r3, 0xed
		ld r3, r3
		rts
end
