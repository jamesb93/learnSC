//// Playback using buffers loaded from a big folder of sounds ////

(
s.options.device = 1;
s.boot;
s.options.numBuffers = 1024;
/*s.options.numBuffers = 21000;
s.options.numBuffers;*/
)

(
s.waitForBoot({
    ~folder = PathName("/Users/jamesbradbury/Desktop/interim/");
	~soundsDict = Dictionary.new;
    ~noiseSamps =  Array.new;

	~folder.entries.do(
        {
		arg path;
        ~noiseSamps = ~noiseSamps.add(Buffer.read(s, path.fullPath));
        }
    );
    postln("---- Samples Loaded ----");
});
)

(
SynthDef.new(\reader, {
    arg buf, amp=1;
    var sig;
    sig = PlayBuf.ar(1, buf, doneAction:2);
    sig = sig * amp;
    Out.ar([0, 1], sig);
}).add;
)

Synth.new(\reader, [\buf, ~noiseSamps[1]]);
s.freeAll;
s.meter;

//// ---------------------------------------------------------------- ////