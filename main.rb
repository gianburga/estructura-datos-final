$planilla = []
$headers = ['Numero de guía', 'Cliente', 'Zona', 'Tiempo estimado', 'Vencimiento', 'Prioridad']

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

def create_guia_despacho(numero_guia, cliente, zona, tiempo_estimado, fecha_vencimiento, prioridad)
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
	return [numero_guia, cliente, zona, tiempo_estimado.to_i, fecha_vencimiento, prioridad.to_i]
end

def input(message)
	puts message
	input = gets.chomp
	return input
end

def add_guia_despacho(guia_despacho)
	$planilla.push(guia_despacho)
end

def form_guia_despacho()
	puts "Agregar guia de despacho:"

	guia_despacho = nil
	while guia_despacho == nil
		numero_guia = input("Ingrese numero guia. (ABC0001)")
		codigo_cliente = input( "Ingrese codigo cliente. (00001)")
		zona = input( "Ingrese zona (N, S)")
		tiempo_estimado = input( "Ingrese tiempo estimado. (hrs)")
		fecha_vencimiento = input( "Ingrese fecha de vencimiento. (yyyy-mm-dd)")
		prioridad = input( "Ingrese prioridad. (1=baja, 2=media, 3=alta)")

		guia_despacho = create_guia_despacho(
			numero_guia, codigo_cliente, zona,
			tiempo_estimado, fecha_vencimiento, prioridad)
	end
	puts "Guia #" + numero_guia + " correctamente"
	add_guia_despacho(guia_despacho)
	return numero_guia
end

def get_index_guia_despacho(numero_guia)
	for i in 0..$planilla.size - 1
		if $planilla[i][0] == numero_guia
			return i
		end
	end
	return -1
end

def print_line(size)
	return '-' * size * 6
end

def print_headers(headers)
	for i in 0..headers.size - 1
		printf "%-18s", headers[i]
		if i != headers.size - 1
			print ' | '
		end
	end
	puts
end

def get_value(id_row, data)
	case id_row
	when 2
		case data
		when 'S'
			return 'Sur'
		when 'N'
			return 'Norte'
		else
			return '-'
		end
	when 3
		return data.to_s + ' horas'	
	when 5
		case data
		when 1
			return '1 (Baja)'
		when 2
			return '2 (Media)'
		when 3
			return '3 (Alta)'
		else
			return '-'
		end
	else
		return data
	end
end

def print_row(row_data)
	for i in 0..row_data.size - 1
		value = get_value(i, row_data[i])
		printf "%-18s", value
		if i != row_data.size - 1
			print ' | '
		end
	end
	puts
end

def print_table(headers, data)
	puts print_line(19)
	print_headers(headers)
	puts print_line(19)
	for j in 0..data.size - 1
		print_row(data[j])
	end
	puts print_line(19)
	puts 'Mostrando ' + data.size.to_s + '/' + $planilla.size.to_s + ' resultados'
	puts print_line(19)
	puts
end

def initialize_data()
	guia1 = create_guia_despacho('T001-00003', '12345678', 'N', '1', '2017-03-06', '3')
	guia2 = create_guia_despacho('T001-00006', '31231231', 'S', '6', '2017-03-06', '2')
	guia3 = create_guia_despacho('T001-00013', '14122424', 'S', '7', '2017-03-07', '1')
	guia4 = create_guia_despacho('T001-00020', '34343434', 'S', '1', '2017-03-08', '3')
	guia5 = create_guia_despacho('T001-00300', '12312323', 'N', '3', '2017-03-09', '3')
	guia6 = create_guia_despacho('T001-00018', '24124124', 'N', '4', '2017-03-09', '2')
	guia7 = create_guia_despacho('T001-00190', '15545455', 'N', '1', '2017-03-06', '3')
	guia8 = create_guia_despacho('T001-00138', '12123455', 'S', '3', '2017-03-06', '1')

	add_guia_despacho(guia1)
	add_guia_despacho(guia2)
	add_guia_despacho(guia3)
	add_guia_despacho(guia4)
	add_guia_despacho(guia5)
	add_guia_despacho(guia6)
	add_guia_despacho(guia7)
	add_guia_despacho(guia8)
end

def buscar_guia_despacho(value, column)
	results = []
	for i in 0..$planilla.size - 1
		if $planilla[i][column].index value
			results.push($planilla[i])
		end
	end
	return results
end

def print_menu_items()
	puts '1. Mostrar guias'
	puts '2. Ingresar guia de despacho'
	puts '3. Buscar guia'
	puts '4. Operaciones de despacho'
	puts '*. Salir'
end

def show_menu()
	option = nil
	while true
		puts 'Engels Merkel'
		print_menu_items()
		print 'Escoja una opción del menú: '
		option = gets.chomp
		case option
		when '1'
			print_table($headers, $planilla)
		when '2'
			form_guia_despacho()
		when '3'
			print 'Ingrese un código de cliente a buscar: '
			value = gets.chomp
			puts
			results = buscar_guia_despacho(value, 1)
			print_table($headers, results)
		else
			puts 'Salir!'
			break
		end
	end
end

def main()
	initialize_data()
	show_menu()
end

main()
