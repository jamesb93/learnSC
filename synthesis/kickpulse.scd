(
{
    arg mratio=4, amp=0.2, boost=2;
    var env, freq, freqenv, trig, index, sig;
    trig = Impulse.ar(LFNoise2.kr(1).linexp(-1, 1, 1, 100));
    env = Env.perc(0.0001, 1.0, curve: -8).ar(0, trig);
    freqenv = Env.perc(0.0001, 0.4, curve: -8).ar(0, trig);
    freq = 60.5.midicps / 16;
    freq = freq * freqenv.linexp(0, 1, 1, 40);
    index = MouseY.kr(0, 2);
    sig = SinOsc.ar(freq, SinOsc.ar(freq * mratio) * index);
    (sig!2 * boost).tanh * env * amp;
}.play;
)