class Persona {
	const property nombre
	const enfermedades = []
	var property temperatura = 36
	var celulas = 3000000
	
	method contraer(enfermedad) { enfermedades.add(enfermedad) }
	method vivir() { enfermedades.forEach({ enfermedad => enfermedad.producirEfecto(self) })}
	method aumentarTemperaturaEn(aumento) { temperatura += aumento }
	method destruirCelulas(_celulas) { celulas -= _celulas}
	method enfermedadesSinCurar() = enfermedades.filter({ enfermedad => ! enfermedad.curada() })
	method tomar(dosis) {
		self.enfermedadesSinCurar().forEach({ enfermedad => enfermedad.atenuar(dosis)})
	}
}

object hipotermia {
	method producirEfecto(persona) {
		persona.temperatura(0)
	}

	method esAgresiva(persona) = true

	method curada() {
		self.error("no implementado aun, consultar con el analista")
	}

	method atenuar(dosis) {
		// el medicamento no la afecta
	}
}

class Medico inherits Persona {
	var property puesto
	
	override method contraer(enfermedad) {
		 super(enfermedad)
		 self.atenderA(self)
	}
	
	method atenderA(persona) {
		puesto.atenderA(persona)
	}
	
}

class PuestoBase {
	const dosis
	
	method atenderA(persona) {
		persona.tomar(dosis)
	}
}

class JefeMedico {
	const equipo = #{ }

	method atenderA(persona) {
		equipo.anyOne().atenderA(persona)
	}
}

class EnfermedadCelular {
	
	var celulasAmenazadas
	
	method atenuar(dosis) {
		if (self.curada())
			throw new Exception(message = "Enfermedad ya curada")
			
		celulasAmenazadas = 0.max(celulasAmenazadas - dosis * 15)
	}
	
	method curada() = celulasAmenazadas == 0
	
	method producirEfecto(persona)
	method esAgresiva(persona)

}

class EnfermedadInfecciosa inherits EnfermedadCelular {
		
	override method producirEfecto(persona) {
		persona.aumentarTemperaturaEn(celulasAmenazadas / 1000)
	}

	method reproducir() {
		celulasAmenazadas += celulasAmenazadas * 2
	}
	
	override method esAgresiva(persona) = celulasAmenazadas > 0.1 + persona.celulas()

}

class EnfermedadAutoinmune inherits EnfermedadCelular {
	var cantidadEfectos = 0
	
	override method producirEfecto(persona) {
		persona.destruirCelulas(celulasAmenazadas)
		cantidadEfectos += 1
	}
	
	override method esAgresiva(persona) = cantidadEfectos > 30
	
}