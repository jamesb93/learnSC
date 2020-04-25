(
s.waitForBoot({

    ~map = Dictionary.new; // Here we will map a file against a set of coordinates

    ~status_osc = OSCFunc({
        arg msg, time, addr, recvPort;
        msg.postln;
    }, '/status');

    ~data_osc = OSCFunc({
        arg msg, time, addr, recvPort;
        msg[0].postln;
        msg[1].postln;
        msg[2].postln;
        msg[3].postln;
    }, '/data');

    z = NetAddr.new("127.0.0.1", 40000);

    // Create a dictionary of symbols to buffers
    ~folder = PathName("/Users/james/Library/Application Support/SuperCollider/Extensions/FluidCorpusManipulation/AudioFiles");
    ~sounds = Dictionary.new;

    ~folder.files.do({
        arg file;

        if (file.isFile && file.extension == "wav") {
            // Each file symbol is mapped to an array of two buffers
            ~sounds.add(file.fileNameWithoutExtension.asSymbol -> [
                Buffer.read(s, file.fullPath.asString),
                Buffer.new(s)
            ]);
        };
    });
})
)


(
Routine.run({
    var mfcc = Buffer.new(s);
    var stats = Buffer.new(s);
    ~sounds.keys.do{
        arg k;

        mfcc = Buffer.new(s);
        s.sync;

        FluidBufMFCC.process(
            s,
            source: ~sounds[k][0],
            features: mfcc,
            numChans: 1
        );

        FluidBufStats.process(
            s,
            source: mfcc,
            stats: ~sounds[k][1],
            numDerivs: 3
        );
    };
    mfcc.free;
    "----Analysis Complete----".postln;
})
)

(
Routine.run({
    ~sounds.keys.do{
        arg k;
        z.sendMsg("/file", k);
        ~sounds[k][1].loadToFloatArray(action:{
            arg data;
            z.sendMsg("/clear", 1);

            data.size.do{
                arg idx;
                z.sendMsg("/add", data[idx]);
            };

            z.sendMsg("/collect", 1)

        });
    };
    z.sendMsg("/reduce", 1);
});
)















z.sendMsg("/kill", 1);
