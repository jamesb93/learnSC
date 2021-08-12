(
SynthDef(\fm7noise, {

	var sig;
	var chans = #[0, 1];

	var ctrls = 6.collect({|ctrl|
		["f", "p", "a"].collect({|val|
			["freq", "phase", "mul", "add"].collect({|param|
				"op_%_%_%".format(ctrl, val, param).asSymbol().kr(0)
			});
		});
	});

	var mods = 6.collect({|row|
		6.collect({|col|
			["freq", "phase", "mul", "add"].collect({|param|
				"mod_%_%_%".format(row, col, param).asSymbol().kr(0)
			});
		});
	});

	ctrls = ctrls.collect({|ctrl| ctrl.collect({|vals| LFSaw.ar(*vals) })});
	mods = mods.collect({|mod| mod.collect({|vals| LFSaw.ar(*vals) })});

	sig = FM7.ar(ctrls, mods).slice(chans) * \amp.kr(0.1);
	sig = sig * Env.asr.ar(doneAction:Done.freeSelf, gate:\gate.kr(1));
	sig = Splay.ar(sig);
	Out.ar(\out.kr(0), sig);

}).add;
)

//

(
SynthDef(\fm7noise, {

	var sig;
	var chans = #[0, 1];

	var ctrls = 6.collect({|ctrl|
		["f", "p", "a"].collect({|val|
			["freq", "phase", "mul", "add"].collect({|param|
				"op_%_%_%".format(ctrl, val, param).asSymbol().kr(0)
			});
		});
	});

	var mods = 6.collect({|row|
		6.collect({|col|
			["freq", "phase", "mul", "add"].collect({|param|
				"mod_%_%_%".format(row, col, param).asSymbol().kr(0)
			});
		});
	});

	ctrls = ctrls.collect({|ctrl| ctrl.collect({|vals| LFSaw.ar(*vals) })});
	mods = mods.collect({|mod| mod.collect({|vals| LFSaw.ar(*vals) })});

	sig = FM7.ar(ctrls, mods).slice(chans) * \amp.kr(0.1);
	sig = sig * Env.asr.ar(doneAction:Done.freeSelf, gate:\gate.kr(1));
	sig = Splay.ar(sig);
	Out.ar(\out.kr(0), sig);

}).add;
)

(
var func = {|seed=1000000|

	var randseed = thisThread.randSeed_(seed);
	var ctrls = 6.collect({|ctrl|
		["f", "p", "a"].collect({|val|
			["freq", "phase", "mul", "add"].collect({|param|
				["op_%_%_%".format(ctrl, val, param).asSymbol(), 1.5.linrand.round(0.5)]
			}).flatten;
		}).flatten;
	});

	var mods = 6.collect({|row|
		6.collect({|col|
			["freq", "phase", "mul", "add"].collect({|param|
				["mod_%_%_%".format(row, col, param).asSymbol, 1.5.linrand.round(0.5)]
			}).flatten;
		}).flatten;
	});

	var pairs = ctrls.flatten ++ mods.flatten;
	pairs;
};

Pdef(\fm7noise, {

	var seed = nil; //83506
	var dur = 0.1;

	Pspawner({|sp|
		inf.do({
			var myseed = seed ?? { 1000000.rand; };
			var pairs = func.(myseed.debug(\seed));
			var ptrn = sp.par(Pbind(\instrument, \fm7noise) <> Pbind(*pairs));
			sp.wait(dur);
			sp.suspend(ptrn);
		});
	})
})
)

Pdef(\fm7noise).play;
Pdef(\fm7noise).stop;