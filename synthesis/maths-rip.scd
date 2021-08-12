({
	var dur_up_down = MouseX.kr(1,5);
	var ctl_maths = Maths2.ar(dur_up_down,dur_up_down, 0.9);

	var trig_rate = ctl_maths[0].linexp(0,1,5,50);
	var trig = Impulse.kr(trig_rate);

	var snd_maths0 = Maths2.ar(0.001, min(0.2, 1/trig_rate), 0.99, 0, 1, trig)[0];
	var freq0 = snd_maths0.linlin(0,1,50,300);
	var sound0 = SinOsc.ar(freq0, 0.0, 0.5)*snd_maths0.sqrt;

	var snd_maths = Maths2.ar(0.001, 0.018, 0.99, 0, 1, trig)[0];
	var env = Lag.ar((snd_maths-0.001)>0, 0.02);

	var freq1 = snd_maths.linlin(0,1,5300,6800);
	var sound1 = SinOsc.ar(freq1*[1,4,8], 0.0, 0.075).sum*env;

	var freq2 = snd_maths.linlin(0,1,3000,4100);
	var sound2 = SinOsc.ar(freq1*[1,4,8], 0.0, 0.075).sum*env;

	var mix = RLPF.ar(sound0+sound1+sound2, ctl_maths[0].linlin(0,1,400, 20000), ctl_maths[0].linlin(0,1,0.4,0.95), 1).dup;

	var out = mix+DelayC.ar(mix, 0.1, 0.018, ctl_maths[0].linlin(0,1,0.25,0));

	out = out;

	out.tanh
}.play)