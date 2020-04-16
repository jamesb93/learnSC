(
// Read Files and allocate buffers
~source = Buffer.read(
	s,
	File.realpath(
		FluidBufStats.class.filenameSymbol
		).dirname.withTrailingSlash ++ "../AudioFiles/Tremblay-ASWINE-ScratchySynth-M.wav");
~loudness = Buffer.new(s);
~stats = Buffer.new(s);
)

(
Routine.run({

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

	~histogram = ~data.histo(24);
	{~histogram.plot;}.defer;

}, clock:AppClock);
)