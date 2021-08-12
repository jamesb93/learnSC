// simple cross-FM, inspired by Joker Nies
(
Ndef(\xfm, { arg freqA = 32, freqB = 9, modAtoB=540, modBtoA=240;
	var fbIn = LocalIn.ar(2);
	var sigs = SinOsc.ar([freqA, freqB] + (fbIn.reverse * [modBtoA, modAtoB]));
	LocalOut.ar(sigs);
	sigs * 0.5;
}).play;

Spec.add(\freqA, [1, 10000, \exp]);
Spec.add(\freqB, [1, 10000, \exp]);
Spec.add(\modBtoA, [0, 1000, 5]);
Spec.add(\modAtoB, [0, 1000, 5]);

Ndef(\xfm).gui;
);

// some chaotic presets that display roughness, instabilities, or
Ndef('xfm').set('freqA', 9.0, 'freqB', 40.0, 'modAtoB', 205,  'modBtoA', 243.64);
Ndef('xfm').set('freqA', 5, 'freqB', 40.0, 'modAtoB', 90.0, 'modBtoA', 155); // try riding the modBtoA slider just slightly with the arrow buttons > find completely different states; hysteresis when returning. Pitch may move in reverse.
Ndef('xfm').set('freqA', 14, 'freqB', 6.69, 'modAtoB', 151, 'modBtoA', 402);

Ndef('xfm').set('freqA', 5, 'freqB', 40.0, 'modAtoB', 90.0, 'modBtoA', 204); // chaotic oscillation between several states

// settling after a short while - press 'send' on the GUI to restart process deterministically
Ndef('xfm').set('freqA', 5.0, 'freqB', 6.36, 'modAtoB', 342.65, 'modBtoA', 448.48);
Ndef('xfm').set('freqA', 223.46, 'freqB', 6.69, 'modAtoB', 70.57, 'modBtoA', 726.15);
Ndef('xfm').set('freqA', 18, 'freqB', 40.0, 'modAtoB', 90.0, 'modBtoA', 172.0);

// ideas to extend:
// - add sample-and-hold
// - more than 2 operators in circle feedback topology