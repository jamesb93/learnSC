// function for wave terrain example

f = { |x, y| sin(x) - (sin(y) * log(x * x + 1)) / 10 };

// check the surface produced by the function with GeoGebra

// copy and paste this syntax into GeoGebra Input, it needs ln for the natural logarithm
// (sin(x) - (sin(y) * ln(x * x + 1))) / 10


// circular path through the terrain, mouse control for distance from origin

(
x = {
	var r = MouseX.kr(0, 25);
	// stereo expansion
	var phi = LFSaw.ar([50, 50.1], -1).range(0, 2pi);
	var x = r * cos(phi);
	var y = r * sin(phi);
	Limiter.ar(f.(x, y), 0.2)
}.play
)

x.release