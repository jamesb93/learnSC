(
// Read Files and allocate buffers
~source = Buffer.read(
	s,
	File.realpath(
		FluidBufStats.class.filenameSymbol
		).dirname.withTrailingSlash ++ "../AudioFiles/Tremblay-ASWINE-ScratchySynth-M.wav");
~loudness = Buffer.new(s);
~stats = Buffer.new(s);
~idx = Buffer.new(s);
)

(
Routine.run({
    var steps = 50;
    var centile;


	FluidBufLoudness.process(
		s,
		source:~source,
		features:~loudness,
		windowSize:17640,
		hopSize:4410
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
    ~quiet_thresh.postln;

    FluidBufAmpGate.process(
        s,
        ~source,
        indices:~idx,
        onThreshold:~quiet_thresh,
        offThreshold:~quiet_thresh
    );

}, clock:AppClock);
)


