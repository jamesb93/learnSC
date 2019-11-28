//////////// Maintain a running buffer /////////////

//-- Set the inputs and outputs --//
(
s.options.inDevice = "Built-in Microph";
s.options.outDevice = "Built-in Output";
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;
s.reboot;
)

// Expensive patch cable
(
x = {SoundIn.ar(0!2)}.play;
)

(
~runningBuffer = Buffer.alloc(s, s.sampleRate * 2, 1);
)
//// Why do I define a synth here but not make an instance of it somewhere else?
//// What is the best structure of this thing?
(
SynthDef(\audioIn, { |out|
    var input = SoundIn.ar(0);
    RecordBuf.ar(input, ~runningBuffer, loop: 1);
}).play;
)

(
{ PlayBuf.ar(1, ~runningBuffer, loop: 1); }.play;
)

//////////// Multithreading model for FluCoMa ////////////

(
~loudness = Buffer.new(s);
FluidBufSpectralShape.process(s, ~runningBuffer, features: ~loudness);
// FluidBufLoudness
)

~loudness.query;

//////////// Query a buffer many ways ////////////

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
	c = Buffer.new(s);ALi
});
)



(
	f = ~noiseSamps[10];
	FluidBufTransientSlice.process(s, f, indices:c);
    c.numFrames;
)