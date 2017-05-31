$planilla = []

def is_number(value)
	return value.is_a? Numeric
end

def is_date_format(value)
	if value.size != 10
		return false
	end

	year = value[0..3].to_i
	month = value[5..6].to_i
	day = value[8..9].to_i

	if is_number(year) and is_number(month) and is_number(day)
		return true
	end
	return false
end

def showErrors(errors)
	puts "ERROR!"
	for i in 0..errors.size - 1
		puts ' - ' + errors[i]
	end
end

def createGuiaDespacho(numero_guia, cliente, zona, tiempo_estimado, fecha_vencimiento, prioridad)
	errors = []
	if !['N', 'S'].index zona
		errors.push("La zona " + zona + " es inválida. (N, S)")
	end

	if !is_number(tiempo_estimado.to_i)
		errors.push("El tiempo estimado tiene que ser numerico.")
	end

	if !is_number(prioridad.to_i) or (is_number(prioridad) and ![1, 2, 3].index prioridad.to_i)
		errors.push("La prioridad tiene que ser numerica. (1, 2, 3)")
	end

	if !is_date_format(fecha_vencimiento)
		errors.push("La fecha '" + fecha_vencimiento + "' no tiene formato válido. (yyyy-mm-dd)")
	end

	if errors.size > 0
		showErrors(errors)
		return nil
	end

	puts "Agregado correctamente"
	return [numero_guia, cliente, zona, tiempo_estimado, fecha_vencimiento, prioridad]
end

def input(message)
	puts message
	input = gets.chomp
	return input
end

def addGuiaDespacho()
	puts "Agregar guia de despacho:"

	guia_despacho = nil
	while guia_despacho == nil
		numero_guia = input("Ingrese numero guia. (ABC0001)")
		codigo_cliente = input( "Ingrese codigo cliente. (00001)")
		zona = input( "Ingrese zona (N, S)")
		tiempo_estimado = input( "Ingrese tiempo estimado. (hrs)")
		fecha_vencimiento = input( "Ingrese fecha de vencimiento. (yyyy-mm-dd)")
		prioridad = input( "Ingrese prioridad. (1=baja, 2=media, 3=alta)")

		guia_despacho = createGuiaDespacho(
			numero_guia, codigo_cliente, zona,
			tiempo_estimado, fecha_vencimiento, prioridad)
	end
	$planilla.push(guia_despacho)
end

addGuiaDespacho()
