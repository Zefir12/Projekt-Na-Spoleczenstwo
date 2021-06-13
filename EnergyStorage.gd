extends Node2D

var outputting_energy = true
var accepting_energy = true
var grid_connection_id = null

var type = 'storage'

var stored_energy = 0
export (float) var max_capacity = 10
export (float) var passive_losses = 0
export (float) var releasing_speed = 1
export (float) var storing_speed = 1
export (float) var output_losses = 0

func add_from_to(fromm, to, speed, losses):
	if fromm >= speed:
		to += speed * losses
		fromm -= speed
	else:
		to += fromm * losses
		fromm = 0
	return [fromm, to]

func handle_storing(net_total):
	self.stored_energy -= self.passive_losses
	if self.stored_energy < 0:
		self.stored_energy = 0
	if net_total >= 0:
		return self.store_energy(net_total)
	else:
		return self.release_energy(net_total)

func store_energy(net_totalii):
	var results = add_from_to(net_totalii, self.stored_energy, self.storing_speed, 1)
	var net_total = results[0]
	self.stored_energy = results[1]
	if self.stored_energy > self.max_capacity:
		var difference = self.stored_energy - self.max_capacity
		self.stored_energy -= difference
		net_total += difference
	return net_total

func release_energy(net_totalii):
	var results = add_from_to(self.stored_energy, net_totalii, self.releasing_speed, self.output_losses)
	self.stored_energy = results[0]
	var net_total = results[1]
	if net_total > 0:
		self.stored_energy += net_total
		net_total = 0
	return net_total
