(
s.boot;
d = Dictionary.new;

SynthDef.new(\bpmono, {
    arg buf=0, rate=1, amp=1;
    var sig, verb;
    sig = PlayBuf.ar(1, buf, BufRateScale.ir(buf)*rate, doneAction:2);
    sig = sig * amp;
    Out.ar(0, sig!2);
}).add;

d.add(\ir -> PathName.new("/Users/james/Cloud/Projects/impulse/irs/flattened").entries.collect({
    arg sf;
    Buffer.read(s, sf.fullPath);
}));

d.add(\click -> PathName.new("/Users/james/Sound/clicks/").entries.collect({
    arg sf;
    Buffer.read(s, sf.fullPath);
}));

d.add(\inter -> PathName.new("/Users/james/Sound/interference/").entries.collect({
    arg sf;
    Buffer.read(s, sf.fullPath);
}));

d.add(\perc -> PathName.new("/Users/james/Sound/samples/click_perc").entries.collect({
    arg sf;
    Buffer.read(s, sf.fullPath);
}));
)

(
Pdef(
    \cunt,
    Pbind(
        \instrument, \bpmono,
        \dur, Pexprand(0.09, 0.11, inf),
        \buf, Pseq(d[\click], inf),
        \rate, 1,
        \amp, Pseq([1.0], inf),
    )
).play;

Pdef(
    \cunt2,
    Pbind(
        \instrument, \bpmono,
        \dur, Pexprand(0.09, 0.11, inf),
        \buf, Pseq(d[\click], inf),
        \rate, 1,
        \amp, Pseq([1.0, 0.5, 0.2], inf),
        \lag, 0.1
    )
).play;
)

(
Pdef(
    \digitalnoise,
    Pbind(
        \instrument, \bpmono,
        \dur, Pseq(
            [
                Pseq([0.1], 4),
                Prand([0.5, 0.2], 1)
            ] * 0.1, inf
        ),
        \buf, Prand(d[\inter][0..4], inf),
        \rate, 1,
        \amp, Pseq([1.0, 0.5, 0.2, 0.9, 0.1] * 0.1, inf),
        \lag, 0.0
    )
).play;
)

