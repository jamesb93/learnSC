(
s.waitForBoot({
    ~osc_receiver = OSCFunc({
        arg msg, time, addr, recvPort;
        [msg, time, addr, recvPort].postln;
    }, '/status', n);
    // "python /Users/james/server.py".unixCmd;
    z = NetAddr.new("127.0.0.1", 40000);
})
)

(
// Read Files and allocate buffers
~source = Buffer.read(
	s,
	File.realpath(
		FluidBufStats.class.filenameSymbol
		).dirname.withTrailingSlash ++ "../AudioFiles/Tremblay-ASWINE-ScratchySynth-M.wav");
)

(
Routine.run({
    var mfcc, stats;
    mfcc = Buffer.new(s);
    stats = Buffer.new(s);
    s.sync;

    FluidBufMFCC.process(
        s,
        source:~source,
        features:mfcc,
    );

    FluidBufStats.process(
        s,
        source:mfcc,
        stats:stats,
        numDerivs: 3,
        action:{
            stats.loadToFloatArray(action:{
                arg data;
                z.sendMsg("/clear", 1);

                data.size.do{
                    arg idx;
                    z.sendMsg("/insert", data[idx]);
                };
                z.sendMsg("/add", 1)
            });
        };
    );
    s.sync;

    mfcc.free;
    stats.free;
    "Analysis Complete".postln;
});
)



z.sendMsg("/add", [100.0, 200.0]);










z.sendMsg("/kill", 1);
