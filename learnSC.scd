(
s.freeAll;
s.reboot;
s.options.numBuffers = 1024;
s.options.numBuffers;
/*s.options.numBuffers = 21000;
s.options.numBuffers;*/
)

/*(
s.waitForBoot({
    ~folder = PathName("/Users/jamesbradbury/Desktop/interim/");
	~soundsDict = Dictionary.new;
    ~assoc = Array.new;

	~folder.filesDo({
		arg file;
		if((file.extension == "wav"),
        {
                ~soundsDict.add(file.fileNameWithoutExtension.asSymbol -> Buffer.read(s, file.fullPath.asString));
                ~assoc.add(Buffer.read(s, ))
        });
	});
    postln("Done");
});
)*/

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
    postln("Done");
});
)

(
SynthDef.new(\reader, {
    arg buf, out=0, amp=1;
    var sig;
    Pan2
    sig = PlayBuf.ar(1, buf, doneAction:2);
    sig = sig * amp;
    Out.ar(out, sig);
}).add;
)

Synth.new(\reader, [\buf, ~noiseSamps[1], \out, [0, 1]]);
s.freeAll;
