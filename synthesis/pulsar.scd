s.boot;

(
// load standard buffer
~buf = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");

// plain granulator
SynthDef(\gran, { |out, gate = 1, bufNum, pos = 0.5, trigRate = 100, trigRateOsc = 100,
	trigRateDev = 0, overlap = 0.3,
	att = 0.005, rel = 0.005, // attack and release of overall envelope, not grain envelope
	susLevel = 1, amp = 0.1|
	var env, sig, trig = Impulse.ar(
		trigRate * LFDNoise3.ar(trigRateOsc).range(1 / (1 + trigRateDev), (1 + trigRateDev))
	);
	sig = TGrains.ar(
		numChannels: 2,
		trigger: trig,
		bufnum: bufNum,
		rate: 1,
		centerPos: pos * BufDur.kr(bufNum),
		dur: overlap / trigRate,
		pan: Dseq([-1, 1], inf)
	);
	// env = EnvGen.ar(Env.asr(att, 1, rel), gate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(att, att, susLevel, rel, 1), gate, doneAction: 2);
	OffsetOut.ar(out, sig * env * amp)
}).add;
)

s.scope

s.freqscope



// some single gran Synths

x = Synth(\gran, [bufNum: ~buf, overlap: 0.55, trigRate: 150, pos: 0.5, amp: 0.5])

x.release

//

x = Synth(\gran, [bufNum: ~buf, overlap: 0.15, trigRate: 500, pos: 0.5, trigRateDev: 0.1, amp: 0.5])

x.release

//

x = Synth(\gran, [bufNum: ~buf, overlap: 0.5, trigRate: 200, pos: 0.3, trigRateDev: 0.7, amp: 0.5])

x.release


//

x = Synth(\gran, [bufNum: ~buf, overlap: 0.2, trigRate: 300, pos: 0.3, trigRateDev: 5, amp: 0.5])

x.release



// run long overlapping pulsar streams with Pattern
// No correspondence between current Events

(
x = Pbind(
	\instrument, \gran,
	\bufNum, ~buf,
	\trigRate, Pexprand(50, 3000),
	\trigRateDev, 0.1,
	// overlap of grains in synth itself < 1: pulsar synthesis
	\overlap, Pexprand(0.1, 1),
	\dur, 1,
	\att, 5,
	\rel, 5,
	\legato, Pexprand(1, 7.0),   // overlaps up to 7 gran synths
	\pos, Pwhite(0.2, 0.8),
	\amp, 0.5
).play
)

// takes some time to stop current long synths

x.stop


// run short overlapping pulsar streams with Pattern
// No correspondence between current Events

(
x = Pbind(
	\instrument, \gran,
	\trigRate, Pexprand(50, 500),
	\overlap, Pexprand(0.1, 1), // overlap of grains in synth itself
	\dur, 0.01,
	\legato, Pexprand(1, 7.0),   // overlaps up to 7 gran synths
	\pos, Pwhite(0.2, 0.8),
	\amp, 0.5
).play
)

x.stop



// correspondence between current Events


(
// storage of current synth ids / Events

~currentIds = List.new;
~currentEvents = Event.new;   // container for pbind-generated Events of active synths, they are linked with ids

// Function to be used in Pattern to update running ids and corresponding Events
// Notification must be on

~updater = { |event|
	var ids = ~currentIds;
	var evs = ~currentEvents;
	thisThread.clock.sched(0, {
		event[\id].do { |id|
			OSCFunc({ ids.add(id); evs.put(id, event) },
				'/n_go', s.addr, nil, [id]).oneShot;
			OSCFunc({ ids.remove(id); evs.put(id, nil) },
				'/n_end', s.addr, nil, [id]).oneShot;
		};
	})
};


// Function to determine average trigRate of currently running synths

~getAverageTrigrate = { |defaultLo = 200, defaultHi = 300|
	var sum = 0, size = { ~currentEvents.size }.value;
	~currentEvents.do { |ev| sum = sum + ev[\trigRate] };
	(size == 0).if {
		rrand(defaultLo, defaultHi);
	}{
		sum / size;
	}
};


x = Pbind(
	\instrument, \gran,
	\count, Pseries.new, // counter
	// core: depending on a changing probability take average trigRate (~freq) or take a new value
	\avrgProb, Pseg(Pseq([1, 0], inf), 10, \sine), // Pseg is a meta pattern for LFO-like changes
	\trigRate, Pfunc { |ev|
		var sign, avrg;
		(ev[\count] == 0).if {
			rrand(200, 600);
		}{
			avrg = ~getAverageTrigrate.value.clip(50, 700);
			ev[\avrgProb].coin.if { avrg }{ avrg * rrand(0.7, 1.3) }
		};
	},

	\overlap, Pexprand(0.1, 0.2), // overlap of grains in synth itself
	\dur, 0.2,
	\legato, Pwrand((1..7), (7..1).normalizeSum, inf),  // overlaps up to 7 gran synths
	\pos, 0.6,
	\susLevel, 0.5,
	\amp, 0.6,
	\do, Pfunc(~updater)
).trace.play
)

x.stop