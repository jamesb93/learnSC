({
	var sweep, synth, trig, back, freqs;

	trig = Delay2.ar(Impulse.ar(1));
	sweep = (Env([0,1], [0.01]).ar*(1-Sweep.ar(trig, 0.25).clip(0,1))).linexp(0,1,0.001,1)**8;

	synth = Array.fill(5, {|i|
		var sweep0 = LagUD.ar(sweep, 0.001*i, 1/SampleRate.ir);
		var sine = SinOsc.ar((i*1.5+2)*sweep0.linlin(0,1,60.5.midicps/4,60.5.midicps*8), 0, 0.2);
		sine*sweep0
	});
	synth = Splay.ar(TScramble.ar(synth, trig))
	+Splay.ar(Delay1.ar(TScramble.ar(synth, trig)))
	+Splay.ar(Delay2.ar(TScramble.ar(synth, trig)));

	synth+DelayC.ar(synth, 0.026, 0.026, 0.05)
}.play)