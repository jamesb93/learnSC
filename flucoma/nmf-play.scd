(
Routine {
    ~source = Buffer.read(s, "/Users/james/Cloud/Projects/impulse/irs/flattened/02_IR_Bedroom_Closet.wav");
    ~resynth = Buffer.new(s);
    s.sync;
    FluidBufNMF.process(s, ~source,
        resynth:~resynth,
        components:2,
        iterations:400,
        windowSize: 16384,
        fftSize: 16384,
        hopSize: 512,
    );
    s.sync;
}.play;
)


{ PlayBuf.ar(2, ~resynth, doneAction:2)[0].dup }.play;

(
Routine {
    var loudness = Buffer.new(s);
    var stats = Buffer.new(s);
    FluidBufLoudness.process(s,~resynth,
        features:loudness,
        windowSize: 17640,
        hopSize: 4410
    );
    s.sync;

    FluidBufStats.process(s,loudness,
        stats:stats,
        numDerivs:0
    );

    stats.query;
    stats.getToFloatArray(action: {
        |x|
        a = x[0..6];
         b = x[7..13];
        c = x[14..20];
        d = x[21..28];
        a.postln;
        b.postln;
        c.postln;
        d.postln;
    });


}.play
)

Array


