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

{PlayBuf.ar(1, ~source).dup}.play

// Get the 0, 5, 10 percentiles
(
Routine{

	FluidBufLoudness.process(
		s,
		source:~source,
		features:~loudness,
		windowSize:17640,
		hopSize:4410
	);

	FluidBufStats.process(
		s,
		~loudness,
		stats:~stats,
		low:0,
		middle:5,
		high:10,
		numDerivs:0,
		action:{"Finished Stats analysis".postln;}
	);

	// Round the values in the buffer to the nearest 5dB
	~loudness.numFrames.do{
		arg i;
		~loudness.get(
			i,
			{
                |x|~loudness.set(i, x.round(5));
            }
		);
	}
}.play;
)

// Now make a histogram of the rounded buffer values
