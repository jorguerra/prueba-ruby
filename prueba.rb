def mostrar_menu
  puts '---- MENU ----'
  puts '1. Generar archivo'
  puts '2. Cantidad de inasistencias'
  puts '3. Mostrar los nombres de alumnos aprobados'
  puts '4. Salir'
  print 'Ingrese una opción:  '
  gets.chomp.to_i
end

def get_promedio(notas)
  values = []
  notas.each do |nota|
    values.push(nota.to_i) if nota.to_i > 0
    values.push(1) if nota.to_i.zero? # Si es A(ausente) asigna un 1
  end
  values.length.zero? ? nil : values.sum / values.length
end

def guardar_promedio
  file = File.open('data.txt', 'r')
  lineas = file.readlines
  file.close
  file_promedios = File.open('promedios.txt', 'w')
  lineas.each do |linea|
    data = linea.split(',')
    promedio = get_promedio(data[1..data.length])
    file_promedios.puts("#{data[0]} #{promedio}")
  end
  file_promedios.close
end

def ausentes
  file = File.open('data.txt', 'r')
  lineas = file.readlines
  file.close
  alumnos = {}
  lineas.each do |linea|
    data = linea.split(',')
    largo = data.length
    total = data[1..largo].inject(0) { |acc, n| acc + (n.strip == 'A' ? 1 : 0) }
    alumnos[data[0]] = total
  end
  alumnos
end

def aprobados(minima = 5)
  # Ejecuto guardar promedio para corrobar que el archivo con promedios exista
  guardar_promedio
  promedios = File.open('promedios.txt')
  lineas = promedios.readlines
  promedios.close
  aprobacion = {}
  lineas.each do |linea|
    aprobacion[linea.split[0]] = linea.split[1].to_i >= minima
  end
  aprobacion
end

salir = false

until salir
  print "\n"
  op = mostrar_menu
  while op.zero? || op > 4
    puts 'Ingrese una opción válida'
    op = mostrar_menu
  end
  puts "\n" if (1..4).to_a.include?(op.to_i)

  case op
  when 1
    guardar_promedio
    puts 'Se generó el archivo promedios.txt con el promedio de cada alumno'
  when 2
    alumnos = ausentes
    alumnos.each do |alumno, ausencias|
      puts "#{alumno} asistió a todas las pruebas" if ausencias.zero?
      prueba = 'prueba' + (ausencias.to_i > 1 ? 's' : '')
      puts "#{alumno} estuvo ausente en #{ausencias} #{prueba}" if ausencias > 0
    end
  when 3
    print 'Ingrese la nota mínima para aprobar (5 por defecto): '
    valor = gets.chomp.strip
    minima = valor.length.zero? ? 5 : valor.to_i
    until minima > 0
      print "Valor inválido. Ingrese un número mayor a 0\n" \
            'Ingrese la nota mínima para aprobar (5 por defecto): '
      valor = gets.chomp.strip
      minima = valor.length.zero? ? 5 : valor.to_i
    end
    alumnos = aprobados(minima)
    alumnos.each do |alumno, aprobo|
      puts "#{alumno} aprobó" if aprobo
      puts "#{alumno} reprobó" unless aprobo
    end
  when 4
    salir = true
  end
end
