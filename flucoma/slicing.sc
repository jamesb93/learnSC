//// Slicing a buffer ////

s.

(
s.waitForBoot({
    ~folder = PathName("/Users/james/dev/data_bending/groupings/spines/spines_short/");
	~soundsDict = Dictionary.new;
    ~noiseSamps =  Array.new;

	~folder.entries.do(
        {
		arg path;
        ~noiseSamps = ~noiseSamps.add(Buffer.read(s, path.fullPath));
        }
    );
    postln("---- Samples Loaded ----");
	c = Buffer.new(s);
});
)

(
	f = ~noiseSamps[10];
	FluidBufTransientSlice.process(s, f, indices:c, doneAction: 2);
	c.query;
)

(
{
	BufRd.ar(
		1, f,
		Phasor.ar(0,
			BufRateScale.kr(f),
			0, BufFrames.kr(f)
		)
	)}.play;
)

BufFrames.kr(c).postln;

~randomSlice = rrand(0, BufFrames(c) -1);
~randomSlice.postln;

//loops over a splice
(
{
	BufRd.ar(1, f,
        Phasor.ar(0,1,
            BufRd.kr(1, c,
                MouseX.kr(0, BufFrames.kr(c) - 1), 0, 1),
            BufRd.kr(1, c,
                MouseX.kr(1, BufFrames.kr(c)), 0, 1),≥
            BufRd.kr(1,c,
                MouseX.kr(0, BufFrames.kr(c) - 1), 0, 1)), 0, 1);
        }.play;
)

s.freeAll;
s.meter;
s.scope;