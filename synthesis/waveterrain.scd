(
SynthDef.new(\leopard_b, {
	arg radius=1, a_centreX=0, a_centreY=0, circlefreq = #[440, 440], amp = 0.2;
	var x, y, grey;
	x = a_centreX + (radius * SinOsc.ar(circlefreq));
	y = a_centreY + (radius * SinOsc.ar(circlefreq, pi/2));
	grey = (x.sin + y.sin).sqrt /2;
	Out.ar(0, grey * amp);
}).add;
)

(
c = Synth.new(\leopard_b, [
	\circlefreq, [70, 70.1],
	\radius, 10,
	\a_centreX, 1,
	\a_centreY, 1
]);
)

(
a = Bus.audio(s, 1);
b = Bus.audio(s, 1);

x = { Out.ar(a, SinOsc.ar(70.03) * LFDNoise3.ar(0.2).range(1, 10)) }.play;
y = { Out.ar(b, SinOsc.ar(70.06) * LFDNoise3.ar(0.2).range(1, 10)) }.play;

c.map(\a_centreX, a);
c.map(\a_centreY, b);
)


x.free;
y.free;
c.free;