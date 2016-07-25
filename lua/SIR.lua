
--- A Susceptible-Infectious-Recovered (SIR) Model to study epidemics.
-- @arg data.susceptible The initial susceptible population. The default value is 9998.
-- @arg data.infected The initial indected population. The default value is 2.
-- @arg data.recovered The initial recovered population. The default value is 0.
-- @arg data.duration The duration of the disease in days. The default value is 2.
-- @arg data.finalTime The final simulation time, in days. The default value is 30.
-- @arg data.probability The probability of a susceptible person getting infected after
-- a contact with an infected one.
-- @arg data.maximum A threshold of infected people that activates a public policy. The
-- policy asks people to start leaving their houses, which cuts the contacts
-- between people by half.
-- @image sir.bmp
SIR = Model{
	susceptible = 9998,
	infected = 2,
	recovered = 0,
	duration = 2,
	finalTime = 30,
	maximum = math.huge,
	probability = 0.25,
	init = function(model)
		model.chart = Chart{
			target = model,
			select = {"susceptible", "infected", "recovered"},
			color = {"green", "red", "blue"}
		}
	
		model.contacts = 6
	
		model.timer = Timer{
			Event{action = function()
				 local proportion = model.susceptible / 
					 (model.susceptible + model.infected + model.recovered)
				
				 local newInfected = model.infected * model.contacts * model.probability * proportion
	
				 local newRecovered = model.infected / model.duration
				 
				 model.susceptible = model.susceptible - newInfected
				 model.recovered = model.recovered + newRecovered
				 model.infected = model.infected + newInfected - newRecovered
			end},
			Event{action = function()
				if model.infected >= model.maximum then
					model.contacts = model.contacts / 2
					return false
				end
			end},
			Event{action = model.chart}
		}
	end
}

