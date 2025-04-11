extends "res://scripts/towers/tower.gd"

func f(g):
	var rng = RandomNumberGenerator.new()
	if level == 1:
		return func (x): return ceil(g.call(x)) % rng.randi_range((x/2) + 1, x)
	if level == 2:
		return func (x): return ceil(g.call(x)) % rng.randi_range((x/3) + 1, x/2)
	if level == 3:
		return func (x): return ceil(g.call(x)) % rng.randi_range((x/4) + 1, x/3)
