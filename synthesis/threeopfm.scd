
(
s.options.device_("BlackHole 32ch");
s.options.blockSize_(512);
s.waitForBoot({
    Require("./FMSynth.scd");
});
)

(
~count = Array.series(8, 1);

~nestedDur = Pseq([
        Pdup(Pseq([7], inf), Pseq([0.1])),
        Pseq([0.2], 1)
    ], inf);

Pdef(
    \ptn,
    Pbind(
        \instrument, \fm,
        \dur, ~nestedDur,
        \fund1, Pseq([150, 180], inf),
        \fund2, Pseq([180, 210], inf),
        \fund3, Pseq([210, 240], inf),
        \fb1, Pexprand(5, 10000, inf),
        \fb1, Pexprand(5, 10000, inf),
        \fb1, Pexprand(5, 10000, inf),
        \amp, Pseq([0.8], inf),
        \curve, Pseq([-10], inf),
        \pitchScale, Pseq([1.0], inf)
    )
).play;

b = ~nestedDur.asStream;
20.do({ b.next.postln });
)

(

~nestedDur = Pseq([
        Pdup(Prand([1, 2], inf), Pseq([0.1])),
        Pseq([0.2], 1)
    ], inf);
b = ~nestedDur.asStream;
20.do({ b.next.postln });
)

