// Compare the difference between startframes

(
~source = Buffer.read(
	s,
	File.realpath(
		FluidBufStats.class.filenameSymbol
    ).dirname.withTrailingSlash ++ "../AudioFiles/Tremblay-ASWINE-ScratchySynth-M.wav");
~idx = Buffer.new(s);
)

(
var thresh = -51;
Routine.run({
    FluidBufAmpGate.process(
        s,
        source: ~source,
        indices: ~idx,
        rampUp: 1,
        rampDown: 100,
        onThreshold: thresh,
        offThreshold: thresh,
        minSliceLength: 22050,
        minSilenceLength: 2,
        minLengthAbove: 0,
        minLengthBelow: 0,
        lookBack: 0,
        lookAhead: 0,
        highPassFreq: 0,
    );

    ~idx.loadToFloatArray(
		action:{arg x;
            ~onsets = x.unlace(2)[0];
            ~offsets = x.unlace(2)[1];
        }
	);
    "----Raw Data----".postln;
    ~idx.getn(0, ~idx.numFrames, {|x|x.postln;});
    s.sync;
    "----Onsets----".postln;
    ~onsets.postln;
    "----Offsets----".postln;
    ~offsets.postln;
    "----Pairs----".postln;
    ~onsets.size.do{
        arg x;
        ~onsets[x].asInteger.post;
        "->".post;
        ~offsets[x].asInteger.postln;
    };

};)
)