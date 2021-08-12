(
SynthDef.new(\bpmono, {
    arg buf=0, rate=1, amp=1;
    var sig, verb;
    sig = PlayBuf.ar(1, buf, BufRateScale.ir(buf)*rate, doneAction:2);
    sig = sig * amp;
    Out.ar(0, sig!2);
}).add;
)

(
SynthDef.new(\bpstereo, {
    arg buf=0, rate=1, amp=1;
    var sig, verb;
    sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf)*rate, doneAction:2);
    sig = sig * amp;
    Out.ar(0, sig);
}).store;
)