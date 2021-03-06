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

	if !is_number(tiempo_estimado.to_f)
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

	year = fecha_vencimiento[0..3]
	month = fecha_vencimiento[5..6]
	day = fecha_vencimiento[8..9]
	_fecha_vencimiento = year + month + day

	return [
		numero_guia,
		cliente,
		zona,
		tiempo_estimado.to_f,
		_fecha_vencimiento,
		prioridad.to_i,
		ordering_column([_fecha_vencimiento, prioridad, tiempo_estimado])
	]
end

def ordering_column(values)
	column_value = values[0]
	for i in 1..values.size - 1
		column_value += values[i]
	end
	return column_value
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
		prioridad = input( "Ingrese prioridad. (1=Alta, 2=Media, 3=Baja)")

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
	when 4
		year = data[0..3]
		month = data[4..5]
		day = data[6..7]
		return day + '/' + month + '/' + year
	when 5
		case data
		when 1
			return '1 (Alta)'
		when 2
			return '2 (Media)'
		when 3
			return '3 (Baja)'
		else
			return '-'
		end
	else
		return data
	end
end

def print_row(row_data, limit)
	for i in 0..limit - 1
		value = get_value(i, row_data[i])
		printf "%-18s", value
		if i != limit - 1
			print ' | '
		end
	end
	puts
end

def print_rows(rows, limit)
	for j in 0..rows.size - 1
		print_row(rows[j], limit)
	end
end

def print_table(headers, data, data_split)
	puts print_line(19)
	print_headers(headers)
	puts print_line(19)
	if data_split.size != 0
		for split in 0..data_split.size - 1
			puts data_split[split]
			puts print_line(19)
			print_rows(data[split], headers.size)
			puts print_line(19)
		end
	else
		print_rows(data, headers.size)
		puts print_line(19)
	end
	puts 'Mostrando ' + data.size.to_s + '/' + $planilla.size.to_s + ' resultados'
	puts print_line(19)
	puts
end

def add_bulk(guias)
	for i in 0..guias.size - 1
		add_guia_despacho(guias[i])
	end
end

def initialize_data()
	guia9 = create_guia_despacho('T001-00138', '12123455', 'S', '2', '2017-05-31', '3')
	guia1 = create_guia_despacho('T001-00003', '12345678', 'N', '1', '2017-03-06', '3')
	guia14 = create_guia_despacho('T001-00003', '12345678', 'N', '0.5', '2017-03-06', '3')
	guia2 = create_guia_despacho('T001-00006', '31231231', 'S', '1', '2017-03-06', '2')
	guia3 = create_guia_despacho('T001-00013', '14122424', 'S', '3', '2017-03-07', '1')
	guia4 = create_guia_despacho('T001-00020', '34343434', 'S', '1', '2017-03-08', '3')
	guia5 = create_guia_despacho('T001-00300', '12312323', 'N', '3', '2017-03-09', '3')
	guia6 = create_guia_despacho('T001-00018', '24124124', 'N', '1', '2017-03-09', '2')
	guia7 = create_guia_despacho('T001-00190', '15545455', 'N', '1', '2017-03-06', '3')
	guia8 = create_guia_despacho('T001-00138', '12123455', 'S', '2', '2017-05-31', '1')
	guia10 = create_guia_despacho('T001-00136', '12123255', 'S', '2', '2017-05-31', '1')
	guia11 = create_guia_despacho('T001-00132', '12133255', 'N', '3', '2017-04-30', '3')
	guia12 = create_guia_despacho('T001-00134', '12155455', 'S', '1', '2017-04-28', '1')
	guia13 = create_guia_despacho('T001-00190', '12121345', 'N', '2', '2017-05-14', '2')

	add_bulk([
		guia9, guia1, guia2, guia3, guia4, guia5, guia6, guia7, guia8,
		guia10, guia11, guia12, guia13, guia14
	])
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

def ordering(data, position)
	data = data.slice(0, data.size)
	for j in 0..data.size - 1
		for k in j + 1..data.size - 1
			if data[j][position] > data[k][position]
				tmp = data[j]
				data[j] = data[k]
				data[k] = tmp
			end
		end
	end
	return data
end

def ordenar_data(data, columns)
	data_ordered = data.slice(0, data.size)
	for i in 0..columns.size - 1
		if i != 0
			results = []
			last_item = nil

			for l in 0..data_ordered.size - 1
				# puts data_ordered[l][columns[i - 1]]
				# puts last_item
				if last_item != data_ordered[l][columns[i - 1]]
					tmp = []
					tmp.push(data_ordered[l])
					results.push(tmp)
				else
					last_tmp = results.size - 1
					results[last_tmp].push(data_ordered[l])
				end
				last_item = data_ordered[l][columns[i - 1]]
			end

			# puts 'results'
			# print results
			# puts

			tmp2 = []
			for r in 0..results.size - 1
				# puts 'results:' + r.to_s
				# print results[r]
				# puts
				tmp = ordering(results[r], columns[i])
				# puts 'ordering'
				# print tmp
				# puts
				for n in 0..tmp.size - 1
					tmp2.push(tmp[n])
				end
			end
			data_ordered = tmp2
		else
			data_ordered = ordering(data_ordered, columns[i])
		end
	end
	return data_ordered
end

def export_filename(extension)
	print '¿Nombre del archivo?: '
	file_name = gets.chomp
	puts
	return file_name + '.' + extension
end

def table_row_html(row, limit)
	html = ''
	for k in 0..limit - 1
		html += '<td style="text-align: center">' + get_value(k, row[k]) + '</td>'
	end
	return html
end

