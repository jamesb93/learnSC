

(
// Read Files and allocate buffers
~source = Buffer.read(
	s,
	File.realpath(
		FluidBufStats.class.filenameSymbol
		).dirname.withTrailingSlash ++ "../AudioFiles/Tremblay-ASWINE-ScratchySynth-M.wav");

// ~source = Buffer.read(s, "/Users/james/song_mono.wav");
~loudness = Buffer.new(s);
~stats = Buffer.new(s);
~idx = Buffer.new(s);
)

(
Routine.run({
    var steps = 100;
    var centile;


	FluidBufLoudness.process(
		s,
		source: ~source,
		features: ~loudness,
		windowSize: 4096,
		hopSize: 1024,
        kWeighting: 0,
        truePeak: 0,
	);


	~loudness.loadToFloatArray(
		action:{arg x; ~data = x.unlace(2)[0]}
	);

	s.sync;


	~histogram = ~data.histo(steps);
    // {~histogram.plot;}.defer;

    s.sync;

    // Create an array of the histo values (not frequencies)
    ~values = Array.series(
        steps,
        ~data.minItem,
        ((~data.maxItem - ~data.minItem) / steps)
    );

    centile = (steps / 5).asInteger;
    ~quiet_thresh = ~values[~histogram[0..centile].maxIndex];
    ("Quiet Threshold: " + ~quiet_thresh).postln;

    FluidBufAmpGate.process(
        s,
        ~source,
        indices:~idx,
        onThreshold:~quiet_thresh,
        offThreshold:~quiet_thresh
    );
    ~idx.loadToFloatArray(
		action:{arg x; ~onsets = x.unlace(2)[0]}
	);
    "----Finished Slicing----".postln;


}, clock:AppClock);
)

(
Routine.run{

    FluidBufLoudness.process(
        s,
        source: ~source,
        features: ~loudness,
        windowSize: 4096,
        hopSize: 1024,
        kWeighting: 0,
        truePeak: 0,
    );

    FluidBufStats.process(
        s,
        source: ~loudness,
        stats: ~stats,
        low: 5,
        middle: 10,
        high: 50,
    );
    ~stats.loadToFloatArray(
        action:{
            arg x;
            ~data = x.unlace(~stats.numChannels)[0];
            ~data.postln;
            ~thresh = (~data[5] + ~data[6] / 2);
            ("Try threshold: " ++ ~thresh).postln;
        }
    );



})



