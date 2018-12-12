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
  lineas.each do |linea|
    data = linea.split(',')
    total = data[1..data.length].inject(0) do |acc, n|
      acc + (n.strip == 'A' ? 1 : 0)
    end
    puts "#{data[0]} asistió a todas las pruebas" if total.zero?
    prueba = 'prueba' + (total.to_i > 1 ? 's' : '')
    puts "#{data[0]} estuvo ausente en #{total} #{prueba}" if total > 0
  end
end


salir = false

until salir
  print "\n"
  op = mostrar_menu
  while op.zero? || op > 4
    puts "Ingrese una opción válida"
    op = mostrar_menu
  end
  puts "\n" if (1..4).to_a.include?(op.to_i)

  case op
  when 1
    guardar_promedio
    puts 'Se generó el archivo promedios.txt con el promedio de cada alumno'
  when 2
    ausentes
    #    when 3
  when 4
    salir = true
  end
end