def table_tbody_html(data, limit)
	html = ''
	for j in 0..data.size - 1
		if j % 2 == 0
			html += '<tr>'
		else
			html += '<tr style="background-color: #ddd">'
		end
		html += table_row_html(data[j], limit)
	end
	html += '</tr>'
	return html
end

def table_html(title, headers, data, split)
	html = '<html><title>' + title + '</title>'
	html += '<body style="font-family: sans-serif, Arial, Helbetica">'
	html += '<h1>Planilla de despacho</h1>'
	html += '<h3>' + title + '</h3>'
	html += '<table style="width: 100%" border="0" cellspacing="0" cellpadding="3">'
	html += '<thead><tr style="background-color: #ccc">'
	for i in 0..headers.size - 1
		html += '<th>' + headers[i] + '</th>'
	end
	html += '</tr></thead>'

	html += '<tbody>'
	if split.size != 0
		for s in 0..split.size - 1
			html += '<tr style="background-color: #bbb">'
			html += '<td colspan="' + headers.size.to_s + '">' + split[s] + '</td></tr>'
			html += table_tbody_html(data, headers.size)
		end
	else
		html += table_tbody_html(data, headers.size)
	end
	html += '<tr><td colspan="' + headers.size.to_s + '" style="text-align: center; background-color: #bbb">' + data.size.to_s + ' registros</td></tr>'
	html += '</tbody>'
	html += '</table>'
	html += '</body>'
	html += '</html>'
end

def export_csv(headers, data, split)
	file_name = export_filename('csv')
	puts 'Exportando ' + file_name + '...'
	require "csv"
	CSV.open(file_name, "wb") do |csv|
		csv << headers
		for i in 0..data.size - 1
			csv << data[i]
		end
	end
	return file_name
end

def export_csv_to_pdf(headers, data, split, title)
	file_name = export_filename('pdf')
	puts 'Exportando ' + file_name + '...'
	require "pdfkit"
	html = table_html(title, headers, data, split)
	kit = PDFKit.new(html, :page_size => 'A4')
	file = kit.to_file(file_name)
	return file_name
end

def print_menu_items()
	puts '1. Mostrar guias'
	puts '2. Ingresar guia de despacho'
	puts '3. Buscar guia por codigo de cliente'
	puts '4. Buscar guia de despacho'
	puts '5. Operaciones de despacho'
	puts '*. Salir'
end

def export_menu(results, title, split)
	if results.size == 0
		return
	end
	while true
		puts 'Opciones: '
		puts '1. Exportar a Excel (CSV)'
		puts '2. Exportar a PDF'
		puts '*. Salir'
		print 'Selecciona una opción: '
		option = gets.chomp
		puts

		case option
		when '1'
			file_name = export_csv($headers, results, split)
			puts 'Archivo ' + file_name + ' exportado correctamente.'
			break;
		when '2'
			file_name = export_csv_to_pdf($headers, results, split, title)
			puts 'Archivo ' + file_name + ' exportado correctamente.'
			break;
		when '*'
			puts 'Cancelar'
			break
		else
			puts 'Opción inválida'
		end
	end
	puts
end

def calculo_horas(data)
	today = []
	tomorrow = []
	pending = []

	hours_today = 0
	hours_tomorrow = 0
	hours_pending = 0

	for i in 0..data.size - 1
		hours = data[i][3]
		if hours_today + hours <= 8
			today.push(data[i])
			hours_today += hours
		elsif hours_tomorrow + hours <= 8
			tomorrow.push(data[i])
			hours_tomorrow += hours
		else
			pending.push(data[i])
			hours_pending += hours
		end
	end
	return [today, tomorrow, pending]
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
			print_table($headers, $planilla, [])
			export_menu($planilla, 'Planilla de despacho', [])
		when '2'
			form_guia_despacho()
		when '3'
			print 'Ingrese un código de cliente a buscar: '
			value = gets.chomp
			puts
			results = buscar_guia_despacho(value, 1)
			print_table($headers, results, [])
			export_menu(results, 'Búsqueda para cliente: ' + value, [])
		when '4'
			print 'Ingrese una guia de despacho a buscar: '
			value = gets.chomp
			puts
			results = buscar_guia_despacho(value, 0)
			print_table($headers, results, [])
			export_menu(results, 'Búsqueda para guia de despacho: ' + value, [])
		when '5'
			puts 'Guias de despacho'
			headers = ['Despachos para hoy', 'Despachos mañana', 'Despachos pendientes']

			while true
				puts 'Zona'
				puts '1. Zona Norte'
				puts '2. Zona Sur'
				puts '*. Cancelar'
				print 'Seleccione Zona: '
				zone = gets.chomp
				puts
				case zone 
				when '1'
					norte = buscar_guia_despacho('N', 2)
					results_norte = ordering(norte, 6)
					calculo_norte = calculo_horas(results_norte)
					puts "Guias despacho - Zona Norte"
					print_table($headers, calculo_norte, headers)	
					export_menu(results_norte, 'Guias despacho - Zona Norte', headers)
				when '2'
					sur = buscar_guia_despacho('S', 2)
					results_sur = ordering(sur, 6)
					puts "Guias despacho - Zona Sur"
					calculo_sur = calculo_horas(results_sur)
					print_table($headers, calculo_sur, headers)
					export_menu(results_sur, 'Guias despacho - Zona Sur', headers)
				when '*'
					puts 'Cancelado'
					break
				else
					puts 'Opción inválida'
				end
			end
		when '*'
			puts 'Salir!'
			break
		else
			puts 'Opción inválida'
		end
	end
end

def main()
	initialize_data()
	show_menu()
end

main()
