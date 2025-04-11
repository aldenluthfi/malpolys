extends "res://scripts/towers/tower.gd"

func f(g):
	if level == 1:
		return func (x): return g.call(x) - 1
	if level == 2:
		return func (x): return g.call(x) - 2
	if level == 3:
		return func (x): return g.call(x) - 3
