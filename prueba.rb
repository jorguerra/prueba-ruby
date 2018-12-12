def mostrar_menu
  puts '---- MENU ----'
  puts '1. Generar archivo'
  puts '2. Cantidad de inasistencias'
  puts '3. Mostrar los nombres de alumnos aprobados'
  puts '4. Salir'
  print 'Ingrese una opción:  '
  gets.chomp.to_i
end

def get_alumno_promedio(notas)
  values = []
  notas.each do |nota|
    values.push(nota.to_i) if nota.to_i > 0
    values.push(1) if nota.to_i == 0 # Si es A(ausente) asigna un 1
  end

  return values.length.zero? ? nil : values.sum / values.length

end

def guardar_promedio
  file = File.open('data.txt', 'r')
  lineas = file.readlines
  file.close

  file_promedios = File.open('promedios.txt', 'w')
  lineas.each do |linea|
    data = linea.split(',')
    nombre = data[0]
    promedio = get_alumno_promedio(data[1..data.length])
    file_promedios.puts("#{nombre} #{promedio}")
  end
  file_promedios.close
end

salir = false

until salir
  op = mostrar_menu
  while op.zero? || op > 4
    puts "Ingrese una opción válida"
    op = mostrar_menu
  end

  case op
  when 1
    guardar_promedio
    puts 'Se generó el archivo promedios.txt con el promedio de cada alumno'
    #    when 2
    #    when 3
  when 4
    salir = true
  end
end
